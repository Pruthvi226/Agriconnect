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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/web/dashboard/farmer">
                        <i class="bi bi-grid me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/web/dashboard/farmer/profile">
                        <i class="bi bi-person me-1"></i>My Profile
                    </a>
                </li>
                </c:if>
                <c:if test="${role == 'Buyer'}">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/web/dashboard/buyer">
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

    <!-- ---- FARMER / BUYER MATCHMAKING ---- -->
    <c:if test="${role == 'Farmer' || role == 'Buyer'}">

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
                <a href="${pageContext.request.contextPath}/web/dashboard/farmer/profile" class="action-btn">
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
