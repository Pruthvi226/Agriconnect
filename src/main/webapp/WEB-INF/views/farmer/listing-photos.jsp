<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Photos | AgriConnect</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
</head>
<body class="bg-light">

<jsp:include page="../fragments/farmer-nav.jsp">
    <jsp:param name="active" value="listings" />
</jsp:include>

<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-12 col-md-8">
            
            <!-- PROGRESS INDICATOR -->
            <div class="d-flex justify-content-between mb-4 px-2">
                <div class="text-center">
                    <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center mb-1 mx-auto" style="width: 32px; height: 32px;"><i class="bi bi-check"></i></div>
                    <small class="fw-bold">Crop</small>
                </div>
                <div class="flex-grow-1 border-bottom mb-4 mx-2 border-success border-2"></div>
                <div class="text-center">
                    <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center mb-1 mx-auto" style="width: 32px; height: 32px;">2</div>
                    <small class="fw-bold">Photos</small>
                </div>
                <div class="flex-grow-1 border-bottom mb-4 mx-2 opacity-25"></div>
                <div class="text-center opacity-50">
                    <div class="bg-secondary text-white rounded-circle d-flex align-items-center justify-content-center mb-1 mx-auto" style="width: 32px; height: 32px;">3</div>
                    <small>Verify</small>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
                <div class="card-header bg-success text-white p-4 border-0">
                    <h1 class="h3 fw-800 mb-1">Add Photos (फोटो जोड़ें)</h1>
                    <p class="mb-0 opacity-75">Upload photos of your actual produce for higher trust.</p>
                </div>
                <div class="card-body p-4">
                    <div class="text-center mb-4 p-5 border-2 border-dashed rounded-4 bg-light" id="dropZone" onclick="document.getElementById('fileInput').click()" style="cursor: pointer;">
                        <i class="bi bi-camera fs-1 text-success mb-2"></i>
                        <h3 class="h5 fw-bold">Click to Upload Photos</h3>
                        <p class="text-muted small">You can upload up to 3 photos of the crop.</p>
                        <input type="file" id="fileInput" class="d-none" accept="image/*" onchange="uploadPhoto(this.files[0])">
                    </div>

                    <div id="photoGrid" class="row g-3 mb-4">
                        <!-- Uploaded photos will appear here -->
                    </div>

                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/web/farmer/listings" class="btn btn-success btn-lg py-3 fw-800 rounded-4 shadow-sm">
                            Finish & Publish Listing <i class="bi bi-check-circle ms-2"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/web/farmer/listings" class="btn btn-link text-muted">Skip for now</a>
                    </div>
                </div>
            </div>

            <div class="alert alert-warning rounded-4 border-0 small">
                <i class="bi bi-lightbulb-fill me-2"></i>
                <strong>Tip:</strong> Listings with clear photos of the grain/produce get 5x more bids from buyers!
            </div>
        </div>
    </div>
</div>

<jsp:include page="../fragments/footer.jsp" />

<script>
    var currentListingId = ${listingId};
    
    async function uploadPhoto(file) {
        if (!file) return;
        
        const dropZone = document.getElementById('dropZone');
        const originalContent = dropZone.innerHTML;
        dropZone.innerHTML = '<div class="spinner-border text-success" role="status"></div><p class="mt-2 fw-bold">Uploading...</p>';
        
        const formData = new FormData();
        formData.append('file', file);
        
        try {
            const response = await fetch(`${pageContext.request.contextPath}/api/farmer/listings/${currentListingId}/photos`, {
                method: 'POST',
                body: formData
            });
            
            if (response.ok) {
                const data = await response.json();
                addPhotoToGrid(data.filename);
            } else {
                alert("Upload failed. Please try a smaller image.");
            }
        } catch (e) {
            alert("Network error.");
        } finally {
            dropZone.innerHTML = originalContent;
        }
    }

    function addPhotoToGrid(filename) {
        const grid = document.getElementById('photoGrid');
        const col = document.createElement('div');
        col.className = 'col-4';
        col.innerHTML = `
            <div class="position-relative rounded-4 overflow-hidden border" style="height: 120px;">
                <img src="${pageContext.request.contextPath}/uploads/${filename}" class="w-100 h-100 object-fit-cover">
                <div class="position-absolute top-0 end-0 p-1">
                    <button class="btn btn-danger btn-sm rounded-circle p-0" style="width: 24px; height: 24px;"><i class="bi bi-x"></i></button>
                </div>
            </div>
        `;
        grid.appendChild(col);
    }
</script>

<style>
    .object-fit-cover { object-fit: cover; }
    .border-dashed { border-style: dashed !important; }
</style>

</body>
</html>
