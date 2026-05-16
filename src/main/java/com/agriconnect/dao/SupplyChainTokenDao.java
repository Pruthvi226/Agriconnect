package com.agriconnect.dao;

import com.agriconnect.model.SupplyChainToken;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public class SupplyChainTokenDao extends BaseDaoImpl<SupplyChainToken, Long> {

    public SupplyChainTokenDao() {
        super(SupplyChainToken.class);
    }

    public Optional<SupplyChainToken> findByToken(String token) {
        String hql = "SELECT s FROM SupplyChainToken s " +
                "JOIN FETCH s.order o " +
                "JOIN FETCH o.bid b " +
                "JOIN FETCH b.listing l " +
                "JOIN FETCH o.farmer f " +
                "JOIN FETCH f.user fu " +
                "WHERE s.token = :token";
        return sessionFactory.getCurrentSession().createQuery(hql, SupplyChainToken.class)
                .setParameter("token", token)
                .uniqueResultOptional();
    }

    public Optional<SupplyChainToken> findByOrderId(Long orderId) {
        String hql = "SELECT s FROM SupplyChainToken s JOIN FETCH s.order o WHERE o.id = :orderId";
        return sessionFactory.getCurrentSession().createQuery(hql, SupplyChainToken.class)
                .setParameter("orderId", orderId)
                .uniqueResultOptional();
    }
}
