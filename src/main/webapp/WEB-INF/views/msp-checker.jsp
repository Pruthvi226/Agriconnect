<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MSP Checker | AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-success mb-4">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/">
            <i class="bi bi-flower1 me-2"></i>AgriConnect
        </a>
        <a href="${pageContext.request.contextPath}/web/login" class="btn btn-outline-light btn-sm">Login</a>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <!-- Feature 1 Header (Rule 6) -->
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
                <div class="card-body bg-primary text-white p-4">
                    <h1 class="h3 fw-800 mb-1">
                        Government Minimum Support Prices 
                    </h1>
                    <p class="mb-0 opacity-75">(सरकारी न्यूनतम समर्थन मूल्य)</p>
                </div>
            </div>

            <!-- Filter (Rule 3) -->
            <div class="card border-0 shadow-sm rounded-4 p-3 mb-4">
                <div class="input-group">
                    <span class="input-group-text bg-white border-0"><i class="bi bi-search"></i></span>
                    <input type="text" id="cropFilter" class="form-control border-0 fs-5" 
                           placeholder="Search crop (फसल खोजें)..." onkeyup="filterCrops()">
                </div>
            </div>

            <!-- MSP Table (Rule 5 & 1) -->
            <div class="table-responsive shadow-sm rounded-4 bg-white">
                <table class="table table-hover align-middle mb-0" id="mspTable">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4 py-3">Crop (फसल)</th>
                            <th class="py-3">Season</th>
                            <th class="py-3 text-end pe-4">MSP (₹/kg)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="rate" items="${rates}">
                            <tr class="crop-row">
                                <td class="ps-4 py-3 fw-bold fs-5">
                                    <i class="bi bi-tag-fill text-success me-2"></i>
                                    <span class="crop-name">${rate.cropName}</span>
                                </td>
                                <td class="py-3">
                                    <span class="badge bg-info-subtle text-info border border-info-subtle px-3 py-2 rounded-pill">
                                        ${rate.season}
                                    </span>
                                </td>
                                <td class="py-3 text-end pe-4">
                                    <span class="fs-4 fw-800 text-success">
                                        ₹${rate.mspPerKg}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="text-center mt-4 text-muted">
                <p><i class="bi bi-info-circle me-1"></i> Data updated for Marketing Year 2024-25</p>
                <a href="${pageContext.request.contextPath}/web/login" class="btn btn-primary-custom px-5 mt-2">
                    <i class="bi bi-plus-circle me-2"></i> List Your Produce to Sell
                </a>
            </div>
        </div>
    </div>
</div>

<footer class="bg-dark text-white py-4 mt-5">
    <div class="container text-center">
        <p class="mb-0 text-white-50">AgriConnect © 2024 | Protecting Farmers' Interests</p>
    </div>
</footer>

<script>
    function filterCrops() {
        let input = document.getElementById('cropFilter');
        let filter = input.value.toUpperCase();
        let table = document.getElementById('mspTable');
        let tr = table.getElementsByClassName('crop-row');

        for (let i = 0; i < tr.length; i++) {
            let nameSpan = tr[i].getElementsByClassName('crop-name')[0];
            if (nameSpan) {
                let txtValue = nameSpan.textContent || nameSpan.innerText;
                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    }
</script>

</body>
</html>
