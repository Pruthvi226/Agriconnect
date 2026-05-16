<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders | Buyer Portal - AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
    <style>
        .order-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            margin-bottom: 1.5rem;
            overflow: hidden;
        }
        .order-header {
            background: #f8fafc;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #f1f5f9;
        }
        .order-body { padding: 1.5rem; }
        .order-status-badge {
            font-size: 0.7rem;
            font-weight: 800;
            padding: 0.35rem 0.75rem;
            border-radius: 8px;
            text-transform: uppercase;
        }
        .status-confirmed { background: #e0f2fe; color: #0369a1; }
        .status-in_transit { background: #fef3c7; color: #92400e; }
        .status-delivered { background: #dcfce7; color: #166534; }
        .status-cancelled { background: #fee2e2; color: #991b1b; }
    </style>
</head>
<body class="bg-light">

<jsp:include page="fragments/navbar-selector.jsp">
    <jsp:param name="active" value="orders" />
</jsp:include>

<div class="container py-5">
    <div class="mb-4">
        <h1 class="h3 fw-800 mb-1">My Procurement Orders</h1>
        <p class="text-muted">Manage your active shipments and historical purchases.</p>
    </div>

    <c:choose>
        <c:when test="${not empty orders}">
            <div class="row">
                <div class="col-12">
                    <c:forEach var="order" items="${orders}">
                        <div class="card order-card">
                            <div class="order-header d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="text-muted small">ORDER ID:</span>
                                    <span class="fw-bold text-dark ms-1">#AC-${order.id}00${order.id}</span>
                                </div>
                                <span class="order-status-badge status-${order.orderStatus.name().toLowerCase()}">
                                    ${order.orderStatus}
                                </span>
                            </div>
                            <div class="order-body">
                                <div class="row align-items-center">
                                    <div class="col-md-4">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="bg-primary bg-opacity-10 p-3 rounded-4">
                                                <i class="bi bi-box-seam fs-3 text-primary"></i>
                                            </div>
                                            <div>
                                                <h5 class="fw-bold mb-0">${order.bid.listing.cropName}</h5>
                                                <p class="text-muted small mb-0">${order.bid.listing.variety}</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="small text-muted">Farmer</div>
                                        <div class="fw-bold">${order.farmer.user.name}</div>
                                        <div class="small text-muted">${order.farmer.district}</div>
                                    </div>
                                    <div class="col-md-2 text-center text-md-start mt-3 mt-md-0">
                                        <div class="small text-muted">Amount</div>
                                        <div class="fw-800 text-success fs-5">₹<fmt:formatNumber value="${order.totalAmount}" /></div>
                                        <div class="small text-muted">${order.quantityKg} kg</div>
                                    </div>
                                    <div class="col-md-3 text-md-end mt-3 mt-md-0">
                                        <c:if test="${order.orderStatus == 'IN_TRANSIT'}">
                                            <form action="${pageContext.request.contextPath}/api/v1/bids/orders/${order.id}/delivery/DELIVERED" method="post">
                                                <button type="submit" class="btn btn-success btn-sm w-100 rounded-3">
                                                    Mark as Received
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${order.orderStatus == 'DELIVERED'}">
                                            <div class="text-success small fw-bold">
                                                <i class="bi bi-check-circle-fill me-1"></i> Delivered on <fmt:formatDate value="${order.actualDelivery}" pattern="MMM dd" />
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="bg-white rounded-5 p-5 text-center shadow-sm">
                <div class="display-1 text-muted opacity-25 mb-3"><i class="bi bi-truck"></i></div>
                <h4 class="fw-bold">No orders found</h4>
                <p class="text-muted">You haven't made any purchases yet. Your orders will appear here once bids are accepted.</p>
                <a href="${pageContext.request.contextPath}/web/marketplace" class="btn btn-primary-custom mt-2 px-4">
                    Find Produce
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="fragments/footer.jsp" />
</body>
</html>
