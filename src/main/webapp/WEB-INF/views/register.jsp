<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - AgriConnect</title>
    <meta name="description" content="Join AgriConnect - India's intelligent agricultural supply chain platform">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
    <style>
        .role-cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.6rem; margin-bottom: 1.25rem; }
        .role-card { position: relative; cursor: pointer; }
        .role-card input[type="radio"] { position: absolute; opacity: 0; pointer-events: none; }
        .role-card label {
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            padding: 0.875rem 0.5rem; border: 2px solid #e2e8f0; border-radius: 12px;
            cursor: pointer; transition: all 0.2s; background: #f8fafc; text-align: center;
        }
        .role-card label .icon { font-size: 1.4rem; margin-bottom: 0.35rem; }
        .role-card label .role-name { font-size: 0.75rem; font-weight: 600; color: var(--text-primary); }
        .role-card label .role-sub { font-size: 0.65rem; color: var(--text-secondary); margin-top: 0.1rem; }
        .role-card input:checked + label {
            border-color: var(--primary); background: #f0fff4; box-shadow: 0 0 0 3px rgba(26,158,74,0.12);
        }
        .role-card input:checked + label .role-name { color: var(--primary-dark); }
        .role-card label:hover { border-color: rgba(26,158,74,0.5); background: white; }
    </style>
</head>
<body class="auth-page">

<div class="auth-wrapper" style="max-width: 520px;">
    <div class="auth-brand">
        <div class="auth-brand-icon">🌾</div>
        <h1 class="fw-bold mb-1">AgriConnect</h1>
        <p class="text-white-50 mb-0">Join India's agricultural revolution</p>
    </div>

    <div class="auth-card">
        <h2>Create your account</h2>
        <p class="text-muted mb-4 small">Connect directly, eliminate middlemen</p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger d-flex align-items-center gap-2 mb-3 border-0" style="background:#fff5f5; color:#c53030; border-radius:12px;">
                <i class="bi bi-exclamation-circle-fill"></i>
                ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/web/register" method="post" id="registerForm">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div class="row g-2 mb-3">
                <div class="col-md-6">
                    <label class="form-label text-uppercase fw-bold text-muted small" style="letter-spacing: 0.5px;">Full Name</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                        <input type="text" class="form-control" name="name" placeholder="Rajesh Kumar" required>
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label text-uppercase fw-bold text-muted small" style="letter-spacing: 0.5px;">Phone Number</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                        <input type="tel" class="form-control" name="phone" placeholder="+91 9876543210" required>
                    </div>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label text-uppercase fw-bold text-muted small" style="letter-spacing: 0.5px;">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" class="form-control" name="email" placeholder="you@example.com" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label text-uppercase fw-bold text-muted small" style="letter-spacing: 0.5px;">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" class="form-control" name="password"
                           placeholder="Min. 8 characters" required minlength="8">
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label text-uppercase fw-bold text-muted small d-block mb-2" style="letter-spacing: 0.5px;">I am a...</label>
                <div class="role-cards">
                    <div class="role-card">
                        <input type="radio" name="role" id="role-farmer" value="FARMER" checked>
                        <label for="role-farmer">
                            <span class="icon">🧑‍🌾</span>
                            <span class="role-name">Farmer</span>
                            <span class="role-sub">Producer</span>
                        </label>
                    </div>
                    <div class="role-card">
                        <input type="radio" name="role" id="role-buyer" value="BUYER">
                        <label for="role-buyer">
                            <span class="icon">🏪</span>
                            <span class="role-name">Buyer</span>
                            <span class="role-sub">Business Entity</span>
                        </label>
                    </div>
                    <div class="role-card">
                        <input type="radio" name="role" id="role-expert" value="AGRI_EXPERT">
                        <label for="role-expert">
                            <span class="icon">🎓</span>
                            <span class="role-name">Expert</span>
                            <span class="role-sub">KVK / University</span>
                        </label>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn btn-primary-custom w-100" id="registerBtn">
                <i class="bi bi-person-plus me-2"></i>Create Account
            </button>
        </form>

        <div class="text-center small mt-4">
            <span class="text-muted">Already have an account?</span>
            <a href="${pageContext.request.contextPath}/web/login" class="text-decoration-none fw-bold" style="color: var(--primary);">Sign in →</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('registerForm').addEventListener('submit', function() {
        const btn = document.getElementById('registerBtn');
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Creating account...';
        btn.disabled = true;
    });
</script>
</body>
</html>
