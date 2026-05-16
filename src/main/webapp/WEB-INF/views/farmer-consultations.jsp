<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expert Consultations - AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body>
<jsp:include page="fragments/farmer-nav.jsp">
    <jsp:param name="active" value="consultations" />
</jsp:include>

<div class="container py-4">
    <div id="consultationStatus" class="form-status mb-3"></div>

    <div class="workspace-panel mb-4">
        <div class="panel-title">
            <div>
                <h2>Browse Available Experts</h2>
                <div class="text-muted small">Filter by crop, district, and date to book a paid 1:1 expert session.</div>
            </div>
        </div>
        <form class="row g-3" method="get">
            <div class="col-md-3">
                <label class="form-label">Crop</label>
                <input class="form-control" type="text" name="crop" value="${selectedCrop}">
            </div>
            <div class="col-md-3">
                <label class="form-label">District</label>
                <input class="form-control" type="text" name="district" value="${selectedDistrict}">
            </div>
            <div class="col-md-3">
                <label class="form-label">Date</label>
                <input class="form-control" type="date" name="date" value="${searchDate}">
            </div>
            <div class="col-md-3 d-flex align-items-end">
                <button class="btn btn-success w-100" type="submit">Search Experts</button>
            </div>
        </form>
    </div>

    <div class="row g-3 mb-4">
        <c:forEach var="expert" items="${availableExperts}">
            <div class="col-lg-6">
                <div class="listing-card p-4 h-100">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <div class="crop-name">${expert.expertName}</div>
                            <div class="crop-variety">${expert.specialisation}</div>
                        </div>
                        <span class="badge bg-success">${expert.avgRating} / 5</span>
                    </div>
                    <div class="text-muted small mb-2">
                        <i class="bi bi-translate me-1"></i>${expert.languagesSpoken}
                    </div>
                    <div class="text-muted small mb-2">
                        <i class="bi bi-geo-alt me-1"></i>${expert.district} · ${expert.cropFocus}
                    </div>
                    <div class="text-muted small mb-3">
                        <i class="bi bi-clock me-1"></i>${searchDate} ${expert.startTime} - ${expert.endTime}
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <strong>30 min: Rs <fmt:formatNumber value="${expert.fee30min}" maxFractionDigits="0" /></strong><br>
                            <strong>60 min: Rs <fmt:formatNumber value="${expert.fee60min}" maxFractionDigits="0" /></strong>
                        </div>
                        <div class="d-flex gap-2">
                            <button class="btn btn-outline-success btn-sm" type="button"
                                    onclick="bookConsultation(${expert.expertId}, ${expert.slotId}, '${expert.cropFocus}', '${expert.district}', 30)">
                                Book 30m
                            </button>
                            <button class="btn btn-success btn-sm" type="button"
                                    onclick="bookConsultation(${expert.expertId}, ${expert.slotId}, '${expert.cropFocus}', '${expert.district}', 60)">
                                Book 60m
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty availableExperts}">
            <div class="col-12">
                <div class="empty-bookings">
                    <i class="bi bi-search"></i>
                    <strong>No expert slots match these filters</strong>
                    <span>Try a different date, crop, or district.</span>
                </div>
            </div>
        </c:if>
    </div>

    <div class="workspace-panel">
        <div class="panel-title">
            <div>
                <h2>My Consultation Bookings</h2>
                <div class="text-muted small">Track session links, payment reference, and leave reviews after completion.</div>
            </div>
        </div>
        <div class="row g-3">
            <c:forEach var="booking" items="${consultationBookings}">
                <div class="col-lg-6">
                    <div class="booking-card h-100">
                        <div class="booking-main">
                            <div>
                                <h3>${booking.cropFocus} <span>${booking.consultationStatus}</span></h3>
                                <div class="booking-meta">
                                    <span><i class="bi bi-person-badge"></i>${booking.expert.name}</span>
                                    <span><i class="bi bi-calendar-event"></i>${booking.slot.slotDate}</span>
                                    <span><i class="bi bi-clock"></i>${booking.slot.startTime}</span>
                                </div>
                            </div>
                            <div class="booking-amount">
                                <span>Paid</span>
                                <strong>Rs <fmt:formatNumber value="${booking.feeAmount}" maxFractionDigits="0" /></strong>
                            </div>
                        </div>
                        <div class="fulfillment-strip">
                            <span><i class="bi bi-credit-card"></i>${booking.razorpayOrderId}</span>
                            <span><i class="bi bi-patch-check"></i>${booking.paymentStatus}</span>
                        </div>
                        <c:if test="${not empty booking.sessionLink}">
                            <div class="booking-actions">
                                <a class="btn btn-outline-primary btn-sm" target="_blank" href="${booking.sessionLink}">Join Session</a>
                            </div>
                        </c:if>
                        <c:if test="${booking.consultationStatus == 'COMPLETED'}">
                            <div class="mt-3">
                                <label class="form-label">Rate this expert</label>
                                <div class="d-flex gap-2">
                                    <select id="rating-${booking.id}" class="form-select form-select-sm" style="max-width: 100px;">
                                        <option value="5">5</option>
                                        <option value="4">4</option>
                                        <option value="3">3</option>
                                        <option value="2">2</option>
                                        <option value="1">1</option>
                                    </select>
                                    <input id="review-${booking.id}" class="form-control form-control-sm" placeholder="Share what helped most">
                                    <button class="btn btn-success btn-sm" type="button" onclick="submitReview(${booking.id})">Submit</button>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty consultationBookings}">
                <div class="col-12">
                    <div class="empty-bookings">
                        <i class="bi bi-camera-video-off"></i>
                        <strong>No expert consultations booked yet</strong>
                        <span>Book your first session to get tailored crop advice.</span>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
    function setStatus(type, message) {
        const box = document.getElementById('consultationStatus');
        box.className = 'form-status mb-3 ' + type;
        box.textContent = message;
    }

    async function bookConsultation(expertId, slotId, crop, district, duration) {
        const response = await fetch('${pageContext.request.contextPath}/api/v1/consultations/book', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ expertId, slotId, crop, district, duration })
        });
        const data = await response.json();
        if (!response.ok || data.success === false) {
            setStatus('error', data.message || 'Unable to book consultation.');
            return;
        }
        setStatus('success', 'Consultation booked. Payment reference: ' + data.data.razorpayOrderId);
        setTimeout(() => window.location.reload(), 700);
    }

    async function submitReview(bookingId) {
        const rating = document.getElementById('rating-' + bookingId).value;
        const reviewText = document.getElementById('review-' + bookingId).value;
        const response = await fetch('${pageContext.request.contextPath}/api/v1/consultations/' + bookingId + '/review', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ rating, reviewText })
        });
        const data = await response.json();
        if (!response.ok || data.success === false) {
            setStatus('error', data.message || 'Unable to submit review.');
            return;
        }
        setStatus('success', 'Review submitted successfully.');
        setTimeout(() => window.location.reload(), 500);
    }
</script>
</body>
</html>
