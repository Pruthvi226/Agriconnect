<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Users</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/agriconnect.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../common/layout.jsp" />
<main class="container py-4">
    <h1 class="h4 mb-3">Users</h1>
    <table class="table table-hover align-middle">
        <thead><tr><th>Name</th><th>Email</th><th>Role</th><th>Status</th><th></th></tr></thead>
        <tbody>
        <c:forEach var="user" items="${users}">
            <tr>
                <td>${user.name}</td><td>${user.email}</td><td>${user.role}</td><td>${user.verificationStatus}</td>
                <td class="text-end">
                    <form action="${pageContext.request.contextPath}/web/admin/users/${user.id}/verify" method="post" class="d-inline">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <input type="hidden" name="status" value="VERIFIED" />
                        <button class="btn btn-sm btn-success">Verify</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/web/admin/users/${user.id}/verify" method="post" class="d-inline">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <input type="hidden" name="status" value="REJECTED" />
                        <button class="btn btn-sm btn-outline-danger">Reject</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</main>
</body>
</html>
