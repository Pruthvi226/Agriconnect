<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Search Listings</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/agriconnect.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../common/layout.jsp" />
<main class="container py-4">
    <form method="get" class="row g-3 mb-4">
        <div class="col-md-4"><input class="form-control" name="cropName" value="${filters.cropName}" placeholder="Crop"></div>
        <div class="col-md-4"><input class="form-control" name="district" value="${filters.district}" placeholder="District"></div>
        <div class="col-md-2"><input class="form-control" name="radiusKm" value="${filters.radiusKm}" placeholder="Radius"></div>
        <div class="col-md-2"><button class="btn btn-primary w-100">Search</button></div>
    </form>
    <table class="table table-hover align-middle">
        <thead><tr><th>Crop</th><th>District</th><th>Quantity</th><th>Price</th><th>Match</th><th></th></tr></thead>
        <tbody>
        <c:forEach var="listing" items="${results}">
            <tr>
                <td>${listing.cropName}</td>
                <td>${listing.district}</td>
                <td>${listing.quantityKg}</td>
                <td>${listing.askingPricePerKg}</td>
                <td>100</td>
                <td>
                    <form action="${pageContext.request.contextPath}/buyer/bids" method="post" class="row g-2">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <input type="hidden" name="listingId" value="${listing.id}" />
                        <div class="col"><input class="form-control form-control-sm" name="bidPricePerKg" type="number" step="0.01" value="${listing.askingPricePerKg}"></div>
                        <div class="col"><input class="form-control form-control-sm" name="quantityKg" type="number" step="0.01" value="${listing.quantityKg}"></div>
                        <div class="col-auto"><button class="btn btn-sm btn-primary">Place Bid</button></div>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</main>
</body>
</html>
