<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg app-navbar">
    <div class="container">
        <a class="navbar-brand text-white" href="${pageContext.request.contextPath}/web/dashboard/admin">
            <i class="bi bi-shield-lock me-2"></i>Agri<span>Admin</span>
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavMenu" aria-label="Toggle navigation">
            <i class="bi bi-list text-white fs-4"></i>
        </button>
        <div class="collapse navbar-collapse" id="adminNavMenu">
            <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-2 mt-3 mt-lg-0">
                <li class="nav-item">
                    <a class="nav-link app-nav-dashboard ${param.active == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/web/dashboard/admin">
                        <i class="bi bi-speedometer2 me-1"></i>Overview
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/web/dashboard/admin/users">
                        <i class="bi bi-people me-1"></i>User Management
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'msp' ? 'active' : ''}" href="${pageContext.request.contextPath}/web/dashboard/admin/msp">
                        <i class="bi bi-currency-rupee me-1"></i>MSP Rates
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'audit' ? 'active' : ''}" href="${pageContext.request.contextPath}/web/dashboard/admin/audit">
                        <i class="bi bi-journal-text me-1"></i>Audit Logs
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
