<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - AgriConnect</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .login-card { border-radius: 15px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .bg-agri { background: linear-gradient(135deg, #28a745, #218838); color: white; }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center vh-100">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card login-card border-0">
                <div class="card-header bg-agri text-center py-4 rounded-top">
                    <h3 class="mb-0 fw-bold">AgriConnect</h3>
                    <p class="mb-0 text-light">Intelligent Supply Chain & Advisory</p>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-danger">Invalid username or password.</div>
                    </c:if>
                    <c:if test="${not empty param.logout}">
                        <div class="alert alert-success">You have been logged out.</div>
                    </c:if>
                    <c:if test="${not empty msg}">
                        <div class="alert alert-success">${msg}</div>
                    </c:if>
                    
                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label text-muted fw-bold">Username</label>
                            <input type="text" class="form-control form-control-lg bg-light border-0" id="username" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label text-muted fw-bold">Password</label>
                            <input type="password" class="form-control form-control-lg bg-light border-0" id="password" name="password" required>
                        </div>
                        <button type="submit" class="btn btn-success btn-lg w-100 rounded-pill fw-bold mt-3 shadow-sm">Login to Platform</button>
                    </form>
                    <div class="text-center mt-4">
                        <p class="text-muted">Don't have an account? <a href="${pageContext.request.contextPath}/web/register" class="text-success fw-bold text-decoration-none">Register here</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
