<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Advisories - AgriConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
        body { background: #f0f4f8; min-height: 100vh; }
        .page-header {
            background: linear-gradient(135deg, #0a4f2c, #1a9e4a);
            color: white; padding: 2rem 0 3.5rem; position: relative; overflow: hidden;
        }
        .page-header::after {
            content: ''; position: absolute; bottom: -1px; left: 0; right: 0; height: 40px;
            background: #f0f4f8; clip-path: ellipse(55% 100% at 50% 100%);
        }
        .panel {
            background: white; border-radius: 18px; border: 1px solid #e2e8f0;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
        }
        .advisory-card {
            background: white; border-radius: 16px; border: 2px solid #e2e8f0;
            padding: 1.25rem; margin-bottom: 1rem;
        }
        .advisory-card.critical { border-color: #fecaca; background: #fff7f7; }
        .advisory-card.warning { border-color: #fed7aa; background: #fffaf2; }
        .advisory-card.info { border-color: #bfdbfe; background: #f8fbff; }
        .severity-pill {
            display: inline-flex; align-items: center; gap: 0.35rem; padding: 0.25rem 0.65rem;
            border-radius: 999px; font-size: 0.72rem; font-weight: 800;
        }
        .severity-pill.CRITICAL { background: #fee2e2; color: #991b1b; }
        .severity-pill.WARNING { background: #ffedd5; color: #9a3412; }
        .severity-pill.INFO { background: #dbeafe; color: #1d4ed8; }
        .form-label {
            font-size: 0.78rem; font-weight: 700; color: #4a5568;
            text-transform: uppercase; letter-spacing: 0.4px;
        }
        .form-control, .form-select { border: 2px solid #e2e8f0; border-radius: 12px; }
    </style>
</head>
<body>

<jsp:include page="fragments/navbar-selector.jsp">
    <jsp:param name="active" value="advisories" />
</jsp:include>

<div class="page-header">
    <div class="container">
        <h1 class="fw-bold mb-1"><i class="bi bi-megaphone me-2"></i>Agricultural Advisories</h1>
        <p class="mb-0 opacity-75">Expert alerts, crop guidance, and market recommendations.</p>
    </div>
</div>

<div class="container pb-5" style="margin-top: -1.5rem; position: relative; z-index: 1;">
    <c:if test="${not empty msg}">
        <div class="alert alert-success border-0 shadow-sm">${msg}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger border-0 shadow-sm">${error}</div>
    </c:if>

    <div class="row g-4">
        <sec:authorize access="hasRole('AGRI_EXPERT')">
            <div class="col-lg-5">
                <div class="panel p-4">
                    <h2 class="h5 fw-bold mb-3"><i class="bi bi-pencil-square me-2 text-success"></i>Publish Advisory</h2>
                    <form action="${pageContext.request.contextPath}/web/advisories" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <div class="mb-3">
                            <label class="form-label">Title</label>
                            <input type="text" class="form-control" name="title" maxlength="200" required>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Type</label>
                                <select class="form-select" name="advisoryType" required>
                                    <option value="PEST">Pest</option>
                                    <option value="DISEASE">Disease</option>
                                    <option value="WEATHER">Weather</option>
                                    <option value="MARKET">Market</option>
                                    <option value="TECHNIQUE">Technique</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Severity</label>
                                <select class="form-select" name="severity" required>
                                    <option value="INFO">Info</option>
                                    <option value="WARNING">Warning</option>
                                    <option value="CRITICAL">Critical</option>
                                </select>
                            </div>
                        </div>
                        <div class="row g-3 mt-0">
                            <div class="col-md-6">
                                <label class="form-label">Crop</label>
                                <input type="text" class="form-control" name="cropName" placeholder="Optional">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Valid Until</label>
                                <input type="date" class="form-control" name="validUntil" value="${defaultValidUntil}" required>
                            </div>
                        </div>
                        <div class="mb-3 mt-3">
                            <label class="form-label">Affected Districts</label>
                            <input type="text" class="form-control" name="affectedDistricts" placeholder="Nashik, Pune" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Advisory Content</label>
                            <textarea class="form-control" name="body" rows="5" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-success w-100 fw-bold">
                            <i class="bi bi-send me-1"></i>Publish and Notify Farmers
                        </button>
                    </form>
                </div>
            </div>
        </sec:authorize>

        <div class="col">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="h6 fw-bold text-uppercase text-muted mb-0">Recent Advisories</h2>
            </div>
            <c:choose>
                <c:when test="${not empty advisories}">
                    <c:forEach var="advisory" items="${advisories}">
                        <c:set var="severityClass" value="${advisory.severity == 'CRITICAL' ? 'critical' : advisory.severity == 'WARNING' ? 'warning' : 'info'}" />
                        <div class="advisory-card ${severityClass}">
                            <div class="d-flex justify-content-between gap-3 mb-2">
                                <div>
                                    <span class="severity-pill ${advisory.severity}">
                                        <i class="bi bi-exclamation-circle"></i>${advisory.severity}
                                    </span>
                                    <span class="badge text-bg-light ms-2">${advisory.advisoryType}</span>
                                </div>
                                <small class="text-muted">${advisory.createdAt}</small>
                            </div>
                            <h3 class="h5 fw-bold mb-2">${advisory.title}</h3>
                            <p class="text-muted mb-3">${advisory.body}</p>
                            <div class="d-flex flex-wrap gap-3 small text-muted">
                                <span><i class="bi bi-person me-1"></i>${advisory.expert.name}</span>
                                <span><i class="bi bi-flower1 me-1"></i>${empty advisory.cropName ? 'All crops' : advisory.cropName}</span>
                                <span><i class="bi bi-geo-alt me-1"></i>${advisory.affectedDistricts}</span>
                                <span><i class="bi bi-calendar-check me-1"></i>Valid until ${advisory.validUntil}</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/web/advisories/${advisory.id}" class="btn btn-sm btn-outline-success mt-3">Open advisory</a>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="panel p-5 text-center">
                        <div class="display-5 mb-3"><i class="bi bi-megaphone"></i></div>
                        <h3 class="h5 fw-bold">No advisories published yet</h3>
                        <p class="text-muted mb-0">Expert advisories will appear here after publishing.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
