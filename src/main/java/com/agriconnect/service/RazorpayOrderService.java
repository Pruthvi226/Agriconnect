package com.agriconnect.service;

import com.agriconnect.exception.BusinessValidationException;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.UUID;

@Service
public class RazorpayOrderService {

    @Value("${razorpay.key.id:}")
    private String razorpayKeyId;

    @Value("${razorpay.key.secret:}")
    private String razorpayKeySecret;

    public String createConsultationOrder(BigDecimal amount, String receipt) {
        if (amount == null || amount.signum() <= 0) {
            throw new BusinessValidationException("Consultation fee must be positive");
        }

        // Local/dev fallback still produces a stable payable reference when real keys are absent.
        if (razorpayKeyId == null || razorpayKeyId.isBlank() || razorpayKeySecret == null || razorpayKeySecret.isBlank()) {
            return "offline_" + receipt + "_" + UUID.randomUUID().toString().replace("-", "").substring(0, 12);
        }

        try {
            RazorpayClient client = new RazorpayClient(razorpayKeyId, razorpayKeySecret);
            JSONObject request = new JSONObject();
            request.put("amount", amount.multiply(new BigDecimal("100")).setScale(0, RoundingMode.HALF_UP).intValueExact());
            request.put("currency", "INR");
            request.put("receipt", receipt);
            request.put("payment_capture", 1);
            Order order = client.orders.create(request);
            return order.get("id");
        } catch (Exception ex) {
            throw new BusinessValidationException("Unable to create Razorpay order: " + ex.getMessage());
        }
    }
}
