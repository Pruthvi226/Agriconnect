<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Listing Form</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/agriconnect.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../common/layout.jsp" />
<main class="container py-4" style="max-width: 760px;">
    <h1 class="h4 mb-3">Produce Listing</h1>
    <form action="${pageContext.request.contextPath}/farmer/listings" method="post" class="card card-body">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <div class="row g-3">
            <div class="col-md-6"><label class="form-label">Crop</label><input class="form-control" name="cropName" value="${listing.cropName}" required></div>
            <div class="col-md-6"><label class="form-label">Variety</label><input class="form-control" name="variety" value="${listing.variety}" required></div>
            <div class="col-md-6"><label class="form-label">Quantity kg</label><input class="form-control" name="quantityKg" type="number" step="0.01" value="${listing.quantityKg}" required></div>
            <div class="col-md-6"><label class="form-label">Asking price</label><input class="form-control" name="askingPricePerKg" type="number" step="0.01" value="${listing.askingPricePerKg}" required></div>
            <div class="col-md-4"><label class="form-label">Quality</label><select class="form-select" name="qualityGrade"><option>A</option><option>B</option><option>C</option></select></div>
            <div class="col-md-4"><label class="form-label">Available from</label><input class="form-control" name="availableFrom" type="date" value="${listing.availableFrom}" required></div>
            <div class="col-md-4"><label class="form-label">Available until</label><input class="form-control" name="availableUntil" type="date" value="${listing.availableUntil}" required></div>
            <div class="col-12"><label class="form-label">District</label><input class="form-control" name="district" value="${listing.district}"></div>
            <div class="col-12"><label class="form-label">Description</label><textarea class="form-control" name="description" rows="4">${listing.description}</textarea></div>
        </div>
        <div class="mt-4"><button class="btn btn-primary" type="submit">Save Listing</button></div>
    </form>
</main>
</body>
</html>
