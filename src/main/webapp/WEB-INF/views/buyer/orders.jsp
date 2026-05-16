<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Buyer Orders - AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="../fragments/buyer-nav.jsp">
    <jsp:param name="active" value="orders" />
</jsp:include>

<main class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h1 class="h4 fw-bold mb-1">Orders</h1>
            <p class="text-muted mb-0">Track accepted bids, delivery status, and receipts.</p>
        </div>
        <a href="${pageContext.request.contextPath}/web/marketplace" class="btn btn-success">
            <i class="bi bi-shop me-1"></i>Browse Market
        </a>
    </div>

    <c:if test="${not empty msg}">
        <div class="alert alert-success border-0 shadow-sm">${msg}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger border-0 shadow-sm">${error}</div>
    </c:if>

    <c:choose>
        <c:when test="${not empty orders}">
            <div class="table-responsive bg-white rounded-4 shadow-sm border">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Crop</th>
                        <th>Farmer</th>
                        <th>Quantity</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Payment</th>
                        <th class="text-end">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td>
                                <div class="fw-bold">${order.bid.listing.cropName}</div>
                                <div class="small text-muted">${order.bid.listing.variety}</div>
                            </td>
                            <td>${order.farmer.user.name}</td>
                            <td>${order.quantityKg} kg</td>
                            <td>Rs ${order.totalAmount}</td>
                            <td><span class="badge text-bg-primary">${order.orderStatus}</span></td>
                            <td><span class="badge text-bg-light">${order.paymentStatus}</span></td>
                            <td class="text-end">
                                <div class="d-flex flex-wrap gap-2 justify-content-end">
                                    <a href="${pageContext.request.contextPath}/web/buyer/orders/${order.id}/receipt" class="btn btn-sm btn-outline-secondary">
                                        <i class="bi bi-receipt me-1"></i>Receipt
                                    </a>
                                    <c:if test="${order.orderStatus != 'DELIVERED' && order.orderStatus != 'CANCELLED'}">
                                        <form action="${pageContext.request.contextPath}/web/buyer/orders/${order.id}/confirm-delivery" method="post">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button type="submit" class="btn btn-sm btn-success">
                                                <i class="bi bi-check2-circle me-1"></i>Confirm Delivery
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <div class="bg-white rounded-4 shadow-sm border p-5 text-center">
                <div class="display-5 mb-3"><i class="bi bi-truck"></i></div>
                <h2 class="h5 fw-bold">No orders yet</h2>
                <p class="text-muted">Accepted bids will show up here.</p>
            </div>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
