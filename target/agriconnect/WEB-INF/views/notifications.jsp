<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
    <style>
        * { font-family: 'Inter', sans-serif; }
        body { background: #f0f4f8; min-height: 100vh; }

        .navbar {
            background: linear-gradient(135deg, #0a4f2c, #16783a) !important;
            padding: 0.875rem 0;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }
        .navbar-brand { font-weight: 800; font-size: 1.3rem; }
        .navbar-brand span { color: #86efac; }
        .nav-link { color: rgba(255,255,255,0.85) !important; font-weight: 500; }
        .nav-link:hover { color: white !important; }
        .btn-logout {
            background: rgba(255,255,255,0.15); border: 1px solid rgba(255,255,255,0.25);
            color: white; border-radius: 8px; font-size: 0.875rem;
            font-weight: 500; padding: 0.4rem 0.875rem; transition: all 0.2s;
        }
        .btn-logout:hover { background: rgba(255,255,255,0.25); color: white; }

        .page-header {
            background: linear-gradient(135deg, #0a4f2c, #1a9e4a);
            color: white; padding: 2rem 0 3.5rem;
            position: relative; overflow: hidden;
        }
        .page-header::after {
            content: ''; position: absolute;
            bottom: -1px; left: 0; right: 0; height: 40px;
            background: #f0f4f8;
            clip-path: ellipse(55% 100% at 50% 100%);
        }
        .page-header h1 { font-weight: 800; font-size: 1.75rem; margin-bottom: 0.25rem; }

        .bell-count {
            background: #ef4444; color: white;
            border-radius: 12px; font-size: 0.75rem;
            padding: 0.2rem 0.6rem; font-weight: 700;
        }

        .notif-item {
            background: white;
            border-radius: 16px;
            padding: 1.25rem 1.5rem;
            margin-bottom: 0.75rem;
            border: 2px solid #e2e8f0;
            cursor: pointer;
            transition: all 0.2s;
            display: flex; align-items: flex-start; gap: 1rem;
        }
        .notif-item:hover { border-color: #16783a; transform: translateX(4px); }
        .notif-item.unread { border-color: #3b82f6; background: #eff6ff; }
        .notif-item.unread:hover { border-color: #16783a; background: #f0fff4; }

        .notif-icon {
            width: 44px; height: 44px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem; flex-shrink: 0;
        }
        .notif-icon.bid { background: #eff6ff; }
        .notif-icon.advisory { background: #f0fff4; }
        .notif-icon.order { background: #fff7ed; }
        .notif-icon.system { background: #f0f4f8; }

        .notif-title { font-weight: 700; color: #1a202c; font-size: 0.9rem; margin-bottom: 0.2rem; }
        .notif-body { color: #4a5568; font-size: 0.825rem; margin-bottom: 0.25rem; }
        .notif-time { color: #a0aec0; font-size: 0.75rem; }
        .new-badge {
            background: #3b82f6; color: white;
            font-size: 0.68rem; font-weight: 700;
            padding: 0.15rem 0.5rem; border-radius: 10px;
            flex-shrink: 0;
        }

        .empty-state { text-align: center; padding: 4rem 2rem; background: white; border-radius: 20px; }
        .empty-state .icon { font-size: 3.5rem; margin-bottom: 1rem; }

        .filter-tabs {
            background: white; border-radius: 16px; padding: 0.5rem;
            display: flex; gap: 0.25rem; margin-bottom: 1.25rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
        }
        .filter-tab {
            flex: 1; padding: 0.5rem; border: none; border-radius: 10px;
            background: transparent; font-size: 0.8rem; font-weight: 600;
            color: #718096; cursor: pointer; transition: all 0.2s; text-align: center;
        }
        .filter-tab.active { background: #16783a; color: white; }
        .filter-tab:hover:not(.active) { background: #f0f4f8; color: #1a202c; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand text-white" href="${pageContext.request.contextPath}/web/marketplace">
            🌾 Agri<span>Connect</span>
        </a>
        <div class="d-flex align-items-center gap-2">
            <a href="${pageContext.request.contextPath}/web/marketplace" class="nav-link">
                <i class="bi bi-shop me-1"></i>Marketplace
            </a>
            <form action="${pageContext.request.contextPath}/logout" method="post" class="d-inline ms-2">
                <button type="submit" class="btn-logout">
                    <i class="bi bi-box-arrow-right me-1"></i>Sign Out
                </button>
            </form>
        </div>
    </div>
</nav>

<div class="page-header">
    <div class="container">
        <h1>
            <i class="bi bi-bell me-2"></i>Notifications
            <span class="bell-count ms-2" id="nav-bell-count">0</span>
        </h1>
        <p class="mb-0" style="opacity: 0.8; font-size: 0.9rem;">Stay updated on bids, orders, and advisories</p>
    </div>
</div>

<div class="container pb-5" style="margin-top: -1.5rem; position: relative; z-index: 1;">

    <!-- Filter Tabs -->
    <div class="filter-tabs">
        <button class="filter-tab active" onclick="filterNotifs('all', this)">All</button>
        <button class="filter-tab" onclick="filterNotifs('bid', this)">Bids</button>
        <button class="filter-tab" onclick="filterNotifs('advisory', this)">Advisories</button>
        <button class="filter-tab" onclick="filterNotifs('order', this)">Orders</button>
    </div>

    <c:choose>
        <c:when test="${not empty notifications}">
            <div id="notifList">
                <c:forEach var="notif" items="${notifications}">
                    <div class="notif-item ${notif.read ? '' : 'unread'}"
                         id="notif-${notif.id}"
                         data-type="${notif.type}"
                         onclick="markAsRead(${notif.id})">
                        <div class="notif-icon ${notif.type}">
                            <c:choose>
                                <c:when test="${notif.type == 'bid'}">🔨</c:when>
                                <c:when test="${notif.type == 'advisory'}">📢</c:when>
                                <c:when test="${notif.type == 'order'}">📦</c:when>
                                <c:otherwise>🔔</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="flex-grow-1">
                            <div class="notif-title">${notif.title}</div>
                            <div class="notif-body">${notif.body}</div>
                            <div class="notif-time">${notif.createdAt}</div>
                        </div>
                        <c:if test="${!notif.read}">
                            <span class="new-badge" id="badge-${notif.id}">NEW</span>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="icon">🔔</div>
                <h5 class="fw-bold text-dark">You're all caught up!</h5>
                <p class="text-muted mb-0">No notifications right now. We'll alert you when there are bids, orders, or advisory updates.</p>
                <a href="${pageContext.request.contextPath}/web/marketplace" class="btn btn-success mt-3">
                    <i class="bi bi-shop me-1"></i>Browse Marketplace
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function markAsRead(id) {
        fetch('${pageContext.request.contextPath}/api/v1/notifications/' + id + '/read', { method: 'PUT' })
            .then(res => res.json())
            .then(data => {
                if (data && data.success) {
                    const el = document.getElementById('notif-' + id);
                    const badge = document.getElementById('badge-' + id);
                    if (el) el.classList.remove('unread');
                    if (badge) badge.style.display = 'none';
                }
            }).catch(() => {});
    }

    function pollUnread() {
        fetch('${pageContext.request.contextPath}/api/v1/notifications/unread-count')
            .then(res => res.json())
            .then(data => {
                if (data && data.success) {
                    const el = document.getElementById('nav-bell-count');
                    if (el) el.innerText = data.data.unreadCount || 0;
                }
            }).catch(() => {});
    }

    function filterNotifs(type, btn) {
        document.querySelectorAll('.filter-tab').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        document.querySelectorAll('.notif-item').forEach(item => {
            item.style.display = (type === 'all' || item.dataset.type === type) ? '' : 'none';
        });
    }

    setInterval(pollUnread, 60000);
    window.onload = pollUnread;
</script>
</body>
</html>
