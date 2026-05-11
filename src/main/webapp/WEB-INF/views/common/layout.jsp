<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.title} | AgriConnect</title>
    
    <!-- Bootstrap 5.3 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <!-- Google Fonts - Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
    
    <style>
        /* Mobile First Overrides (Rule 5) */
        @media (max-width: 768px) {
            .navbar-brand { font-size: 1.2rem; }
            .btn { width: 100%; margin-bottom: 10px; }
            .stat-card { margin-bottom: 15px; }
        }
    </style>
</head>
<body class="${param.bodyClass}">

    <!-- Redesign: Navbar will be included per role via fragments, or a global one here -->
    <jsp:include page="/WEB-INF/views/fragments/navbar.jsp" />

    <main class="container-fluid p-0">
        <jsp:doBody />
    </main>

    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container text-center">
            <div class="row">
                <div class="col-12">
                    <p class="mb-2 fw-bold">AgriConnect © 2024</p>
                    <nav class="d-flex justify-content-center gap-3">
                        <a href="${pageContext.request.contextPath}/web/msp-checker" class="text-white-50 text-decoration-none">MSP Checker</a>
                        <a href="#" class="text-white-50 text-decoration-none">Help</a>
                        <a href="#" class="text-white-50 text-decoration-none">Contact</a>
                    </nav>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
