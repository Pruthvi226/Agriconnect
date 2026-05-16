<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Buyer Bids - AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="../fragments/buyer-nav.jsp">
    <jsp:param name="active" value="bids" />
</jsp:include>

<main class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h1 class="h4 fw-bold mb-1">My Bids</h1>
            <p class="text-muted mb-0">Review bid status and accept farmer counter offers.</p>
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
        <c:when test="${not empty bids}">
            <div class="table-responsive bg-white rounded-4 shadow-sm border">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Crop</th>
                        <th>Your Price</th>
                        <th>Quantity</th>
                        <th>Counter Offer</th>
                        <th>Status</th>
                        <th class="text-end">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="bid" items="${bids}">
                        <tr>
                            <td>
                                <div class="fw-bold">${bid.listing.cropName}</div>
                                <div class="small text-muted">${bid.listing.district}</div>
                            </td>
                            <td>Rs ${bid.bidPricePerKg}/kg</td>
                            <td>${bid.quantityKg} kg</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty bid.counterPricePerKg}">
                                        <div class="fw-bold">Rs ${bid.counterPricePerKg}/kg</div>
                                        <div class="small text-muted">${bid.counterMessage}</div>
                                    </c:when>
                                    <c:otherwise><span class="text-muted">No counter</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td><span class="badge text-bg-primary">${bid.bidStatus}</span></td>
                            <td class="text-end">
                                <c:if test="${bid.bidStatus == 'COUNTERED'}">
                                    <form action="${pageContext.request.contextPath}/web/buyer/bids/${bid.id}/accept-counter" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="btn btn-sm btn-success">
                                            <i class="bi bi-check2-circle me-1"></i>Accept Counter
                                        </button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <div class="bg-white rounded-4 shadow-sm border p-5 text-center">
                <div class="display-5 mb-3"><i class="bi bi-hammer"></i></div>
                <h2 class="h5 fw-bold">No active bids</h2>
                <p class="text-muted">Place a bid from a marketplace listing.</p>
            </div>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
