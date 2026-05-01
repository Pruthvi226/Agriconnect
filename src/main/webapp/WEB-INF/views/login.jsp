<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - AgriConnect</title>
    <meta name="description" content="Login to AgriConnect - India's intelligent agricultural supply chain platform">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body class="auth-page">

<div class="auth-wrapper">
    <div class="auth-brand">
        <div class="auth-brand-icon">🌾</div>
        <h1 class="fw-bold mb-1">AgriConnect</h1>
        <p class="text-white-50 mb-0">Intelligent Agricultural Supply Chain</p>
    </div>

    <div class="auth-card">
        <h2>Welcome back</h2>
        <p class="text-muted mb-4 small">Sign in to access your dashboard</p>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger d-flex align-items-center gap-2 mb-3 border-0" style="background:#fff5f5; color:#c53030; border-radius:12px;">
                <i class="bi bi-exclamation-circle-fill"></i>
                Invalid email or password. Please try again.
            </div>
        </c:if>
        <c:if test="${not empty param.logout}">
            <div class="alert alert-success d-flex align-items-center gap-2 mb-3 border-0" style="background:#f0fff4; color:#276749; border-radius:12px;">
                <i class="bi bi-check-circle-fill"></i>
                You have been signed out successfully.
            </div>
        </c:if>
        <c:if test="${not empty msg}">
            <div class="alert alert-success d-flex align-items-center gap-2 mb-3 border-0" style="background:#f0fff4; color:#276749; border-radius:12px;">
                <i class="bi bi-check-circle-fill"></i>
                ${msg}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
            <div class="mb-3">
                <label for="username" class="form-label text-uppercase fw-bold text-muted small" style="letter-spacing: 0.5px;">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" class="form-control" id="username" name="username"
                           placeholder="you@example.com" required autocomplete="email">
                </div>
            </div>
            <div class="mb-4">
                <label for="password" class="form-label text-uppercase fw-bold text-muted small" style="letter-spacing: 0.5px;">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" class="form-control" id="password" name="password"
                           placeholder="Enter your password" required autocomplete="current-password">
                </div>
            </div>
            <button type="submit" class="btn btn-primary-custom w-100" id="loginBtn">
                <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
            </button>
        </form>

        <div class="divider"><span>New to AgriConnect?</span></div>

        <div class="text-center small">
            <span class="text-muted">Don't have an account?</span>
            <a href="${pageContext.request.contextPath}/web/register" class="text-decoration-none fw-bold" style="color: var(--primary);">Create one for free →</a>
        </div>
    </div>

    <div class="d-flex justify-content-center gap-4 mt-4 text-white-50 small">
        <span><i class="bi bi-shield-check text-white me-1"></i> Secure</span>
        <span><i class="bi bi-graph-up text-white me-1"></i> MSP Tracking</span>
        <span><i class="bi bi-people text-white me-1"></i> Direct Trade</span>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('loginForm').addEventListener('submit', function() {
        const btn = document.getElementById('loginBtn');
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Signing in...';
        btn.disabled = true;
    });
</script>
</body>
</html>
