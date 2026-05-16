<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supply Chain Trace - AgriConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body>
<section class="farmer-hero compact-hero">
    <div class="container">
        <span class="farmer-chip"><i class="bi bi-qr-code-scan"></i> Supply Chain Transparency</span>
        <h1>Trace verified farm origin</h1>
        <p>This produce record is published without buyer identity and validated through AgriConnect order completion.</p>
    </div>
</section>

<main class="container farmer-page-shell">
    <div class="row g-3">
        <div class="col-lg-8">
            <section class="workspace-panel h-100">
                <div class="panel-title">
                    <div>
                        <h2>${trace.cropName}</h2>
                        <div class="text-muted small">${trace.variety} · Grade ${trace.qualityGrade}</div>
                    </div>
                    <span class="status-badge done">Verified by AgriConnect</span>
                </div>
                <div class="compact-table">
                    <div class="compact-row">
                        <span><strong>Farmer</strong><small>${trace.farmerName}</small></span>
                        <span><strong>District</strong><small>${trace.district}</small></span>
                        <span><strong>State</strong><small>${trace.state}</small></span>
                        <span class="status-badge live">${trace.farmerScoreBadge}</span>
                    </div>
                    <div class="compact-row">
                        <span><strong>Farmer score</strong><small><fmt:formatNumber value="${trace.farmerScore}" minFractionDigits="2" maxFractionDigits="2" /></small></span>
                        <span><strong>Quantity</strong><small><fmt:formatNumber value="${trace.quantityKg}" maxFractionDigits="0" /> kg</small></span>
                        <span><strong>Listing date</strong><small>${trace.listingDate}</small></span>
                        <span><strong>Pickup date</strong><small>${trace.pickupDate}</small></span>
                    </div>
                </div>
            </section>
        </div>
        <div class="col-lg-4">
            <section class="workspace-panel h-100 text-center">
                <c:if test="${not empty trace.qrImageUrl}">
                    <img src="${trace.qrImageUrl}" alt="Trace QR code" class="img-fluid rounded-4 border mb-3" />
                </c:if>
                <div class="text-muted small">Trace token</div>
                <div class="fw-bold">${trace.token}</div>
                <div class="mt-3 text-muted small">Scanned ${trace.scanCount} times</div>
            </section>
        </div>
    </div>
</main>
</body>
</html>
