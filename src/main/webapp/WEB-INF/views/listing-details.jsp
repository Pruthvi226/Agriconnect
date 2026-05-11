<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Listing Details - AgriConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        .btn-back {
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.25);
            color: white; border-radius: 8px; font-size: 0.875rem;
            font-weight: 500; padding: 0.4rem 0.875rem;
            text-decoration: none; transition: all 0.2s;
        }
        .btn-back:hover { background: rgba(255,255,255,0.25); color: white; }

        .page-header {
            background: linear-gradient(135deg, #0a4f2c, #1a9e4a);
            color: white;
            padding: 2rem 0 3.5rem;
            position: relative;
            overflow: hidden;
        }
        .page-header::after {
            content: '';
            position: absolute;
            bottom: -1px; left: 0; right: 0;
            height: 40px;
            background: #f0f4f8;
            clip-path: ellipse(55% 100% at 50% 100%);
        }

        .info-card {
            background: white;
            border-radius: 20px;
            border: none;
            box-shadow: 0 4px 20px rgba(0,0,0,0.07);
            overflow: hidden;
        }

        .info-card .card-header-custom {
            background: linear-gradient(135deg, #f0fff4, #dcfce7);
            padding: 1.25rem 1.5rem;
            border-bottom: 2px solid #bbf7d0;
        }

        .info-card .card-body { padding: 1.5rem; }

        .price-display {
            background: linear-gradient(135deg, #0a4f2c, #16783a);
            color: white;
            border-radius: 16px;
            padding: 1.5rem;
            text-align: center;
        }
        .price-display .label { font-size: 0.75rem; font-weight: 600; opacity: 0.8; text-transform: uppercase; letter-spacing: 0.5px; }
        .price-display .amount { font-size: 2.5rem; font-weight: 800; line-height: 1; }
        .price-display .unit { font-size: 0.875rem; opacity: 0.8; }

        .detail-row {
            display: flex; justify-content: space-between; align-items: center;
            padding: 0.75rem 0; border-bottom: 1px solid #f0f4f8;
            font-size: 0.875rem;
        }
        .detail-row:last-child { border-bottom: none; }
        .detail-row .label { color: #718096; font-weight: 500; }
        .detail-row .value { color: #1a202c; font-weight: 600; }

        .farmer-badge {
            background: #f0fff4;
            border: 2px solid #bbf7d0;
            border-radius: 14px;
            padding: 1rem;
            display: flex; align-items: center; gap: 1rem;
        }
        .farmer-avatar {
            width: 48px; height: 48px;
            background: linear-gradient(135deg, #16783a, #0a4f2c);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem; color: white; flex-shrink: 0;
        }

        .bid-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.07);
            overflow: hidden;
        }
        .bid-card-header {
            background: linear-gradient(135deg, #1e3a5f, #2563eb);
            color: white;
            padding: 1rem 1.25rem;
        }
        .bid-card-body { padding: 1.25rem; }

        .bid-form .form-control {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            font-size: 0.9rem;
        }
        .bid-form .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
        }
        .btn-bid-submit {
            background: linear-gradient(135deg, #2563eb, #1e3a5f);
            border: none; border-radius: 12px;
            color: white; font-weight: 700;
            padding: 0.875rem; width: 100%; font-size: 0.95rem;
            transition: all 0.2s;
        }
        .btn-bid-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(37,99,235,0.35);
            color: white;
        }
    </style>
</head>
<body>

<jsp:include page="fragments/navbar-selector.jsp">
    <jsp:param name="active" value="marketplace" />
</jsp:include>

<div class="page-header">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-2" style="font-size: 0.8rem; opacity: 0.8;">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/web/marketplace" class="text-white">Marketplace</a></li>
                <li class="breadcrumb-item active text-white">Listing Details</li>
            </ol>
        </nav>
        <h1 class="fw-bold mb-1" style="font-size: 1.6rem;">${listing.cropName} — ${listing.variety}</h1>
        <p class="mb-0" style="opacity: 0.8; font-size: 0.9rem;">
            <i class="bi bi-geo-alt me-1"></i>${listing.district}
        </p>
    </div>
</div>

<div class="container pb-5" style="margin-top: -1.5rem; position: relative; z-index: 1;">
    <div class="row g-4">

        <!-- LEFT: Listing Info -->
        <div class="col-lg-7">

            <!-- Price Block -->
            <div class="price-display mb-4">
                <div class="row text-center">
                    <div class="col-6 border-end border-white-50">
                        <div class="label">Asking Price</div>
                        <div class="amount">₹${listing.askingPricePerKg}</div>
                        <div class="unit">per kg</div>
                    </div>
                    <div class="col-6">
                        <div class="label">MSP Price</div>
                        <div class="amount">₹${not empty listing.mspPricePerKg ? listing.mspPricePerKg : 'N/A'}</div>
                        <div class="unit">per kg</div>
                    </div>
                </div>
            </div>

            <!-- Details -->
            <div class="info-card mb-4">
                <div class="card-header-custom">
                    <h6 class="fw-bold mb-0 text-success"><i class="bi bi-box-seam me-2"></i>Produce Details</h6>
                </div>
                <div class="card-body">
                    <div class="detail-row">
                        <span class="label">Crop</span>
                        <span class="value">${listing.cropName}</span>
                    </div>
                    <div class="detail-row">
                        <span class="label">Variety</span>
                        <span class="value">${listing.variety}</span>
                    </div>
                    <div class="detail-row">
                        <span class="label">Available Quantity</span>
                        <span class="value">${listing.quantityKg} kg</span>
                    </div>
                    <div class="detail-row">
                        <span class="label">Available From</span>
                        <span class="value">${listing.availableFrom}</span>
                    </div>
                    <div class="detail-row">
                        <span class="label">Listing Status</span>
                        <span class="value"><span class="badge bg-primary">${listing.status}</span></span>
                    </div>
                </div>
            </div>

            <!-- Farmer Info -->
            <div class="info-card">
                <div class="card-header-custom">
                    <h6 class="fw-bold mb-0 text-success"><i class="bi bi-person-check me-2"></i>Farmer Information</h6>
                </div>
                <div class="card-body">
                    <div class="farmer-badge">
                        <div class="farmer-avatar">🧑‍🌾</div>
                        <div>
                            <div class="fw-bold text-dark">${listing.farmer.user.name}</div>
                            <div class="text-muted" style="font-size: 0.8rem;">
                                <i class="bi bi-geo-alt me-1"></i>${listing.farmer.village}, ${listing.farmer.district}
                            </div>
                            <div class="mt-1">
                                <span class="badge" style="background: #dcfce7; color: #15803d;">Score: ${listing.farmer.farmerScore}/100</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- RIGHT: Bidding -->
        <div class="col-lg-5">
            <div class="bid-card sticky-top" style="top: 1rem;">
                <div class="bid-card-header">
                    <h6 class="fw-bold mb-0"><i class="bi bi-hammer me-2"></i>Place Your Bid</h6>
                    <small style="opacity: 0.8;">Bids are anonymous to other buyers</small>
                </div>
                <div class="bid-card-body">
                    <!-- Bid Form -->
                    <form class="bid-form" id="bidForm" onsubmit="submitBid(event)">
                        <div class="mb-3">
                            <label class="form-label fw-semibold" style="font-size: 0.8rem; color: #4a5568; text-transform: uppercase; letter-spacing: 0.5px;">
                                Your Bid Price (₹/kg)
                            </label>
                            <input type="number" class="form-control" id="bidAmount" name="bidAmount"
                                   placeholder="e.g. 24.50" min="1" step="0.50" required>
                            <div class="form-text text-muted" style="font-size: 0.75rem;">
                                Current asking price: ₹${listing.askingPricePerKg}/kg
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold" style="font-size: 0.8rem; color: #4a5568; text-transform: uppercase; letter-spacing: 0.5px;">
                                Quantity Required (kg)
                            </label>
                            <input type="number" class="form-control" id="bidQuantity" name="quantityKg" 
                                   placeholder="e.g. 500" min="1" max="${listing.quantityKg}" required>
                            <div class="form-text text-muted" style="font-size: 0.75rem;">
                                Max available: ${listing.quantityKg} kg
                            </div>
                        </div>
                        <button type="submit" class="btn-bid-submit" id="bidBtn">
                            <i class="bi bi-hammer me-2"></i>Submit Bid
                        </button>
                    </form>

                    <div class="text-center mt-3">
                        <small class="text-muted">
                            <i class="bi bi-shield-lock me-1"></i>
                            Your bid is confidential. Farmers only see aggregate stats.
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function submitBid(e) {
        e.preventDefault();
        const btn = document.getElementById('bidBtn');
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Placing bid...';
        btn.disabled = true;

        const price = document.getElementById('bidAmount').value;
        const quantity = document.getElementById('bidQuantity').value;
        
        fetch('${pageContext.request.contextPath}/api/v1/bids', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ 
                listingId: ${listing.id}, 
                bidPricePerKg: parseFloat(price),
                quantityKg: parseFloat(quantity),
                message: 'Bid placed via marketplace'
            })
        }).then(res => res.json())
          .then(data => {
              if (data && data.success) {
                  btn.innerHTML = '<i class="bi bi-check-lg me-2"></i>Bid Placed!';
                  btn.style.background = 'linear-gradient(135deg, #10b981, #059669)';
                  setTimeout(() => {
                      window.location.href = '${pageContext.request.contextPath}/web/dashboard/buyer/bids';
                  }, 1500);
              } else {
                  btn.innerHTML = '<i class="bi bi-hammer me-2"></i>Submit Bid';
                  btn.disabled = false;
                  alert(data.message || 'Could not place bid. Please ensure you are logged in as a Buyer.');
              }
          }).catch(() => {
              btn.innerHTML = '<i class="bi bi-hammer me-2"></i>Submit Bid';
              btn.disabled = false;
              alert('Network error. Please try again.');
          });
    }
</script>
<jsp:include page="fragments/footer.jsp" />
</body>
</html>
