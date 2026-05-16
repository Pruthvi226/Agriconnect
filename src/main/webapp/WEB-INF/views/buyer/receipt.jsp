<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Order Receipt - AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="../fragments/buyer-nav.jsp">
    <jsp:param name="active" value="orders" />
</jsp:include>

<main class="container py-4" style="max-width: 760px;">
    <a href="${pageContext.request.contextPath}/web/buyer/orders" class="btn btn-link px-0 mb-3">
        <i class="bi bi-arrow-left me-1"></i>Back to orders
    </a>
    <section class="bg-white border rounded-4 shadow-sm p-4">
        <div class="d-flex justify-content-between align-items-start border-bottom pb-3 mb-3">
            <div>
                <h1 class="h4 fw-bold mb-1">Order Receipt</h1>
                <div class="text-muted">Receipt #AGRI-${order.id}</div>
            </div>
            <span class="badge text-bg-success">${order.orderStatus}</span>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-6">
                <div class="text-muted small">Crop</div>
                <div class="fw-bold">${order.bid.listing.cropName} ${order.bid.listing.variety}</div>
            </div>
            <div class="col-md-6">
                <div class="text-muted small">Farmer</div>
                <div class="fw-bold">${order.farmer.user.name}</div>
            </div>
            <div class="col-md-6">
                <div class="text-muted small">Expected Delivery</div>
                <div class="fw-bold">${order.expectedDelivery}</div>
            </div>
            <div class="col-md-6">
                <div class="text-muted small">Actual Delivery</div>
                <div class="fw-bold">${empty order.actualDelivery ? 'Pending' : order.actualDelivery}</div>
            </div>
        </div>

        <table class="table">
            <tbody>
            <tr>
                <td>Quantity</td>
                <td class="text-end">${order.quantityKg} kg</td>
            </tr>
            <tr>
                <td>Final price</td>
                <td class="text-end">Rs ${order.finalPricePerKg} / kg</td>
            </tr>
            <tr class="table-light">
                <th>Total Amount</th>
                <th class="text-end">Rs ${order.totalAmount}</th>
            </tr>
            <tr>
                <td>Payment Status</td>
                <td class="text-end">${order.paymentStatus}</td>
            </tr>
            </tbody>
        </table>
    </section>
</main>
</body>
</html>
