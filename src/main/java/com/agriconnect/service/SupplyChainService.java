package com.agriconnect.service;

import com.agriconnect.dao.OrderDao;
import com.agriconnect.dao.SupplyChainTokenDao;
import com.agriconnect.dto.SupplyChainTraceView;
import com.agriconnect.exception.ResourceNotFoundException;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.Order;
import com.agriconnect.model.ProduceListing;
import com.agriconnect.model.SupplyChainToken;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.HexFormat;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class SupplyChainService {

    @Autowired
    private SupplyChainTokenDao supplyChainTokenDao;

    @Autowired
    private OrderDao orderDao;

    @Value("${app.base-url:http://localhost:8080/agriconnect}")
    private String baseUrl;

    @Value("${app.qr.storage-dir:src/main/webapp/qr}")
    private String qrStorageDir;

    public String generateQrForOrder(Long orderId) {
        Order order = orderDao.findDetailedById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Order not found"));
        SupplyChainToken token = supplyChainTokenDao.findByOrderId(orderId).orElseGet(() -> createToken(order));

        String publicUrl = buildPublicTraceUrl(token.getToken());
        try {
            byte[] pngBytes = renderQr(publicUrl);
            String fileName = token.getToken() + ".png";
            writeQrFile(fileName, pngBytes);
            token.setQrImagePath(fileName);
            supplyChainTokenDao.update(token);
            return buildQrImageUrl(fileName);
        } catch (IOException | WriterException e) {
            throw new IllegalStateException("Unable to generate QR code for order " + orderId, e);
        }
    }

    public SupplyChainTraceView resolveSupplyChainTrace(String tokenValue) {
        SupplyChainToken token = supplyChainTokenDao.findByToken(tokenValue)
                .orElseThrow(() -> new ResourceNotFoundException("Supply chain trace not found"));
        token.setScanCount(Optional.ofNullable(token.getScanCount()).orElse(0) + 1);
        supplyChainTokenDao.update(token);
        return toTraceView(token);
    }

    public byte[] getQrImageBytesForOrder(Long orderId) {
        SupplyChainToken token = supplyChainTokenDao.findByOrderId(orderId)
                .orElseGet(() -> {
                    generateQrForOrder(orderId);
                    return supplyChainTokenDao.findByOrderId(orderId)
                            .orElseThrow(() -> new ResourceNotFoundException("Supply chain QR not found"));
                });
        try {
            return Files.readAllBytes(resolveQrPath(token.getQrImagePath()));
        } catch (IOException e) {
            throw new IllegalStateException("Unable to read QR image for order " + orderId, e);
        }
    }

    @Transactional(readOnly = true)
    public SupplyChainTraceView getTraceViewForOrder(Long orderId) {
        SupplyChainToken token = supplyChainTokenDao.findByOrderId(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Supply chain trace not found"));
        return toTraceView(token);
    }

    @Transactional(readOnly = true)
    public byte[] getQrImageBytes(String fileName) {
        try {
            return Files.readAllBytes(resolveQrPath(fileName));
        } catch (IOException e) {
            throw new ResourceNotFoundException("QR image not found");
        }
    }

    private SupplyChainToken createToken(Order order) {
        SupplyChainToken token = new SupplyChainToken();
        token.setOrder(order);
        token.setToken(generateToken(order.getId()));
        supplyChainTokenDao.save(token);
        return token;
    }

    private String generateToken(Long orderId) {
        String uuidPart = UUID.randomUUID().toString().replace("-", "");
        String orderHash = HexFormat.of().toHexDigits(("order-" + orderId).hashCode());
        return (uuidPart + orderHash).substring(0, Math.min(40, uuidPart.length() + orderHash.length()));
    }

    private byte[] renderQr(String publicUrl) throws WriterException, IOException {
        BitMatrix matrix = new QRCodeWriter().encode(publicUrl, BarcodeFormat.QR_CODE, 320, 320);
        try (ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
            MatrixToImageWriter.writeToStream(matrix, "PNG", outputStream);
            return outputStream.toByteArray();
        }
    }

    private void writeQrFile(String fileName, byte[] pngBytes) throws IOException {
        Path storageDir = Paths.get(qrStorageDir).toAbsolutePath().normalize();
        Files.createDirectories(storageDir);
        Files.write(resolveQrPath(fileName), pngBytes);
    }

    private Path resolveQrPath(String fileName) {
        Path storageDir = Paths.get(qrStorageDir).toAbsolutePath().normalize();
        Path filePath = storageDir.resolve(fileName).normalize();
        if (!filePath.startsWith(storageDir)) {
            throw new ResourceNotFoundException("QR image not found");
        }
        return filePath;
    }

    private String buildPublicTraceUrl(String token) {
        return baseUrl + "/chain/" + token;
    }

    private String buildQrImageUrl(String fileName) {
        return baseUrl + "/qr/" + fileName;
    }

    private SupplyChainTraceView toTraceView(SupplyChainToken token) {
        Order order = orderDao.findDetailedById(token.getOrder().getId())
                .orElseThrow(() -> new ResourceNotFoundException("Order not found"));
        ProduceListing listing = order.getBid().getListing();
        FarmerProfile farmer = order.getFarmer();

        SupplyChainTraceView view = new SupplyChainTraceView();
        view.setToken(token.getToken());
        view.setPublicUrl(buildPublicTraceUrl(token.getToken()));
        view.setQrImageUrl(token.getQrImagePath() == null ? null : buildQrImageUrl(token.getQrImagePath()));
        view.setScanCount(Optional.ofNullable(token.getScanCount()).orElse(0));
        view.setFarmerName(farmer.getUser() != null ? farmer.getUser().getName() : "AgriConnect Farmer");
        view.setDistrict(farmer.getDistrict());
        view.setState(farmer.getState());
        view.setFarmerScore(farmer.getFarmerScore());
        view.setFarmerScoreBadge(resolveScoreBadge(farmer.getFarmerScore()));
        view.setCropName(listing.getCropName());
        view.setVariety(listing.getVariety());
        view.setQualityGrade(listing.getQualityGrade() != null ? listing.getQualityGrade().name() : "Not graded");
        view.setListingDate(listing.getCreatedAt() != null ? listing.getCreatedAt().toLocalDate() : LocalDate.now());
        view.setPickupDate(order.getActualDelivery() != null ? order.getActualDelivery() : order.getExpectedDelivery());
        view.setQuantityKg(order.getQuantityKg());
        return view;
    }

    private String resolveScoreBadge(BigDecimal farmerScore) {
        BigDecimal score = farmerScore == null ? BigDecimal.ZERO : farmerScore;
        if (score.compareTo(new BigDecimal("90")) >= 0) {
            return "Elite";
        }
        if (score.compareTo(new BigDecimal("70")) >= 0) {
            return "Top Seller";
        }
        if (score.compareTo(new BigDecimal("40")) >= 0) {
            return "Reliable";
        }
        return "New Farmer";
    }
}
