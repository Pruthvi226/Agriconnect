<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trade Desk | AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
</head>
<body class="bg-light">

<jsp:include page="fragments/farmer-nav.jsp">
    <jsp:param name="active" value="bookings" />
</jsp:include>

<div class="container py-4 pb-5">
    
    <!-- HEADER -->
    <div class="mb-4 px-2">
        <h1 class="h3 fw-800 mb-1">Trade Desk</h1>
        <p class="text-muted">Manage your bookings and negotiate deals (सौदा पक्का करें)</p>
    </div>

    <!-- TABS -->
    <ul class="nav nav-pills nav-fill bg-white p-2 rounded-4 shadow-sm mb-4" id="tradeTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active rounded-4 fw-bold" id="bids-tab" data-bs-toggle="tab" data-bs-target="#bids" type="button" role="tab">
                New Bids (${pendingBookingCount})
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link rounded-4 fw-bold" id="orders-tab" data-bs-toggle="tab" data-bs-target="#orders" type="button" role="tab">
                Active Orders (${activeOrderCount})
            </button>
        </li>
    </ul>

    <div class="tab-content" id="tradeTabsContent">
        <!-- TAB 1: NEW BIDS -->
        <div class="tab-pane fade show active" id="bids" role="tabpanel">
            <c:choose>
                <c:when test="${not empty pendingBookings}">
                    <div class="row g-3">
                        <c:forEach var="bid" items="${pendingBookings}">
                            <div class="col-12">
                                <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-2">
                                    <div class="card-body p-4">
                                        <div class="row align-items-center">
                                            <div class="col-12 col-md-4 mb-3 mb-md-0 border-end-md">
                                                <div class="badge bg-light text-dark border mb-2 rounded-pill px-3">${bid.listing.cropName}</div>
                                                <div class="h4 fw-800 mb-0">₹${bid.bidPricePerKg}/kg</div>
                                                <div class="text-muted small">Buyer offered for ${bid.quantityKg} kg</div>
                                            </div>
                                            <div class="col-12 col-md-4 mb-3 mb-md-0">
                                                <div class="d-flex align-items-center mb-2">
                                                    <i class="bi bi-building text-primary me-2"></i>
                                                    <span class="fw-bold">${bid.buyer.companyName}</span>
                                                </div>
                                                <div class="small text-muted"><i class="bi bi-telephone me-1"></i>${not empty bid.buyer.user.phone ? bid.buyer.user.phone : 'Contact pending'}</div>
                                            </div>
                                            <div class="col-12 col-md-4">
                                                <div class="d-grid gap-2">
                                                    <form action="${pageContext.request.contextPath}/web/farmer/bids/${bid.id}/accept" method="post">
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                        <button type="submit" class="btn btn-success w-100 py-2 fw-bold">Accept Deal</button>
                                                    </form>
                                                    <div class="d-flex gap-2">
                                                        <button class="btn btn-outline-primary flex-grow-1 fw-bold" onclick="openCounterModal(${bid.id}, ${bid.bidPricePerKg}, '${bid.listing.cropName}')">
                                                            Counter
                                                        </button>
                                                        <form action="${pageContext.request.contextPath}/web/farmer/bids/${bid.id}/reject" method="post" class="flex-grow-1">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                            <button type="submit" class="btn btn-outline-danger w-100 fw-bold">Reject</button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="bg-white rounded-4 p-5 text-center shadow-sm">
                        <i class="bi bi-inbox fs-1 text-muted opacity-25"></i>
                        <p class="mt-3 fw-bold">No new bids right now.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- TAB 2: ACTIVE ORDERS (Part 2: PAGE 3) -->
        <div class="tab-pane fade" id="orders" role="tabpanel">
            <c:choose>
                <c:when test="${not empty farmerOrders}">
                    <div class="row g-3">
                        <c:forEach var="order" items="${farmerOrders}">
                            <div class="col-12">
                                <div class="card border-0 shadow-sm rounded-4 mb-3 p-4">
                                    <div class="d-flex justify-content-between align-items-start mb-4">
                                        <div>
                                            <h3 class="h5 fw-800 mb-1">${order.bid.listing.cropName} (${order.quantityKg} kg)</h3>
                                            <div class="text-muted small">Order #${order.id} · Buyer: ${order.buyer.companyName}</div>
                                        </div>
                                        <span class="badge ${order.orderStatus == 'DELIVERED' ? 'bg-success' : 'bg-primary'} rounded-pill px-3">
                                            ${order.orderStatus}
                                        </span>
                                    </div>

                                    <!-- PROGRESS TRACKER (Rule 6) -->
                                    <div class="order-progress-container mb-4">
                                        <div class="d-flex justify-content-between position-relative">
                                            <div class="text-center" style="width: 33.33%;">
                                                <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center mx-auto mb-1" style="width: 24px; height: 24px;"><i class="bi bi-check small"></i></div>
                                                <small class="fw-bold">Confirmed</small>
                                            </div>
                                            <div class="text-center" style="width: 33.33%;">
                                                <div class="${order.orderStatus == 'IN_TRANSIT' || order.orderStatus == 'DELIVERED' ? 'bg-success' : 'bg-secondary'} text-white rounded-circle d-flex align-items-center justify-content-center mx-auto mb-1" style="width: 24px; height: 24px;">
                                                    <c:if test="${order.orderStatus == 'IN_TRANSIT' || order.orderStatus == 'DELIVERED'}"><i class="bi bi-check small"></i></c:if>
                                                </div>
                                                <small class="${order.orderStatus == 'IN_TRANSIT' || order.orderStatus == 'DELIVERED' ? 'fw-bold' : ''}">In Transit</small>
                                            </div>
                                            <div class="text-center" style="width: 33.33%;">
                                                <div class="${order.orderStatus == 'DELIVERED' ? 'bg-success' : 'bg-secondary'} text-white rounded-circle d-flex align-items-center justify-content-center mx-auto mb-1" style="width: 24px; height: 24px;">
                                                    <c:if test="${order.orderStatus == 'DELIVERED'}"><i class="bi bi-check small"></i></c:if>
                                                </div>
                                                <small class="${order.orderStatus == 'DELIVERED' ? 'fw-bold' : ''}">Delivered</small>
                                            </div>
                                            <div class="progress position-absolute top-50 start-0 w-100 translate-middle-y" style="height: 2px; z-index: -1;">
                                                <div class="progress-bar bg-success" style="width: ${order.orderStatus == 'DELIVERED' ? '100%' : (order.orderStatus == 'IN_TRANSIT' ? '50%' : '0%')}"></div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="d-flex gap-2">
                                        <c:if test="${order.orderStatus == 'CONFIRMED'}">
                                            <form action="${pageContext.request.contextPath}/web/farmer/orders/${order.id}/status" method="post" class="flex-grow-1">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                <input type="hidden" name="action" value="IN_TRANSIT">
                                                <button type="submit" class="btn btn-primary w-100 fw-bold">Start Delivery</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${order.orderStatus == 'IN_TRANSIT'}">
                                            <form action="${pageContext.request.contextPath}/web/farmer/orders/${order.id}/status" method="post" class="flex-grow-1">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                <input type="hidden" name="action" value="DELIVERED">
                                                <button type="submit" class="btn btn-success w-100 fw-bold">Mark Delivered</button>
                                            </form>
                                        </c:if>
                                        <button class="btn btn-outline-secondary px-3"><i class="bi bi-telephone"></i></button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="bg-white rounded-4 p-5 text-center shadow-sm">
                        <i class="bi bi-truck fs-1 text-muted opacity-25"></i>
                        <p class="mt-3 fw-bold">No active orders right now.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- FEATURE 3: COUNTER MODAL -->
<div class="modal fade" id="counterModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-4 shadow">
            <div class="modal-header bg-primary text-white border-0 p-4">
                <h5 class="modal-title fw-800" id="counterTitle">Negotiate Price</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <form id="counterForm" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <div class="mb-3">
                        <label class="form-label fw-bold">Buyer Offered</label>
                        <div class="h4 fw-800 text-muted" id="offeredPriceLabel">₹25.00</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold text-primary">Your Counter Price (पर केजी कीमत)</label>
                        <div class="input-group input-group-lg">
                            <span class="input-group-text">₹</span>
                            <input type="number" class="form-control" name="counterPrice" id="counterPriceInput" step="0.5" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold small">Message to Buyer (Optional)</label>
                        <textarea class="form-control" name="counterMessage" rows="2" placeholder="e.g. My quality is Grade A, can't go lower than this."></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary btn-lg w-100 rounded-3 fw-bold">Send Counter Offer</button>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const counterModal = new bootstrap.Modal(document.getElementById('counterModal'));
    
    function openCounterModal(bidId, offeredPrice, cropName) {
        document.getElementById('counterTitle').innerText = 'Negotiate Price for ' + cropName;
        document.getElementById('offeredPriceLabel').innerText = '₹' + offeredPrice.toFixed(2);
        document.getElementById('counterPriceInput').value = offeredPrice + 1; // Default suggest +1
        document.getElementById('counterForm').action = '${pageContext.request.contextPath}/web/farmer/bids/' + bidId + '/counter';
        counterModal.show();
    }
</script>

</body>
</html>
