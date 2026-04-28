package com.agriconnect.service;

import com.agriconnect.dao.BaseDao;
import com.agriconnect.model.MspRate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@Transactional
public class MspRateService {

    @Autowired
    private BaseDao<MspRate, Long> mspRateDao;

    public MspRate.Season getCurrentSeason() {
        int month = LocalDate.now().getMonthValue();
        if (month >= 6 && month <= 10) {
            return MspRate.Season.KHARIF;
        } else if (month >= 11 || month <= 3) {
            return MspRate.Season.RABI;
        } else {
            return MspRate.Season.ZAID;
        }
    }

    public MspRate getCurrentMsp(String cropName) {
        MspRate.Season currentSeason = getCurrentSeason();
        List<MspRate> rates = mspRateDao.findByField("cropName", cropName);
        
        // Find the latest one for the current season, or fallback to the latest available
        MspRate latestForSeason = null;
        MspRate latestOverall = null;

        for (MspRate rate : rates) {
            if (latestOverall == null || rate.getAnnouncedAt().isAfter(latestOverall.getAnnouncedAt())) {
                latestOverall = rate;
            }
            if (rate.getSeason() == currentSeason) {
                if (latestForSeason == null || rate.getAnnouncedAt().isAfter(latestForSeason.getAnnouncedAt())) {
                    latestForSeason = rate;
                }
            }
        }
        return latestForSeason != null ? latestForSeason : latestOverall;
    }
}
