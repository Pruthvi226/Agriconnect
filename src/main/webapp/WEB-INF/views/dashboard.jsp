<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>AgriConnect - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-success mb-4">
    <div class="container">
        <a class="navbar-brand" href="#">AgriConnect</a>
    </div>
</nav>

<div class="container">
    <h2 class="mb-4">Welcome to the ${role} Dashboard</h2>

    <c:if test="${role == 'Administrator'}">
        <div class="card shadow-sm mb-4">
            <div class="card-body bg-warning text-dark">
                <h5>Platform Health (Admin)</h5>
                <p class="display-6"><strong>${belowMspPercentage}%</strong></p>
                <p>of active listings are priced BELOW the Government MSP.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${role == 'Farmer' || role == 'Buyer'}">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white">
                <h5 class="mb-0">✨ Recommended for you</h5>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty matches}">
                        <div class="row">
                            <c:forEach var="match" items="${matches}">
                                <div class="col-md-4 mb-3">
                                    <div class="card h-100 border-success">
                                        <div class="card-body">
                                            <h6>Match Score: <span class="text-success">${match.score}%</span></h6>
                                            <div class="progress mb-2" style="height: 10px;">
                                              <div class="progress-bar bg-success" role="progressbar" data-width="${match.score}" aria-valuenow="${match.score}" aria-valuemin="0" aria-valuemax="100"></div>
                                            </div>
                                            <small class="text-muted">Proximity | Crop Fit | History</small>
                                            <hr>
                                            <c:if test="${role == 'Farmer'}">
                                                <p class="mb-0"><strong>Buyer:</strong> ${match.buyer.companyName}</p>
                                            </c:if>
                                            <c:if test="${role == 'Buyer'}">
                                                <p class="mb-0"><strong>Farmer in:</strong> ${match.farmer.district}</p>
                                                <p class="mb-0 text-muted"><small>Score: ${match.farmer.farmerScore}/100</small></p>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted">No recommendations generated yet. Check back tomorrow!</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:if>

</div>
<script>
    document.querySelectorAll('.progress-bar').forEach(function(el) {
        var w = el.getAttribute('data-width');
        if (w) el.style.width = w + '%';
    });
</script>
</body>
</html>
