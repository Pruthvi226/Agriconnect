package com.agriconnect.validation;

import com.agriconnect.dto.ListingRequestDto;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

public class ValidDateRangeValidator implements ConstraintValidator<ValidDateRange, ListingRequestDto> {
    @Override
    public boolean isValid(ListingRequestDto dto, ConstraintValidatorContext context) {
        if (dto.getAvailableFrom() == null || dto.getAvailableUntil() == null) {
            return true; // Let @NotNull handle this
        }
        return dto.getAvailableFrom().isBefore(dto.getAvailableUntil());
    }
}
