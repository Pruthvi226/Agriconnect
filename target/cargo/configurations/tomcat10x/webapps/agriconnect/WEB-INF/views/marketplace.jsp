<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>AgriConnect - Marketplace</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .badge-msp { font-size: 0.85em; padding: 0.4em 0.6em; margin-left: 10px; }
    </style>
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-success mb-4">
    <div class="container">
        <a class="navbar-brand" href="#">AgriConnect</a>
    </div>
</nav>

<div class="container">
    <h2 class="mb-4">Live Marketplace</h2>
    <div class="row">
        <c:forEach var="listing" items="${listings}">
            <div class="col-md-4 mb-4">
                <div class="card h-100 shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title">${listing.cropName} - ${listing.variety}</h5>
                        <p class="card-text text-muted">📍 ${listing.district}</p>
                        <h4 class="text-success mb-3">₹${listing.askingPrice} / kg</h4>
                        
                        <p class="mb-1">
                            <strong>MSP:</strong> 
                            <c:choose>
                                <c:when test="${not empty listing.mspPrice}">
                                    ₹${listing.mspPrice} / kg
                                    
                                    <c:choose>
                                        <c:when test="${listing.mspBadge == 'BELOW_MSP'}">
                                            <span class="badge bg-danger badge-msp">Below MSP (${listing.mspDiffPercent}%)</span>
                                        </c:when>
                                        <c:when test="${listing.mspBadge == 'ABOVE_MSP'}">
                                            <span class="badge bg-success badge-msp">Above MSP (+${listing.mspDiffPercent}%)</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary badge-msp">At MSP</span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Not announced</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <p class="mb-0"><strong>Quantity available:</strong> ${listing.quantityKg} kg</p>
                    </div>
                    <div class="card-footer bg-white border-top-0">
                        <button class="btn btn-outline-success w-100">View & Bid</button>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>
