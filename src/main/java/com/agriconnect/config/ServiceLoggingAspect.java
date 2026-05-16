package com.agriconnect.config;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * Aspect for logging execution time of service methods.
 * Flags any service call taking longer than 500ms as a performance warning.
 */
@Aspect
@Component
public class ServiceLoggingAspect {

    private static final Logger log = LoggerFactory.getLogger(ServiceLoggingAspect.class);

    @Around("execution(* com.agriconnect.service.*.*(..))")
    public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
        long start = System.currentTimeMillis();
        
        Object proceed = joinPoint.proceed();
        
        long executionTime = System.currentTimeMillis() - start;
        
        String methodName = joinPoint.getSignature().toShortString();
        
        if (executionTime > 500) {
            log.warn("PERFORMANCE ALERT: {} executed in {}ms", methodName, executionTime);
        } else if (log.isDebugEnabled()) {
            log.debug("{} executed in {}ms", methodName, executionTime);
        }
        
        return proceed;
    }
}
