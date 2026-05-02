<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Listings - AgriConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body>
<jsp:include page="fragments/farmer-nav.jsp">
    <jsp:param name="active" value="listings" />
</jsp:include>

<section class="farmer-hero compact-hero">
    <div class="container">
        <span class="farmer-chip"><i class="bi bi-card-checklist"></i> Listing Desk</span>
        <h1>Add and manage produce listings</h1>
        <p>Publish clean stock details so buyers can request exact quantities with confidence.</p>
    </div>
</section>

<main class="container farmer-page-shell">
    <section class="workspace-panel listing-builder" id="addListingPanel">
        <div class="builder-head">
            <div>
                <h2><i class="bi bi-plus-square-fill text-success me-2"></i>Add Listing</h2>
                <div class="text-muted small mt-1">Quantity, quality, price, and pickup clarity are the details buyers act on first.</div>
            </div>
            <a href="#myListings" class="btn btn-outline-success btn-sm"><i class="bi bi-list-check me-1"></i>View my listings</a>
        </div>

        <div id="listingFormStatus" class="form-status mb-3"></div>

        <form id="addListingForm">
            <div class="row g-3">
                <div class="col-lg-8">
                    <div class="listing-form-grid">
                        <div>
                            <label class="form-label text-muted fw-bold small">Crop Name</label>
                            <input type="text" class="form-control" name="cropName" id="listingCropName" placeholder="Wheat" required>
                        </div>
                        <div>
                            <label class="form-label text-muted fw-bold small">Variety</label>
                            <input type="text" class="form-control" name="variety" id="listingVariety" placeholder="Sharbati" required>
                        </div>
                        <div>
                            <label class="form-label text-muted fw-bold small">Quantity kg</label>
                            <input type="number" class="form-control" name="quantityKg" id="listingQuantity" value="1000" min="1" step="1" required>
                        </div>
                        <div>
                            <label class="form-label text-muted fw-bold small">Quality</label>
                            <select class="form-select" name="qualityGrade" id="listingQuality">
                                <option value="A">Grade A</option>
                                <option value="B">Grade B</option>
                                <option value="C">Grade C</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label text-muted fw-bold small">Available From</label>
                            <input type="date" class="form-control" name="availableFrom" id="availableFrom" required>
                        </div>
                        <div>
                            <label class="form-label text-muted fw-bold small">Available Until</label>
                            <input type="date" class="form-control" name="availableUntil" id="availableUntil" required>
                        </div>
                        <div>
                            <label class="form-label text-muted fw-bold small">Price / kg</label>
                            <input type="number" class="form-control" name="askingPricePerKg" id="listingPrice" value="25" min="1" step="0.25" required>
                        </div>
                        <div>
                            <label class="form-label text-muted fw-bold small">Pickup Window</label>
                            <select class="form-select" id="listingPickupWindow">
                                <option>Within 48 hours</option>
                                <option>3-5 days</option>
                                <option>Flexible this week</option>
                            </select>
                        </div>
                        <div class="full">
                            <label class="form-label text-muted fw-bold small">Buyer Notes</label>
                            <textarea class="form-control" name="description" id="listingDescription" rows="3" maxlength="500" placeholder="Moisture level, packaging, loading help, pickup point..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="listing-preview">
                        <div class="text-muted small fw-bold text-uppercase">Preview</div>
                        <h5 class="fw-bold mb-1" id="previewTitle">Wheat</h5>
                        <div class="text-muted small mb-3" id="previewSubtitle">Sharbati · Grade A</div>
                        <div class="preview-price mb-1" id="previewPrice">Rs 25/kg</div>
                        <div class="text-muted small mb-3" id="previewValue">Estimated gross: Rs 25,000</div>
                        <div class="signal-card mb-3">
                            <div class="signal-label">Listing Strength</div>
                            <div class="progress mt-2">
                                <div class="progress-bar bg-success" id="listingStrengthBar" style="width: 76%"></div>
                            </div>
                            <div class="text-muted small mt-2" id="listingStrengthText">Good: enough detail for buyers to request quantity.</div>
                        </div>
                        <button type="submit" class="btn btn-success w-100" id="submitListingBtn">
                            <i class="bi bi-cloud-upload me-1"></i>Publish Listing
                        </button>
                        <button type="button" class="btn btn-outline-success w-100 mt-2" onclick="fillPremiumListing()">
                            <i class="bi bi-magic me-1"></i>Use Example
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </section>

    <section class="workspace-panel mt-3" id="myListings">
        <div class="panel-title">
            <div>
                <h2>My Listings</h2>
                <div class="text-muted small">Listings you publish here display in the live marketplace.</div>
            </div>
            <span class="booking-count active"><i class="bi bi-card-checklist"></i>${farmerListings.size()} total</span>
        </div>

        <c:choose>
            <c:when test="${not empty farmerListings}">
                <div class="listing-table">
                    <c:forEach var="listing" items="${farmerListings}">
                        <article class="listing-row-card">
                            <div>
                                <h3>${listing.cropName} <span>${listing.variety}</span></h3>
                                <div class="booking-meta">
                                    <span><i class="bi bi-box-seam"></i><fmt:formatNumber value="${listing.quantityKg}" maxFractionDigits="0" /> kg available</span>
                                    <span><i class="bi bi-award"></i>Grade ${listing.qualityGrade}</span>
                                    <span><i class="bi bi-geo-alt"></i>${listing.district}</span>
                                </div>
                                <c:if test="${not empty listing.description}">
                                    <p>${listing.description}</p>
                                </c:if>
                            </div>
                            <div class="listing-side">
                                <strong>Rs ${listing.askingPricePerKg}/kg</strong>
                                <span class="status-badge live">${listing.status}</span>
                                <small>Until ${listing.availableUntil}</small>
                                <a class="btn btn-outline-success btn-sm" href="${pageContext.request.contextPath}/web/marketplace/listing/${listing.id}">
                                    <i class="bi bi-eye me-1"></i>Open
                                </a>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-bookings">
                    <i class="bi bi-card-checklist"></i>
                    <strong>No listings yet</strong>
                    <span>Add a listing above and it will appear here immediately after publishing.</span>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function formatRupees(value) {
        return 'Rs ' + Math.round(value).toLocaleString('en-IN');
    }

    function getTomorrowIso(offsetDays) {
        const date = new Date();
        date.setDate(date.getDate() + offsetDays);
        return date.toISOString().slice(0, 10);
    }

    function updateListingPreview() {
        const crop = document.getElementById('listingCropName');
        const variety = document.getElementById('listingVariety');
        const quality = document.getElementById('listingQuality');
        const qty = document.getElementById('listingQuantity');
        const price = document.getElementById('listingPrice');
        const description = document.getElementById('listingDescription');
        const quantityValue = parseFloat(qty.value || '0');
        const priceValue = parseFloat(price.value || '0');
        let strength = 45;

        document.getElementById('previewTitle').innerText = crop.value.trim() || 'Wheat';
        document.getElementById('previewSubtitle').innerText = (variety.value.trim() || 'Sharbati') + ' · Grade ' + (quality.value || 'A');
        document.getElementById('previewPrice').innerText = 'Rs ' + (priceValue || 0).toFixed(2) + '/kg';
        document.getElementById('previewValue').innerText = 'Estimated gross: ' + formatRupees(quantityValue * priceValue || 0);

        if (crop.value.trim()) strength += 10;
        if (variety.value.trim()) strength += 10;
        if (quantityValue >= 100) strength += 10;
        if (priceValue >= 1) strength += 10;
        if (description.value.trim().length > 30) strength += 15;
        strength = Math.min(strength, 100);
        document.getElementById('listingStrengthBar').style.width = strength + '%';
        document.getElementById('listingStrengthText').innerText =
            strength >= 85 ? 'Excellent: buyers can confidently book this stock.' :
            strength >= 70 ? 'Good: enough detail for buyers to request quantity.' :
            'Needs detail: add variety, quantity, and pickup notes.';
    }

    function fillPremiumListing() {
        document.getElementById('listingCropName').value = 'Wheat';
        document.getElementById('listingVariety').value = 'Sharbati';
        document.getElementById('listingQuantity').value = '1250';
        document.getElementById('listingQuality').value = 'A';
        document.getElementById('listingPrice').value = '26.5';
        document.getElementById('availableFrom').value = getTomorrowIso(1);
        document.getElementById('availableUntil').value = getTomorrowIso(7);
        document.getElementById('listingDescription').value = 'Clean Grade A stock, packed in 50 kg bags, farm-gate pickup available with morning loading support.';
        updateListingPreview();
    }

    function showListingStatus(type, message) {
        const status = document.getElementById('listingFormStatus');
        status.className = 'form-status mb-3 ' + type;
        status.innerText = message;
    }

    document.getElementById('addListingForm').addEventListener('submit', function(event) {
        event.preventDefault();
        const form = event.target;
        const btn = document.getElementById('submitListingBtn');
        const payload = {
            cropName: form.cropName.value.trim(),
            variety: form.variety.value.trim(),
            quantityKg: parseFloat(form.quantityKg.value),
            availableFrom: form.availableFrom.value,
            availableUntil: form.availableUntil.value,
            askingPricePerKg: parseFloat(form.askingPricePerKg.value),
            qualityGrade: form.qualityGrade.value,
            description: form.description.value.trim()
        };

        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Publishing...';

        fetch('${pageContext.request.contextPath}/api/v1/listings', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        })
        .then(async response => {
            const data = await response.json().catch(() => ({}));
            if (!response.ok || data.success === false) {
                throw new Error(data.message || 'Could not create listing.');
            }
            showListingStatus('success', 'Listing published. It is now visible in Marketplace and My Listings.');
            setTimeout(() => window.location.href = '${pageContext.request.contextPath}/web/dashboard/farmer/listings#myListings', 700);
        })
        .catch(error => showListingStatus('error', error.message))
        .finally(() => {
            btn.disabled = false;
            btn.innerHTML = '<i class="bi bi-cloud-upload me-1"></i>Publish Listing';
        });
    });

    document.querySelectorAll('#addListingForm input, #addListingForm select, #addListingForm textarea').forEach(function(field) {
        field.addEventListener('input', updateListingPreview);
        field.addEventListener('change', updateListingPreview);
    });
    fillPremiumListing();
</script>
</body>
</html>
