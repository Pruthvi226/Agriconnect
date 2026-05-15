<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${advisory.title} - AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="fragments/navbar-selector.jsp">
    <jsp:param name="active" value="advisories" />
</jsp:include>

<main class="container py-4" style="max-width: 860px;">
    <a href="${pageContext.request.contextPath}/web/advisories" class="btn btn-link px-0 mb-3">
        <i class="bi bi-arrow-left me-1"></i>Back to advisories
    </a>
    <article class="bg-white border rounded-4 shadow-sm p-4">
        <div class="d-flex flex-wrap gap-2 mb-3">
            <span class="badge text-bg-success">${advisory.advisoryType}</span>
            <span class="badge text-bg-warning">${advisory.severity}</span>
            <span class="badge text-bg-light">Valid until ${advisory.validUntil}</span>
        </div>
        <h1 class="h3 fw-bold">${advisory.title}</h1>
        <p class="text-muted mb-4">
            By ${advisory.expert.name} for ${empty advisory.cropName ? 'all crops' : advisory.cropName}
        </p>
        <p class="fs-5" style="line-height: 1.7;">${advisory.body}</p>
        <hr>
        <div class="small text-muted">
            <i class="bi bi-geo-alt me-1"></i>Affected districts: ${advisory.affectedDistricts}
        </div>
    </article>
</main>
</body>
</html>
