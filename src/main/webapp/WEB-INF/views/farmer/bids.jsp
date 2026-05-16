<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Farmer Bids</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/agriconnect.css" rel="stylesheet">
</head>
<body>
<jsp:include page="../common/layout.jsp" />
<main class="container py-4">
    <h1 class="h4 mb-3">Bids Received</h1>
    <table class="table table-hover align-middle">
        <thead><tr><th>Listing</th><th>Buyer</th><th>Price</th><th>Quantity</th><th>Status</th><th></th></tr></thead>
        <tbody>
        <c:forEach var="bid" items="${bids}">
            <tr>
                <td>${bid.listing.cropName}</td>
                <td>${bid.buyer.companyName}</td>
                <td>${bid.bidPricePerKg}</td>
                <td>${bid.quantityKg}</td>
                <td><span class="badge bg-secondary">${bid.bidStatus}</span></td>
                <td class="text-end">
                    <form action="${pageContext.request.contextPath}/farmer/bids/${bid.id}/accept" method="post" class="d-inline">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button class="btn btn-sm btn-success">Accept</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/farmer/bids/${bid.id}/reject" method="post" class="d-inline">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button class="btn btn-sm btn-outline-danger">Reject</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</main>
</body>
</html>
