package com.agriconnect.dao;

import com.agriconnect.model.WalletTransaction;
import org.springframework.stereotype.Repository;

@Repository
public class WalletTransactionDao extends BaseDaoImpl<WalletTransaction, Long> {

    public WalletTransactionDao() {
        super(WalletTransaction.class);
    }
}
