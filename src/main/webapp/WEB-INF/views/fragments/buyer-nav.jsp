<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg app-navbar">
    <div class="container">
        <a class="navbar-brand text-white" href="${pageContext.request.contextPath}/web/marketplace">
            <i class="bi bi-shop me-2"></i>Agri<span>Connect</span>
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#buyerNavMenu" aria-label="Toggle navigation">
            <i class="bi bi-list text-white fs-4"></i>
        </button>
        <div class="collapse navbar-collapse" id="buyerNavMenu">
            <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-2 mt-3 mt-lg-0">
                <li class="nav-item">
                    <a class="nav-link app-nav-dashboard ${param.active == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/web/buyer/dashboard">
                        <i class="bi bi-grid-1x2 me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'marketplace' ? 'active' : ''}" href="${pageContext.request.contextPath}/web/marketplace">
                        <i class="bi bi-shop-window me-1"></i>Browse Market
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'bids' ? 'active' : ''}" href="${pageContext.request.contextPath}/web/buyer/bids">
                        <i class="bi bi-hammer me-1"></i>My Bids
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'orders' ? 'active' : ''}" href="${pageContext.request.contextPath}/web/buyer/orders">
                        <i class="bi bi-truck me-1"></i>Orders
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
