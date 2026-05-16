<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Farmer Orders</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/agriconnect.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../common/layout.jsp" />
<main class="container py-4">
    <h1 class="h4 mb-3">Orders</h1>
    <table class="table table-striped align-middle">
        <thead><tr><th>Crop</th><th>Buyer</th><th>Amount</th><th>Delivery</th><th>Status</th><th>Payment</th></tr></thead>
        <tbody>
        <c:forEach var="order" items="${orders}">
            <tr>
                <td>${order.bid.listing.cropName}</td>
                <td>${order.buyer.companyName}</td>
                <td>${order.totalAmount}</td>
                <td>${order.expectedDelivery}</td>
                <td><span class="badge bg-secondary">${order.orderStatus}</span></td>
                <td>${order.paymentStatus}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</main>
</body>
</html>
