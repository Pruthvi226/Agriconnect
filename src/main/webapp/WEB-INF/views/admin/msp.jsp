<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>MSP Rates</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/agriconnect.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../common/layout.jsp" />
<main class="container py-4">
    <h1 class="h4 mb-3">MSP Rates</h1>
    <form action="${pageContext.request.contextPath}/web/admin/msp" method="post" class="row g-2 mb-4">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <div class="col-md-3"><input class="form-control" name="cropName" placeholder="Crop" required></div>
        <div class="col-md-2"><select class="form-select" name="season"><option>KHARIF</option><option>RABI</option><option>ZAID</option></select></div>
        <div class="col-md-2"><input class="form-control" name="year" type="number" placeholder="Year" required></div>
        <div class="col-md-2"><input class="form-control" name="mspPerKg" type="number" step="0.01" placeholder="MSP/kg" required></div>
        <div class="col-md-2"><input class="form-control" name="announcedAt" type="date" required></div>
        <div class="col-md-1"><button class="btn btn-primary w-100">Add</button></div>
    </form>
    <table class="table table-striped">
        <thead><tr><th>Crop</th><th>Season</th><th>Year</th><th>MSP/kg</th><th>Announced</th></tr></thead>
        <tbody><c:forEach var="rate" items="${rates}"><tr><td>${rate.cropName}</td><td>${rate.season}</td><td>${rate.year}</td><td>${rate.mspPerKg}</td><td>${rate.announcedAt}</td></tr></c:forEach></tbody>
    </table>
</main>
</body>
</html>
