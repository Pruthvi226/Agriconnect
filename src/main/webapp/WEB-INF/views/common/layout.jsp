<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">AgriConnect</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav me-auto">
                <sec:authorize access="hasRole('FARMER')">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/farmer/dashboard">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/farmer/listings">Listings</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/farmer/bids">Bids</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/farmer/orders">Orders</a></li>
                </sec:authorize>
                <sec:authorize access="hasRole('BUYER')">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/buyer/dashboard">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/buyer/search">Search</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/buyer/bids">Bids</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/buyer/orders">Orders</a></li>
                </sec:authorize>
                <sec:authorize access="hasRole('ADMIN')">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Users</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/msp">MSP</a></li>
                </sec:authorize>
                <sec:authorize access="hasRole('AGRI_EXPERT')">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/expert/advisories">Advisories</a></li>
                </sec:authorize>
            </ul>
            <a class="btn btn-outline-light btn-sm me-2" href="${pageContext.request.contextPath}/api/notifications">Notifications <span class="badge text-bg-light">${unreadCount}</span></a>
            <form action="${pageContext.request.contextPath}/auth/logout" method="post" class="d-flex">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <button class="btn btn-light btn-sm" type="submit">Logout</button>
            </form>
        </div>
    </div>
</nav>
