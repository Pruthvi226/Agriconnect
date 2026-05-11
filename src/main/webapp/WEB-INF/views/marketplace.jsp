<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Live Marketplace - AgriConnect</title>
    <meta name="description" content="AgriConnect Live Marketplace - Find fresh produce with MSP price comparison">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
    <style>
        .page-header {
            background: linear-gradient(135deg, #0a4f2c, #1a9e4a);
            color: white; padding: 2rem 0 3rem; position: relative; overflow: hidden;
        }
        .page-header::after {
            content: ''; position: absolute; bottom: -1px; left: 0; right: 0;
            height: 40px; background: var(--bg-color); clip-path: ellipse(55% 100% at 50% 100%);
        }
        .page-header h1 { font-weight: 800; font-size: 1.75rem; margin-bottom: 0.25rem; }
        .page-header p { color: rgba(255,255,255,0.8); margin: 0; font-size: 0.9rem; }

        .search-bar {
            background: var(--card-bg); border-radius: 16px; padding: 1.25rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08); margin-bottom: 1.75rem; backdrop-filter: blur(10px);
        }
        .search-bar .btn-search {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            border: none; border-radius: 10px; color: white; font-weight: 600;
            font-size: 0.875rem; padding: 0.6rem 1.25rem; transition: all 0.2s;
        }
        .search-bar .btn-search:hover { transform: translateY(-1px); box-shadow: 0 4px 15px rgba(26,158,74,0.3); }

        .listing-card {
            background: white; border-radius: 20px; border: 2px solid #e2e8f0;
            overflow: hidden; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); height: 100%;
        }
        .listing-card:hover {
            border-color: var(--primary); transform: translateY(-5px); box-shadow: var(--shadow-hover);
        }
        .card-top { padding: 1.25rem 1.25rem 0.75rem; }
        .crop-icon {
            width: 44px; height: 44px; background: linear-gradient(135deg, #dcfce7, #bbf7d0);
            border-radius: 12px; display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem; flex-shrink: 0;
        }
        .crop-name { font-size: 1rem; font-weight: 700; color: #1a202c; margin-bottom: 0.1rem; }
        .crop-variety { font-size: 0.78rem; color: #718096; font-weight: 500; }
        .location-chip {
            display: inline-flex; align-items: center; gap: 0.3rem; background: #f0f4f8; color: #4a5568;
            padding: 0.25rem 0.6rem; border-radius: 20px; font-size: 0.75rem; font-weight: 500;
        }
        .price-row { padding: 0.75rem 1.25rem; border-top: 1px solid #f0f4f8; }
        .asking-price { font-size: 1.5rem; font-weight: 800; color: #15803d; }
        .price-unit { font-size: 0.75rem; color: #718096; font-weight: 500; }
        .msp-row { padding: 0 1.25rem 0.75rem; }
        .badge-msp-below { background: #fee2e2; color: #b91c1c; font-size: 0.72rem; padding: 0.2rem 0.5rem; border-radius: 6px; font-weight: 600; }
        .badge-msp-above { background: #dcfce7; color: #15803d; font-size: 0.72rem; padding: 0.2rem 0.5rem; border-radius: 6px; font-weight: 600; }
        .badge-msp-at { background: #e0e7ff; color: #3730a3; font-size: 0.72rem; padding: 0.2rem 0.5rem; border-radius: 6px; font-weight: 600; }
        .qty-row { padding: 0.5rem 1.25rem; background: #f8fafc; font-size: 0.8rem; color: #718096; }
        .card-footer-custom { padding: 0.875rem 1.25rem; background: white; border-top: 1px solid #f0f4f8; }
        .results-count { font-size: 0.875rem; color: #718096; margin-bottom: 1rem; }
        .navbar .btn-logout {
            background: rgba(255,255,255,0.15); border: 1px solid rgba(255,255,255,0.25);
            color: white; border-radius: 8px; font-size: 0.875rem; font-weight: 500;
            padding: 0.4rem 0.875rem; transition: all 0.2s;
        }
        .navbar .btn-logout:hover { background: rgba(255,255,255,0.25); }
    </style>
</head>
<body>

<!-- NAVBAR -->
<jsp:include page="fragments/navbar-selector.jsp">
    <jsp:param name="active" value="marketplace" />
</jsp:include>

<!-- PAGE HEADER -->
<div class="page-header">
    <div class="container">
        <h1><i class="bi bi-shop me-2"></i>Live Marketplace</h1>
        <p>Browse fresh produce listings with real-time MSP comparison</p>
    </div>
</div>

<div class="container pb-5" style="margin-top: -1.5rem; position: relative; z-index: 1;">

    <c:if test="${not empty fpoListings}">
        <div class="workspace-panel mb-4">
            <div class="panel-title">
                <div>
                    <h2>FPO collective deals</h2>
                    <div class="text-muted small">Verified farmer collectives pooled for bulk-ready procurement.</div>
                </div>
                <span class="priority-pill">At the top</span>
            </div>
            <div class="row g-3">
                <c:forEach var="fpo" items="${fpoListings}">
                    <div class="col-md-6 col-lg-4">
                        <div class="listing-card border-success">
                            <div class="card-top">
                                <div class="d-flex align-items-start justify-content-between gap-3 mb-2">
                                    <div>
                                        <div class="crop-name">${fpo.cropName}</div>
                                        <div class="crop-variety">${fpo.groupName}</div>
                                    </div>
                                    <span class="badge-msp-above">${fpo.badgeLabel}</span>
                                </div>
                                <span class="location-chip">
                                    <i class="bi bi-geo-alt-fill text-danger"></i>
                                    ${fpo.district}, ${fpo.state}
                                </span>
                            </div>
                            <div class="price-row d-flex align-items-end gap-1">
                                <span class="asking-price">Rs ${fpo.minPricePerKg}</span>
                                <span class="price-unit mb-1">/ kg min</span>
                            </div>
                            <div class="qty-row">
                                <i class="bi bi-people-fill me-1"></i>
                                <strong>${fpo.totalQuantityKg} kg</strong> pooled from ${fpo.totalMembers} members
                            </div>
                            <div class="card-footer-custom">
                                <div class="d-flex justify-content-between align-items-center small text-muted">
                                    <span>Grade ${fpo.qualityGrade}</span>
                                    <span>Deadline ${fpo.poolingDeadline}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <!-- SEARCH BAR -->
    <div class="search-bar">
        <form method="get" action="${pageContext.request.contextPath}/web/marketplace" class="row g-2 align-items-end">
            <div class="col-md-4">
                <label class="form-label text-muted fw-semibold" style="font-size: 0.78rem;">SEARCH CROP</label>
                <input type="text" class="form-control" name="crop" placeholder="e.g. Wheat, Rice, Onion...">
            </div>
            <div class="col-md-3">
                <label class="form-label text-muted fw-semibold" style="font-size: 0.78rem;">DISTRICT</label>
                <input type="text" class="form-control" name="district" placeholder="e.g. Nashik">
            </div>
            <div class="col-md-3">
                <label class="form-label text-muted fw-semibold" style="font-size: 0.78rem;">MSP STATUS</label>
                <select class="form-select" name="mspFilter" style="border: 2px solid #e2e8f0; border-radius: 10px; font-size: 0.875rem;">
                    <option value="">All listings</option>
                    <option value="ABOVE_MSP">Above MSP</option>
                    <option value="BELOW_MSP">Below MSP</option>
                </select>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-search w-100">
                    <i class="bi bi-search me-1"></i>Search
                </button>
            </div>
        </form>
    </div>

    <!-- RESULTS -->
    <c:choose>
        <c:when test="${not empty listings}">
            <div class="results-count">
                Showing <strong>${listings.size()} listings</strong> on the market
            </div>
            <div class="row g-3">
                <c:forEach var="listing" items="${listings}">
                    <div class="col-md-6 col-lg-4">
                        <div class="listing-card">
                            <div class="card-top">
                                <div class="d-flex align-items-start gap-3 mb-2">
                                    <div class="crop-icon">🌾</div>
                                    <div class="flex-grow-1">
                                        <div class="crop-name">${listing.cropName}</div>
                                        <div class="crop-variety">${listing.variety}</div>
                                    </div>
                                </div>
                                <span class="location-chip">
                                    <i class="bi bi-geo-alt-fill text-danger"></i>
                                    ${listing.district}
                                </span>
                            </div>

                            <div class="price-row d-flex align-items-end gap-1">
                                <span class="asking-price">₹${listing.askingPrice}</span>
                                <span class="price-unit mb-1">/ kg</span>
                            </div>

                            <div class="msp-row">
                                <c:choose>
                                    <c:when test="${not empty listing.mspPrice}">
                                        <small class="text-muted">MSP: ₹${listing.mspPrice}/kg &nbsp;</small>
                                        <c:choose>
                                            <c:when test="${listing.mspBadge == 'BELOW_MSP'}">
                                                <span class="badge-msp-below">▼ Below MSP (${listing.mspDiffPercent}%)</span>
                                            </c:when>
                                            <c:when test="${listing.mspBadge == 'ABOVE_MSP'}">
                                                <span class="badge-msp-above">▲ Above MSP (+${listing.mspDiffPercent}%)</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-msp-at">= At MSP</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <small class="text-muted"><i class="bi bi-info-circle me-1"></i>MSP not announced for this crop</small>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="qty-row">
                                <i class="bi bi-box-seam me-1"></i>
                                <strong>${listing.quantityKg} kg</strong> available
                            </div>

                            <div class="card-footer-custom">
                                <a href="${pageContext.request.contextPath}/web/marketplace/listing/${listing.id}"
                                   class="btn btn-primary-custom w-100 p-2">
                                    <i class="bi bi-hammer me-1"></i>View &amp; Bid
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="icon">🌱</div>
                <h4 class="text-dark fw-bold">No listings found</h4>
                <p class="text-muted">There are no active produce listings at the moment. Check back soon!</p>
                <a href="${pageContext.request.contextPath}/web/marketplace" class="btn btn-success mt-2">
                    <i class="bi bi-arrow-clockwise me-1"></i>Refresh
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="fragments/footer.jsp" />
</body>
</html>
