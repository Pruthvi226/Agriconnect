<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Audit Logs - AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="../fragments/admin-nav.jsp">
    <jsp:param name="active" value="audit" />
</jsp:include>

<main class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h1 class="h4 fw-bold mb-1">Audit Logs</h1>
            <p class="text-muted mb-0">Recent sensitive actions across listings, bids, orders, and users.</p>
        </div>
    </div>

    <div class="table-responsive bg-white rounded-4 shadow-sm border">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
            <tr>
                <th>Time</th>
                <th>User</th>
                <th>Action</th>
                <th>Entity</th>
                <th>Old Value</th>
                <th>New Value</th>
                <th>IP</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="log" items="${logs}">
                <tr>
                    <td class="small text-muted">${log.timestamp}</td>
                    <td>${log.userId}</td>
                    <td><span class="badge text-bg-primary">${log.action}</span></td>
                    <td>${log.entityType} #${log.entityId}</td>
                    <td><code>${log.oldValue}</code></td>
                    <td><code>${log.newValue}</code></td>
                    <td class="small text-muted">${log.ipAddress}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty logs}">
                <tr><td colspan="7" class="text-center text-muted py-5">No audit events yet.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>
