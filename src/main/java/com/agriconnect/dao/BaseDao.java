package com.agriconnect.dao;

import java.util.List;
import java.util.Optional;

public interface BaseDao<T, ID> {
    Optional<T> findById(ID id);
    List<T> findAll();
    void save(T entity);
    void update(T entity);
    void delete(T entity);
    List<T> findByField(String fieldName, Object value);
}
