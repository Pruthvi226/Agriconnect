<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg app-navbar">
    <div class="container">
        <a class="navbar-brand text-white" href="${pageContext.request.contextPath}/web/marketplace">
            <i class="bi bi-flower1 me-2"></i>Agri<span>Connect</span>
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#farmerNavMenu" aria-label="Toggle navigation">
            <i class="bi bi-list text-white fs-4"></i>
        </button>
        <div class="collapse navbar-collapse" id="farmerNavMenu">
            <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-2 mt-3 mt-lg-0">
                <li class="nav-item">
                    <a class="nav-link app-nav-dashboard ${param.active == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/web/dashboard/farmer">
                        <i class="bi bi-grid-1x2 me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'marketplace' ? 'active' : ''}" href="${pageContext.request.contextPath}/web/marketplace">
                        <i class="bi bi-shop-window me-1"></i>Marketplace
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'listings' ? 'active' : ''}" href="${pageContext.request.contextPath}/web/dashboard/farmer/listings">
                        <i class="bi bi-card-checklist me-1"></i>Listings
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'bookings' ? 'active' : ''}" href="${pageContext.request.contextPath}/web/dashboard/farmer/bookings">
                        <i class="bi bi-clipboard2-check me-1"></i>Bookings
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/web/dashboard/farmer/profile">
                        <i class="bi bi-person-badge me-1"></i>Profile
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'alerts' ? 'active' : ''}" href="${pageContext.request.contextPath}/web/notifications">
                        <i class="bi bi-bell me-1"></i>Alerts
                    </a>
                </li>
                <li class="nav-item ms-lg-2">
                    <form action="${pageContext.request.contextPath}/logout" method="post" class="d-inline">
                        <button type="submit" class="btn app-nav-signout">
                            <i class="bi bi-box-arrow-right me-1"></i>Sign Out
                        </button>
                    </form>
                </li>
            </ul>
        </div>
    </div>
</nav>
