<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Advisories - AgriConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
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
        .nav-link { color: rgba(255,255,255,0.85) !important; font-weight: 500; }
        .nav-link:hover { color: white !important; }
        .btn-logout {
            background: rgba(255,255,255,0.15); border: 1px solid rgba(255,255,255,0.25);
            color: white; border-radius: 8px; font-size: 0.875rem;
            font-weight: 500; padding: 0.4rem 0.875rem; transition: all 0.2s;
        }
        .btn-logout:hover { background: rgba(255,255,255,0.25); color: white; }

        .page-header {
            background: linear-gradient(135deg, #0a4f2c, #1a9e4a);
            color: white; padding: 2rem 0 3.5rem;
            position: relative; overflow: hidden;
        }
        .page-header::after {
            content: ''; position: absolute;
            bottom: -1px; left: 0; right: 0; height: 40px;
            background: #f0f4f8;
            clip-path: ellipse(55% 100% at 50% 100%);
        }
        .page-header h1 { font-weight: 800; font-size: 1.75rem; margin-bottom: 0.25rem; }

        .advisory-card {
            background: white;
            border-radius: 20px;
            border: 2px solid #e2e8f0;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.2s;
        }
        .advisory-card:hover { border-color: #16783a; transform: translateY(-2px); box-shadow: 0 8px 25px rgba(22,120,58,0.1); }

        .advisory-tag {
            display: inline-flex; align-items: center; gap: 0.35rem;
            background: #dcfce7; color: #15803d;
            padding: 0.25rem 0.75rem; border-radius: 20px;
            font-size: 0.75rem; font-weight: 600;
            margin-bottom: 0.75rem;
        }
        .advisory-tag.warning { background: #fff7ed; color: #c2410c; }
        .advisory-tag.info { background: #eff6ff; color: #1d4ed8; }

        .advisory-title { font-size: 1.05rem; font-weight: 700; color: #1a202c; margin-bottom: 0.5rem; }
        .advisory-body { color: #4a5568; font-size: 0.875rem; line-height: 1.6; margin-bottom: 0.75rem; }
        .advisory-meta { color: #a0aec0; font-size: 0.78rem; display: flex; gap: 1.25rem; }

        .publish-card {
            background: white; border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.07); padding: 1.75rem;
            margin-bottom: 1.5rem;
        }
        .publish-card h5 { font-weight: 700; color: #1a202c; margin-bottom: 1rem; }

        .form-label {
            font-size: 0.78rem; font-weight: 600; color: #4a5568;
            text-transform: uppercase; letter-spacing: 0.5px;
        }
        .form-control, .form-select {
            border: 2px solid #e2e8f0; border-radius: 12px;
            padding: 0.7rem 1rem; font-size: 0.875rem; transition: all 0.2s;
        }
        .form-control:focus, .form-select:focus {
            border-color: #16783a;
            box-shadow: 0 0 0 3px rgba(22,120,58,0.1);
        }
        .btn-publish {
            background: linear-gradient(135deg, #16783a, #0a4f2c);
            border: none; border-radius: 12px;
            color: white; font-weight: 600; padding: 0.75rem 2rem;
            transition: all 0.2s;
        }
        .btn-publish:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(22,120,58,0.35); color: white; }

        .empty-state { text-align: center; padding: 3rem 2rem; background: white; border-radius: 20px; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand text-white" href="${pageContext.request.contextPath}/web/marketplace">
            🌾 Agri<span>Connect</span>
        </a>
        <div class="d-flex align-items-center gap-2">
            <a href="${pageContext.request.contextPath}/web/expert/dashboard" class="nav-link">
                <i class="bi bi-grid me-1"></i>Dashboard
            </a>
            <form action="${pageContext.request.contextPath}/logout" method="post" class="d-inline ms-2">
                <button type="submit" class="btn-logout">
                    <i class="bi bi-box-arrow-right me-1"></i>Sign Out
                </button>
            </form>
        </div>
    </div>
</nav>

<div class="page-header">
    <div class="container">
        <h1><i class="bi bi-megaphone me-2"></i>Agricultural Advisories</h1>
        <p class="mb-0" style="opacity: 0.8; font-size: 0.9rem;">
            Share expert insights with registered farmers across the platform
        </p>
    </div>
</div>

<div class="container pb-5" style="margin-top: -1.5rem; position: relative; z-index: 1;">
    <div class="row g-4">

        <!-- Publish Form -->
        <div class="col-lg-5">
            <div class="publish-card">
                <h5><i class="bi bi-pencil-square me-2 text-success"></i>Publish New Advisory</h5>
                <form id="advisoryForm" onsubmit="publishAdvisory(event)">
                    <div class="mb-3">
                        <label class="form-label">Title</label>
                        <input type="text" class="form-control" id="advisoryTitle"
                               placeholder="e.g. Early blight alert for Nashik wheat farmers" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Category</label>
                        <select class="form-select" id="advisoryCategory">
                            <option value="PEST_ALERT">🐛 Pest Alert</option>
                            <option value="WEATHER">🌦️ Weather Advisory</option>
                            <option value="MARKET">📈 Market Update</option>
                            <option value="TECHNIQUE">🌱 Best Practice / Technique</option>
                            <option value="GOVERNMENT">🏛️ Government Scheme</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Target Crop (optional)</label>
                        <input type="text" class="form-control" id="advisoryCrop"
                               placeholder="e.g. Wheat, Onion, Rice (leave blank for all)">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Advisory Content</label>
                        <textarea class="form-control" id="advisoryBody" rows="5"
                                  placeholder="Provide detailed advice, recommended actions, and expected impact..." required></textarea>
                    </div>
                    <button type="submit" class="btn btn-publish" id="publishBtn">
                        <i class="bi bi-send me-2"></i>Publish to All Farmers
                    </button>
                </form>

                <div id="publishSuccess" style="display:none;" class="alert alert-success mt-3 border-0" style="border-radius:12px;">
                    <i class="bi bi-check-circle-fill me-2"></i>Advisory published! All farmers have been notified.
                </div>
            </div>
        </div>

        <!-- Published Advisories List -->
        <div class="col-lg-7">
            <h6 class="fw-bold text-dark mb-3" style="font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.5px;">
                Recent Advisories
            </h6>
            <c:choose>
                <c:when test="${not empty advisories}">
                    <c:forEach var="advisory" items="${advisories}">
                        <div class="advisory-card">
                            <div class="advisory-tag">📢 Advisory</div>
                            <div class="advisory-title">${advisory.title}</div>
                            <div class="advisory-body">${advisory.body}</div>
                            <div class="advisory-meta">
                                <span><i class="bi bi-person me-1"></i>${advisory.expertName}</span>
                                <span><i class="bi bi-calendar me-1"></i>${advisory.createdAt}</span>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <!-- Demo Advisories when DB is empty -->
                    <div class="advisory-card">
                        <div class="advisory-tag warning">⚠️ Pest Alert</div>
                        <div class="advisory-title">Early Blight Risk — Nashik & Pune Districts</div>
                        <div class="advisory-body">
                            High humidity levels this week (85%+) significantly increase the risk of early blight
                            in wheat and tomato crops. Apply recommended fungicide (Mancozeb) at 2.5g/litre
                            as a preventive measure. Avoid overhead irrigation between 6–10 AM.
                        </div>
                        <div class="advisory-meta">
                            <span><i class="bi bi-person me-1"></i>Dr. Priya Sharma, KVK Nashik</span>
                            <span><i class="bi bi-calendar me-1"></i>30 Apr 2026</span>
                        </div>
                    </div>
                    <div class="advisory-card">
                        <div class="advisory-tag info">📈 Market Update</div>
                        <div class="advisory-title">Onion Prices Expected to Rise — Good Time to List</div>
                        <div class="advisory-body">
                            Based on APMC data and seasonal trends, onion prices are projected to rise
                            15–20% over the next 3 weeks due to supply reduction in Karnataka.
                            Farmers with stored onion produce should consider listing now.
                        </div>
                        <div class="advisory-meta">
                            <span><i class="bi bi-person me-1"></i>Prof. Ramesh Nair, ICAR</span>
                            <span><i class="bi bi-calendar me-1"></i>29 Apr 2026</span>
                        </div>
                    </div>
                    <div class="advisory-card">
                        <div class="advisory-tag">🌱 Best Practice</div>
                        <div class="advisory-title">Drip Irrigation Subsidy — PM-KUSUM Scheme</div>
                        <div class="advisory-body">
                            The Government of Maharashtra is offering 55% subsidy on drip irrigation
                            systems under PM-KUSUM for farmers under 5 acres. Apply online at
                            mahadbt.maharashtra.gov.in before May 31, 2026.
                        </div>
                        <div class="advisory-meta">
                            <span><i class="bi bi-person me-1"></i>AgriConnect Expert Team</span>
                            <span><i class="bi bi-calendar me-1"></i>28 Apr 2026</span>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function publishAdvisory(e) {
        e.preventDefault();
        const btn = document.getElementById('publishBtn');
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Publishing...';
        btn.disabled = true;

        const payload = {
            title: document.getElementById('advisoryTitle').value,
            body: document.getElementById('advisoryBody').value,
            cropType: document.getElementById('advisoryCrop').value || null,
            category: document.getElementById('advisoryCategory').value
        };

        fetch('${pageContext.request.contextPath}/api/v1/advisories', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        }).then(res => res.json())
          .then(data => {
              document.getElementById('publishSuccess').style.display = 'block';
              document.getElementById('advisoryForm').reset();
              btn.innerHTML = '<i class="bi bi-send me-2"></i>Publish to All Farmers';
              btn.disabled = false;
              setTimeout(() => {
                  document.getElementById('publishSuccess').style.display = 'none';
              }, 5000);
          }).catch(() => {
              btn.innerHTML = '<i class="bi bi-send me-2"></i>Publish to All Farmers';
              btn.disabled = false;
              alert('Could not publish advisory. Please ensure you are logged in as an Expert.');
          });
    }
</script>
</body>
</html>
