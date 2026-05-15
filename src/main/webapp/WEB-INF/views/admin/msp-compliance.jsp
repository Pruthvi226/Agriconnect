<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>MSP Compliance - AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="../fragments/admin-nav.jsp">
    <jsp:param name="active" value="msp-compliance" />
</jsp:include>

<main class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h1 class="h4 fw-bold mb-1">MSP Compliance</h1>
            <p class="text-muted mb-0">Active listings priced below MSP for admin review and outreach.</p>
        </div>
        <a href="${pageContext.request.contextPath}/web/admin/msp" class="btn btn-outline-success">
            <i class="bi bi-currency-rupee me-1"></i>Manage MSP Rates
        </a>
    </div>

    <div class="table-responsive bg-white rounded-4 shadow-sm border">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
            <tr>
                <th>Crop</th>
                <th>Farmer</th>
                <th>District</th>
                <th>Asking Price</th>
                <th>MSP</th>
                <th>Status</th>
                <th>Gap</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="listing" items="${listings}">
                <tr>
                    <td>
                        <div class="fw-bold">${listing.cropName}</div>
                        <div class="small text-muted">${listing.variety}</div>
                    </td>
                    <td>${listing.farmerProfile.user.name}</td>
                    <td>${listing.district}</td>
                    <td>Rs ${listing.askingPricePerKg}/kg</td>
                    <td>Rs ${listing.mspPricePerKg}/kg</td>
                    <td><span class="badge text-bg-primary">${listing.status}</span></td>
                    <td><span class="badge text-bg-danger">Below MSP</span></td>
                </tr>
            </c:forEach>
            <c:if test="${empty listings}">
                <tr>
                    <td colspan="7" class="text-center text-muted py-5">
                        No active listings are below MSP.
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>
