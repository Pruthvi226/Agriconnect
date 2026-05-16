<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bids | Buyer Portal - AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
    <style>
        .bid-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: transform 0.2s;
            overflow: hidden;
        }
        .bid-card:hover { transform: translateY(-3px); }
        .status-badge {
            font-size: 0.75rem;
            font-weight: 700;
            padding: 0.4rem 0.8rem;
            border-radius: 10px;
            text-transform: uppercase;
        }
        .status-pending { background: #fffbeb; color: #b45309; }
        .status-accepted { background: #f0fdf4; color: #15803d; }
        .status-rejected { background: #fef2f2; color: #b91c1c; }
        .status-counter { background: #eff6ff; color: #1d4ed8; }
    </style>
</head>
<body class="bg-light">

<jsp:include page="fragments/navbar-selector.jsp">
    <jsp:param name="active" value="bids" />
</jsp:include>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h3 fw-800 mb-1">My Active Bids</h1>
            <p class="text-muted">Track all your submitted offers and counter-proposals.</p>
        </div>
        <a href="${pageContext.request.contextPath}/web/marketplace" class="btn btn-primary-custom">
            <i class="bi bi-plus-circle me-1"></i> Place New Bid
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty bids}">
            <div class="row g-4">
                <c:forEach var="bid" items="${bids}">
                    <div class="col-md-6 col-lg-4">
                        <div class="card bid-card h-100">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <span class="status-badge status-${bid.bidStatus.name().toLowerCase()}">
                                        ${bid.bidStatus}
                                    </span>
                                    <small class="text-muted"><i class="bi bi-clock me-1"></i> 
                                        <fmt:formatDate value="${bid.createdAt}" pattern="MMM dd, HH:mm" />
                                    </small>
                                </div>
                                <h5 class="fw-bold mb-1">${bid.listing.cropName}</h5>
                                <p class="text-muted small mb-3"><i class="bi bi-geo-alt me-1"></i>${bid.listing.district}</p>
                                
                                <div class="bg-light rounded-4 p-3 mb-3">
                                    <div class="row text-center">
                                        <div class="col-6 border-end">
                                            <div class="small text-muted mb-1">Your Bid</div>
                                            <div class="fw-800 text-dark">₹${bid.bidPricePerKg}/kg</div>
                                        </div>
                                        <div class="col-6">
                                            <div class="small text-muted mb-1">Quantity</div>
                                            <div class="fw-800 text-dark">${bid.quantityKg} kg</div>
                                        </div>
                                    </div>
                                </div>

                                <c:if test="${bid.bidStatus == 'COUNTER_OFFER'}">
                                    <div class="alert alert-info border-0 rounded-4 small mb-3">
                                        <strong>Farmer's Counter:</strong> ₹${bid.counterPricePerKg}/kg
                                        <br/>
                                        <em class="text-muted">"${bid.counterMessage}"</em>
                                    </div>
                                </c:if>

                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/web/marketplace/listing/${bid.listing.id}" class="btn btn-outline-secondary w-100 btn-sm">
                                        View Listing
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="bg-white rounded-5 p-5 text-center shadow-sm">
                <div class="display-1 text-muted opacity-25 mb-3"><i class="bi bi-hammer"></i></div>
                <h4 class="fw-bold">No active bids found</h4>
                <p class="text-muted">You haven't placed any bids yet. Explore the marketplace to find fresh produce!</p>
                <a href="${pageContext.request.contextPath}/web/marketplace" class="btn btn-primary-custom mt-2 px-4">
                    Explore Marketplace
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="fragments/footer.jsp" />
</body>
</html>
