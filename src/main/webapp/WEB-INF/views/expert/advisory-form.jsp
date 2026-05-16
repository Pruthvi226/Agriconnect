<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Create Advisory</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/agriconnect.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../common/layout.jsp" />
<main class="container py-4" style="max-width: 760px;">
    <h1 class="h4 mb-3">Create Advisory</h1>
    <form action="${pageContext.request.contextPath}/expert/advisories" method="post" class="card card-body">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <div class="mb-3"><label class="form-label">Title</label><input class="form-control" name="title" required></div>
        <div class="mb-3"><label class="form-label">Body</label><textarea class="form-control" name="body" rows="5" required></textarea></div>
        <div class="row g-3">
            <div class="col-md-4"><label class="form-label">Crop</label><input class="form-control" name="cropName"></div>
            <div class="col-md-4"><label class="form-label">Type</label><select class="form-select" name="advisoryType"><option>PEST</option><option>DISEASE</option><option>WEATHER</option><option>MARKET</option><option>TECHNIQUE</option></select></div>
            <div class="col-md-4"><label class="form-label">Severity</label><select class="form-select" name="severity"><option>INFO</option><option>WARNING</option><option>CRITICAL</option></select></div>
            <div class="col-md-6"><label class="form-label">Affected districts</label><input class="form-control" name="affectedDistricts" required></div>
            <div class="col-md-6"><label class="form-label">Valid until</label><input class="form-control" name="validUntil" type="date" required></div>
        </div>
        <div class="mt-4"><button class="btn btn-primary">Publish</button></div>
    </form>
</main>
</body>
</html>
