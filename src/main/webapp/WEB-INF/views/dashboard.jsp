<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - AgriConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
    <style>
        .progress { height: 8px; border-radius: 4px; background: #e2e8f0; }
        .progress-bar { border-radius: 4px; }
        .navbar .btn-logout {
            background: rgba(255,255,255,0.15); border: 1px solid rgba(255,255,255,0.25);
            color: white; border-radius: 8px; font-size: 0.875rem; font-weight: 500;
            padding: 0.4rem 0.875rem; transition: all 0.2s;
        }
        .navbar .btn-logout:hover { background: rgba(255,255,255,0.25); color: white; }
    </style>
</head>
<body>

<c:choose>
    <c:when test="${role == 'Farmer'}">
        <jsp:include page="fragments/farmer-nav.jsp">
            <jsp:param name="active" value="dashboard" />
        </jsp:include>
    </c:when>
    <c:otherwise>
<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand text-white" href="${pageContext.request.contextPath}/web/marketplace">
            🌾 Agri<span>Connect</span>
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
            <i class="bi bi-list text-white fs-4"></i>
        </button>
        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav ms-auto align-items-center gap-1">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/web/marketplace">
                        <i class="bi bi-shop me-1"></i>Marketplace
                    </a>
                </li>
                <c:if test="${role == 'Farmer'}">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/web/farmer/dashboard">
                        <i class="bi bi-grid me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/web/farmer/profile">
                        <i class="bi bi-person me-1"></i>My Profile
                    </a>
                </li>
                </c:if>
                <c:if test="${role == 'Buyer'}">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/web/buyer/dashboard">
                        <i class="bi bi-grid me-1"></i>Dashboard
                    </a>
                </li>
                </c:if>
                <c:if test="${role == 'Agri-Expert'}">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/web/advisories">
                        <i class="bi bi-lightbulb me-1"></i>Advisories
                    </a>
                </li>
                </c:if>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/web/notifications">
                        <i class="bi bi-bell me-1"></i>Alerts
                    </a>
                </li>
                <li class="nav-item ms-2">
                    <form action="${pageContext.request.contextPath}/logout" method="post" class="d-inline">
                        <button type="submit" class="btn-logout">
                            <i class="bi bi-box-arrow-right me-1"></i>Sign Out
                        </button>
                    </form>
                </li>
            </ul>
        </div>
    </div>
</nav>
    </c:otherwise>
</c:choose>

<!-- ROLE BANNER -->
<div class="role-banner">
    <div class="container">
        <c:choose>
            <c:when test="${role == 'Farmer'}">
                <div class="role-badge">🧑‍🌾 Farmer Account</div>
            </c:when>
            <c:when test="${role == 'Buyer'}">
                <div class="role-badge">🏪 Buyer Account</div>
            </c:when>
            <c:when test="${role == 'Agri-Expert'}">
                <div class="role-badge">🎓 Expert Account</div>
            </c:when>
            <c:otherwise>
                <div class="role-badge">⚙️ Administrator</div>
            </c:otherwise>
        </c:choose>
        <h2>Welcome back!</h2>
        <p>Here's what's happening on your ${role} dashboard today.</p>
    </div>
</div>

<div class="container pb-5" style="margin-top: -1.5rem; position: relative; z-index: 1;">

    <!-- ---- ADMIN PANEL ---- -->
    <c:if test="${role == 'Administrator'}">
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="stat-card h-100">
                    <div class="stat-icon red">⚠️</div>
                    <div class="stat-value text-danger">${belowMspPercentage}%</div>
                    <div class="stat-label">Listings priced BELOW Government MSP</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card h-100">
                    <div class="stat-icon green">✅</div>
                    <div class="stat-value text-success">${empty belowMspPercentage ? '—' : (100 - belowMspPercentage.replaceAll('[^0-9.]',''))}%</div>
                    <div class="stat-label">Listings at or above MSP</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card h-100">
                    <div class="stat-icon blue">📊</div>
                    <div class="stat-value">Live</div>
                    <div class="stat-label">Platform Status — All systems operational</div>
                </div>
            </div>
        </div>
        <div class="admin-alert mb-4">
            <div class="d-flex align-items-center gap-3">
                <div>
                    <div class="msp-percent">${belowMspPercentage}%</div>
                    <div class="text-muted mt-1" style="font-size: 0.85rem;">of active listings are priced <strong>BELOW</strong> the Government Minimum Support Price</div>
                </div>
                <div class="ms-auto text-end">
                    <a href="${pageContext.request.contextPath}/web/marketplace" class="btn btn-warning btn-sm">
                        <i class="bi bi-eye me-1"></i>Review Listings
                    </a>
                </div>
            </div>
        </div>
        <p class="text-muted text-center py-3">
            <i class="bi bi-info-circle me-1"></i>
            Admin features: use the <a href="${pageContext.request.contextPath}/web/marketplace">Marketplace</a>
            to view all listings and enforce MSP compliance.
        </p>
    </c:if>

    <!-- ---- FARMER WORKSPACE ---- -->
    <c:if test="${role == 'Farmer'}">
        <div class="workspace-panel mb-4">
            <div class="panel-title">
                <div>
                    <h2>Farmer Command Center</h2>
                    <div class="text-muted small">Fast actions built for listing, pricing, bids, and field decisions.</div>
                </div>
                <span class="sell-signal good"><i class="bi bi-lightning-charge-fill"></i>Ready to trade</span>
            </div>
            <div class="feature-grid">
                <a href="#addListingPanel" class="farmer-action">
                    <i class="bi bi-plus-circle"></i>
                    <span><strong>Create Listing</strong><span>Post fresh produce</span></span>
                </a>
                <a href="${pageContext.request.contextPath}/web/notifications" class="farmer-action">
                    <i class="bi bi-hammer"></i>
                    <span><strong>Manage Bookings</strong><span>Accept, reject, deliver</span></span>
                </a>
                <a href="${pageContext.request.contextPath}/web/marketplace" class="farmer-action">
                    <i class="bi bi-graph-up-arrow"></i>
                    <span><strong>Market Prices</strong><span>Compare with MSP</span></span>
                </a>
                <a href="${pageContext.request.contextPath}/web/farmer/profile" class="farmer-action">
                    <i class="bi bi-shield-check"></i>
                    <span><strong>Trust Score</strong><span>Improve buyer confidence</span></span>
                </a>
            </div>
        </div>

        <div class="workspace-panel listing-builder mb-4" id="addListingPanel">
            <div class="builder-head">
                <div>
                    <h2><i class="bi bi-plus-square-fill text-success me-2"></i>Add Produce Listing</h2>
                    <div class="text-muted small mt-1">Built from marketplace patterns: photos/quality, MSP guard, availability, and pickup clarity.</div>
                </div>
                <div class="builder-stepper">
                    <span class="builder-step"><i class="bi bi-1-circle"></i>Crop</span>
                    <span class="builder-step"><i class="bi bi-2-circle"></i>Price</span>
                    <span class="builder-step"><i class="bi bi-3-circle"></i>Pickup</span>
                </div>
            </div>

            <div id="listingFormStatus" class="form-status mb-3"></div>

            <form id="addListingForm">
                <div class="row g-3">
                    <div class="col-lg-8">
                        <div class="listing-form-grid">
                            <div>
                                <label class="form-label text-muted fw-bold small">Crop Name</label>
                                <input type="text" class="form-control" name="cropName" id="listingCropName" placeholder="Wheat" required>
                                <span class="field-hint">Use buyer-searchable names.</span>
                            </div>
                            <div>
                                <label class="form-label text-muted fw-bold small">Variety</label>
                                <input type="text" class="form-control" name="variety" id="listingVariety" placeholder="Sharbati" required>
                            </div>
                            <div>
                                <label class="form-label text-muted fw-bold small">Quantity kg</label>
                                <input type="number" class="form-control" name="quantityKg" id="listingQuantity" value="1000" min="1" step="1" required>
                            </div>
                            <div>
                                <label class="form-label text-muted fw-bold small">Quality</label>
                                <select class="form-select" name="qualityGrade" id="listingQuality">
                                    <option value="A">Grade A</option>
                                    <option value="B">Grade B</option>
                                    <option value="C">Grade C</option>
                                </select>
                            </div>
                            <div>
                                <label class="form-label text-muted fw-bold small">Available From</label>
                                <input type="date" class="form-control" name="availableFrom" id="availableFrom" required>
                            </div>
                            <div>
                                <label class="form-label text-muted fw-bold small">Available Until</label>
                                <input type="date" class="form-control" name="availableUntil" id="availableUntil" required>
                            </div>
                            <div>
                                <label class="form-label text-muted fw-bold small">Price / kg</label>
                                <input type="number" class="form-control" name="askingPricePerKg" id="listingPrice" value="25" min="1" step="0.25" required>
                            </div>
                            <div>
                                <label class="form-label text-muted fw-bold small">Pickup Window</label>
                                <select class="form-select" id="listingPickupWindow">
                                    <option>Within 48 hours</option>
                                    <option>3-5 days</option>
                                    <option>Flexible this week</option>
                                </select>
                            </div>
                            <div class="full">
                                <label class="form-label text-muted fw-bold small">Buyer Notes</label>
                                <textarea class="form-control" name="description" id="listingDescription" rows="3" maxlength="500" placeholder="Moisture level, packaging, loading help, farm-gate pickup details..."></textarea>
                                <span class="field-hint">Clear notes reduce back-and-forth and help buyers bid faster.</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="listing-preview">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <div class="text-muted small fw-bold text-uppercase">Live Preview</div>
                                    <h5 class="fw-bold mb-0" id="previewTitle">Wheat</h5>
                                    <div class="text-muted small" id="previewSubtitle">Sharbati · Grade A</div>
                                </div>
                                <span class="preview-chip"><i class="bi bi-shield-check"></i>MSP Guard</span>
                            </div>
                            <div class="preview-price mb-1" id="previewPrice">₹ 25/kg</div>
                            <div class="text-muted small mb-3" id="previewValue">Estimated gross: ₹ 25,000</div>
                            <div class="signal-card mb-3">
                                <div class="signal-label">Listing Strength</div>
                                <div class="progress mt-2">
                                    <div class="progress-bar bg-success" id="listingStrengthBar" style="width: 76%"></div>
                                </div>
                                <div class="text-muted small mt-2" id="listingStrengthText">Good: add photos when upload support is enabled.</div>
                            </div>
                            <button type="submit" class="btn btn-success w-100" id="submitListingBtn">
                                <i class="bi bi-cloud-upload me-1"></i>Publish Listing
                            </button>
                            <button type="button" class="btn btn-outline-success w-100 mt-2" onclick="fillPremiumListing()">
                                <i class="bi bi-magic me-1"></i>Use Smart Example
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <div class="workspace-panel booking-manager mb-4" id="bookingManager">
            <div class="panel-title">
                <div>
                    <h2><i class="bi bi-clipboard2-check text-success me-2"></i>Booking Manager</h2>
                    <div class="text-muted small">Manage buyer quantity requests from listing to delivery.</div>
                </div>
                <div class="d-flex gap-2 flex-wrap justify-content-end">
                    <span class="booking-count"><i class="bi bi-hourglass-split"></i>${pendingBookingCount} requests</span>
                    <span class="booking-count active"><i class="bi bi-truck"></i>${activeOrderCount} active orders</span>
                </div>
            </div>

            <div id="bookingActionStatus" class="form-status mb-3"></div>

            <div class="row g-3">
                <div class="col-lg-7">
                    <div class="booking-lane">
                        <div class="lane-title">
                            <span>Quantity Requests</span>
                            <small>Accept only what you can supply</small>
                        </div>
                        <c:choose>
                            <c:when test="${not empty pendingBookings}">
                                <div class="booking-list">
                                    <c:forEach var="booking" items="${pendingBookings}">
                                        <div class="booking-card" data-booking-id="${booking.id}">
                                            <div class="booking-main">
                                                <div>
                                                    <h3>${booking.listing.cropName} <span>${booking.listing.variety}</span></h3>
                                                    <div class="booking-meta">
                                                        <span><i class="bi bi-building"></i>${booking.buyer.companyName}</span>
                                                        <span><i class="bi bi-box-seam"></i><fmt:formatNumber value="${booking.quantityKg}" maxFractionDigits="0" /> kg requested</span>
                                                        <span><i class="bi bi-currency-rupee"></i>${booking.bidPricePerKg}/kg</span>
                                                    </div>
                                                </div>
                                                <div class="booking-amount">
                                                    <span>Booking value</span>
                                                    <strong>₹ <fmt:formatNumber value="${booking.bidPricePerKg * booking.quantityKg}" maxFractionDigits="0" /></strong>
                                                </div>
                                            </div>
                                            <c:if test="${not empty booking.message}">
                                                <p class="booking-note">${booking.message}</p>
                                            </c:if>
                                            <div class="fulfillment-strip">
                                                <span><i class="bi bi-check2-circle"></i>Available: <fmt:formatNumber value="${booking.listing.quantityKg}" maxFractionDigits="0" /> kg</span>
                                                <span><i class="bi bi-calendar-event"></i>Until ${booking.listing.availableUntil}</span>
                                                <span><i class="bi bi-shield-check"></i>Grade ${booking.listing.qualityGrade}</span>
                                            </div>
                                            <div class="booking-actions">
                                                <button type="button" class="btn btn-success btn-sm" onclick="handleBooking('${booking.id}', 'accept', this)">
                                                    <i class="bi bi-check-lg me-1"></i>Accept
                                                </button>
                                                <button type="button" class="btn btn-outline-danger btn-sm" onclick="handleBooking('${booking.id}', 'reject', this)">
                                                    <i class="bi bi-x-lg me-1"></i>Reject
                                                </button>
                                                <a href="${pageContext.request.contextPath}/web/marketplace/listing/${booking.listing.id}" class="btn btn-outline-success btn-sm">
                                                    <i class="bi bi-eye me-1"></i>Open Listing
                                                </a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-bookings">
                                    <i class="bi bi-inbox"></i>
                                    <strong>No pending booking requests</strong>
                                    <span>New buyer quantity requests will appear here as soon as buyers submit them.</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="booking-lane">
                        <div class="lane-title">
                            <span>Delivery Control</span>
                            <small>Say if you can deliver, then close the order</small>
                        </div>
                        <c:choose>
                            <c:when test="${not empty farmerOrders}">
                                <div class="booking-list compact">
                                    <c:forEach var="order" items="${farmerOrders}">
                                        <div class="booking-card order-card" data-order-id="${order.id}">
                                            <div class="d-flex justify-content-between gap-3 align-items-start">
                                                <div>
                                                    <h3>${order.bid.listing.cropName} <span>${order.orderStatus}</span></h3>
                                                    <div class="booking-meta">
                                                        <span><i class="bi bi-box-seam"></i><fmt:formatNumber value="${order.quantityKg}" maxFractionDigits="0" /> kg</span>
                                                        <span><i class="bi bi-currency-rupee"></i><fmt:formatNumber value="${order.totalAmount}" maxFractionDigits="0" /></span>
                                                    </div>
                                                </div>
                                                <span class="status-badge ${order.orderStatus == 'DELIVERED' ? 'done' : order.orderStatus == 'CANCELLED' ? 'danger' : 'live'}">${order.orderStatus}</span>
                                            </div>
                                            <div class="delivery-rail">
                                                <span class="${order.orderStatus == 'CONFIRMED' || order.orderStatus == 'IN_TRANSIT' || order.orderStatus == 'DELIVERED' ? 'on' : ''}">Confirmed</span>
                                                <span class="${order.orderStatus == 'IN_TRANSIT' || order.orderStatus == 'DELIVERED' ? 'on' : ''}">Can deliver</span>
                                                <span class="${order.orderStatus == 'DELIVERED' ? 'on' : ''}">Delivered</span>
                                            </div>
                                            <div class="booking-actions">
                                                <button type="button" class="btn btn-outline-success btn-sm" onclick="updateDelivery('${order.id}', 'can_deliver', this)">
                                                    <i class="bi bi-truck me-1"></i>Can Deliver
                                                </button>
                                                <button type="button" class="btn btn-success btn-sm" onclick="updateDelivery('${order.id}', 'delivered', this)">
                                                    <i class="bi bi-check2-all me-1"></i>Delivered
                                                </button>
                                                <button type="button" class="btn btn-outline-danger btn-sm" onclick="updateDelivery('${order.id}', 'cannot_deliver', this)">
                                                    <i class="bi bi-slash-circle me-1"></i>Cannot
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-bookings">
                                    <i class="bi bi-truck"></i>
                                    <strong>No active deliveries</strong>
                                    <span>Accepted bookings become delivery cards here.</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-lg-8">
                <div class="workspace-panel h-100">
                    <div class="panel-title">
                        <h2>Price Assistant</h2>
                        <span class="priority-pill">MSP-aware</span>
                    </div>
                    <div class="mini-form-grid mb-3">
                        <div>
                            <label class="form-label text-muted fw-bold small">Crop</label>
                            <select id="cropPreset" class="form-select" onchange="updatePriceAssistant()">
                                <option value="wheat" data-msp="22.75" data-market="25.40">Wheat</option>
                                <option value="onion" data-msp="18.20" data-market="23.80">Onion</option>
                                <option value="rice" data-msp="23.00" data-market="26.10">Rice</option>
                                <option value="tomato" data-msp="14.00" data-market="19.60">Tomato</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label text-muted fw-bold small">Your Price / kg</label>
                            <input id="askingPrice" type="number" class="form-control" value="25" min="1" step="0.5" oninput="updatePriceAssistant()">
                        </div>
                        <div>
                            <label class="form-label text-muted fw-bold small">Quantity kg</label>
                            <input id="quantityKg" type="number" class="form-control" value="1200" min="1" step="50" oninput="updatePriceAssistant()">
                        </div>
                        <div>
                            <label class="form-label text-muted fw-bold small">Pickup Window</label>
                            <select class="form-select">
                                <option>Within 2 days</option>
                                <option>3-5 days</option>
                                <option>Next week</option>
                            </select>
                        </div>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <div class="signal-card">
                                <div class="signal-label">Market Avg</div>
                                <div class="signal-value" id="marketAvg">₹ 25.40</div>
                                <span class="text-muted small">Nearby district rate</span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="signal-card">
                                <div class="signal-label">MSP Guard</div>
                                <div class="signal-value" id="mspGuard">Above MSP</div>
                                <span id="mspHint" class="sell-signal good mt-2">Good floor price</span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="signal-card">
                                <div class="signal-label">Expected Value</div>
                                <div class="signal-value" id="expectedValue">₹ 30,000</div>
                                <span class="text-muted small">Before logistics</span>
                            </div>
                        </div>
                    </div>
                    <div class="d-flex flex-wrap gap-2 mt-3">
                        <a href="#addListingPanel" class="btn btn-success">
                            <i class="bi bi-upload me-1"></i>List Produce
                        </a>
                        <a href="${pageContext.request.contextPath}/web/notifications" class="btn btn-outline-success">
                            <i class="bi bi-bell me-1"></i>Set Price Alert
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="workspace-panel h-100">
                    <div class="panel-title">
                        <h2>Today on the Farm</h2>
                    </div>
                    <div class="timeline-list">
                        <div class="timeline-item">
                            <i class="bi bi-cloud-sun"></i>
                            <div>
                                <strong>Spray window opens after 4 PM</strong>
                                <span>Low wind expected in Nashik belt</span>
                            </div>
                            <span class="priority-pill">Weather</span>
                        </div>
                        <div class="timeline-item">
                            <i class="bi bi-truck"></i>
                            <div>
                                <strong>Confirm pickup availability</strong>
                                <span>2 buyers prefer morning loading</span>
                            </div>
                            <span class="priority-pill">Trade</span>
                        </div>
                        <div class="timeline-item">
                            <i class="bi bi-lightbulb"></i>
                            <div>
                                <strong>Advisory: onion storage</strong>
                                <span>Ventilate stacks before humidity rises</span>
                            </div>
                            <span class="priority-pill">Expert</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-lg-7">
                <div class="workspace-panel h-100">
                    <div class="panel-title">
                        <h2>Booking Playbook</h2>
                        <a href="#bookingManager" class="btn btn-sm btn-outline-success">Manage</a>
                    </div>
                    <div class="timeline-list">
                        <div class="timeline-item">
                            <i class="bi bi-currency-rupee"></i>
                            <div>
                                <strong>Accept by quantity fit first</strong>
                                <span>Prefer requests you can fully supply without reducing quality.</span>
                            </div>
                            <span class="priority-pill">Rule</span>
                        </div>
                        <div class="timeline-item">
                            <i class="bi bi-chat-dots"></i>
                            <div>
                                <strong>Check delivery promise</strong>
                                <span>Mark can deliver only when transport and pickup window are ready.</span>
                            </div>
                            <span class="priority-pill">Action</span>
                        </div>
                        <div class="timeline-item">
                            <i class="bi bi-hourglass-split"></i>
                            <div>
                                <strong>Reject early when stock is short</strong>
                                <span>Declining quickly keeps buyer trust higher than late cancellation.</span>
                            </div>
                            <span class="priority-pill">Trust</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-5">
                <div class="workspace-panel h-100">
                    <div class="panel-title">
                        <h2>Local Price Watch</h2>
                        <span class="sell-signal watch">Watch</span>
                    </div>
                    <table class="price-table">
                        <tbody>
                            <tr>
                                <td>Onion</td>
                                <td><span class="text-success fw-bold">₹ 23.80/kg</span><br><small class="text-muted">+9% this week</small></td>
                            </tr>
                            <tr>
                                <td>Wheat</td>
                                <td><span class="text-success fw-bold">₹ 25.40/kg</span><br><small class="text-muted">Above MSP</small></td>
                            </tr>
                            <tr>
                                <td>Tomato</td>
                                <td><span class="text-warning fw-bold">₹ 19.60/kg</span><br><small class="text-muted">Volatile demand</small></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-lg-4">
                <div class="workspace-panel h-100">
                    <div class="panel-title">
                        <h2>My Listing Health</h2>
                        <span class="priority-pill">3 active</span>
                    </div>
                    <div class="listing-health">
                        <div class="health-row">
                            <div>
                                <strong><span class="status-dot green"></span>Wheat - Sharbati</strong>
                                <span>12 buyer views, 4 bid signals, price above MSP</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/web/marketplace" class="btn btn-sm btn-outline-success">Open</a>
                        </div>
                        <div class="health-row">
                            <div>
                                <strong><span class="status-dot orange"></span>Tomato - Grade A</strong>
                                <span>Expires tomorrow, update freshness note</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/web/marketplace" class="btn btn-sm btn-outline-warning">Fix</a>
                        </div>
                        <div class="health-row">
                            <div>
                                <strong><span class="status-dot blue"></span>Onion - Red</strong>
                                <span>High demand nearby, add pickup slot</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/web/marketplace" class="btn btn-sm btn-outline-primary">Boost</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="workspace-panel h-100">
                    <div class="panel-title">
                        <h2>Logistics & Payment</h2>
                        <span class="sell-signal good">Ready</span>
                    </div>
                    <div class="readiness-list">
                        <div class="readiness-item">
                            <span><i class="bi bi-truck me-2"></i>Pickup address</span>
                            <span class="text-success">Ready</span>
                        </div>
                        <div class="readiness-item">
                            <span><i class="bi bi-bank me-2"></i>Bank account</span>
                            <span class="text-warning">Verify</span>
                        </div>
                        <div class="readiness-item">
                            <span><i class="bi bi-receipt me-2"></i>Invoice details</span>
                            <span class="text-success">Ready</span>
                        </div>
                        <div class="readiness-item">
                            <span><i class="bi bi-box-seam me-2"></i>Packaging notes</span>
                            <span class="text-warning">Add</span>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/web/farmer/profile" class="btn btn-success w-100 mt-3">
                        <i class="bi bi-person-check me-1"></i>Update Profile
                    </a>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="workspace-panel h-100">
                    <div class="panel-title">
                        <h2>Harvest Planner</h2>
                        <span class="priority-pill">7 days</span>
                    </div>
                    <div class="planner-grid">
                        <div class="planner-step">
                            <div class="day">Today</div>
                            <strong>Grade produce</strong>
                            <span>Separate A/B quality before listing.</span>
                        </div>
                        <div class="planner-step">
                            <div class="day">Tomorrow</div>
                            <strong>Upload photos</strong>
                            <span>Add close-up and sack-level images.</span>
                        </div>
                        <div class="planner-step">
                            <div class="day">Friday</div>
                            <strong>Accept bids</strong>
                            <span>Choose buyer by price and pickup reliability.</span>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/web/notifications" class="btn btn-outline-success w-100 mt-3">
                        <i class="bi bi-calendar-check me-1"></i>Set Reminder
                    </a>
                </div>
            </div>
        </div>

        <!-- Recommendations -->
        <div class="section-title">
            Recommended Buyers
            <span class="badge bg-success ms-auto" style="font-size: 0.7rem;">AI Matchmaking</span>
        </div>

        <c:choose>
            <c:when test="${not empty matches}">
                <div class="row g-3">
                    <c:forEach var="match" items="${matches}">
                        <div class="col-md-4">
                            <div class="match-card">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <div class="fw-bold text-dark">${match.buyer.companyName}</div>
                                        <div class="text-muted" style="font-size: 0.8rem;">
                                            <i class="bi bi-geo-alt me-1"></i>${match.buyer.district}
                                        </div>
                                    </div>
                                    <span class="match-score-badge">${match.score}%</span>
                                </div>
                                <div class="progress mb-2">
                                    <div class="progress-bar bg-success" role="progressbar"
                                         data-width="${match.score}"
                                         aria-valuenow="${match.score}"
                                         aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                                <div class="text-muted d-flex gap-2 flex-wrap" style="font-size: 0.75rem;">
                                    <span><i class="bi bi-geo-alt"></i> Proximity</span>
                                    <span><i class="bi bi-flower1"></i> Crop Fit</span>
                                    <span><i class="bi bi-clock-history"></i> Trade History</span>
                                </div>
                                <a href="${pageContext.request.contextPath}/web/marketplace"
                                   class="btn btn-outline-success btn-sm w-100 mt-3">
                                    <i class="bi bi-box-arrow-up-right me-1"></i>Open Marketplace
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="workspace-panel text-center py-5">
                    <i class="bi bi-people text-success" style="font-size: 3rem;"></i>
                    <h5 class="mt-3 text-dark">No buyer matches yet</h5>
                    <p class="text-muted mb-0">Add active listings and keep your profile complete to improve buyer matching.</p>
                    <a href="${pageContext.request.contextPath}/web/marketplace" class="btn btn-success mt-3">
                        <i class="bi bi-shop-window me-1"></i>Browse Marketplace
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </c:if>

    <!-- ---- BUYER MATCHMAKING ---- -->
    <c:if test="${role == 'Buyer'}">

        <!-- Quick Actions -->
        <div class="row g-3 mb-4">
            <c:if test="${role == 'Farmer'}">
            <div class="col-6 col-md-3">
                <a href="${pageContext.request.contextPath}/web/marketplace" class="action-btn">
                    <div class="action-icon">🌾</div>
                    <div class="action-label">My Listings</div>
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="${pageContext.request.contextPath}/web/farmer/profile" class="action-btn">
                    <div class="action-icon">⭐</div>
                    <div class="action-label">Farmer Score</div>
                </a>
            </div>
            </c:if>
            <c:if test="${role == 'Buyer'}">
            <div class="col-6 col-md-3">
                <a href="${pageContext.request.contextPath}/web/marketplace" class="action-btn">
                    <div class="action-icon">🛒</div>
                    <div class="action-label">Browse Market</div>
                </a>
            </div>
            </c:if>
            <div class="col-6 col-md-3">
                <a href="${pageContext.request.contextPath}/web/notifications" class="action-btn">
                    <div class="action-icon">🔔</div>
                    <div class="action-label">Notifications</div>
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="${pageContext.request.contextPath}/web/marketplace" class="action-btn">
                    <div class="action-icon">📈</div>
                    <div class="action-label">Market Prices</div>
                </a>
            </div>
        </div>

        <!-- Recommendations -->
        <div class="section-title">
            ✨ Recommended for You
            <span class="badge bg-success ms-auto" style="font-size: 0.7rem;">AI Matchmaking</span>
        </div>

        <c:choose>
            <c:when test="${not empty matches}">
                <div class="row g-3">
                    <c:forEach var="match" items="${matches}">
                        <div class="col-md-4">
                            <div class="match-card">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <c:if test="${role == 'Farmer'}">
                                        <div>
                                            <div class="fw-bold text-dark">${match.buyer.companyName}</div>
                                            <div class="text-muted" style="font-size: 0.8rem;">
                                                <i class="bi bi-geo-alt me-1"></i>${match.buyer.district}
                                            </div>
                                        </div>
                                    </c:if>
                                    <c:if test="${role == 'Buyer'}">
                                        <div>
                                            <div class="fw-bold text-dark">Farmer — ${match.farmer.district}</div>
                                            <div class="text-muted" style="font-size: 0.8rem;">
                                                Score: ${match.farmer.farmerScore}/100
                                            </div>
                                        </div>
                                    </c:if>
                                    <span class="match-score-badge">${match.score}%</span>
                                </div>
                                <div class="progress mb-2">
                                    <div class="progress-bar bg-success" role="progressbar"
                                         data-width="${match.score}"
                                         aria-valuenow="${match.score}"
                                         aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                                <div class="text-muted d-flex gap-2 flex-wrap" style="font-size: 0.75rem;">
                                    <span><i class="bi bi-geo-alt"></i> Proximity</span>
                                    <span><i class="bi bi-flower1"></i> Crop Fit</span>
                                    <span><i class="bi bi-clock-history"></i> Trade History</span>
                                </div>
                                <a href="${pageContext.request.contextPath}/web/marketplace"
                                   class="btn btn-outline-success btn-sm w-100 mt-3">
                                    <i class="bi bi-box-arrow-up-right me-1"></i>View in Marketplace
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5 bg-white rounded-4">
                    <div style="font-size: 3rem;">🤝</div>
                    <h5 class="mt-3 text-dark">No matches yet</h5>
                    <p class="text-muted mb-0">Our AI will generate recommendations based on your trade history. Check back soon!</p>
                    <a href="${pageContext.request.contextPath}/web/marketplace" class="btn btn-success mt-3">
                        <i class="bi bi-shop me-1"></i>Browse Marketplace
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </c:if>

    <!-- ---- EXPERT PANEL ---- -->
    <c:if test="${role == 'Agri-Expert'}">
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <a href="${pageContext.request.contextPath}/web/advisories" class="action-btn">
                    <div class="action-icon">📢</div>
                    <div class="action-label">Publish Advisory</div>
                </a>
            </div>
            <div class="col-md-4">
                <a href="${pageContext.request.contextPath}/web/notifications" class="action-btn">
                    <div class="action-icon">🔔</div>
                    <div class="action-label">Notifications</div>
                </a>
            </div>
            <div class="col-md-4">
                <a href="${pageContext.request.contextPath}/web/marketplace" class="action-btn">
                    <div class="action-icon">📊</div>
                    <div class="action-label">Market Overview</div>
                </a>
            </div>
        </div>
        <div class="text-center py-5 bg-white rounded-4">
            <div style="font-size: 3rem;">🎓</div>
            <h5 class="mt-3 text-dark">Expert Dashboard</h5>
            <p class="text-muted mb-0">Share agricultural advisories and insights with registered farmers.</p>
            <a href="${pageContext.request.contextPath}/web/advisories" class="btn btn-success mt-3">
                <i class="bi bi-megaphone me-1"></i>Go to Advisories
            </a>
        </div>
    </c:if>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function formatRupees(value) {
        return 'Rs ' + Math.round(value).toLocaleString('en-IN');
    }

    function updatePriceAssistant() {
        const crop = document.getElementById('cropPreset');
        const priceInput = document.getElementById('askingPrice');
        const qtyInput = document.getElementById('quantityKg');
        if (!crop || !priceInput || !qtyInput) return;

        const selected = crop.options[crop.selectedIndex];
        const msp = parseFloat(selected.dataset.msp || '0');
        const market = parseFloat(selected.dataset.market || '0');
        const price = parseFloat(priceInput.value || '0');
        const quantity = parseFloat(qtyInput.value || '0');
        const mspGuard = document.getElementById('mspGuard');
        const mspHint = document.getElementById('mspHint');

        document.getElementById('marketAvg').innerText = 'Rs ' + market.toFixed(2);
        document.getElementById('expectedValue').innerText = formatRupees(price * quantity);

        if (price >= msp) {
            mspGuard.innerText = 'Above MSP';
            mspHint.innerText = 'Good floor price';
            mspHint.className = 'sell-signal good mt-2';
        } else {
            mspGuard.innerText = 'Below MSP';
            mspHint.innerText = 'Raise price';
            mspHint.className = 'sell-signal watch mt-2';
        }
    }

    function getTomorrowIso(offsetDays) {
        const date = new Date();
        date.setDate(date.getDate() + offsetDays);
        return date.toISOString().slice(0, 10);
    }

    function updateListingPreview() {
        const crop = document.getElementById('listingCropName');
        const variety = document.getElementById('listingVariety');
        const quality = document.getElementById('listingQuality');
        const qty = document.getElementById('listingQuantity');
        const price = document.getElementById('listingPrice');
        if (!crop || !variety || !quality || !qty || !price) return;

        const cropText = crop.value.trim() || 'Wheat';
        const varietyText = variety.value.trim() || 'Sharbati';
        const qualityText = quality.value || 'A';
        const quantityValue = parseFloat(qty.value || '0');
        const priceValue = parseFloat(price.value || '0');
        const totalValue = quantityValue * priceValue;

        document.getElementById('previewTitle').innerText = cropText;
        document.getElementById('previewSubtitle').innerText = varietyText + ' · Grade ' + qualityText;
        document.getElementById('previewPrice').innerText = 'Rs ' + (priceValue || 0).toFixed(2) + '/kg';
        document.getElementById('previewValue').innerText = 'Estimated gross: ' + formatRupees(totalValue || 0);

        let strength = 45;
        if (crop.value.trim()) strength += 10;
        if (variety.value.trim()) strength += 10;
        if (quantityValue >= 100) strength += 10;
        if (priceValue >= 15) strength += 10;
        if (document.getElementById('listingDescription').value.trim().length > 30) strength += 15;
        strength = Math.min(strength, 100);

        document.getElementById('listingStrengthBar').style.width = strength + '%';
        document.getElementById('listingStrengthText').innerText =
            strength >= 85 ? 'Excellent: buyers have enough detail to bid confidently.' :
            strength >= 70 ? 'Good: add photos when upload support is enabled.' :
            'Needs detail: add variety, quantity, and pickup notes.';
    }

    function fillPremiumListing() {
        document.getElementById('listingCropName').value = 'Wheat';
        document.getElementById('listingVariety').value = 'Sharbati';
        document.getElementById('listingQuantity').value = '1250';
        document.getElementById('listingQuality').value = 'A';
        document.getElementById('listingPrice').value = '26.5';
        document.getElementById('availableFrom').value = getTomorrowIso(1);
        document.getElementById('availableUntil').value = getTomorrowIso(7);
        document.getElementById('listingDescription').value = 'Clean Grade A stock, packed in 50 kg bags, farm-gate pickup available with loading support in the morning.';
        updateListingPreview();
    }

    function showListingStatus(type, message) {
        const status = document.getElementById('listingFormStatus');
        if (!status) return;
        status.className = 'form-status mb-3 ' + type;
        status.innerText = message;
    }

    function submitListing(event) {
        event.preventDefault();
        const form = event.target;
        const btn = document.getElementById('submitListingBtn');
        const payload = {
            cropName: form.cropName.value.trim(),
            variety: form.variety.value.trim(),
            quantityKg: parseFloat(form.quantityKg.value),
            availableFrom: form.availableFrom.value,
            availableUntil: form.availableUntil.value,
            askingPricePerKg: parseFloat(form.askingPricePerKg.value),
            qualityGrade: form.qualityGrade.value,
            description: form.description.value.trim()
        };

        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Publishing...';

        fetch('${pageContext.request.contextPath}/api/v1/listings', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        })
        .then(async response => {
            const data = await response.json().catch(() => ({}));
            if (!response.ok || data.success === false) {
                throw new Error(data.message || 'Could not create listing. Please check the form.');
            }
            showListingStatus('success', 'Listing published. Buyers can now discover it in the marketplace.');
            form.reset();
            fillPremiumListing();
        })
        .catch(error => showListingStatus('error', error.message))
        .finally(() => {
            btn.disabled = false;
            btn.innerHTML = '<i class="bi bi-cloud-upload me-1"></i>Publish Listing';
        });
    }

    function showBookingStatus(type, message) {
        const status = document.getElementById('bookingActionStatus');
        if (!status) return;
        status.className = 'form-status mb-3 ' + type;
        status.innerText = message;
    }

    function runBookingAction(url, button, loadingText, successText) {
        const original = button ? button.innerHTML : '';
        if (button) {
            button.disabled = true;
            button.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>' + loadingText;
        }

        fetch(url, { method: 'PUT', headers: { 'Content-Type': 'application/json' } })
            .then(async response => {
                const data = await response.json().catch(() => ({}));
                if (!response.ok || data.success === false) {
                    throw new Error(data.message || 'Could not update booking.');
                }
                showBookingStatus('success', successText);
                setTimeout(() => window.location.reload(), 700);
            })
            .catch(error => {
                showBookingStatus('error', error.message);
                if (button) {
                    button.disabled = false;
                    button.innerHTML = original;
                }
            });
    }

    function handleBooking(id, action, button) {
        const label = action === 'accept' ? 'Accepting...' : 'Rejecting...';
        const done = action === 'accept'
            ? 'Booking accepted. The order is now ready for delivery tracking.'
            : 'Booking rejected. The buyer has been notified.';
        runBookingAction('${pageContext.request.contextPath}/api/v1/bids/' + id + '/' + action, button, label, done);
    }

    function updateDelivery(id, action, button) {
        const labels = {
            can_deliver: 'Updating...',
            delivered: 'Closing...',
            cannot_deliver: 'Cancelling...'
        };
        const messages = {
            can_deliver: 'Marked as deliverable. Buyer has been updated.',
            delivered: 'Order marked delivered and payment moved to paid.',
            cannot_deliver: 'Order cancelled as cannot deliver. Buyer has been updated.'
        };
        runBookingAction('${pageContext.request.contextPath}/api/v1/bids/orders/' + id + '/delivery/' + action,
            button,
            labels[action] || 'Updating...',
            messages[action] || 'Delivery updated.');
    }

    updatePriceAssistant();
    fillPremiumListing();

    const addListingForm = document.getElementById('addListingForm');
    if (addListingForm) {
        addListingForm.addEventListener('submit', submitListing);
        addListingForm.querySelectorAll('input, select, textarea').forEach(function(field) {
            field.addEventListener('input', updateListingPreview);
            field.addEventListener('change', updateListingPreview);
        });
    }

    // Animate progress bars
    document.querySelectorAll('.progress-bar').forEach(function(el) {
        const w = el.getAttribute('data-width');
        if (w) {
            el.style.width = '0%';
            setTimeout(() => { el.style.transition = 'width 1s ease-in-out'; el.style.width = w + '%'; }, 200);
        }
    });
</script>
</body>
</html>
