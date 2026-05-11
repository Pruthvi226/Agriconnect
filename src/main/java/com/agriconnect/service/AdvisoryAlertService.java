package com.agriconnect.service;

import com.agriconnect.dao.AdvisoryDao;
import com.agriconnect.dao.BaseDao;
import com.agriconnect.dto.AdvisoryRequestDto;
import com.agriconnect.model.Advisory;
import com.agriconnect.model.CriticalAlert;
import com.agriconnect.model.Notification;
import com.agriconnect.model.User;
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

    @org.springframework.security.access.prepost.PreAuthorize("hasRole('AGRI_EXPERT') and #expertId == authentication.principal.id")
    public void publishAdvisory(AdvisoryRequestDto dto, Long expertId) {
        User expert = userDao.findById(expertId).orElseThrow();

        Advisory advisory = new Advisory();
        advisory.setExpert(expert);
        advisory.setTitle(dto.getTitle());
        advisory.setBody(dto.getBody());
        advisory.setCropName(dto.getCropName());
        advisory.setAdvisoryType(Advisory.AdvisoryType.valueOf(dto.getAdvisoryType()));
        advisory.setSeverity(Advisory.Severity.valueOf(dto.getSeverity()));
        advisory.setAffectedDistricts(dto.getAffectedDistricts().toString()); // Simple JSON stringification
        advisory.setValidUntil(dto.getValidUntil());
        
        advisoryDao.save(advisory);

        if (advisory.getSeverity() == Advisory.Severity.CRITICAL) {
            CriticalAlert alert = new CriticalAlert();
            alert.setAdvisory(advisory);
            criticalAlertDao.save(alert);
        }

        // Feature 3: specific async query
        sendBulkNotifications(dto.getAffectedDistricts(), dto.getCropName(), advisory);
    }

    @Async
    public void sendBulkNotifications(List<String> affectedDistricts, String cropName, Advisory advisory) {
        System.out.println("Async Bulk Notification started.");
        
        String hql = "SELECT DISTINCT l.farmerProfile.user.id FROM ProduceListing l WHERE l.district IN (:districts) AND l.cropName = :cropName AND l.status = 'ACTIVE'";
        List<Long> userIds = sessionFactory.getCurrentSession().createQuery(hql, Long.class)
                .setParameterList("districts", affectedDistricts)
                .setParameter("cropName", cropName)
                .getResultList();

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
        String hql = "FROM Advisory a WHERE a.affectedDistricts LIKE :district " +
                     "AND a.validUntil >= CURRENT_DATE AND a.severity != 'INFO' " +
                     "ORDER BY a.severity DESC, a.createdAt DESC";
        return sessionFactory.getCurrentSession().createQuery(hql, Advisory.class)
                .setParameter("district", "%" + district + "%")
                .setMaxResults(3)
                .getResultList();
    }
}
