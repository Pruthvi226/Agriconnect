<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="navPage" value="farmer-nav.jsp" />
<sec:authorize access="hasRole('BUYER')">
    <c:set var="navPage" value="buyer-nav.jsp" />
</sec:authorize>
<sec:authorize access="hasRole('AGRI_EXPERT')">
    <c:set var="navPage" value="expert-nav.jsp" />
</sec:authorize>
<sec:authorize access="hasRole('ADMIN')">
    <c:set var="navPage" value="admin-nav.jsp" />
</sec:authorize>

<jsp:include page="${navPage}">
    <jsp:param name="active" value="${param.active}" />
</jsp:include>
