<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Expert Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/agriconnect.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../fragments/expert-nav.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>
<main class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h1 class="h4">Expert Dashboard</h1>
        <a class="btn btn-success" href="${pageContext.request.contextPath}/web/advisories">Create Advisory</a>
    </div>

    <c:if test="${totalEarnings ne null}">
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body">
                        <div class="text-muted small">Upcoming sessions</div>
                        <div class="fs-3 fw-bold">${upcomingCount}</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body">
                        <div class="text-muted small">Net expert earnings</div>
                        <div class="fs-3 fw-bold">Rs <fmt:formatNumber value="${totalEarnings}" maxFractionDigits="0" /></div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body">
                        <div class="text-muted small">Wallet credits</div>
                        <div class="fs-3 fw-bold">${walletTransactions.size()}</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="h5 mb-0">Upcoming Sessions</h2>
            <a class="btn btn-outline-success" href="${pageContext.request.contextPath}/web/expert/slots">Manage Availability</a>
        </div>
        <div class="row g-3 mb-4">
            <c:forEach var="booking" items="${bookings}">
                <div class="col-lg-6">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body">
                            <h3 class="h6">${booking.cropFocus} <span class="badge text-bg-light">${booking.consultationStatus}</span></h3>
                            <div class="text-muted small">${booking.farmer.user.name} · ${booking.farmerDistrict}</div>
                            <div class="text-muted small">${booking.slot.slotDate} ${booking.slot.startTime}</div>
                            <a class="btn btn-sm btn-outline-success mt-3" href="${pageContext.request.contextPath}/web/expert/sessions/${booking.id}">Open Session</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty bookings}">
                <div class="col-12">
                    <div class="alert alert-light border mb-0">No sessions booked yet.</div>
                </div>
            </c:if>
        </div>
    </c:if>

    <c:if test="${advisories ne null}">
        <table class="table table-striped">
            <thead><tr><th>Title</th><th>Crop</th><th>Type</th><th>Severity</th><th>Valid Until</th></tr></thead>
            <tbody>
            <c:forEach var="advisory" items="${advisories}">
                <tr><td>${advisory.title}</td><td>${advisory.cropName}</td><td>${advisory.advisoryType}</td><td>${advisory.severity}</td><td>${advisory.validUntil}</td></tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
</main>
</body>
</html>
