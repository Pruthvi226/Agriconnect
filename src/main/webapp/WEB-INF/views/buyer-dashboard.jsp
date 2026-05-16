<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buyer Dashboard - AgriConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body>
<jsp:include page="fragments/buyer-nav.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>

<section class="role-banner">
    <div class="container">
        <span class="role-badge"><i class="bi bi-shop"></i> Buyer Portal</span>
        <h2>Welcome back, ${buyer.companyName}</h2>
        <p>Manage your procurement, track bids, and discover high-quality produce.</p>
    </div>
</section>

<main class="container mt-n4">
    <div class="row g-4">
        <!-- Stats Row -->
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon blue mb-3"><i class="bi bi-hammer"></i></div>
                <div class="stat-value">${activeBidCount != null ? activeBidCount : 0}</div>
                <div class="stat-label">Active Bids</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon green mb-3"><i class="bi bi-truck"></i></div>
                <div class="stat-value">${activeOrderCount != null ? activeOrderCount : 0}</div>
                <div class="stat-label">Pending Deliveries</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon orange mb-3"><i class="bi bi-wallet2"></i></div>
                <div class="stat-value">₹<fmt:formatNumber value="${buyer.creditLimit}" pattern="#,##,###"/></div>
                <div class="stat-label">Credit Limit</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon red mb-3"><i class="bi bi-star-fill"></i></div>
                <div class="stat-value">4.8</div>
                <div class="stat-label">Buyer Rating</div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-lg-8">
            <section class="mb-4">
                <div class="section-title">
                    <i class="bi bi-stars text-warning"></i> Recommended for You
                </div>
                <div class="row g-3">
                    <c:choose>
                        <c:when test="${not empty matches}">
                            <c:forEach var="match" items="${matches}">
                                <div class="col-md-6">
                                    <div class="match-card">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <span class="match-score-badge">Match Score: ${match.score}%</span>
                                            <i class="bi bi-geo-alt text-danger small"> ${match.farmer.district}</i>
                                        </div>
                                        <h5 class="fw-bold mb-1">${match.farmer.user.name}</h5>
                                        <p class="text-muted small mb-3">Specializes in ${match.farmer.state} produce</p>
                                        <div class="d-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/web/marketplace?farmerId=${match.farmer.id}" class="btn btn-sm btn-outline-success w-100">View Listings</a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12">
                                <div class="alert alert-light border text-center py-4">
                                    <i class="bi bi-search fs-2 mb-2 d-block text-muted"></i>
                                    <p class="mb-0">No smart matches yet. Try updating your preferred crops in profile.</p>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </div>

        <div class="col-lg-4">
            <section class="mb-4">
                <div class="section-title">Quick Actions</div>
                <div class="row g-2">
                    <div class="col-6">
                        <a href="${pageContext.request.contextPath}/web/marketplace" class="action-btn">
                            <div class="action-icon text-success"><i class="bi bi-search"></i></div>
                            <div class="action-label">Browse Crops</div>
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="${pageContext.request.contextPath}/web/buyer/bids" class="action-btn">
                            <div class="action-icon text-primary"><i class="bi bi-hammer"></i></div>
                            <div class="action-label">Track Bids</div>
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="${pageContext.request.contextPath}/web/buyer/orders" class="action-btn">
                            <div class="action-icon text-info"><i class="bi bi-clock-history"></i></div>
                            <div class="action-label">Order History</div>
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="${pageContext.request.contextPath}/web/notifications" class="action-btn">
                            <div class="action-icon text-danger"><i class="bi bi-bell"></i></div>
                            <div class="action-label">Alerts</div>
                        </a>
                    </div>
                </div>
            </section>
            
            <section class="stat-card">
                <div class="section-title">Market Pulse</div>
                <div class="d-flex align-items-center gap-3 mb-3">
                    <div class="stat-icon blue"><i class="bi bi-graph-up"></i></div>
                    <div>
                        <div class="fw-bold">Wheat (Sharbati)</div>
                        <div class="text-success small"><i class="bi bi-caret-up-fill"></i> +2.4% this week</div>
                    </div>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <div class="stat-icon orange"><i class="bi bi-graph-down"></i></div>
                    <div>
                        <div class="fw-bold">Rice (Basmati)</div>
                        <div class="text-danger small"><i class="bi bi-caret-down-fill"></i> -1.2% this week</div>
                    </div>
                </div>
            </section>
        </div>
    </div>
</main>

<jsp:include page="fragments/footer.jsp" />
</body>
</html>
