<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Academic Announcements"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <jsp:include page="/WEB-INF/views/components/sidebar.jsp">
            <jsp:param name="activeMenu" value="announcements"/>
        </jsp:include>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="h3 fw-bold text-light mb-1">Campus Announcements</h2>
                        <p class="text-secondary small mb-0">Official updates from faculty, examination board, and university administrators.</p>
                    </div>
                </div>

                <div class="row g-4">
                    <c:choose>
                        <c:when test="${not empty announcements}">
                            <c:forEach var="ann" items="${announcements}">
                                <div class="col-md-6">
                                    <div class="sm-card h-100 p-4 rounded-4 d-flex flex-column ${ann.priority == 'URGENT' ? 'border-danger border-opacity-50' : ''}">
                                        <div class="d-flex align-items-center justify-content-between mb-3">
                                            <span class="badge ${ann.priority == 'URGENT' ? 'bg-danger text-light' : (ann.priority == 'HIGH' ? 'bg-warning text-dark' : 'bg-primary-subtle text-primary')} fw-semibold">
                                                <i class="bi ${ann.priority == 'URGENT' ? 'bi-exclamation-octagon' : 'bi-info-circle'} me-1"></i>
                                                ${ann.priority} Priority
                                            </span>
                                            <span class="text-secondary small">
                                                <fmt:formatDate value="${ann.publishDate}" pattern="MMMM dd, yyyy"/>
                                            </span>
                                        </div>

                                        <h4 class="fw-bold text-light mb-2"><c:out value="${ann.title}"/></h4>
                                        <p class="text-secondary mb-4 flex-grow-1 leading-relaxed"><c:out value="${ann.content}"/></p>

                                        <div class="pt-3 border-top border-secondary border-opacity-10 d-flex align-items-center justify-content-between text-secondary small">
                                            <span>
                                                <i class="bi bi-person me-1"></i> Published by <strong class="text-light"><c:out value="${ann.author.fullName}"/></strong>
                                            </span>
                                            <span class="badge bg-secondary-subtle text-secondary">
                                                Target: ${ann.targetAudience}
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12 text-center py-5">
                                <div class="sm-glass-card p-5 rounded-4 max-w-md mx-auto">
                                    <i class="bi bi-megaphone-fill fs-1 text-secondary opacity-50 mb-3 d-block"></i>
                                    <h4 class="fw-bold text-light mb-1">No Active Announcements</h4>
                                    <p class="text-secondary small mb-0">Check back later for university and course updates.</p>
                                </div>
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

