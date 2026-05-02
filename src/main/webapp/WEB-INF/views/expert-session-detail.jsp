<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Session Detail - AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body>
<div class="container py-4">
    <a class="btn btn-outline-success mb-3" href="${pageContext.request.contextPath}/web/expert/dashboard">Back to Dashboard</a>

    <div id="sessionStatus" class="form-status mb-3"></div>

    <div class="workspace-panel">
        <div class="panel-title">
            <div>
                <h2>${consultation.cropFocus} Consultation</h2>
                <div class="text-muted small">${consultation.slot.slotDate} at ${consultation.slot.startTime}</div>
            </div>
            <span class="booking-count active">${consultation.consultationStatus}</span>
        </div>

        <div class="row g-4">
            <div class="col-lg-6">
                <h5>Farmer</h5>
                <p class="mb-1"><strong>${consultation.farmer.user.name}</strong></p>
                <p class="text-muted mb-1">${consultation.farmerDistrict}</p>
                <p class="text-muted mb-0">Duration: ${consultation.durationMinutes} minutes</p>
            </div>
            <div class="col-lg-6">
                <h5>Commercial</h5>
                <p class="mb-1">Fee: Rs <fmt:formatNumber value="${consultation.feeAmount}" maxFractionDigits="0" /></p>
                <p class="text-muted mb-1">Payment: ${consultation.paymentStatus}</p>
                <p class="text-muted mb-0">Razorpay order: ${consultation.razorpayOrderId}</p>
            </div>
        </div>

        <div class="mt-4">
            <label class="form-label">Google Meet Link</label>
            <div class="input-group">
                <input id="sessionLink" class="form-control" type="url" value="${consultation.sessionLink}" placeholder="https://meet.google.com/abc-defg-hij">
                <button class="btn btn-success" type="button" onclick="saveLink(${consultation.id})">Save Link</button>
            </div>
        </div>

        <div class="mt-4 d-flex gap-2">
            <c:if test="${consultation.consultationStatus == 'BOOKED'}">
                <button class="btn btn-success" type="button" onclick="completeSession(${consultation.id})">Mark Session Complete</button>
            </c:if>
            <c:if test="${not empty consultation.sessionLink}">
                <a class="btn btn-outline-primary" target="_blank" href="${consultation.sessionLink}">Open Meeting</a>
            </c:if>
        </div>
    </div>
</div>

<script>
    function setStatus(type, message) {
        const box = document.getElementById('sessionStatus');
        box.className = 'form-status mb-3 ' + type;
        box.textContent = message;
    }

    async function saveLink(id) {
        const sessionLink = document.getElementById('sessionLink').value;
        const response = await fetch('${pageContext.request.contextPath}/api/v1/consultations/' + id + '/session-link', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ sessionLink })
        });
        const data = await response.json();
        if (!response.ok || data.success === false) {
            setStatus('error', data.message || 'Unable to save session link.');
            return;
        }
        setStatus('success', 'Session link saved and farmer notified.');
        setTimeout(() => window.location.reload(), 500);
    }

    async function completeSession(id) {
        const response = await fetch('${pageContext.request.contextPath}/api/v1/consultations/' + id + '/complete', { method: 'PUT' });
        const data = await response.json();
        if (!response.ok || data.success === false) {
            setStatus('error', data.message || 'Unable to complete consultation.');
            return;
        }
        setStatus('success', 'Consultation completed and earnings credited.');
        setTimeout(() => window.location.reload(), 600);
    }
</script>
</body>
</html>
