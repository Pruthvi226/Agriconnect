<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expert Slots - AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body>
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h3 mb-1">Expert Availability Calendar</h1>
            <p class="text-muted mb-0">Publish crop-specific slots and block time that is no longer available.</p>
        </div>
        <a href="${pageContext.request.contextPath}/web/expert/dashboard" class="btn btn-outline-success">
            <i class="bi bi-arrow-left me-1"></i>Back
        </a>
    </div>

    <div id="slotStatus" class="form-status mb-3"></div>

    <div class="workspace-panel mb-4">
        <div class="panel-title">
            <div>
                <h2>Create Slot</h2>
                <div class="text-muted small">Set crop, district, and session duration window.</div>
            </div>
        </div>
        <form id="slotForm" class="row g-3">
            <div class="col-md-3">
                <label class="form-label">Date</label>
                <input class="form-control" type="date" name="slotDate" required>
            </div>
            <div class="col-md-2">
                <label class="form-label">Start</label>
                <input class="form-control" type="time" name="startTime" required>
            </div>
            <div class="col-md-2">
                <label class="form-label">End</label>
                <input class="form-control" type="time" name="endTime" required>
            </div>
            <div class="col-md-2">
                <label class="form-label">District</label>
                <input class="form-control" type="text" name="district" required>
            </div>
            <div class="col-md-3">
                <label class="form-label">Crop Focus</label>
                <input class="form-control" type="text" name="cropFocus" required>
            </div>
            <div class="col-12">
                <label class="form-label">Notes</label>
                <input class="form-control" type="text" name="notes" placeholder="Optional session note">
            </div>
            <div class="col-12">
                <button class="btn btn-success" type="submit">
                    <i class="bi bi-plus-circle me-1"></i>Publish Slot
                </button>
            </div>
        </form>
    </div>

    <div class="workspace-panel">
        <div class="panel-title">
            <div>
                <h2>Current Slots</h2>
                <div class="text-muted small">Booked slots are locked automatically when farmers reserve them.</div>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table align-middle">
                <thead>
                <tr>
                    <th>Date</th>
                    <th>Time</th>
                    <th>District</th>
                    <th>Crop</th>
                    <th>Status</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="slot" items="${slots}">
                    <tr>
                        <td>${slot.slotDate}</td>
                        <td>${slot.startTime} - ${slot.endTime}</td>
                        <td>${slot.district}</td>
                        <td>${slot.cropFocus}</td>
                        <td><span class="badge bg-secondary">${slot.slotStatus}</span></td>
                        <td>
                            <c:if test="${slot.slotStatus == 'OPEN'}">
                                <button class="btn btn-outline-danger btn-sm" type="button" onclick="blockSlot(${slot.id})">
                                    <i class="bi bi-slash-circle me-1"></i>Block
                                </button>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty slots}">
                    <tr><td colspan="6" class="text-muted">No consultation slots published yet.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    function setStatus(type, message) {
        const box = document.getElementById('slotStatus');
        box.className = 'form-status mb-3 ' + type;
        box.textContent = message;
    }

    document.getElementById('slotForm').addEventListener('submit', async function (event) {
        event.preventDefault();
        const form = event.target;
        const payload = Object.fromEntries(new FormData(form).entries());
        const response = await fetch('${pageContext.request.contextPath}/api/v1/expert/slots', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });
        const data = await response.json();
        if (!response.ok || data.success === false) {
            setStatus('error', data.message || 'Unable to publish slot.');
            return;
        }
        setStatus('success', 'Slot published successfully.');
        setTimeout(() => window.location.reload(), 600);
    });

    async function blockSlot(slotId) {
        const response = await fetch('${pageContext.request.contextPath}/api/v1/expert/slots/' + slotId + '/block', { method: 'PUT' });
        const data = await response.json();
        if (!response.ok || data.success === false) {
            setStatus('error', data.message || 'Unable to block slot.');
            return;
        }
        setStatus('success', 'Slot blocked.');
        setTimeout(() => window.location.reload(), 600);
    }
</script>
</body>
</html>
