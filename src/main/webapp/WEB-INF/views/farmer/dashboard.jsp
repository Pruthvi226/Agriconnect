<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Farmer Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/agriconnect.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../common/layout.jsp" />
<main class="container py-4">
    <div class="row g-3 mb-4">
        <div class="col-md-4"><div class="card"><div class="card-body"><div class="text-muted">Listings</div><div class="display-6">${listingCount}</div></div></div></div>
        <div class="col-md-4"><div class="card"><div class="card-body"><div class="text-muted">Bids</div><div class="display-6">${bidCount}</div></div></div></div>
        <div class="col-md-4"><div class="card"><div class="card-body"><div class="text-muted">Orders</div><div class="display-6">${orderCount}</div></div></div></div>
    </div>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h1 class="h4">Recent Listings</h1>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/farmer/listings/new">Create Listing</a>
    </div>
    <table class="table table-striped align-middle">
        <thead><tr><th>Crop</th><th>Quantity</th><th>Price</th><th>Status</th></tr></thead>
        <tbody>
        <c:forEach var="listing" items="${recentListings}">
            <tr>
                <td>${listing.cropName}</td>
                <td>${listing.quantityKg} kg</td>
                <td>${listing.askingPricePerKg}</td>
                <td><span class="badge bg-secondary">${listing.status}</span></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</main>
</body>
</html>
