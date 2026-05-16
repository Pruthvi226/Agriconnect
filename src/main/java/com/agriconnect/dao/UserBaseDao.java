package com.agriconnect.dao;

import com.agriconnect.model.User;
import org.springframework.stereotype.Repository;

@Repository
public class UserBaseDao extends BaseDaoImpl<User, Long> {
    public UserBaseDao() {
        super(User.class);
    }
}
