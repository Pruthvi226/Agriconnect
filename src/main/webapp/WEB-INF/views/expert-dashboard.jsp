<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expert Dashboard - AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg app-navbar">
    <div class="container">
        <a class="navbar-brand text-white" href="${pageContext.request.contextPath}/web/expert/dashboard">
            <i class="bi bi-mortarboard me-2"></i>AgriConnect Expert
        </a>
        <div class="navbar-nav ms-auto gap-3">
            <a class="nav-link active" href="${pageContext.request.contextPath}/web/expert/dashboard">Dashboard</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/web/expert/slots">Slots</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/web/advisories">Advisories</a>
        </div>
    </div>
</nav>

<div class="container py-4">
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="stat-card h-100">
                <div class="stat-icon green"><i class="bi bi-calendar2-check"></i></div>
                <div class="stat-value">${upcomingCount}</div>
                <div class="stat-label">Upcoming sessions</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card h-100">
                <div class="stat-icon blue"><i class="bi bi-currency-rupee"></i></div>
                <div class="stat-value">Rs <fmt:formatNumber value="${totalEarnings}" maxFractionDigits="0" /></div>
                <div class="stat-label">Net expert earnings</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card h-100">
                <div class="stat-icon gold"><i class="bi bi-wallet2"></i></div>
                <div class="stat-value">${walletTransactions.size()}</div>
                <div class="stat-label">Wallet credits</div>
            </div>
        </div>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="h4 mb-0">Upcoming Sessions</h2>
        <a class="btn btn-success" href="${pageContext.request.contextPath}/web/expert/slots">
            <i class="bi bi-plus-circle me-1"></i>Manage Availability
        </a>
    </div>

    <div class="row g-3">
        <c:forEach var="booking" items="${bookings}">
            <div class="col-lg-6">
                <div class="booking-card h-100">
                    <div class="booking-main">
                        <div>
                            <h3>${booking.cropFocus} <span>${booking.consultationStatus}</span></h3>
                            <div class="booking-meta">
                                <span><i class="bi bi-person"></i>${booking.farmer.user.name}</span>
                                <span><i class="bi bi-geo-alt"></i>${booking.farmerDistrict}</span>
                                <span><i class="bi bi-clock"></i>${booking.slot.slotDate} ${booking.slot.startTime}</span>
                            </div>
                        </div>
                        <div class="booking-amount">
                            <span>Fee</span>
                            <strong>Rs <fmt:formatNumber value="${booking.feeAmount}" maxFractionDigits="0" /></strong>
                        </div>
                    </div>
                    <div class="booking-actions">
                        <a class="btn btn-outline-success btn-sm" href="${pageContext.request.contextPath}/web/expert/sessions/${booking.id}">
                            <i class="bi bi-box-arrow-up-right me-1"></i>Open Session
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty bookings}">
            <div class="col-12">
                <div class="empty-bookings">
                    <i class="bi bi-calendar-x"></i>
                    <strong>No sessions booked yet</strong>
                    <span>Publish consultation slots to start receiving bookings from farmers.</span>
                </div>
            </div>
        </c:if>
    </div>

    <div class="workspace-panel mt-4">
        <div class="panel-title">
            <div>
                <h2>Wallet Credits</h2>
                <div class="text-muted small">Net payouts after AgriConnect platform fee.</div>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table align-middle">
                <thead>
                <tr>
                    <th>Consultation</th>
                    <th>Gross</th>
                    <th>Platform Fee</th>
                    <th>Net</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="wallet" items="${walletTransactions}">
                    <tr>
                        <td>#${wallet.consultation.id}</td>
                        <td>Rs <fmt:formatNumber value="${wallet.grossAmount}" maxFractionDigits="0" /></td>
                        <td>Rs <fmt:formatNumber value="${wallet.platformFee}" maxFractionDigits="0" /></td>
                        <td class="text-success fw-bold">Rs <fmt:formatNumber value="${wallet.netAmount}" maxFractionDigits="0" /></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty walletTransactions}">
                    <tr><td colspan="4" class="text-muted">No expert wallet credits yet.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
