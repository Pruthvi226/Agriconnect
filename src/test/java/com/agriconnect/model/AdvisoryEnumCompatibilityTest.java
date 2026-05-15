package com.agriconnect.model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class AdvisoryEnumCompatibilityTest {

    @Test
    void advisoryTypeConverterReadsLegacyValuesAndWritesCanonicalValues() {
        Advisory.AdvisoryTypeConverter converter = new Advisory.AdvisoryTypeConverter();

        assertEquals(Advisory.AdvisoryType.WEATHER, converter.convertToEntityAttribute("WEATHER_ALERT"));
        assertEquals(Advisory.AdvisoryType.PEST, converter.convertToEntityAttribute("PEST_WARNING"));
        assertEquals(Advisory.AdvisoryType.TECHNIQUE, converter.convertToEntityAttribute("BEST_PRACTICES"));
        assertEquals("WEATHER", converter.convertToDatabaseColumn(Advisory.AdvisoryType.WEATHER));
    }

    @Test
    void severityConverterReadsLegacyValuesAndWritesCanonicalValues() {
        Advisory.SeverityConverter converter = new Advisory.SeverityConverter();

        assertEquals(Advisory.Severity.WARNING, converter.convertToEntityAttribute("HIGH"));
        assertEquals(Advisory.Severity.WARNING, converter.convertToEntityAttribute("MEDIUM"));
        assertEquals(Advisory.Severity.CRITICAL, converter.convertToEntityAttribute("URGENT"));
        assertEquals("WARNING", converter.convertToDatabaseColumn(Advisory.Severity.WARNING));
    }
}
