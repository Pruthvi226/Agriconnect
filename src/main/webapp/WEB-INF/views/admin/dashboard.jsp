<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/agriconnect.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../common/layout.jsp" />
<main class="container py-4">
    <div class="row g-3">
        <div class="col-md-4"><div class="card"><div class="card-body"><div class="text-muted">Users</div><div class="display-6">${userCount}</div></div></div></div>
        <div class="col-md-4"><div class="card"><div class="card-body"><div class="text-muted">Listings</div><div class="display-6">${listingCount}</div></div></div></div>
        <div class="col-md-4"><div class="card"><div class="card-body"><div class="text-muted">Order Volume</div><div class="display-6">${orderVolume}</div></div></div></div>
    </div>
</main>
</body>
</html>
