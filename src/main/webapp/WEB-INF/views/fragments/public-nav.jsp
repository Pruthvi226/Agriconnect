<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<nav class="navbar navbar-expand-lg app-navbar">
    <div class="container">
        <a class="navbar-brand text-white" href="${pageContext.request.contextPath}/web/marketplace">
            <i class="bi bi-flower1 me-2"></i>Agri<span>Connect</span>
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#publicNavMenu" aria-label="Toggle navigation">
            <i class="bi bi-list text-white fs-4"></i>
        </button>
        <div class="collapse navbar-collapse" id="publicNavMenu">
            <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-2 mt-3 mt-lg-0">
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'marketplace' ? 'active' : ''}" href="${pageContext.request.contextPath}/web/marketplace">
                        <i class="bi bi-shop-window me-1"></i>Marketplace
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'msp' ? 'active' : ''}" href="${pageContext.request.contextPath}/web/msp-checker">
                        <i class="bi bi-graph-up-arrow me-1"></i>MSP Checker
                    </a>
                </li>
                <li class="nav-item ms-lg-2">
                    <a class="btn app-nav-signout" href="${pageContext.request.contextPath}/web/login">
                        <i class="bi bi-box-arrow-in-right me-1"></i>Sign In
                    </a>
                </li>
                <li class="nav-item">
                    <a class="btn btn-light fw-bold" href="${pageContext.request.contextPath}/web/register">
                        <i class="bi bi-person-plus me-1"></i>Register
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>
