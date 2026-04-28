<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>AgriConnect - Farmer Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .circular-chart { display: block; margin: 0 auto; max-width: 80%; max-height: 250px; }
        .circle-bg { fill: none; stroke: #eee; stroke-width: 3.8; }
        .circle { fill: none; stroke-width: 2.8; stroke-linecap: round; animation: progress 1s ease-out forwards; }
        @keyframes progress { 0% { stroke-dasharray: 0 100; } }
        .percentage { fill: #666; font-family: sans-serif; font-size: 0.5em; text-anchor: middle; }
    </style>
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-success mb-4">
    <div class="container"><a class="navbar-brand" href="#">AgriConnect</a></div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow text-center py-4">
                <div class="card-body">
                    <h3 class="card-title mb-1">Rajesh Kumar</h3>
                    <p class="text-muted mb-4">📍 Nashik, Maharashtra</p>
                    
                    <!-- SVG Circular Progress Ring -->
                    <div style="width: 200px; height: 200px; margin: 0 auto;">
                        <svg viewBox="0 0 36 36" class="circular-chart">
                            <path class="circle-bg" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
                            <path class="circle" stroke="${scoreColor}" stroke-dasharray="${farmer.farmerScore}, 100" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
                            <text x="18" y="20.35" class="percentage">${farmer.farmerScore}</text>
                        </svg>
                    </div>

                    <h4 class="mt-3" style="color: ${scoreColor};">${scoreBadge}</h4>
                    <p class="text-muted small">Based on delivery history, quality, and volume.</p>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
