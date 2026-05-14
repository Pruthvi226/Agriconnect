<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Register - AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/agriconnect.css" rel="stylesheet">
</head>
<body class="bg-light">
<main class="container py-5" style="max-width: 560px;">
    <h1 class="h3 mb-4 text-primary">Create Account</h1>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <form action="${pageContext.request.contextPath}/auth/register" method="post" class="card card-body shadow-sm">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <div class="mb-3">
            <label class="form-label" for="name">Name</label>
            <input class="form-control" id="name" name="name" required>
        </div>
        <div class="mb-3">
            <label class="form-label" for="email">Email</label>
            <input class="form-control" id="email" name="email" type="email" required>
        </div>
        <div class="mb-3">
            <label class="form-label" for="password">Password</label>
            <input class="form-control" id="password" name="password" type="password" minlength="8" required>
        </div>
        <div class="mb-3">
            <label class="form-label" for="phone">Phone</label>
            <input class="form-control" id="phone" name="phone" pattern="[6-9][0-9]{9}" required>
        </div>
        <div class="mb-4">
            <label class="form-label" for="role">Role</label>
            <select class="form-select" id="role" name="role" required>
                <option value="FARMER">Farmer</option>
                <option value="BUYER">Buyer</option>
            </select>
        </div>
        <button class="btn btn-primary w-100" type="submit">Register</button>
        <a class="btn btn-link mt-3" href="${pageContext.request.contextPath}/auth/login">Back to login</a>
    </form>
</main>
</body>
</html>
