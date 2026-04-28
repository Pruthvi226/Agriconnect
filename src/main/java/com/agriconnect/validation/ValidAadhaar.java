package com.agriconnect.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import java.lang.annotation.*;

@Documented
@Constraint(validatedBy = AadhaarValidator.class)
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidAadhaar {
    String message() default "Invalid Aadhaar Number";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
