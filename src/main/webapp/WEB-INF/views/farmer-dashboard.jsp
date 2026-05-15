<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Farmer Dashboard | AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
</head>
<body class="bg-light">

<jsp:include page="fragments/farmer-nav.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>

<!-- TOP - Greeting Bar (Part 2: PAGE 1) -->
<div class="bg-white border-bottom py-3 mb-4">
    <div class="container d-flex justify-content-between align-items-center">
        <div>
            <h1 class="h4 mb-0 fw-800">Namaste, ${farmer.user.name} 👋</h1>
            <p class="text-muted small mb-0">${farmer.village}, ${farmer.district}</p>
        </div>
        <div class="position-relative">
            <a href="${pageContext.request.contextPath}/web/notifications" class="text-dark fs-4">
                <i class="bi bi-bell"></i>
                <c:if test="${unreadCount > 0}">
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.6rem;">
                        ${unreadCount}
                    </span>
                </c:if>
            </a>
        </div>
    </div>
</div>

<div class="container pb-5">
    
    <!-- EXPERT ADVISORY ALERTS (Feature 6) -->
    <c:forEach var="advisory" items="${advisories}">
        <div class="alert ${advisory.severity == 'CRITICAL' ? 'alert-danger' : 'alert-warning'} alert-dismissible fade show rounded-4 shadow-sm mb-4" role="alert">
            <div class="d-flex align-items-center">
                <i class="bi ${advisory.severity == 'CRITICAL' ? 'bi-exclamation-triangle-fill' : 'bi-exclamation-circle-fill'} fs-2 me-3"></i>
                <div>
                    <strong class="d-block">${advisory.severity}: ${advisory.title}</strong>
                    <p class="mb-1 small">${advisory.body.length() > 120 ? advisory.body.substring(0, 120).concat('...') : advisory.body}</p>
                    <a href="${pageContext.request.contextPath}/web/advisories/${advisory.id}" class="fw-bold text-decoration-none">Read Full Advisory (पूरा पढ़ें)</a>
                </div>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:forEach>

    <!-- ROW 1 - 3 Stat Cards (Rule 1 & Part 2) -->
    <div class="row g-3 mb-4">
        <div class="col-12 col-md-4">
            <div class="card farmer-card p-4 bg-white">
                <div class="d-flex justify-content-between">
                    <div>
                        <div class="farmer-stat-value text-success">${listingCount}</div>
                        <div class="farmer-stat-label">Active Listings</div>
                        <div class="small text-muted">(आपकी फसलें)</div>
                    </div>
                    <div class="fs-1 text-success opacity-25"><i class="bi bi-list-ul"></i></div>
                </div>
            </div>
        </div>
        <div class="col-12 col-md-4">
            <div class="card farmer-card p-4 bg-white">
                <div class="d-flex justify-content-between">
                    <div>
                        <div class="farmer-stat-value text-warning">${pendingBookingCount}</div>
                        <div class="farmer-stat-label">Bids Received</div>
                        <div class="small text-muted">(मिली बोलियां)</div>
                    </div>
                    <div class="fs-1 text-warning opacity-25"><i class="bi bi-envelope-paper"></i></div>
                </div>
            </div>
        </div>
        <div class="col-12 col-md-4">
            <div class="card farmer-card p-4 bg-white border-primary border-opacity-25">
                <div class="d-flex justify-content-between">
                    <div>
                        <div class="farmer-stat-value text-primary">₹<fmt:formatNumber value="${earnings.monthlyEarnings}" maxFractionDigits="0"/></div>
                        <div class="farmer-stat-label">Monthly Earnings</div>
                        <a href="${pageContext.request.contextPath}/web/farmer/listings" class="small text-decoration-none">View All</a>(इस महीने की कमाई)</div>
                    </div>
                    <div class="fs-1 text-primary opacity-25"><i class="bi bi-currency-rupee"></i></div>
                </div>
            </div>
        </div>
    </div>

    <!-- ROW 2 - Latest Bids (Part 2: PAGE 1) -->
    <div class="row mb-4">
        <div class="col-12">
            <h2 class="h5 fw-800 mb-3 d-flex align-items-center">
                <i class="bi bi-lightning-charge-fill text-warning me-2"></i> Latest Bids
            </h2>
            <c:choose>
                <c:when test="${not empty latestBids}">
                    <div class="row g-3">
                        <c:forEach var="bid" items="${latestBids}">
                            <div class="col-12 col-md-4">
                                <div class="card border-0 shadow-sm rounded-4 h-100 ${bid.bidPricePerKg >= bid.listing.askingPricePerKg ? 'border-start border-4 border-success' : ''}">
                                    <div class="card-body p-4">
                                        <div class="d-flex justify-content-between mb-3">
                                            <span class="badge bg-light text-dark border rounded-pill px-3 py-2 fw-bold">
                                                ${bid.listing.cropName}
                                            </span>
                                            <small class="text-muted"><i class="bi bi-clock me-1"></i> 2h ago</small>
                                        </div>
                                        <div class="mb-3">
                                            <div class="fs-4 fw-800 ${bid.bidPricePerKg >= bid.listing.askingPricePerKg ? 'text-success' : 'text-dark'}">
                                                ₹${bid.bidPricePerKg}/kg
                                            </div>
                                            <div class="small text-muted">Asking: ₹${bid.listing.askingPricePerKg}/kg</div>
                                            
                                            <c:if test="${not empty bid.listing.mspPricePerKg && bid.bidPricePerKg < bid.listing.mspPricePerKg}">
                                                <div class="mt-2 py-1 px-2 bg-danger-subtle text-danger rounded small fw-bold">
                                                    <i class="bi bi-exclamation-triangle-fill me-1"></i> Below MSP (₹${bid.listing.mspPricePerKg})
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="d-flex align-items-center mb-4">
                                            <div class="bg-light rounded-circle p-2 me-2">
                                                <i class="bi bi-building text-secondary"></i>
                                            </div>
                                            <div class="small fw-bold">${bid.buyer.companyName}</div>
                                        </div>
                                        <div class="d-flex gap-2">
                                            <form action="${pageContext.request.contextPath}/web/farmer/bids/${bid.id}/accept" method="post" class="flex-grow-1">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                <button type="submit" class="btn btn-success w-100 btn-sm">
                                                    <i class="bi bi-check-circle"></i> Accept
                                                </button>
                                            </form>
                                            <a href="${pageContext.request.contextPath}/web/farmer/bookings" class="btn btn-outline-secondary btn-sm px-3">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="bg-white rounded-4 p-5 text-center shadow-sm">
                        <i class="bi bi-inbox fs-1 text-muted opacity-25"></i>
                        <p class="mt-3 fw-bold">No bids yet. Add more listings to get discovered!</p>
                        <a href="${pageContext.request.contextPath}/web/farmer/listings" class="btn btn-primary mt-2">
                            <i class="bi bi-plus-circle"></i> Add Listing
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- BOTTOM - Quick Links (Rule 7) -->
    <div class="row g-3">
        <div class="col-6 col-md-3">
            <a href="${pageContext.request.contextPath}/web/farmer/listings" class="btn btn-white w-100 shadow-sm rounded-4 p-4 border-0 text-center h-100 d-flex flex-column align-items-center justify-content-center">
                <i class="bi bi-plus-circle fs-2 text-success mb-2"></i>
                <span class="fw-bold">Add Listing</span>
                <small class="text-muted">(फसल जोड़ें)</small>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="${pageContext.request.contextPath}/web/farmer/bookings" class="btn btn-white w-100 shadow-sm rounded-4 p-4 border-0 text-center h-100 d-flex flex-column align-items-center justify-content-center">
                <i class="bi bi-clipboard-data fs-2 text-warning mb-2"></i>
                <span class="fw-bold">My Bids</span>
                <small class="text-muted">(मेरी बोलियां)</small>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="${pageContext.request.contextPath}/web/farmer/earnings" class="btn btn-white w-100 shadow-sm rounded-4 p-4 border-0 text-center h-100 d-flex flex-column align-items-center justify-content-center">
                <i class="bi bi-wallet2 fs-2 text-primary mb-2"></i>
                <span class="fw-bold">Earnings</span>
                <small class="text-muted">(कमाई)</small>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="${pageContext.request.contextPath}/web/msp-checker" class="btn btn-white w-100 shadow-sm rounded-4 p-4 border-0 text-center h-100 d-flex flex-column align-items-center justify-content-center">
                <i class="bi bi-shield-check fs-2 text-info mb-2"></i>
                <span class="fw-bold">Help</span>
                <small class="text-muted">(सहायता)</small>
            </a>
        </div>
    </div>

</div>

<jsp:include page="fragments/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
