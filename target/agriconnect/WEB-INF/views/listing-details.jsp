<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>AgriConnect - Listing Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-success mb-4">
    <div class="container">
        <a class="navbar-brand" href="#">AgriConnect</a>
    </div>
</nav>

<div class="container">
    <div class="row">
        <!-- Listing info -->
        <div class="col-md-8">
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h2>Wheat - Sharbati</h2>
                    <p class="text-muted">Farmer Score: <strong>85/100 (Reliable)</strong></p>
                    <hr>
                    <p>Asking Price: <strong>₹25.00 / kg</strong></p>
                    <p>Quantity: <strong>5000 kg</strong></p>
                </div>
            </div>
        </div>

        <!-- Bid Stats (Anonymous) -->
        <div class="col-md-4">
            <div class="card shadow-sm border-primary">
                <div class="card-header bg-primary text-white">
                    Bid Distribution (Anonymous)
                </div>
                <div class="card-body">
                    <canvas id="bidChart" width="400" height="300"></canvas>
                    <hr>
                    <div id="myRankInfo" style="display:none;">
                        <p class="mb-1">Your Rank: <strong id="rankText" class="text-primary"></strong> / <span id="totalBidsText"></span></p>
                        <p class="mb-0 text-danger" style="font-size: 0.9em;">Delta to highest: <span id="deltaText"></span>%</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Chart JS
const ctx = document.getElementById('bidChart').getContext('2d');
const bidChart = new Chart(ctx, {
    type: 'bar',
    data: {
        labels: ['₹20-22', '₹22-24', '₹24-26', '₹26+'],
        datasets: [{
            label: 'Number of Bids',
            data: [2, 5, 3, 1], // Stubbed data
            backgroundColor: 'rgba(54, 162, 235, 0.5)',
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 1
        }]
    },
    options: {
        scales: {
            y: { beginAtZero: true, ticks: { stepSize: 1 } }
        }
    }
});

// Fetch Rank
fetch('/api/v1/listings/1/bid-rank') // Stub listing 1
    .then(res => res.json())
    .then(data => {
        if(data.success) {
            document.getElementById('myRankInfo').style.display = 'block';
            document.getElementById('rankText').innerText = '#' + data.data.yourRank;
            document.getElementById('totalBidsText').innerText = data.data.totalBids;
            document.getElementById('deltaText').innerText = data.data.highestBidDelta;
        }
    });
</script>
</body>
</html>
