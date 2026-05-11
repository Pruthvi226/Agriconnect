<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expert Workspace - AgriConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body>
<jsp:include page="fragments/expert-nav.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>

<section class="role-banner">
    <div class="container">
        <span class="role-badge bg-info border-info text-white"><i class="bi bi-mortarboard"></i> Agri Expert</span>
        <h2>Expert Knowledge Desk</h2>
        <p>Providing data-driven advisories and critical weather alerts to the farming community.</p>
    </div>
</section>

<main class="container mt-n4">
    <div class="row g-4">
        <div class="col-lg-8">
            <!-- Advisory Tool -->
            <div class="stat-card mb-4">
                <div class="section-title text-primary"><i class="bi bi-megaphone"></i> Broadcast New Advisory</div>
                <form action="${pageContext.request.contextPath}/api/v1/advisories" method="post">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold">Target Crop</label>
                            <select class="form-select" name="cropName">
                                <option>General / All</option>
                                <option>Wheat</option>
                                <option>Rice</option>
                                <option>Cotton</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold">Advisory Type</label>
                            <select class="form-select" name="type">
                                <option>PEST_ALERT</option>
                                <option>WEATHER_WARNING</option>
                                <option>MARKET_ADVISORY</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold">Message Content</label>
                            <textarea class="form-control" rows="4" placeholder="Enter expert guidance for farmers..."></textarea>
                        </div>
                        <div class="col-12 text-end">
                            <button type="submit" class="btn btn-primary-custom px-4">Broadcast Advisory</button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Recent Queries -->
            <div class="stat-card">
                <div class="section-title"><i class="bi bi-question-circle"></i> Recent Farmer Queries</div>
                <div class="alert alert-light border d-flex gap-3 align-items-center">
                    <div class="bg-primary text-white rounded-circle p-2" style="width: 40px; height: 40px; flex-shrink: 0; display: flex; align-items: center; justify-content: center;">
                        <i class="bi bi-person"></i>
                    </div>
                    <div class="flex-grow-1">
                        <div class="d-flex justify-content-between">
                            <span class="fw-bold">Ramesh Kumar <small class="text-muted">(Wheat Farmer)</small></span>
                            <span class="small text-muted">2h ago</span>
                        </div>
                        <p class="small mb-0">What is the best fertilizer for late-sown Wheat in Kangra district?</p>
                    </div>
                    <button class="btn btn-sm btn-outline-primary">Reply</button>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <!-- Market Trends -->
            <div class="stat-card mb-4">
                <div class="section-title"><i class="bi bi-graph-up"></i> Price Surveillance</div>
                <canvas id="marketChart" height="200"></canvas>
                <div class="mt-3">
                    <div class="small fw-bold mb-1">Wheat Price Volatility</div>
                    <div class="progress" style="height: 6px;">
                        <div class="progress-bar bg-success" style="width: 75%"></div>
                    </div>
                </div>
            </div>

            <!-- Critical Alerts -->
            <div class="stat-card bg-dark text-white">
                <div class="section-title text-white"><i class="bi bi-lightning-charge text-warning"></i> Active Warnings</div>
                <div class="d-grid gap-2">
                    <div class="p-2 border border-secondary rounded">
                        <div class="small fw-bold text-warning">Heatwave Alert</div>
                        <div class="small opacity-75">North India - Expected +4°C rise</div>
                    </div>
                    <div class="p-2 border border-secondary rounded">
                        <div class="small fw-bold text-info">Pest Sighting</div>
                        <div class="small opacity-75">Locust swarm reported in Rajasthan</div>
                    </div>
                </div>
                <button class="btn btn-sm btn-outline-light w-100 mt-3">View Global Alerts</button>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const ctx = document.getElementById('marketChart');
    if (ctx) {
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
                datasets: [{
                    label: 'Avg Market Price',
                    data: [22.1, 22.4, 22.2, 22.8, 23.1, 22.9],
                    borderColor: '#1a9e4a',
                    tension: 0.4
                }]
            },
            options: {
                plugins: { legend: { display: false } },
                scales: { y: { display: false }, x: { grid: { display: false } } }
            }
        });
    }
</script>
</body>
</html>
