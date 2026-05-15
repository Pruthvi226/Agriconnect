<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Listings | AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
</head>
<body class="bg-light">

<jsp:include page="fragments/farmer-nav.jsp">
    <jsp:param name="active" value="listings" />
</jsp:include>

<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-12 col-md-8">
            
            <!-- PROGRESS INDICATOR (Rule 6) -->
            <div class="d-flex justify-content-between mb-4 px-2">
                <div class="text-center">
                    <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center mb-1" style="width: 32px; height: 32px;">1</div>
                    <small class="fw-bold">Crop</small>
                </div>
                <div class="flex-grow-1 border-bottom mb-4 mx-2 opacity-25"></div>
                <div class="text-center opacity-50">
                    <div class="bg-secondary text-white rounded-circle d-flex align-items-center justify-content-center mb-1" style="width: 32px; height: 32px;">2</div>
                    <small>Price</small>
                </div>
                <div class="flex-grow-1 border-bottom mb-4 mx-2 opacity-25"></div>
                <div class="text-center opacity-50">
                    <div class="bg-secondary text-white rounded-circle d-flex align-items-center justify-content-center mb-1" style="width: 32px; height: 32px;">3</div>
                    <small>Photos</small>
                </div>
            </div>

            <!-- MAIN FORM CARD -->
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
                <div class="card-header bg-success text-white p-4 border-0">
                    <h1 class="h3 fw-800 mb-1">List Your Crop</h1>
                    <p class="mb-0 opacity-75">Tell buyers what you are selling (आप क्या बेच रहे हैं?)</p>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger rounded-3">${error}</div>
                    </c:if>
                    <c:if test="${not empty msg}">
                        <div class="alert alert-success rounded-3">${msg}</div>
                    </c:if>

                    <form id="addListingForm" method="post" action="${pageContext.request.contextPath}/web/farmer/listings">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <!-- SECTION A: Crop Details -->
                        <div class="mb-4">
                            <label class="form-label fw-bold">Select Crop (फसल चुनें)</label>
                            <select class="form-select form-select-lg rounded-3 border-2" name="cropName" id="cropName" required onchange="fetchMsp(this.value)">
                                <option value="">-- Choose Crop --</option>
                                <option value="Wheat">Wheat (गेहूं)</option>
                                <option value="Rice (Paddy)">Rice (चावल/धान)</option>
                                <option value="Maize">Maize (मक्का)</option>
                                <option value="Soybean">Soybean (सोयाबीन)</option>
                                <option value="Onion">Onion (प्याज)</option>
                            </select>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-6">
                                <label class="form-label fw-bold">Variety (किस्म)</label>
                                <input type="text" class="form-control form-control-lg rounded-3 border-2" name="variety" placeholder="e.g. Sharbati" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-bold">Quality (क्वालिटी)</label>
                                <select class="form-select form-select-lg rounded-3 border-2" name="qualityGrade">
                                    <option value="A">Grade A (Best)</option>
                                    <option value="B">Grade B (Good)</option>
                                    <option value="C">Grade C (Average)</option>
                                </select>
                            </div>
                        </div>

                        <!-- SECTION B: Quantity & Price -->
                        <div class="row g-3 mb-4">
                            <div class="col-12 col-md-6">
                                <label class="form-label fw-bold">Quantity in kg (मात्रा)</label>
                                <div class="input-group input-group-lg">
                                    <input type="number" class="form-control rounded-3 border-2" name="quantityKg" value="1000" required>
                                    <span class="input-group-text bg-light border-2 border-start-0">kg</span>
                                </div>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label fw-bold">Your Price per kg (कीमत)</label>
                                <div class="input-group input-group-lg">
                                    <span class="input-group-text bg-light border-2 border-end-0">₹</span>
                                    <input type="number" class="form-control border-2" name="askingPricePerKg" id="askingPrice" value="25" step="0.5" required oninput="compareWithMsp()">
                                </div>
                                <div id="mspComparison" class="mt-2 small fw-bold d-none">
                                    <!-- Dynamic MSP Text -->
                                </div>
                            </div>
                        </div>

                        <!-- FEATURE 2: URGENT SALE (Rule 2) -->
                        <div class="p-3 rounded-4 mb-4 border-2 border-dashed" style="background-color: #fff9f0; border: 2px dashed #ffeeba;">
                            <div class="form-check form-switch d-flex align-items-center">
                                <input class="form-check-input flex-shrink-0 me-3" type="checkbox" name="isUrgent" id="isUrgent" style="width: 3rem; height: 1.5rem;" onchange="toggleUrgentReason(this.checked)">
                                <label class="form-check-label" for="isUrgent">
                                    <span class="d-block fw-800 text-warning-emphasis">Need to sell urgently? (जल्दी बेचना है?)</span>
                                    <span class="small text-muted">Urgent sales are highlighted to buyers first.</span>
                                </label>
                            </div>
                            <div id="urgentReasonBox" class="mt-3 d-none">
                                <label class="form-label fw-bold text-danger small">Why is it urgent?</label>
                                <select class="form-select border-danger border-opacity-25" name="urgentReason">
                                    <option value="IMMEDIATE_CASH">Need cash for hospital/fees</option>
                                    <option value="STORAGE_FULL">Storage is full / New crop coming</option>
                                    <option value="PERISHABLE">Produce might spoil</option>
                                    <option value="TRAVEL">Traveling out of village</option>
                                </select>
                            </div>
                        </div>

                        <!-- SECTION C: Dates -->
                        <div class="row g-3 mb-4">
                            <div class="col-6">
                                <label class="form-label fw-bold small">Available From</label>
                                <input type="date" class="form-control rounded-3" name="availableFrom" id="availableFrom" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-bold small">Available Until</label>
                                <input type="date" class="form-control rounded-3" name="availableUntil" id="availableUntil" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-success btn-lg w-100 py-3 fw-800 shadow-sm rounded-4" id="submitBtn">
                            Next: Add Photos & Publish <i class="bi bi-arrow-right-circle ms-2"></i>
                        </button>
                    </form>
                </div>
            </div>

            <!-- MY LISTINGS SUMMARY -->
            <div class="d-flex justify-content-between align-items-center mb-3 px-2">
                <h2 class="h5 fw-800 mb-0">Your Listings</h2>
                <span class="small text-muted">Withdraw or reactivate without leaving this page</span>
            </div>
            
            <c:forEach var="listing" items="${farmerListings}">
                <div class="card border-0 shadow-sm rounded-4 mb-3 p-3">
                    <div class="d-flex justify-content-between align-items-center gap-3">
                        <div class="d-flex align-items-center">
                            <div class="bg-success-subtle p-3 rounded-4 me-3">
                                <i class="bi bi-box-seam text-success fs-4"></i>
                            </div>
                            <div>
                                <div class="fw-800">${listing.cropName}</div>
                                <div class="small text-muted">${listing.quantityKg} kg · ₹${listing.askingPricePerKg}/kg</div>
                            </div>
                        </div>
                        <span class="badge ${listing.status == 'ACTIVE' ? 'bg-success' : 'bg-warning'} rounded-pill">
                            ${listing.status}
                        </span>
                    </div>
                    <div class="d-flex flex-wrap gap-2 justify-content-end mt-3">
                        <a href="${pageContext.request.contextPath}/web/farmer/listings/${listing.id}/photos" class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-images me-1"></i>Photos
                        </a>
                        <c:if test="${listing.status != 'WITHDRAWN' && listing.status != 'SOLD'}">
                            <form action="${pageContext.request.contextPath}/web/farmer/listings/${listing.id}/withdraw" method="post">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                    <i class="bi bi-eye-slash me-1"></i>Withdraw
                                </button>
                            </form>
                        </c:if>
                        <c:if test="${listing.status == 'WITHDRAWN' || listing.status == 'EXPIRED'}">
                            <form action="${pageContext.request.contextPath}/web/farmer/listings/${listing.id}/reactivate" method="post">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="btn btn-sm btn-success">
                                    <i class="bi bi-arrow-clockwise me-1"></i>Reactivate
                                </button>
                            </form>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />

<script>
    let currentMsp = null;

    async function fetchMsp(crop) {
        if (!crop) return;
        try {
            const response = await fetch(`${pageContext.request.contextPath}/api/msp?crop=${crop}`);
            if (response.ok) {
                const data = await response.json();
                currentMsp = data.mspPerKg;
                compareWithMsp();
            }
        } catch (e) { console.error("MSP fetch failed", e); }
    }

    function compareWithMsp() {
        const mspBox = document.getElementById('mspComparison');
        const askingPrice = parseFloat(document.getElementById('askingPrice').value);
        
        if (!currentMsp || !askingPrice) {
            mspBox.classList.add('d-none');
            return;
        }

        mspBox.classList.remove('d-none');
        if (askingPrice < currentMsp) {
            mspBox.innerHTML = `<i class="bi bi-exclamation-triangle-fill text-danger me-1"></i> Your price is below MSP (₹${currentMsp}/kg)`;
            mspBox.className = "mt-2 small fw-bold text-danger";
        } else {
            mspBox.innerHTML = `<i class="bi bi-check-circle-fill text-success me-1"></i> Good price (MSP: ₹${currentMsp}/kg)`;
            mspBox.className = "mt-2 small fw-bold text-success";
        }
    }

    function toggleUrgentReason(show) {
        document.getElementById('urgentReasonBox').classList.toggle('d-none', !show);
    }

    // Set default dates
    const today = new Date();
    document.getElementById('availableFrom').value = today.toISOString().split('T')[0];
    today.setDate(today.getDate() + 7);
    document.getElementById('availableUntil').value = today.toISOString().split('T')[0];

    document.getElementById('addListingForm').addEventListener('submit', function() {
        const btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Publishing...';
    });
</script>

</body>
</html>
