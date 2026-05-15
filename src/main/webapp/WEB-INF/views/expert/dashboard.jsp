<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Expert Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/agriconnect.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../fragments/expert-nav.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>
<main class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h1 class="h4">Expert Dashboard</h1>
        <a class="btn btn-success" href="${pageContext.request.contextPath}/web/advisories">Create Advisory</a>
    </div>
    <table class="table table-striped">
        <thead><tr><th>Title</th><th>Crop</th><th>Type</th><th>Severity</th><th>Valid Until</th></tr></thead>
        <tbody>
        <c:forEach var="advisory" items="${advisories}">
            <tr><td>${advisory.title}</td><td>${advisory.cropName}</td><td>${advisory.advisoryType}</td><td>${advisory.severity}</td><td>${advisory.validUntil}</td></tr>
        </c:forEach>
        </tbody>
    </table>
</main>
</body>
</html>
