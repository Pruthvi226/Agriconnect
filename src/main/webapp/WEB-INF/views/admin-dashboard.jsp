<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Command Center - AgriConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="fragments/admin-nav.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>

<section class="role-banner py-4">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <span class="role-badge bg-danger border-danger text-white"><i class="bi bi-shield-lock"></i> System Admin</span>
                <h2>Platform Oversight</h2>
                <p>Monitoring platform health, user verification, and MSP compliance.</p>
            </div>
            <div class="text-end">
                <div class="stat-value text-white">${allUsers.size()}</div>
                <div class="stat-label text-white-50">Total Registered Users</div>
            </div>
        </div>
    </div>
</section>

<main class="container mt-n4">
    <div class="row g-4">
        <!-- Platform Health -->
        <div class="col-lg-4">
            <div class="admin-alert h-100">
                <div class="section-title text-warning"><i class="bi bi-exclamation-triangle"></i> MSP Alert</div>
                <div class="msp-percent mb-2">${belowMspPercentage}%</div>
                <div class="fw-bold mb-3">Listings below MSP</div>
                <p class="small text-muted mb-4">A high percentage indicates market instability or urgent need for intervention.</p>
                <a href="${pageContext.request.contextPath}/web/admin/msp" class="btn btn-warning w-100 fw-bold">Review MSP Policy</a>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="stat-card h-100">
                <div class="section-title d-flex justify-content-between">
                    <span><i class="bi bi-people"></i> Verification Queue</span>
                    <a href="${pageContext.request.contextPath}/web/admin/users" class="small text-decoration-none">View All</a>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>User</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${allUsers}" begin="0" end="5">
                                <tr>
                                    <td>
                                        <div class="fw-bold">${user.name}</div>
                                        <div class="small text-muted">${user.email}</div>
                                    </td>
                                    <td><span class="badge bg-light text-dark border">${user.role}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.verificationStatus == 'VERIFIED'}">
                                                <span class="text-success small fw-bold"><i class="bi bi-check-circle-fill"></i> Verified</span>
                                            </c:when>
                                            <c:when test="${user.verificationStatus == 'PENDING'}">
                                                <span class="text-warning small fw-bold"><i class="bi bi-clock-history"></i> Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-danger small fw-bold"><i class="bi bi-x-circle-fill"></i> Rejected</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <c:if test="${user.verificationStatus == 'PENDING'}">
                                            <button class="btn btn-sm btn-success px-3 me-1">Approve</button>
                                            <button class="btn btn-sm btn-outline-danger">Reject</button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Platform Stats -->
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon blue mb-3"><i class="bi bi-cart-check"></i></div>
                <div class="stat-value">${listingCount}</div>
                <div class="stat-label">Active Listings</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon green mb-3"><i class="bi bi-currency-exchange"></i></div>
                <div class="stat-value">12.4L</div>
                <div class="stat-label">Total Trade Volume (GMV)</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon orange mb-3"><i class="bi bi-journal-text"></i></div>
                <div class="stat-value">482</div>
                <div class="stat-label">Audit Events (24h)</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon red mb-3"><i class="bi bi-cpu"></i></div>
                <div class="stat-value">99.9%</div>
                <div class="stat-label">System Uptime</div>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
