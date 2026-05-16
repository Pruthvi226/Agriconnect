package com.agriconnect.service;

import com.agriconnect.dao.AdvisoryDao;
import com.agriconnect.dao.BaseDao;
import com.agriconnect.dto.AdvisoryRequestDto;
import com.agriconnect.model.Advisory;
import com.agriconnect.model.CriticalAlert;
import com.agriconnect.model.Notification;
import com.agriconnect.model.User;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class AdvisoryAlertService {

    @Autowired
    private AdvisoryDao advisoryDao;

    @Autowired
    private BaseDao<User, Long> userDao;

    @Autowired
    private BaseDao<Notification, Long> notificationDao;

    @Autowired
    private BaseDao<CriticalAlert, Long> criticalAlertDao;

    @Autowired
    private SessionFactory sessionFactory;

    @Autowired(required = false)
    private ObjectMapper objectMapper = new ObjectMapper();

    @org.springframework.security.access.prepost.PreAuthorize("hasRole('AGRI_EXPERT') and #expertId == authentication.principal.id")
    public Advisory publishAdvisory(AdvisoryRequestDto dto, Long expertId) {
        User expert = userDao.findById(expertId).orElseThrow();

        Advisory advisory = new Advisory();
        advisory.setExpert(expert);
        advisory.setTitle(dto.getTitle());
        advisory.setBody(dto.getBody());
        advisory.setCropName(dto.getCropName());
        advisory.setAdvisoryType(parseAdvisoryType(dto.getAdvisoryType()));
        advisory.setSeverity(parseSeverity(dto.getSeverity()));
        advisory.setAffectedDistricts(writeAffectedDistricts(dto.getAffectedDistricts()));
        advisory.setValidUntil(dto.getValidUntil());
        
        advisoryDao.save(advisory);

        if (advisory.getSeverity() == Advisory.Severity.CRITICAL) {
            CriticalAlert alert = new CriticalAlert();
            alert.setAdvisory(advisory);
            criticalAlertDao.save(alert);
        }

        // Feature 3: specific async query
        sendBulkNotifications(dto.getAffectedDistricts(), dto.getCropName(), advisory);
        return advisory;
    }

    @Async
    public void sendBulkNotifications(List<String> affectedDistricts, String cropName, Advisory advisory) {
        System.out.println("Async Bulk Notification started.");
        
        StringBuilder hql = new StringBuilder("""
                SELECT DISTINCT l.farmerProfile.user.id
                FROM ProduceListing l
                WHERE l.district IN (:districts)
                  AND l.status IN (:statuses)
                """);
        boolean targetCrop = cropName != null && !cropName.isBlank();
        if (targetCrop) {
            hql.append(" AND LOWER(l.cropName) = :cropName");
        }
        var query = sessionFactory.getCurrentSession().createQuery(hql.toString(), Long.class)
                .setParameterList("districts", affectedDistricts)
                .setParameterList("statuses", List.of(
                        com.agriconnect.model.ProduceListing.Status.ACTIVE,
                        com.agriconnect.model.ProduceListing.Status.BIDDING));
        if (targetCrop) {
            query.setParameter("cropName", cropName.toLowerCase());
        }
        List<Long> userIds = query.getResultList();

        for (Long userId : userIds) {
            User user = userDao.findById(userId).orElse(null);
            if (user != null) {
                Notification n = new Notification();
                n.setUser(user);
                n.setTitle("URGENT: " + advisory.getTitle());
                n.setBody(advisory.getBody());
                n.setType("ADVISORY_ALERT");
                notificationDao.save(n);
            }
        }
        System.out.println("Dispatched " + userIds.size() + " notifications.");
    }

    public List<Advisory> getActiveAdvisoriesForDistrict(String district) {
        if (district == null || district.isBlank()) {
            return List.of();
        }
        String hql = "FROM Advisory a WHERE a.affectedDistricts LIKE :district " +
                     "AND a.validUntil >= CURRENT_DATE AND a.severity != :infoSeverity " +
                     "ORDER BY a.severity DESC, a.createdAt DESC";
        return sessionFactory.getCurrentSession().createQuery(hql, Advisory.class)
                .setParameter("district", "%" + district + "%")
                .setParameter("infoSeverity", Advisory.Severity.INFO)
                .setMaxResults(3)
                .getResultList();
    }

    public List<Advisory> getAllAdvisories() {
        return advisoryDao.findAll();
    }

    public Advisory getAdvisory(Long id) {
        return advisoryDao.findById(id)
                .orElseThrow(() -> new com.agriconnect.exception.ResourceNotFoundException("Advisory not found"));
    }

    private Advisory.AdvisoryType parseAdvisoryType(String value) {
        return Advisory.AdvisoryType.fromExternalValue(value);
    }

    private Advisory.Severity parseSeverity(String value) {
        return Advisory.Severity.fromExternalValue(value);
    }

    private String writeAffectedDistricts(List<String> districts) {
        try {
            return objectMapper.writeValueAsString(districts);
        } catch (JsonProcessingException ex) {
            throw new IllegalArgumentException("Could not encode affected districts", ex);
        }
    }
}
