<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications - AgriConnect</title>
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
        .bell-count {
            background: #ef4444; color: white; border-radius: 12px; font-size: 0.75rem;
            padding: 0.2rem 0.6rem; font-weight: 700;
        }
        .filter-tabs {
            background: white; border-radius: 16px; padding: 0.5rem; display: flex; gap: 0.25rem;
            margin-bottom: 1.25rem; box-shadow: 0 2px 10px rgba(0,0,0,0.06);
        }
        .filter-tab {
            flex: 1; padding: 0.5rem; border: none; border-radius: 10px; background: transparent;
            font-size: 0.8rem; font-weight: 600; color: #718096; transition: all 0.2s; text-align: center;
        }
        .filter-tab.active { background: #16783a; color: white; }
        .notification-row {
            background: white; border-radius: 16px; padding: 1.25rem 1.5rem; margin-bottom: 0.75rem;
            border: 2px solid #e2e8f0; display: flex; align-items: flex-start; gap: 1rem;
        }
        .notification-row.unread { border-color: #3b82f6; background: #eff6ff; }
        .notification-icon {
            width: 44px; height: 44px; border-radius: 12px; display: flex; align-items: center;
            justify-content: center; font-size: 1.2rem; flex-shrink: 0;
        }
        .notification-icon.bid { background: #eff6ff; }
        .notification-icon.advisory { background: #f0fff4; }
        .notification-icon.order { background: #fff7ed; }
        .notification-icon.system { background: #f0f4f8; }
        .notification-title { font-weight: 700; color: #1a202c; font-size: 0.92rem; margin-bottom: 0.25rem; }
        .notification-body { color: #4a5568; font-size: 0.84rem; margin-bottom: 0.25rem; }
        .notification-time { color: #a0aec0; font-size: 0.75rem; }
        .empty-state { text-align: center; padding: 4rem 2rem; background: white; border-radius: 20px; }
    </style>
</head>
<body>

<jsp:include page="fragments/navbar-selector.jsp">
    <jsp:param name="active" value="alerts" />
</jsp:include>

<div class="page-header">
    <div class="container">
        <h1 class="fw-bold mb-1">
            <i class="bi bi-bell me-2"></i>Notifications
            <span class="bell-count ms-2">${unreadCount}</span>
        </h1>
        <p class="mb-0 opacity-75">Stay updated on bids, orders, and advisories.</p>
    </div>
</div>

<div class="container pb-5" style="margin-top: -1.5rem; position: relative; z-index: 1;">
    <c:if test="${not empty msg}">
        <div class="alert alert-success border-0 shadow-sm">${msg}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger border-0 shadow-sm">${error}</div>
    </c:if>

    <div class="filter-tabs">
        <button class="filter-tab active" onclick="filterNotifs('all', this)">All</button>
        <button class="filter-tab" onclick="filterNotifs('bid', this)">Bids</button>
        <button class="filter-tab" onclick="filterNotifs('advisory', this)">Advisories</button>
        <button class="filter-tab" onclick="filterNotifs('order', this)">Orders</button>
    </div>

    <c:if test="${unreadCount > 0}">
        <form action="${pageContext.request.contextPath}/web/notifications/read-all" method="post" class="text-end mb-3">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <button type="submit" class="btn btn-outline-success btn-sm">
                <i class="bi bi-check2-all me-1"></i>Mark all as read
            </button>
        </form>
    </c:if>

    <c:choose>
        <c:when test="${not empty notifications}">
            <div id="notifList">
                <c:forEach var="notif" items="${notifications}">
                    <c:set var="notifType" value="system" />
                    <c:if test="${fn:contains(notif.type, 'BID') or fn:contains(notif.type, 'WALLET')}">
                        <c:set var="notifType" value="bid" />
                    </c:if>
                    <c:if test="${fn:contains(notif.type, 'ADVISORY')}">
                        <c:set var="notifType" value="advisory" />
                    </c:if>
                    <c:if test="${fn:contains(notif.type, 'ORDER')}">
                        <c:set var="notifType" value="order" />
                    </c:if>
                    <div class="notification-row ${notif.isRead ? '' : 'unread'}" data-type="${notifType}">
                        <div class="notification-icon ${notifType}">
                            <c:choose>
                                <c:when test="${notifType == 'bid'}"><i class="bi bi-hammer text-primary"></i></c:when>
                                <c:when test="${notifType == 'advisory'}"><i class="bi bi-megaphone text-success"></i></c:when>
                                <c:when test="${notifType == 'order'}"><i class="bi bi-truck text-warning"></i></c:when>
                                <c:otherwise><i class="bi bi-bell text-secondary"></i></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="flex-grow-1">
                            <div class="notification-title">${notif.title}</div>
                            <div class="notification-body">${notif.body}</div>
                            <div class="notification-time">${notif.createdAt}</div>
                        </div>
                        <c:if test="${!notif.isRead}">
                            <form action="${pageContext.request.contextPath}/web/notifications/${notif.id}/read" method="post">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="btn btn-sm btn-primary">Mark read</button>
                            </form>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="display-4 mb-3"><i class="bi bi-bell"></i></div>
                <h5 class="fw-bold text-dark">You are all caught up</h5>
                <p class="text-muted mb-0">No notifications right now.</p>
                <a href="${pageContext.request.contextPath}/web/marketplace" class="btn btn-success mt-3">
                    <i class="bi bi-shop me-1"></i>Browse Marketplace
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function filterNotifs(type, btn) {
        document.querySelectorAll('.filter-tab').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        document.querySelectorAll('.notification-row').forEach(item => {
            item.style.display = (type === 'all' || item.dataset.type === type) ? '' : 'none';
        });
    }
</script>
</body>
</html>
