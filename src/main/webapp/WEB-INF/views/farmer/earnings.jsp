<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Earnings | AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
</head>
<body class="bg-light">

<jsp:include page="../fragments/farmer-nav.jsp">
    <jsp:param name="active" value="earnings" />
</jsp:include>

<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-12 col-md-8">
            
            <!-- HEADER (Feature 4) -->
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
                <div class="card-body bg-primary text-white p-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h1 class="h3 fw-800 mb-1">My Earnings</h1>
                            <p class="mb-0 opacity-75">Track your sales and income (आपकी कमाई)</p>
                        </div>
                        <div class="bg-white bg-opacity-25 p-3 rounded-4">
                            <i class="bi bi-wallet2 fs-1"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- EARNINGS SUMMARY CARDS -->
            <div class="row g-3 mb-4">
                <div class="col-6">
                    <div class="card border-0 shadow-sm rounded-4 p-4 text-center h-100">
                        <div class="text-muted small fw-bold mb-1">THIS MONTH</div>
                        <div class="h2 fw-800 text-success mb-0">₹<fmt:formatNumber value="${earnings.monthlyEarnings}" maxFractionDigits="0"/></div>
                        <div class="small text-muted">${earnings.monthlyOrders} Orders</div>
                    </div>
                </div>
                <div class="col-6">
                    <div class="card border-0 shadow-sm rounded-4 p-4 text-center h-100">
                        <div class="text-muted small fw-bold mb-1">THIS YEAR</div>
                        <div class="h2 fw-800 text-primary mb-0">₹<fmt:formatNumber value="${earnings.yearlyEarnings}" maxFractionDigits="0"/></div>
                        <div class="small text-muted">${earnings.yearlyOrders} Orders</div>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4 bg-white border-start border-4 border-info">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-muted small fw-bold">TOTAL VOLUME SOLD</div>
                        <div class="h3 fw-800 mb-0">${earnings.allTimeKgSold} kg</div>
                    </div>
                    <div class="text-end">
                        <div class="text-muted small fw-bold">TOTAL INCOME</div>
                        <div class="h3 fw-800 text-success mb-0">₹<fmt:formatNumber value="${earnings.allTimeEarnings}" maxFractionDigits="0"/></div>
                    </div>
                </div>
            </div>

            <!-- RECENT TRANSACTIONS (Part 2: PAGE 1 - record-keeping) -->
            <h2 class="h5 fw-800 mb-3">Recent Settlements</h2>
            <c:choose>
                <c:when test="${not empty earnings.recentOrders}">
                    <c:forEach var="order" items="${earnings.recentOrders}">
                        <div class="card border-0 shadow-sm rounded-4 mb-3 p-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="d-flex align-items-center">
                                    <div class="bg-light p-3 rounded-4 me-3">
                                        <i class="bi bi-receipt text-secondary fs-4"></i>
                                    </div>
                                    <div>
                                        <div class="fw-800">${order.crop}</div>
                                        <div class="small text-muted">${order.qty} kg · ₹${order.price}/kg</div>
                                        <div class="small text-muted font-monospace" style="font-size: 0.7rem;">Buyer: ${order.buyer}</div>
                                    </div>
                                </div>
                                <div class="text-end">
                                    <div class="fw-800 text-success">+ ₹<fmt:formatNumber value="${order.total}" maxFractionDigits="0"/></div>
                                    <div class="small text-muted">${order.date}</div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="bg-white rounded-4 p-5 text-center shadow-sm">
                        <p class="text-muted mb-0">No completed orders yet.</p>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="alert alert-info rounded-4 border-0 mt-4 small">
                <i class="bi bi-info-circle-fill me-2"></i>
                Payments are typically settled within 48 hours of delivery confirmation.
            </div>
        </div>
    </div>
</div>

<jsp:include page="../fragments/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
