package com.agriconnect.service;

import com.agriconnect.dao.DemandForecastDao;
import com.agriconnect.dto.DemandForecastReport;
import com.agriconnect.model.DemandForecastCache;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class DemandForecastServiceTest {

    @Mock
    private DemandForecastDao demandForecastDao;

    @InjectMocks
    private DemandForecastService demandForecastService;

    @Test
    void generateForecastBuildsAndCachesReport() {
        when(demandForecastDao.findTopCropDemandSince(any(LocalDateTime.class))).thenReturn(List.<Object[]>of(
                new Object[]{"Tomato", 12L, new BigDecimal("23.40")},
                new Object[]{"Onion", 9L, new BigDecimal("18.75")}
        ));
        when(demandForecastDao.findHotDistrictDemand()).thenReturn(List.<Object[]>of(
                new Object[]{"Nashik", "Tomato", new BigDecimal("640.00")}
        ));
        when(demandForecastDao.findPriceHistorySince(any(LocalDate.class))).thenReturn(List.<Object[]>of(
                new Object[]{"Tomato", new BigDecimal("18.00"), LocalDate.now().minusMonths(5)},
                new Object[]{"Tomato", new BigDecimal("24.00"), LocalDate.now().minusDays(5)},
                new Object[]{"Onion", new BigDecimal("22.00"), LocalDate.now().minusMonths(4)},
                new Object[]{"Onion", new BigDecimal("19.00"), LocalDate.now().minusDays(2)}
        ));

        DemandForecastReport report = demandForecastService.generateForecast();

        assertThat(report.getTopCrops()).hasSize(2);
        assertThat(report.getTopCrops().get(0).getCropName()).isEqualTo("Tomato");
        assertThat(report.getHotDistricts()).hasSize(1);
        assertThat(report.getRisingPriceCrops()).extracting(DemandForecastReport.PriceTrendSnapshot::getCropName)
                .contains("Tomato");
        assertThat(report.getFallingPriceCrops()).extracting(DemandForecastReport.PriceTrendSnapshot::getCropName)
                .contains("Onion");
        verify(demandForecastDao).save(any(DemandForecastCache.class));
    }

    @Test
    void getLatestForecastUsesCacheWhenAvailable() {
        DemandForecastCache cache = new DemandForecastCache();
        cache.setReportJson("""
                {"topCrops":[{"cropName":"Maize","bidCount":4,"avgPrice":19.50}],
                "hotDistricts":[],
                "priceTrends":[{"cropName":"Maize","latestPrice":20.00,"oldestPrice":18.00,"changePercent":11.11,"direction":"UP"}],
                "risingPriceCrops":[{"cropName":"Maize","latestPrice":20.00,"oldestPrice":18.00,"changePercent":11.11,"direction":"UP"}],
                "fallingPriceCrops":[],
                "generatedAt":"2026-05-02T06:00:00"}
                """);
        when(demandForecastDao.findLatestCache()).thenReturn(Optional.of(cache));

        DemandForecastReport report = demandForecastService.getLatestForecast();

        assertThat(report.getTopCrops()).hasSize(1);
        assertThat(report.getTopCrops().get(0).getCropName()).isEqualTo("Maize");
        verify(demandForecastDao, never()).save(any(DemandForecastCache.class));
    }
}
