<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FPO Dashboard - AgriConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
</head>
<body>
<jsp:include page="fragments/farmer-nav.jsp">
    <jsp:param name="active" value="fpo" />
</jsp:include>

<section class="farmer-hero compact-hero">
    <div class="container">
        <span class="farmer-chip"><i class="bi bi-diagram-3"></i> FPO Collective Bargaining</span>
        <h1>Pool produce for bulk deals</h1>
        <p>Create a verified group, approve members, and publish collective listings from live member inventory.</p>
    </div>
</section>

<main class="container farmer-page-shell">
    <div class="row g-3">
        <div class="col-lg-5">
            <section class="workspace-panel">
                <div class="panel-title"><h2>Create FPO group</h2></div>
                <form method="post" action="${pageContext.request.contextPath}/web/farmer/fpo/groups" class="mini-form-grid">
                    <div class="full">
                        <label class="form-label">Group name</label>
                        <input class="form-control" name="groupName" required>
                    </div>
                    <div>
                        <label class="form-label">District</label>
                        <input class="form-control" name="district" required>
                    </div>
                    <div>
                        <label class="form-label">State</label>
                        <input class="form-control" name="state" required>
                    </div>
                    <div class="wide">
                        <label class="form-label">Registration number</label>
                        <input class="form-control" name="registrationNumber" required>
                    </div>
                    <div class="full">
                        <button class="btn btn-success" type="submit">Create FPO Group</button>
                    </div>
                </form>
            </section>
        </div>
        <div class="col-lg-7">
            <section class="workspace-panel h-100">
                <div class="panel-title"><h2>Pending approvals</h2></div>
                <c:choose>
                    <c:when test="${not empty pendingApprovals}">
                        <div class="compact-table">
                            <c:forEach var="membership" items="${pendingApprovals}">
                                <div class="compact-row">
                                    <span><strong>${membership.farmer.user.name}</strong><small>${membership.fpoGroup.groupName}</small></span>
                                    <span>${membership.farmer.district}</span>
                                    <span>Requested</span>
                                    <span>
                                        <form method="post" action="${pageContext.request.contextPath}/web/farmer/fpo/memberships/${membership.id}/approve">
                                            <button class="btn btn-sm btn-success" type="submit">Approve</button>
                                        </form>
                                    </span>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-bookings">
                            <i class="bi bi-check2-circle"></i>
                            <strong>No pending requests</strong>
                            <span>New join requests will appear here for leader approval.</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </div>

    <section class="workspace-panel mt-3">
        <div class="panel-title"><h2>Groups you lead</h2></div>
        <c:choose>
            <c:when test="${not empty groupsLed}">
                <c:forEach var="group" items="${groupsLed}">
                    <div class="row g-3 mb-3">
                        <div class="col-lg-6">
                            <div class="compact-table">
                                <div class="compact-row">
                                    <span><strong>${group.groupName}</strong><small>${group.registrationNumber}</small></span>
                                    <span>${group.district}, ${group.state}</span>
                                    <span>${group.totalMembers} members</span>
                                    <span class="status-badge done">FPO Verified</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <form method="post" action="${pageContext.request.contextPath}/web/farmer/fpo/${group.id}/listings" class="mini-form-grid">
                                <div>
                                    <label class="form-label">Crop</label>
                                    <input class="form-control" name="cropName" required>
                                </div>
                                <div>
                                    <label class="form-label">Min price/kg</label>
                                    <input class="form-control" type="number" step="0.01" name="minPricePerKg" required>
                                </div>
                                <div>
                                    <label class="form-label">Quality grade</label>
                                    <input class="form-control" name="qualityGrade" required>
                                </div>
                                <div>
                                    <label class="form-label">Pooling deadline</label>
                                    <input class="form-control" type="date" name="poolingDeadline" required>
                                </div>
                                <div class="full">
                                    <button class="btn btn-outline-success" type="submit">Create collective listing</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-bookings">
                    <i class="bi bi-people"></i>
                    <strong>No FPO groups yet</strong>
                    <span>Create your first group to start collective bargaining.</span>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <section class="workspace-panel mt-3">
        <div class="panel-title"><h2>Your memberships</h2></div>
        <c:choose>
            <c:when test="${not empty memberships}">
                <div class="compact-table">
                    <c:forEach var="membership" items="${memberships}">
                        <div class="compact-row">
                            <span><strong>${membership.fpoGroup.groupName}</strong><small>${membership.fpoGroup.district}</small></span>
                            <span>${membership.fpoGroup.registrationNumber}</span>
                            <span>${membership.isActive ? 'Active member' : 'Approval pending'}</span>
                            <span class="status-badge ${membership.isActive ? 'done' : 'live'}">${membership.isActive ? 'ACTIVE' : 'PENDING'}</span>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-bookings">
                    <i class="bi bi-diagram-2"></i>
                    <strong>No memberships yet</strong>
                    <span>Join an existing collective using the API or from a leader invite.</span>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>
</body>
</html>
