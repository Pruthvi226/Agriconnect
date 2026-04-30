<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .bg-agri { background: linear-gradient(135deg, #198754, #146c43); color: white; }
    </style>
</head>
<body class="py-5">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="card-header bg-agri text-center py-4">
                    <h3 class="mb-0 fw-bold">Join AgriConnect</h3>
                    <p class="mb-0 text-light opacity-75">Connect directly, eliminate middlemen.</p>
                </div>
                <div class="card-body p-4 p-md-5">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/web/register" method="post">
                        <div class="mb-3">
                            <label class="form-label text-muted fw-bold">Full Name</label>
                            <input type="text" class="form-control form-control-lg bg-light border-0" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted fw-bold">Email</label>
                            <input type="email" class="form-control form-control-lg bg-light border-0" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted fw-bold">Password</label>
                            <input type="password" class="form-control form-control-lg bg-light border-0" name="password" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted fw-bold">Phone Number</label>
                            <input type="text" class="form-control form-control-lg bg-light border-0" name="phone" required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label text-muted fw-bold">I am a...</label>
                            <select class="form-select form-select-lg bg-light border-0" name="role" required>
                                <option value="FARMER">Farmer (Producer)</option>
                                <option value="BUYER">Buyer (Business Entity)</option>
                                <option value="AGRI_EXPERT">Agri-Expert (KVK/University)</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-success btn-lg w-100 rounded-pill fw-bold shadow-sm">Complete Registration</button>
                    </form>
                    <div class="text-center mt-4">
                        <p class="text-muted">Already have an account? <a href="${pageContext.request.contextPath}/web/login" class="text-success fw-bold text-decoration-none">Login here</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
