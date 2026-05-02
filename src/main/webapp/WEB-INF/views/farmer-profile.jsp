<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Farmer Profile - AgriConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
        body { background: #f0f4f8; min-height: 100vh; }

        .navbar {
            background: linear-gradient(135deg, #0a4f2c, #16783a) !important;
            padding: 0.875rem 0;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }
        .navbar-brand { font-weight: 800; font-size: 1.3rem; }
        .navbar-brand span { color: #86efac; }
        .nav-link { color: rgba(255,255,255,0.85) !important; font-weight: 500; font-size: 0.9rem; }
        .nav-link:hover { color: white !important; }
        .btn-back {
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.25);
            color: white; border-radius: 8px; font-size: 0.875rem;
            font-weight: 500; padding: 0.4rem 0.875rem; transition: all 0.2s;
            text-decoration: none;
        }
        .btn-back:hover { background: rgba(255,255,255,0.25); color: white; }

        .profile-hero {
            background: linear-gradient(135deg, #0a4f2c, #1a9e4a);
            color: white;
            padding: 2.5rem 0 5rem;
            position: relative;
            overflow: hidden;
        }
        .profile-hero::after {
            content: '';
            position: absolute;
            bottom: -1px; left: 0; right: 0;
            height: 50px;
            background: #f0f4f8;
            clip-path: ellipse(55% 100% at 50% 100%);
        }

        .avatar {
            width: 90px; height: 90px;
            background: rgba(255,255,255,0.2);
            border: 3px solid rgba(255,255,255,0.4);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 2.5rem;
            margin: 0 auto 1rem;
        }

        .score-ring-wrapper {
            background: white;
            border-radius: 24px;
            padding: 2rem;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            text-align: center;
            margin-top: -2rem;
            position: relative;
            z-index: 1;
        }

        .circular-chart { display: block; margin: 0 auto; max-width: 180px; max-height: 180px; }
        .circle-bg { fill: none; stroke: #e2e8f0; stroke-width: 3.8; }
        .circle {
            fill: none; stroke-width: 3.8;
            stroke-linecap: round;
            transform: rotate(-90deg);
            transform-origin: 50% 50%;
            transition: stroke-dasharray 1.5s ease-in-out;
        }
        .circle-label { fill: #1a202c; font-size: 0.45em; font-weight: 800; text-anchor: middle; }
        .circle-sub { fill: #718096; font-size: 0.22em; text-anchor: middle; }

        .badge-pill {
            display: inline-flex; align-items: center; gap: 0.4rem;
            padding: 0.4rem 1rem; border-radius: 20px;
            font-weight: 700; font-size: 0.875rem; margin-top: 1rem;
        }
        .badge-new { background: #e0e7ff; color: #3730a3; }
        .badge-reliable { background: #fff7ed; color: #c2410c; }
        .badge-top { background: #dcfce7; color: #15803d; }
        .badge-elite { background: linear-gradient(135deg, #fef08a, #fcd34d); color: #92400e; }

        .score-desc { font-size: 0.8rem; color: #718096; margin-top: 0.5rem; }

        .metric-card {
            background: white;
            border-radius: 16px;
            padding: 1.25rem;
            text-align: center;
            border: 2px solid #e2e8f0;
            transition: all 0.2s;
        }
        .metric-card:hover { border-color: #16783a; transform: translateY(-2px); }
        .metric-icon { font-size: 1.4rem; margin-bottom: 0.4rem; }
        .metric-value { font-size: 1.4rem; font-weight: 800; color: #1a202c; }
        .metric-label { font-size: 0.75rem; color: #718096; font-weight: 500; }

        .criteria-card {
            background: white;
            border-radius: 16px;
            padding: 1.25rem 1.5rem;
        }
        .criteria-item { padding: 0.75rem 0; border-bottom: 1px solid #f0f4f8; }
        .criteria-item:last-child { border-bottom: none; }
        .criteria-bar { height: 8px; background: #e2e8f0; border-radius: 4px; overflow: hidden; margin-top: 0.4rem; }
        .criteria-bar-fill { height: 100%; border-radius: 4px; transition: width 1s ease-in-out; }
    </style>
</head>
<body>

<jsp:include page="fragments/farmer-nav.jsp">
    <jsp:param name="active" value="profile" />
</jsp:include>

<div class="profile-hero">
    <div class="container text-center">
        <div class="avatar">🧑‍🌾</div>
        <h2 class="fw-bold mb-1">Farmer Profile</h2>
        <p class="text-white-75 mb-0" style="opacity: 0.8;">
            <i class="bi bi-geo-alt me-1"></i>Nashik, Maharashtra
        </p>
    </div>
</div>

<div class="container pb-5" style="margin-top: -2rem; position: relative; z-index: 1;">
    <div class="row g-4">

        <!-- Score Ring -->
        <div class="col-md-4">
            <div class="score-ring-wrapper">
                <h6 class="text-muted text-uppercase fw-bold mb-3" style="font-size: 0.75rem; letter-spacing: 1px;">
                    Farmer Trust Score
                </h6>
                <svg viewBox="0 0 36 36" class="circular-chart">
                    <path class="circle-bg" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"/>
                    <path class="circle"
                          id="scoreCircle"
                          stroke="${scoreColor}"
                          stroke-dasharray="0 100"
                          d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831"/>
                    <text x="18" y="18.5" class="circle-label">${farmer.farmerScore}</text>
                    <text x="18" y="22.5" class="circle-sub">/100</text>
                </svg>

                <c:choose>
                    <c:when test="${scoreBadge == 'Elite'}">
                        <div class="badge-pill badge-elite"><i class="bi bi-trophy-fill"></i>${scoreBadge} Farmer</div>
                    </c:when>
                    <c:when test="${scoreBadge == 'Top Seller'}">
                        <div class="badge-pill badge-top"><i class="bi bi-star-fill"></i>${scoreBadge}</div>
                    </c:when>
                    <c:when test="${scoreBadge == 'Reliable'}">
                        <div class="badge-pill badge-reliable"><i class="bi bi-patch-check-fill"></i>${scoreBadge}</div>
                    </c:when>
                    <c:otherwise>
                        <div class="badge-pill badge-new"><i class="bi bi-person-fill"></i>${scoreBadge}</div>
                    </c:otherwise>
                </c:choose>

                <p class="score-desc">Based on delivery history, quality ratings, and trade volume</p>
            </div>
        </div>

        <!-- Metrics & Criteria -->
        <div class="col-md-8">
            <div class="row g-3 mb-3">
                <div class="col-6 col-md-3">
                    <div class="metric-card">
                        <div class="metric-icon">📦</div>
                        <div class="metric-value">24</div>
                        <div class="metric-label">Orders Completed</div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="metric-card">
                        <div class="metric-icon">⭐</div>
                        <div class="metric-value">4.8</div>
                        <div class="metric-label">Avg. Buyer Rating</div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="metric-card">
                        <div class="metric-icon">🚚</div>
                        <div class="metric-value">96%</div>
                        <div class="metric-label">On-time Delivery</div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="metric-card">
                        <div class="metric-icon">🌾</div>
                        <div class="metric-value">5</div>
                        <div class="metric-label">Active Listings</div>
                    </div>
                </div>
            </div>

            <div class="criteria-card">
                <h6 class="fw-bold text-dark mb-3" style="font-size: 0.9rem;">Score Breakdown</h6>
                <div class="criteria-item">
                    <div class="d-flex justify-content-between">
                        <span class="fw-semibold" style="font-size: 0.875rem;">Delivery Reliability</span>
                        <span class="text-success fw-bold" style="font-size: 0.875rem;">96%</span>
                    </div>
                    <div class="criteria-bar">
                        <div class="criteria-bar-fill bg-success" data-width="96"></div>
                    </div>
                </div>
                <div class="criteria-item">
                    <div class="d-flex justify-content-between">
                        <span class="fw-semibold" style="font-size: 0.875rem;">Produce Quality</span>
                        <span class="text-success fw-bold" style="font-size: 0.875rem;">88%</span>
                    </div>
                    <div class="criteria-bar">
                        <div class="criteria-bar-fill bg-success" data-width="88"></div>
                    </div>
                </div>
                <div class="criteria-item">
                    <div class="d-flex justify-content-between">
                        <span class="fw-semibold" style="font-size: 0.875rem;">Trade Volume</span>
                        <span class="text-warning fw-bold" style="font-size: 0.875rem;">62%</span>
                    </div>
                    <div class="criteria-bar">
                        <div class="criteria-bar-fill bg-warning" data-width="62"></div>
                    </div>
                </div>
                <div class="criteria-item">
                    <div class="d-flex justify-content-between">
                        <span class="fw-semibold" style="font-size: 0.875rem;">Response Rate</span>
                        <span class="text-success fw-bold" style="font-size: 0.875rem;">91%</span>
                    </div>
                    <div class="criteria-bar">
                        <div class="criteria-bar-fill bg-success" data-width="91"></div>
                    </div>
                </div>
            </div>

            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/web/marketplace" class="btn btn-success px-4">
                    <i class="bi bi-shop me-1"></i>Go to Marketplace
                </a>
                <a href="${pageContext.request.contextPath}/web/dashboard/farmer" class="btn btn-outline-secondary ms-2 px-4">
                    <i class="bi bi-grid me-1"></i>Dashboard
                </a>
            </div>
        </div>
    </div>

    <div class="row g-3 mt-1">
        <div class="col-lg-4">
            <div class="workspace-panel h-100">
                <div class="panel-title">
                    <h3>Profile Readiness</h3>
                    <span class="sell-signal good">86%</span>
                </div>
                <div class="criteria-item">
                    <div class="d-flex justify-content-between">
                        <span class="fw-semibold" style="font-size: 0.875rem;">Farm location</span>
                        <span class="text-success fw-bold" style="font-size: 0.875rem;">Done</span>
                    </div>
                    <div class="criteria-bar"><div class="criteria-bar-fill bg-success" data-width="100"></div></div>
                </div>
                <div class="criteria-item">
                    <div class="d-flex justify-content-between">
                        <span class="fw-semibold" style="font-size: 0.875rem;">Crop history</span>
                        <span class="text-success fw-bold" style="font-size: 0.875rem;">Good</span>
                    </div>
                    <div class="criteria-bar"><div class="criteria-bar-fill bg-success" data-width="82"></div></div>
                </div>
                <div class="criteria-item">
                    <div class="d-flex justify-content-between">
                        <span class="fw-semibold" style="font-size: 0.875rem;">Bank verification</span>
                        <span class="text-warning fw-bold" style="font-size: 0.875rem;">Pending</span>
                    </div>
                    <div class="criteria-bar"><div class="criteria-bar-fill bg-warning" data-width="45"></div></div>
                </div>
                <a href="${pageContext.request.contextPath}/web/notifications" class="btn btn-outline-success w-100 mt-3">
                    <i class="bi bi-patch-check me-1"></i>Complete Verification
                </a>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="workspace-panel h-100">
                <div class="panel-title">
                    <h3>Buyer Trust Signals</h3>
                </div>
                <div class="timeline-list">
                    <div class="timeline-item">
                        <i class="bi bi-camera"></i>
                        <div>
                            <strong>Add produce photos</strong>
                            <span>Photos improve bid confidence.</span>
                        </div>
                    </div>
                    <div class="timeline-item">
                        <i class="bi bi-droplet"></i>
                        <div>
                            <strong>Add quality notes</strong>
                            <span>Moisture, grade, and packaging.</span>
                        </div>
                    </div>
                    <div class="timeline-item">
                        <i class="bi bi-truck"></i>
                        <div>
                            <strong>Confirm pickup slots</strong>
                            <span>Buyers prefer clear loading windows.</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="workspace-panel h-100">
                <div class="panel-title">
                    <h3>Smart Suggestions</h3>
                </div>
                <div class="signal-card mb-2">
                    <div class="signal-label">Next best action</div>
                    <div class="fw-bold mt-1">List wheat before Friday mandi close</div>
                    <div class="text-muted small mt-1">Nearby bids are trending above MSP.</div>
                </div>
                <div class="signal-card">
                    <div class="signal-label">Score booster</div>
                    <div class="fw-bold mt-1">Respond to buyer messages within 6 hours</div>
                    <div class="text-muted small mt-1">Improves response-rate component.</div>
                </div>
                <a href="${pageContext.request.contextPath}/web/dashboard/farmer" class="btn btn-success w-100 mt-3">
                    <i class="bi bi-grid-1x2 me-1"></i>Open Dashboard
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Animate score ring
    window.addEventListener('load', function() {
        const circle = document.getElementById('scoreCircle');
        const score = ${farmer.farmerScore};
        if (circle && score) {
            setTimeout(() => {
                circle.setAttribute('stroke-dasharray', score + ' 100');
            }, 300);
        }
        // Animate bars
        document.querySelectorAll('.criteria-bar-fill').forEach(bar => {
            const w = bar.getAttribute('data-width');
            bar.style.width = '0%';
            setTimeout(() => { bar.style.width = w + '%'; }, 400);
        });
    });
</script>
</body>
</html>
