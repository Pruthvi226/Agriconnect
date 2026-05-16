<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Farmer Dashboard - AgriConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body>
<jsp:include page="fragments/farmer-nav.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>

<section class="farmer-hero compact-hero">
    <div class="container">
        <span class="farmer-chip"><i class="bi bi-speedometer2"></i> Farmer Overview</span>
        <h1>Today’s trade desk</h1>
        <p>Track listing health, booking requests, and deliveries from one clean summary.</p>
    </div>
</section>

<main class="container farmer-page-shell">
    <div class="dashboard-metrics">
        <a class="metric-tile" href="${pageContext.request.contextPath}/web/dashboard/farmer/listings">
            <span class="metric-icon green"><i class="bi bi-card-checklist"></i></span>
            <span>
                <strong>${listingCount}</strong>
                <small>Total listings</small>
            </span>
        </a>
        <a class="metric-tile" href="${pageContext.request.contextPath}/web/dashboard/farmer/bookings">
            <span class="metric-icon amber"><i class="bi bi-hourglass-split"></i></span>
            <span>
                <strong>${pendingBookingCount}</strong>
                <small>Pending bookings</small>
            </span>
        </a>
        <a class="metric-tile" href="${pageContext.request.contextPath}/web/dashboard/farmer/bookings">
            <span class="metric-icon blue"><i class="bi bi-truck"></i></span>
            <span>
                <strong>${activeOrderCount}</strong>
                <small>Active deliveries</small>
            </span>
        </a>
        <a class="metric-tile" href="${pageContext.request.contextPath}/web/dashboard/farmer/bookings">
            <span class="metric-icon purple"><i class="bi bi-check2-circle"></i></span>
            <span>
                <strong>${deliveredOrderCount}</strong>
                <small>Delivered orders</small>
            </span>
        </a>
        <a class="metric-tile" href="${pageContext.request.contextPath}/web/farmer/consultations">
            <span class="metric-icon green"><i class="bi bi-camera-video"></i></span>
            <span>
                <strong>Expert Help</strong>
                <small>Book a consultation</small>
            </span>
        </a>
    </div>

    <div class="row g-3 mt-1">
        <div class="col-lg-8">
            <section class="workspace-panel h-100">
                <div class="panel-title">
                    <div>
                        <h2>Next Best Actions</h2>
                        <div class="text-muted small">A lightweight flow for selling without jumping between screens.</div>
                    </div>
                </div>
                <div class="clean-action-grid">
                    <a href="${pageContext.request.contextPath}/web/dashboard/farmer/listings#addListingPanel" class="clean-action">
                        <i class="bi bi-plus-circle"></i>
                        <strong>Add listing</strong>
                        <span>Publish crop, quantity, price, and availability.</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/web/dashboard/farmer/listings#myListings" class="clean-action">
                        <i class="bi bi-list-check"></i>
                        <strong>Review listings</strong>
                        <span>See active stock and marketplace-ready details.</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/web/dashboard/farmer/bookings" class="clean-action">
                        <i class="bi bi-clipboard2-check"></i>
                        <strong>Manage bookings</strong>
                        <span>Accept, reject, and update delivery status.</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/web/farmer/consultations" class="clean-action">
                        <i class="bi bi-camera-video"></i>
                        <strong>Talk to an expert</strong>
                        <span>Book 30 or 60 minute crop consultations with verified advisors.</span>
                    </a>
                </div>
            </section>
        </div>
        <div class="col-lg-4">
            <section class="workspace-panel h-100">
                <div class="panel-title">
                    <h2>Quick Flow</h2>
                    <span class="priority-pill">End to end</span>
                </div>
                <div class="flow-steps">
                    <div><span>1</span><strong>Add listing</strong><small>Crop, grade, quantity, price</small></div>
                    <div><span>2</span><strong>Buyer requests</strong><small>Quantity and offered price</small></div>
                    <div><span>3</span><strong>Accept or reject</strong><small>Stock is reserved after accept</small></div>
                    <div><span>4</span><strong>Deliver</strong><small>Can deliver, delivered, or cannot</small></div>
                </div>
            </section>
        </div>
    </div>

    <section class="workspace-panel mt-3">
        <div class="panel-title">
            <div>
                <h2>What to grow next season</h2>
                <div class="text-muted small">Built from the last 90 days of buyer demand and six months of accepted price movement.</div>
            </div>
            <span class="priority-pill">Forecast</span>
        </div>
        <c:choose>
            <c:when test="${not empty forecastTopCrops}">
                <div class="compact-table">
                    <c:forEach var="crop" items="${forecastTopCrops}">
                        <c:set var="trend" value="${forecastTrendMap[crop.cropName]}" />
                        <div class="compact-row">
                            <span>
                                <strong>${crop.cropName}</strong>
                                <small>${crop.bidCount} buyer signals in the last 90 days</small>
                            </span>
                            <span>Avg bid Rs <fmt:formatNumber value="${crop.avgPrice}" minFractionDigits="2" maxFractionDigits="2" />/kg</span>
                            <span>
                                <c:choose>
                                    <c:when test="${not empty trend and trend.direction == 'UP'}">
                                        <span class="status-badge success"><i class="bi bi-arrow-up-right"></i> Up <fmt:formatNumber value="${trend.changePercent}" minFractionDigits="0" maxFractionDigits="2" />%</span>
                                    </c:when>
                                    <c:when test="${not empty trend and trend.direction == 'DOWN'}">
                                        <span class="status-badge danger"><i class="bi bi-arrow-down-right"></i> Down <fmt:formatNumber value="${0 - trend.changePercent}" minFractionDigits="0" maxFractionDigits="2" />%</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge neutral"><i class="bi bi-arrow-left-right"></i> Flat</span>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-bookings">
                    <i class="bi bi-graph-up-arrow"></i>
                    <strong>Forecast is warming up</strong>
                    <span>As more bids and accepted prices come in, AgriConnect will highlight the strongest crops and districts for your next cycle.</span>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <section class="workspace-panel mt-3">
        <div class="panel-title">
            <h2>Recent Listings</h2>
            <a href="${pageContext.request.contextPath}/web/dashboard/farmer/listings" class="btn btn-sm btn-outline-success">Open listings</a>
        </div>
        <c:choose>
            <c:when test="${not empty farmerListings}">
                <div class="compact-table">
                    <c:forEach var="listing" items="${farmerListings}" begin="0" end="4">
                        <div class="compact-row">
                            <span><strong>${listing.cropName}</strong><small>${listing.variety} · Grade ${listing.qualityGrade}</small></span>
                            <span><fmt:formatNumber value="${listing.quantityKg}" maxFractionDigits="0" /> kg</span>
                            <span>Rs ${listing.askingPricePerKg}/kg</span>
                            <span class="status-badge live">${listing.status}</span>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-bookings">
                    <i class="bi bi-card-checklist"></i>
                    <strong>No listings yet</strong>
                    <span>Create your first produce listing to start receiving booking requests.</span>
                    <a class="btn btn-success mt-2" href="${pageContext.request.contextPath}/web/dashboard/farmer/listings#addListingPanel">Add Listing</a>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
