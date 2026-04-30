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
    <style>
        * { font-family: 'Inter', sans-serif; }

        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #0a4f2c 0%, #16783a 40%, #1a9e4a 70%, #0d6e31 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-wrapper {
            width: 100%;
            max-width: 460px;
        }

        .brand-section {
            text-align: center;
            margin-bottom: 2rem;
        }

        .brand-logo {
            width: 60px;
            height: 60px;
            background: rgba(255,255,255,0.2);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin: 0 auto 1rem;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.3);
        }

        .brand-section h1 {
            color: white;
            font-weight: 800;
            font-size: 1.8rem;
            margin: 0;
            letter-spacing: -0.5px;
        }

        .brand-section p {
            color: rgba(255,255,255,0.75);
            margin: 0.25rem 0 0;
            font-size: 0.9rem;
        }

        .card {
            border: none;
            border-radius: 24px;
            background: white;
            box-shadow: 0 25px 60px rgba(0,0,0,0.25);
            padding: 2rem;
        }

        .card h2 {
            font-size: 1.3rem;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 0.25rem;
        }

        .card .subtitle {
            color: #718096;
            font-size: 0.875rem;
            margin-bottom: 1.75rem;
        }

        .form-label {
            font-size: 0.8rem;
            font-weight: 600;
            color: #4a5568;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            transition: all 0.2s;
            background: #f8fafc;
        }

        .form-control:focus {
            border-color: #16783a;
            box-shadow: 0 0 0 4px rgba(22,120,58,0.1);
            background: white;
        }

        .input-group-text {
            border: 2px solid #e2e8f0;
            border-right: none;
            border-radius: 12px 0 0 12px;
            background: #f8fafc;
            color: #718096;
        }

        .input-group .form-control {
            border-left: none;
            border-radius: 0 12px 12px 0;
        }

        .input-group:focus-within .input-group-text {
            border-color: #16783a;
            background: white;
        }

        .btn-login {
            background: linear-gradient(135deg, #16783a, #0a4f2c);
            border: none;
            border-radius: 12px;
            padding: 0.875rem;
            font-size: 0.95rem;
            font-weight: 600;
            color: white;
            width: 100%;
            transition: all 0.2s;
            letter-spacing: 0.3px;
        }

        .btn-login:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 25px rgba(22,120,58,0.4);
            color: white;
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .alert {
            border-radius: 12px;
            border: none;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .alert-danger {
            background: #fff5f5;
            color: #c53030;
        }

        .alert-success {
            background: #f0fff4;
            color: #276749;
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 1.25rem 0;
            color: #a0aec0;
            font-size: 0.8rem;
        }

        .divider::before, .divider::after {
            flex: 1;
            height: 1px;
            background: #e2e8f0;
            content: '';
        }

        .divider span { padding: 0 0.75rem; }

        .register-link {
            text-align: center;
            color: #718096;
            font-size: 0.875rem;
        }

        .register-link a {
            color: #16783a;
            font-weight: 600;
            text-decoration: none;
        }

        .register-link a:hover { text-decoration: underline; }

        .features-row {
            display: flex;
            justify-content: center;
            gap: 1.5rem;
            margin-top: 1.5rem;
        }

        .feature-chip {
            color: rgba(255,255,255,0.8);
            font-size: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.35rem;
        }

        .feature-chip i { color: rgba(255,255,255,0.95); }
    </style>
</head>
<body>

<div class="login-wrapper">
    <div class="brand-section">
        <div class="brand-logo">🌾</div>
        <h1>AgriConnect</h1>
        <p>Intelligent Agricultural Supply Chain</p>
    </div>

    <div class="card">
        <h2>Welcome back</h2>
        <p class="subtitle">Sign in to access your dashboard</p>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger d-flex align-items-center gap-2 mb-3">
                <i class="bi bi-exclamation-circle-fill"></i>
                Invalid email or password. Please try again.
            </div>
        </c:if>
        <c:if test="${not empty param.logout}">
            <div class="alert alert-success d-flex align-items-center gap-2 mb-3">
                <i class="bi bi-check-circle-fill"></i>
                You have been signed out successfully.
            </div>
        </c:if>
        <c:if test="${not empty msg}">
            <div class="alert alert-success d-flex align-items-center gap-2 mb-3">
                <i class="bi bi-check-circle-fill"></i>
                ${msg}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
            <div class="mb-3">
                <label for="username" class="form-label">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" class="form-control" id="username" name="username"
                           placeholder="you@example.com" required autocomplete="email">
                </div>
            </div>
            <div class="mb-4">
                <label for="password" class="form-label">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" class="form-control" id="password" name="password"
                           placeholder="Enter your password" required autocomplete="current-password">
                </div>
            </div>
            <button type="submit" class="btn btn-login" id="loginBtn">
                <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
            </button>
        </form>

        <div class="divider"><span>New to AgriConnect?</span></div>

        <div class="register-link">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/web/register">Create one for free →</a>
        </div>
    </div>

    <div class="features-row">
        <span class="feature-chip"><i class="bi bi-shield-check"></i> Secure</span>
        <span class="feature-chip"><i class="bi bi-graph-up"></i> MSP Tracking</span>
        <span class="feature-chip"><i class="bi bi-people"></i> Direct Trade</span>
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
