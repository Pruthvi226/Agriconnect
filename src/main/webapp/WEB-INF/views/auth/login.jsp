<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login - AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/agriconnect.css" rel="stylesheet">
</head>
<body class="bg-light">
<main class="container py-5" style="max-width: 480px;">
    <h1 class="h3 mb-4 text-primary">AgriConnect Login</h1>
    <c:if test="${param.error == 'true'}"><div class="alert alert-danger">Invalid email or password.</div></c:if>
    <c:if test="${param.logout == 'true'}"><div class="alert alert-success">You have been logged out.</div></c:if>
    <c:if test="${param.expired == 'true'}"><div class="alert alert-warning">Your session expired.</div></c:if>
    <c:if test="${param.registered == 'true'}"><div class="alert alert-success">Registration complete. Please log in.</div></c:if>
    <form action="${pageContext.request.contextPath}/auth/login" method="post" class="card card-body shadow-sm">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <div class="mb-3">
            <label class="form-label" for="email">Email</label>
            <input class="form-control" id="email" name="email" type="email" required autofocus>
        </div>
        <div class="mb-3">
            <label class="form-label" for="password">Password</label>
            <input class="form-control" id="password" name="password" type="password" required>
        </div>
        <button class="btn btn-primary w-100" type="submit">Login</button>
        <a class="btn btn-link mt-3" href="${pageContext.request.contextPath}/auth/register">Create account</a>
    </form>
</main>
</body>
</html>
