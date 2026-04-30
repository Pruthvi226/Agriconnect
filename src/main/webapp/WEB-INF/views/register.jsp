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
    <style>
        * { font-family: 'Inter', sans-serif; }

        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #0a4f2c 0%, #16783a 40%, #1a9e4a 70%, #0d6e31 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px 20px;
        }

        .register-wrapper { width: 100%; max-width: 520px; }

        .brand-section { text-align: center; margin-bottom: 1.75rem; }

        .brand-logo {
            width: 56px; height: 56px;
            background: rgba(255,255,255,0.2);
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.6rem;
            margin: 0 auto 0.75rem;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.3);
        }

        .brand-section h1 { color: white; font-weight: 800; font-size: 1.6rem; margin: 0; }
        .brand-section p { color: rgba(255,255,255,0.75); font-size: 0.875rem; margin: 0.2rem 0 0; }

        .card {
            border: none;
            border-radius: 24px;
            background: white;
            box-shadow: 0 25px 60px rgba(0,0,0,0.25);
            padding: 2rem;
        }

        .card h2 { font-size: 1.25rem; font-weight: 700; color: #1a202c; margin-bottom: 0.25rem; }
        .card .subtitle { color: #718096; font-size: 0.875rem; margin-bottom: 1.5rem; }

        .form-label {
            font-size: 0.78rem;
            font-weight: 600;
            color: #4a5568;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control, .form-select {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 0.7rem 1rem;
            font-size: 0.9rem;
            transition: all 0.2s;
            background: #f8fafc;
        }

        .form-control:focus, .form-select:focus {
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

        .role-cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.6rem; margin-bottom: 1.25rem; }

        .role-card {
            position: relative;
            cursor: pointer;
        }

        .role-card input[type="radio"] {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

        .role-card label {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 0.875rem 0.5rem;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.2s;
            background: #f8fafc;
            text-align: center;
        }

        .role-card label .icon { font-size: 1.4rem; margin-bottom: 0.35rem; }
        .role-card label .role-name { font-size: 0.75rem; font-weight: 600; color: #4a5568; }
        .role-card label .role-sub { font-size: 0.65rem; color: #a0aec0; margin-top: 0.1rem; }

        .role-card input:checked + label {
            border-color: #16783a;
            background: #f0fff4;
            box-shadow: 0 0 0 3px rgba(22,120,58,0.12);
        }

        .role-card input:checked + label .role-name { color: #276749; }

        .role-card label:hover { border-color: #68d391; background: white; }

        .btn-register {
            background: linear-gradient(135deg, #16783a, #0a4f2c);
            border: none;
            border-radius: 12px;
            padding: 0.875rem;
            font-size: 0.95rem;
            font-weight: 600;
            color: white;
            width: 100%;
            transition: all 0.2s;
        }

        .btn-register:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 25px rgba(22,120,58,0.4);
            color: white;
        }

        .alert { border-radius: 12px; border: none; font-size: 0.875rem; font-weight: 500; }
        .alert-danger { background: #fff5f5; color: #c53030; }

        .login-link { text-align: center; color: #718096; font-size: 0.875rem; margin-top: 1rem; }
        .login-link a { color: #16783a; font-weight: 600; text-decoration: none; }
        .login-link a:hover { text-decoration: underline; }

        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 0.875rem; }
    </style>
</head>
<body>

<div class="register-wrapper">
    <div class="brand-section">
        <div class="brand-logo">🌾</div>
        <h1>AgriConnect</h1>
        <p>Join India's agricultural revolution</p>
    </div>

    <div class="card">
        <h2>Create your account</h2>
        <p class="subtitle">Connect directly, eliminate middlemen</p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger d-flex align-items-center gap-2 mb-3">
                <i class="bi bi-exclamation-circle-fill"></i>
                ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/web/register" method="post" id="registerForm">
            <div class="form-row mb-3">
                <div>
                    <label class="form-label">Full Name</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                        <input type="text" class="form-control" name="name" placeholder="Rajesh Kumar" required>
                    </div>
                </div>
                <div>
                    <label class="form-label">Phone Number</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                        <input type="tel" class="form-control" name="phone" placeholder="+91 9876543210" required>
                    </div>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" class="form-control" name="email" placeholder="you@example.com" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" class="form-control" name="password"
                           placeholder="Min. 8 characters" required minlength="8">
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label d-block mb-2">I am a...</label>
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

            <button type="submit" class="btn btn-register" id="registerBtn">
                <i class="bi bi-person-plus me-2"></i>Create Account
            </button>
        </form>

        <div class="login-link">
            Already have an account?
            <a href="${pageContext.request.contextPath}/web/login">Sign in →</a>
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
