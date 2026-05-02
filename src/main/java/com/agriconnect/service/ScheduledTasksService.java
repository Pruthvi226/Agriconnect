package com.agriconnect.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
public class ScheduledTasksService {

    private static final Logger log = LoggerFactory.getLogger(ScheduledTasksService.class);

    @Autowired
    private MatchmakingService matchmakingService;

    @Autowired
    private FarmerScoreService farmerScoreService;

    @Autowired
    private ListingService listingService;

    @Autowired
    private AdvisoryAlertService advisoryAlertService;

    @Scheduled(cron = "0 0 2 * * ?")
    public void recomputeFarmerScores() {
        log.info("Scheduled: recomputing all farmer scores");
        farmerScoreService.recomputeAllActiveScores();
    }

    @Scheduled(cron = "0 0 3 * * ?")
    public void recomputeMatchmakingScores() {
        log.info("Scheduled: recomputing matchmaking scores");
        matchmakingService.computeAllScores();
    }

    @Scheduled(cron = "0 0 1 * * ?")
    public void expireStaleListings() {
        int count = listingService.expireStaleListings();
        log.info("Scheduled: expired {} stale listings", count);
    }
}
