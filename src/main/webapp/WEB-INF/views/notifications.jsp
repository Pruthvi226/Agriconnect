<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>AgriConnect - Notifications</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        function markAsRead(id) {
            fetch('/api/v1/notifications/' + id + '/read', { method: 'PUT' })
                .then(res => res.json())
                .then(data => {
                    if(data.success) {
                        document.getElementById('notif-' + id).classList.remove('bg-light', 'border-primary');
                        document.getElementById('badge-' + id).style.display = 'none';
                    }
                });
        }
        
        function pollUnread() {
            fetch('/api/v1/notifications/unread-count')
                .then(res => res.json())
                .then(data => {
                    if(data.success) {
                        document.getElementById('nav-bell-count').innerText = data.data.unreadCount;
                    }
                });
        }
        setInterval(pollUnread, 60000); // 60s polling
        window.onload = pollUnread;
    </script>
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-success mb-4">
    <div class="container">
        <a class="navbar-brand" href="#">AgriConnect</a>
        <div class="d-flex">
            <a href="/web/notifications" class="nav-link text-white position-relative">
                🔔 <span id="nav-bell-count" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">0</span>
            </a>
        </div>
    </div>
</nav>

<div class="container">
    <h2 class="mb-4">Your Notifications</h2>
    <div class="list-group">
        <c:forEach var="notif" items="${notifications}">
            <a href="#" id="notif-${notif.id}" onclick="markAsRead(${notif.id})" class="list-group-item list-group-item-action ${notif.read ? '' : 'bg-light border-primary'}">
                <div class="d-flex w-100 justify-content-between">
                    <h5 class="mb-1">${notif.title}
                        <c:if test="${!notif.read}">
                            <span id="badge-${notif.id}" class="badge bg-primary rounded-pill">New</span>
                        </c:if>
                    </h5>
                    <small class="text-muted">${notif.createdAt}</small>
                </div>
                <p class="mb-1">${notif.body}</p>
            </a>
        </c:forEach>
        <c:if test="${empty notifications}">
            <p class="text-muted">No notifications right now.</p>
        </c:if>
    </div>
</div>
</body>
</html>
