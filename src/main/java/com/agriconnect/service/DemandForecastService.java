package com.agriconnect.service;

import com.agriconnect.dao.DemandForecastDao;
import com.agriconnect.dto.DemandForecastReport;
import com.agriconnect.model.DemandForecastCache;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class DemandForecastService {

    private static final Logger log = LoggerFactory.getLogger(DemandForecastService.class);

    @Autowired
    private DemandForecastDao demandForecastDao;

    private final ObjectMapper objectMapper = new ObjectMapper()
            .registerModule(new JavaTimeModule())
            .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

    @Scheduled(cron = "0 0 6 * * MON")
    public void refreshWeeklyForecastCache() {
        log.info("Scheduled: generating weekly demand forecast cache");
        generateForecast();
    }

    public DemandForecastReport generateForecast() {
        DemandForecastReport report = new DemandForecastReport();
        report.setGeneratedAt(LocalDateTime.now());
        report.setTopCrops(mapTopCrops(demandForecastDao.findTopCropDemandSince(LocalDateTime.now().minusDays(90))));
        report.setHotDistricts(mapHotDistricts(demandForecastDao.findHotDistrictDemand()));

        List<DemandForecastReport.PriceTrendSnapshot> priceTrends =
                buildPriceTrends(demandForecastDao.findPriceHistorySince(LocalDate.now().minusMonths(6)));
        report.setPriceTrends(priceTrends);
        report.setRisingPriceCrops(priceTrends.stream()
                .filter(trend -> "UP".equals(trend.getDirection()))
                .sorted(Comparator.comparing(DemandForecastReport.PriceTrendSnapshot::getChangePercent).reversed())
                .limit(5)
                .toList());
        report.setFallingPriceCrops(priceTrends.stream()
                .filter(trend -> "DOWN".equals(trend.getDirection()))
                .sorted(Comparator.comparing(DemandForecastReport.PriceTrendSnapshot::getChangePercent))
                .limit(5)
                .toList());

        cacheReport(report);
        return report;
    }

    public DemandForecastReport getLatestForecast() {
        DemandForecastCache cache = demandForecastDao.findLatestCache().orElse(null);
        if (cache != null) {
            return deserialize(cache);
        }
        return generateForecast();
    }

    public String getLatestForecastJson() {
        DemandForecastCache cache = demandForecastDao.findLatestCache().orElse(null);
        if (cache != null) {
            return cache.getReportJson();
        }
        return serialize(generateForecast());
    }

    private List<DemandForecastReport.CropDemandSnapshot> mapTopCrops(List<Object[]> rows) {
        List<DemandForecastReport.CropDemandSnapshot> snapshots = new ArrayList<>();
        for (Object[] row : rows) {
            snapshots.add(new DemandForecastReport.CropDemandSnapshot(
                    asString(row[0]),
                    asLong(row[1]),
                    asBigDecimal(row[2])
            ));
        }
        return snapshots;
    }

    private List<DemandForecastReport.DistrictDemandSnapshot> mapHotDistricts(List<Object[]> rows) {
        List<DemandForecastReport.DistrictDemandSnapshot> snapshots = new ArrayList<>();
        for (Object[] row : rows) {
            snapshots.add(new DemandForecastReport.DistrictDemandSnapshot(
                    asString(row[0]),
                    asString(row[1]),
                    asBigDecimal(row[2])
            ));
        }
        return snapshots;
    }

    private List<DemandForecastReport.PriceTrendSnapshot> buildPriceTrends(List<Object[]> rows) {
        Map<String, List<BigDecimal>> priceSeries = new LinkedHashMap<>();
        for (Object[] row : rows) {
            priceSeries.computeIfAbsent(asString(row[0]), ignored -> new ArrayList<>())
                    .add(asBigDecimal(row[1]));
        }

        List<DemandForecastReport.PriceTrendSnapshot> trends = new ArrayList<>();
        for (Map.Entry<String, List<BigDecimal>> entry : priceSeries.entrySet()) {
            List<BigDecimal> series = entry.getValue();
            if (series.isEmpty()) {
                continue;
            }

            BigDecimal oldestPrice = series.get(0);
            BigDecimal latestPrice = series.get(series.size() - 1);
            BigDecimal changePercent = calculateChangePercent(oldestPrice, latestPrice);
            String direction = determineDirection(oldestPrice, latestPrice);
            trends.add(new DemandForecastReport.PriceTrendSnapshot(
                    entry.getKey(),
                    latestPrice,
                    oldestPrice,
                    changePercent,
                    direction
            ));
        }

        return trends.stream()
                .sorted(Comparator.comparing(DemandForecastReport.PriceTrendSnapshot::getChangePercent).reversed())
                .toList();
    }

    private BigDecimal calculateChangePercent(BigDecimal oldestPrice, BigDecimal latestPrice) {
        if (oldestPrice == null || latestPrice == null || BigDecimal.ZERO.compareTo(oldestPrice) == 0) {
            return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        }
        return latestPrice.subtract(oldestPrice)
                .multiply(BigDecimal.valueOf(100))
                .divide(oldestPrice, 2, RoundingMode.HALF_UP);
    }

    private String determineDirection(BigDecimal oldestPrice, BigDecimal latestPrice) {
        if (oldestPrice == null || latestPrice == null) {
            return "FLAT";
        }
        int comparison = latestPrice.compareTo(oldestPrice);
        if (comparison > 0) {
            return "UP";
        }
        if (comparison < 0) {
            return "DOWN";
        }
        return "FLAT";
    }

    private void cacheReport(DemandForecastReport report) {
        DemandForecastCache cache = new DemandForecastCache();
        cache.setReportJson(serialize(report));
        cache.setGeneratedAt(report.getGeneratedAt());
        demandForecastDao.save(cache);
    }

    private String serialize(DemandForecastReport report) {
        try {
            return objectMapper.writeValueAsString(report);
        } catch (JsonProcessingException e) {
            throw new IllegalStateException("Unable to serialize demand forecast report", e);
        }
    }

    private DemandForecastReport deserialize(DemandForecastCache cache) {
        try {
            return objectMapper.readValue(cache.getReportJson(), DemandForecastReport.class);
        } catch (JsonProcessingException e) {
            throw new IllegalStateException("Unable to deserialize cached demand forecast report", e);
        }
    }

    private String asString(Object value) {
        return value == null ? null : String.valueOf(value);
    }

    private long asLong(Object value) {
        return value == null ? 0L : ((Number) value).longValue();
    }

    private BigDecimal asBigDecimal(Object value) {
        if (value == null) {
            return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        }
        if (value instanceof BigDecimal bigDecimal) {
            return bigDecimal.setScale(2, RoundingMode.HALF_UP);
        }
        if (value instanceof Number number) {
            return BigDecimal.valueOf(number.doubleValue()).setScale(2, RoundingMode.HALF_UP);
        }
        return new BigDecimal(String.valueOf(value)).setScale(2, RoundingMode.HALF_UP);
    }
}
