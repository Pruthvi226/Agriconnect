package com.agriconnect.service;

import com.agriconnect.dao.AdvisoryDao;
import com.agriconnect.dao.BaseDao;
import com.agriconnect.dto.AdvisoryRequestDto;
import com.agriconnect.model.Advisory;
import com.agriconnect.model.CriticalAlert;
import com.agriconnect.model.User;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class AdvisoryAlertServiceTest {

    @Mock
    private AdvisoryDao advisoryDao;
    @Mock
    private BaseDao<User, Long> userDao;
    @Mock
    private BaseDao<com.agriconnect.model.Notification, Long> notificationDao;
    @Mock
    private BaseDao<CriticalAlert, Long> criticalAlertDao;
    @Mock
    private SessionFactory sessionFactory;
    @Mock
    private Session session;
    @Mock
    private Query<Long> query;

    @InjectMocks
    private AdvisoryAlertService advisoryAlertService;

    @Test
    void testPublishAdvisory_CreatesCriticalAlert() {
        AdvisoryRequestDto dto = new AdvisoryRequestDto();
        dto.setSeverity("CRITICAL");
        dto.setAdvisoryType("WEATHER");
        dto.setAffectedDistricts(Arrays.asList("Nashik"));
        dto.setCropName("Grape");

        User expert = new User();
        when(userDao.findById(1L)).thenReturn(Optional.of(expert));

        // Spy the service to mock the async call within it if needed, or just let it fail silently if mock session factory isn't fully mocked.
        // For complete mocking:
        when(sessionFactory.getCurrentSession()).thenReturn(session);
        when(session.createQuery(anyString(), eq(Long.class))).thenReturn(query);
        when(query.setParameterList(anyString(), anyList())).thenReturn(query);
        when(query.setParameter(anyString(), anyString())).thenReturn(query);
        when(query.getResultList()).thenReturn(List.of(2L)); // Mock one farmer found

        User farmer = new User();
        when(userDao.findById(2L)).thenReturn(Optional.of(farmer));

        advisoryAlertService.publishAdvisory(dto, 1L);

        verify(advisoryDao, times(1)).save(any(Advisory.class));
        verify(criticalAlertDao, times(1)).save(any(CriticalAlert.class));
        verify(notificationDao, times(1)).save(any(com.agriconnect.model.Notification.class));
    }
}
