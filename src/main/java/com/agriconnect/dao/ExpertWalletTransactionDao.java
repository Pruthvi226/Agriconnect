package com.agriconnect.dao;

import com.agriconnect.model.ExpertWalletTransaction;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ExpertWalletTransactionDao extends BaseDaoImpl<ExpertWalletTransaction, Long> {

    public ExpertWalletTransactionDao() {
        super(ExpertWalletTransaction.class);
    }

    public List<ExpertWalletTransaction> findByExpert(Long expertId) {
        String hql = "SELECT t FROM ExpertWalletTransaction t WHERE t.expert.id = :expertId ORDER BY t.createdAt DESC";
        return sessionFactory.getCurrentSession().createQuery(hql, ExpertWalletTransaction.class)
                .setParameter("expertId", expertId)
                .getResultList();
    }

    public boolean existsByConsultation(Long consultationId) {
        String hql = "SELECT COUNT(t.id) FROM ExpertWalletTransaction t WHERE t.consultation.id = :consultationId";
        Long count = sessionFactory.getCurrentSession().createQuery(hql, Long.class)
                .setParameter("consultationId", consultationId)
                .uniqueResult();
        return count != null && count > 0;
    }
}
