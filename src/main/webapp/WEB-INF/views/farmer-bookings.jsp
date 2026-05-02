<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bookings - AgriConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body>
<jsp:include page="fragments/farmer-nav.jsp">
    <jsp:param name="active" value="bookings" />
</jsp:include>

<section class="farmer-hero compact-hero">
    <div class="container">
        <span class="farmer-chip"><i class="bi bi-clipboard2-check"></i> Booking Desk</span>
        <h1>Manage buyer requests and delivery</h1>
        <p>Accept only the requested quantity you can fulfill, then update delivery status clearly.</p>
    </div>
</section>

<main class="container farmer-page-shell">
    <div class="dashboard-metrics mb-3">
        <div class="metric-tile">
            <span class="metric-icon amber"><i class="bi bi-hourglass-split"></i></span>
            <span><strong>${pendingBookingCount}</strong><small>Pending quantity requests</small></span>
        </div>
        <div class="metric-tile">
            <span class="metric-icon blue"><i class="bi bi-truck"></i></span>
            <span><strong>${activeOrderCount}</strong><small>Active delivery orders</small></span>
        </div>
        <a class="metric-tile" href="${pageContext.request.contextPath}/web/dashboard/farmer/listings">
            <span class="metric-icon green"><i class="bi bi-plus-circle"></i></span>
            <span><strong>Add</strong><small>Create more listings</small></span>
        </a>
    </div>

    <div id="bookingActionStatus" class="form-status mb-3"></div>

    <div class="row g-3">
        <div class="col-lg-7">
            <section class="workspace-panel h-100">
                <div class="panel-title">
                    <div>
                        <h2>Quantity Requests</h2>
                        <div class="text-muted small">Accepting creates an order and reserves quantity from the listing.</div>
                    </div>
                    <span class="booking-count"><i class="bi bi-hourglass"></i>${pendingBookingCount} waiting</span>
                </div>
                <c:choose>
                    <c:when test="${not empty pendingBookings}">
                        <div class="booking-list">
                            <c:forEach var="booking" items="${pendingBookings}">
                                <article class="booking-card">
                                    <div class="booking-main">
                                        <div>
                                            <h3>${booking.listing.cropName} <span>${booking.listing.variety}</span></h3>
                                            <div class="booking-meta">
                                                <span><i class="bi bi-building"></i>${booking.buyer.companyName}</span>
                                                <span><i class="bi bi-box-seam"></i><fmt:formatNumber value="${booking.quantityKg}" maxFractionDigits="0" /> kg requested</span>
                                                <span><i class="bi bi-currency-rupee"></i>${booking.bidPricePerKg}/kg</span>
                                            </div>
                                        </div>
                                        <div class="booking-amount">
                                            <span>Value</span>
                                            <strong>Rs <fmt:formatNumber value="${booking.bidPricePerKg * booking.quantityKg}" maxFractionDigits="0" /></strong>
                                        </div>
                                    </div>
                                    <c:if test="${not empty booking.message}">
                                        <p class="booking-note">${booking.message}</p>
                                    </c:if>
                                    <div class="fulfillment-strip">
                                        <span><i class="bi bi-check2-circle"></i>Stock left: <fmt:formatNumber value="${booking.listing.quantityKg}" maxFractionDigits="0" /> kg</span>
                                        <span><i class="bi bi-calendar-event"></i>Available until ${booking.listing.availableUntil}</span>
                                        <span><i class="bi bi-award"></i>Grade ${booking.listing.qualityGrade}</span>
                                    </div>
                                    <div class="booking-actions">
                                        <button type="button" class="btn btn-success btn-sm" onclick="handleBooking(${booking.id}, 'accept', this)">
                                            <i class="bi bi-check-lg me-1"></i>Accept
                                        </button>
                                        <button type="button" class="btn btn-outline-danger btn-sm" onclick="handleBooking(${booking.id}, 'reject', this)">
                                            <i class="bi bi-x-lg me-1"></i>Reject
                                        </button>
                                        <a class="btn btn-outline-success btn-sm" href="${pageContext.request.contextPath}/web/marketplace/listing/${booking.listing.id}">
                                            <i class="bi bi-eye me-1"></i>Open Listing
                                        </a>
                                    </div>
                                </article>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-bookings">
                            <i class="bi bi-inbox"></i>
                            <strong>No pending requests</strong>
                            <span>When buyers request quantity from your listings, requests will appear here.</span>
                            <a class="btn btn-success mt-2" href="${pageContext.request.contextPath}/web/dashboard/farmer/listings">Add Listing</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>

        <div class="col-lg-5">
            <section class="workspace-panel h-100">
                <div class="panel-title">
                    <div>
                        <h2>Orders & Delivery</h2>
                        <div class="text-muted small">Update buyers as soon as delivery ability changes.</div>
                    </div>
                </div>
                <c:choose>
                    <c:when test="${not empty farmerOrders}">
                        <div class="booking-list compact">
                            <c:forEach var="order" items="${farmerOrders}">
                                <article class="booking-card order-card">
                                    <div class="d-flex justify-content-between gap-3 align-items-start">
                                        <div>
                                            <h3>${order.bid.listing.cropName} <span>${order.bid.listing.variety}</span></h3>
                                            <div class="booking-meta">
                                                <span><i class="bi bi-box-seam"></i><fmt:formatNumber value="${order.quantityKg}" maxFractionDigits="0" /> kg</span>
                                                <span><i class="bi bi-currency-rupee"></i><fmt:formatNumber value="${order.totalAmount}" maxFractionDigits="0" /></span>
                                            </div>
                                        </div>
                                        <span class="status-badge ${order.orderStatus == 'DELIVERED' ? 'done' : order.orderStatus == 'CANCELLED' ? 'danger' : 'live'}">${order.orderStatus}</span>
                                    </div>
                                    <div class="delivery-rail">
                                        <span class="${order.orderStatus == 'CONFIRMED' || order.orderStatus == 'IN_TRANSIT' || order.orderStatus == 'DELIVERED' ? 'on' : ''}">Confirmed</span>
                                        <span class="${order.orderStatus == 'IN_TRANSIT' || order.orderStatus == 'DELIVERED' ? 'on' : ''}">Can deliver</span>
                                        <span class="${order.orderStatus == 'DELIVERED' ? 'on' : ''}">Delivered</span>
                                    </div>
                                    <div class="booking-actions">
                                        <button type="button" class="btn btn-outline-success btn-sm" onclick="updateDelivery(${order.id}, 'can_deliver', this)">
                                            <i class="bi bi-truck me-1"></i>Can Deliver
                                        </button>
                                        <button type="button" class="btn btn-success btn-sm" onclick="updateDelivery(${order.id}, 'delivered', this)">
                                            <i class="bi bi-check2-all me-1"></i>Delivered
                                        </button>
                                        <button type="button" class="btn btn-outline-danger btn-sm" onclick="updateDelivery(${order.id}, 'cannot_deliver', this)">
                                            <i class="bi bi-slash-circle me-1"></i>Cannot
                                        </button>
                                    </div>
                                </article>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-bookings">
                            <i class="bi bi-truck"></i>
                            <strong>No orders yet</strong>
                            <span>Accepted booking requests become delivery orders here.</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function showBookingStatus(type, message) {
        const status = document.getElementById('bookingActionStatus');
        status.className = 'form-status mb-3 ' + type;
        status.innerText = message;
    }

    function runBookingAction(url, button, loadingText, successText) {
        const original = button ? button.innerHTML : '';
        if (button) {
            button.disabled = true;
            button.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>' + loadingText;
        }

        fetch(url, { method: 'PUT', headers: { 'Content-Type': 'application/json' } })
            .then(async response => {
                const data = await response.json().catch(() => ({}));
                if (!response.ok || data.success === false) {
                    throw new Error(data.message || 'Could not update booking.');
                }
                showBookingStatus('success', successText);
                setTimeout(() => window.location.reload(), 700);
            })
            .catch(error => {
                showBookingStatus('error', error.message);
                if (button) {
                    button.disabled = false;
                    button.innerHTML = original;
                }
            });
    }

    function handleBooking(id, action, button) {
        const label = action === 'accept' ? 'Accepting...' : 'Rejecting...';
        const done = action === 'accept'
            ? 'Booking accepted. Quantity was reserved and an order was created.'
            : 'Booking rejected. Buyer has been notified.';
        runBookingAction('${pageContext.request.contextPath}/api/v1/bids/' + id + '/' + action, button, label, done);
    }

    function updateDelivery(id, action, button) {
        const labels = { can_deliver: 'Updating...', delivered: 'Closing...', cannot_deliver: 'Cancelling...' };
        const messages = {
            can_deliver: 'Marked as can deliver. Buyer has been updated.',
            delivered: 'Order marked delivered and payment moved to paid.',
            cannot_deliver: 'Order cancelled as cannot deliver. Buyer has been updated.'
        };
        runBookingAction('${pageContext.request.contextPath}/api/v1/bids/orders/' + id + '/delivery/' + action,
            button,
            labels[action] || 'Updating...',
            messages[action] || 'Delivery updated.');
    }
</script>
</body>
</html>
