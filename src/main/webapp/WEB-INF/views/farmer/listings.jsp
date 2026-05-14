<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Farmer Listings</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/agriconnect.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../common/layout.jsp" />
<main class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h1 class="h4">Produce Listings</h1>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/farmer/listings/new">Create Listing</a>
    </div>
    <table class="table table-hover align-middle">
        <thead><tr><th>Crop</th><th>Variety</th><th>Quantity</th><th>Price</th><th>District</th><th>Status</th></tr></thead>
        <tbody>
        <c:forEach var="listing" items="${farmerListings}">
            <tr>
                <td><a href="${pageContext.request.contextPath}/farmer/listings/${listing.id}">${listing.cropName}</a></td>
                <td>${listing.variety}</td>
                <td>${listing.quantityKg}</td>
                <td>${listing.askingPricePerKg}</td>
                <td>${listing.district}</td>
                <td><span class="badge bg-secondary">${listing.status}</span></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</main>
</body>
</html>
