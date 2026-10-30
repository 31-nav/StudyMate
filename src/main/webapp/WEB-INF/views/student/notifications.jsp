<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Notifications"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <jsp:include page="/WEB-INF/views/components/sidebar.jsp">
            <jsp:param name="activeMenu" value="notifications"/>
        </jsp:include>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="h3 fw-bold text-light mb-1">Activity & Alerts</h2>
                        <p class="text-secondary small mb-0">Direct notifications regarding newly uploaded materials, announcements, and account security.</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/student/notifications/read-all" method="post">
                        <input type="hidden" name="_csrf" value="${csrfToken}">
                        <button type="submit" class="btn btn-sm btn-sm-outline d-flex align-items-center gap-2">
                            <i class="bi bi-check2-all"></i> Mark All as Read
                        </button>
                    </form>
                </div>

                <div class="sm-card p-4 rounded-4 max-w-3xl">
                    <c:choose>
                        <c:when test="${not empty notifications}">
                            <div class="d-flex flex-column gap-2">
                                <c:forEach var="notif" items="${notifications}">
                                    <div class="p-3 rounded-3 sm-notification-item d-flex align-items-start gap-3 ${not notif.read ? 'border-start border-3 border-primary bg-primary bg-opacity-10' : ''}">
                                        <div class="p-2 rounded-circle bg-secondary bg-opacity-20 text-light mt-1">
                                            <i class="bi ${notif.notificationType == 'RESOURCE_UPLOAD' ? 'bi-file-earmark-plus' : (notif.notificationType == 'ANNOUNCEMENT' ? 'bi-megaphone' : 'bi-bell')}"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="d-flex align-items-center justify-content-between mb-1">
                                                <h6 class="fw-semibold text-light mb-0"><c:out value="${notif.title}"/></h6>
                                                <span class="text-secondary small">
                                                    <fmt:formatDate value="${notif.createdAt}" pattern="MMM dd, hh:mm a"/>
                                                </span>
                                            </div>
                                            <p class="text-secondary small mb-1"><c:out value="${notif.message}"/></p>
                                            <c:if test="${not empty notif.targetUrl}">
                                                <a href="${pageContext.request.contextPath}${notif.targetUrl}" class="small text-primary text-decoration-none">
                                                    View Details <i class="bi bi-arrow-right"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5 text-secondary">
                                <i class="bi bi-bell-slash fs-1 opacity-50 mb-3 d-block"></i>
                                <h5 class="fw-semibold text-light mb-1">All Caught Up</h5>
                                <p class="small mb-0">You have no new alerts or notifications at this moment.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/navigation.js"></script>
</body>
</html>

