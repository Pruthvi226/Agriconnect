package com.agriconnect.dao;

import com.agriconnect.model.Crop;
import org.springframework.stereotype.Repository;

@Repository
public class CropDao extends BaseDaoImpl<Crop, Long> {
    public CropDao() {
        super(Crop.class);
    }
}
