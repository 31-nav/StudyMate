<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Student Dashboard"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <!-- Sidebar Navigation -->
        <jsp:include page="/WEB-INF/views/components/sidebar.jsp">
            <jsp:param name="activeMenu" value="dashboard"/>
        </jsp:include>

        <!-- Main Content Area -->
        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <!-- Topbar Header -->
            <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <!-- Welcome Banner -->
                <div class="sm-glass-card p-4 p-md-5 rounded-4 mb-4 border border-secondary border-opacity-20 position-relative overflow-hidden">
                    <div class="sm-hero-glow"></div>
                    <div class="position-relative z-1 d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                        <div>
                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle mb-2">Student Academic Workspace</span>
                            <h2 class="display-6 fw-bold text-light mb-1">
                                Welcome back, <c:out value="${user.fullName}"/>!
                            </h2>
                            <p class="text-secondary mb-0">
                                <c:choose>
                                    <c:when test="${not empty user.course}">
                                        Enrolled in <strong><c:out value="${user.course.courseName}"/></strong>
                                        <c:if test="${not empty user.semester}"> &bull; Semester ${user.semester.semesterNumber}</c:if>
                                    </c:when>
                                    <c:otherwise>
                                        Explore our academic library and customize your enrolled curriculum in your profile.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/resources" class="btn btn-primary fw-semibold d-flex align-items-center gap-2">
                                <i class="bi bi-search"></i> Browse Library
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Metric Cards -->
                <div class="row g-3 mb-4">
                    <div class="col-sm-6 col-xl-3">
                        <div class="sm-card p-3 rounded-4 h-100 d-flex align-items-center gap-3">
                            <div class="p-3 rounded-3 bg-primary bg-opacity-10 text-primary fs-3">
                                <i class="bi bi-bookmark-check"></i>
                            </div>
                            <div>
                                <h3 class="fw-bold text-light mb-0">${bookmarkedResources != null ? bookmarkedResources.size() : 0}</h3>
                                <small class="text-secondary">Saved Bookmarks</small>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-xl-3">
                        <div class="sm-card p-3 rounded-4 h-100 d-flex align-items-center gap-3">
                            <div class="p-3 rounded-3 bg-success bg-opacity-10 text-success fs-3">
                                <i class="bi bi-clock-history"></i>
                            </div>
                            <div>
                                <h3 class="fw-bold text-light mb-0">${recentlyViewed != null ? recentlyViewed.size() : 0}</h3>
                                <small class="text-secondary">Recently Accessed</small>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-xl-3">
                        <div class="sm-card p-3 rounded-4 h-100 d-flex align-items-center gap-3">
                            <div class="p-3 rounded-3 bg-warning bg-opacity-10 text-warning fs-3">
                                <i class="bi bi-megaphone"></i>
                            </div>
                            <div>
                                <h3 class="fw-bold text-light mb-0">${announcements != null ? announcements.size() : 0}</h3>
                                <small class="text-secondary">Announcements</small>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-xl-3">
                        <div class="sm-card p-3 rounded-4 h-100 d-flex align-items-center gap-3">
                            <div class="p-3 rounded-3 bg-info bg-opacity-10 text-info fs-3">
                                <i class="bi bi-bell"></i>
                            </div>
                            <div>
                                <h3 class="fw-bold text-light mb-0">${unreadNotificationCount != null ? unreadNotificationCount : 0}</h3>
                                <small class="text-secondary">Unread Alerts</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row g-4">
                    <!-- Left Column: Recently Viewed & Saved Bookmarks -->
                    <div class="col-lg-8">
                        <!-- Recently Viewed -->
                        <div class="sm-card p-4 rounded-4 mb-4">
                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <div class="d-flex align-items-center gap-2">
                                    <i class="bi bi-clock-history text-primary fs-5"></i>
                                    <h5 class="fw-bold text-light mb-0">Continue Learning</h5>
                                </div>
                                <span class="badge bg-secondary-subtle text-secondary">History</span>
                            </div>

                            <c:choose>
                                <c:when test="${not empty recentlyViewed}">
                                    <div class="d-flex flex-column gap-2">
                                        <c:forEach var="item" items="${recentlyViewed}">
                                            <div class="p-3 rounded-3 sm-resource-item d-flex align-items-center justify-content-between">
                                                <div class="d-flex align-items-center gap-3 overflow-hidden">
                                                    <div class="p-2 rounded bg-primary-subtle text-primary fs-4">
                                                        <i class="bi bi-file-earmark-text"></i>
                                                    </div>
                                                    <div class="overflow-hidden">
                                                        <a href="${pageContext.request.contextPath}/resources/view?id=${item.resource.id}" class="fw-semibold text-light text-decoration-none text-truncate d-block">
                                                            <c:out value="${item.resource.title}"/>
                                                        </a>
                                                        <span class="text-secondary small">
                                                            <c:out value="${item.resource.subject.subjectName}"/> &bull; <c:out value="${item.resource.category.categoryName}"/>
                                                        </span>
                                                    </div>
                                                </div>
                                                <div class="d-flex align-items-center gap-2">
                                                    <a href="${pageContext.request.contextPath}/resources/view?id=${item.resource.id}" class="btn btn-sm btn-sm-outline">
                                                        <i class="bi bi-eye"></i> View
                                                    </a>
                                                    <c:if test="${item.resource.resourceType != 'EXTERNAL_URL'}">
                                                        <a href="${pageContext.request.contextPath}/resources/download?id=${item.resource.id}" class="btn btn-sm btn-sm-primary" title="Download">
                                                            <i class="bi bi-download"></i>
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4 text-secondary">
                                        <i class="bi bi-journal-x fs-1 mb-2 d-block opacity-50"></i>
                                        <p class="mb-0">No resources accessed yet. Start exploring your subjects!</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Saved Bookmarks Quick Preview -->
                        <div class="sm-card p-4 rounded-4">
                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <div class="d-flex align-items-center gap-2">
                                    <i class="bi bi-bookmark-star text-warning fs-5"></i>
                                    <h5 class="fw-bold text-light mb-0">Saved for Quick Revision</h5>
                                </div>
                                <a href="${pageContext.request.contextPath}/student/bookmarks" class="text-primary small text-decoration-none">
                                    View All (${bookmarkedResources != null ? bookmarkedResources.size() : 0}) <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>

                            <c:choose>
                                <c:when test="${not empty bookmarkedResources}">
                                    <div class="d-flex flex-column gap-2">
                                        <c:forEach var="bm" items="${bookmarkedResources}" begin="0" end="3">
                                            <div class="p-3 rounded-3 sm-resource-item d-flex align-items-center justify-content-between">
                                                <div class="d-flex align-items-center gap-3 overflow-hidden">
                                                    <div class="p-2 rounded bg-warning-subtle text-warning fs-4">
                                                        <i class="bi bi-star-fill"></i>
                                                    </div>
                                                    <div class="overflow-hidden">
                                                        <a href="${pageContext.request.contextPath}/resources/view?id=${bm.resource.id}" class="fw-semibold text-light text-decoration-none text-truncate d-block">
                                                            <c:out value="${bm.resource.title}"/>
                                                        </a>
                                                        <span class="text-secondary small">
                                                            <c:out value="${bm.resource.subject.subjectCode}"/> &bull; <c:out value="${bm.resource.category.categoryName}"/>
                                                        </span>
                                                    </div>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/resources/view?id=${bm.resource.id}" class="btn btn-sm btn-sm-outline">
                                                    Open
                                                </a>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4 text-secondary">
                                        <p class="mb-0">You haven't bookmarked any study materials yet. Click the bookmark icon on any resource to save it here.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Right Column: Announcements & Quick Links -->
                    <div class="col-lg-4">
                        <!-- Announcements Widget -->
                        <div class="sm-card p-4 rounded-4 mb-4">
                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <div class="d-flex align-items-center gap-2">
                                    <i class="bi bi-megaphone text-danger fs-5"></i>
                                    <h5 class="fw-bold text-light mb-0">Announcements</h5>
                                </div>
                                <a href="${pageContext.request.contextPath}/student/announcements" class="text-primary small text-decoration-none">
                                    All Alerts
                                </a>
                            </div>

                            <c:choose>
                                <c:when test="${not empty announcements}">
                                    <div class="d-flex flex-column gap-3">
                                        <c:forEach var="ann" items="${announcements}" begin="0" end="3">
                                            <div class="p-3 rounded-3 sm-glass-item">
                                                <div class="d-flex align-items-center justify-content-between mb-1">
                                                    <span class="badge ${ann.priority == 'URGENT' ? 'bg-danger' : (ann.priority == 'HIGH' ? 'bg-warning text-dark' : 'bg-secondary')} small">
                                                        ${ann.priority}
                                                    </span>
                                                    <span class="text-secondary" style="font-size: 0.7rem;">
                                                        <fmt:formatDate value="${ann.publishDate}" pattern="MMM dd, yyyy"/>
                                                    </span>
                                                </div>
                                                <h6 class="fw-bold text-light mb-1"><c:out value="${ann.title}"/></h6>
                                                <p class="text-secondary small mb-0"><c:out value="${ann.content}"/></p>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-3 text-secondary small">
                                        No recent announcements.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Academic Quick Links -->
                        <div class="sm-card p-4 rounded-4">
                            <h5 class="fw-bold text-light mb-3">Quick Actions</h5>
                            <div class="d-flex flex-column gap-2">
                                <a href="${pageContext.request.contextPath}/courses" class="btn btn-sm-outline text-start py-2 px-3 d-flex align-items-center justify-content-between">
                                    <span><i class="bi bi-mortarboard me-2 text-primary"></i> Browse Degree Programs</span>
                                    <i class="bi bi-chevron-right text-secondary small"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/subjects" class="btn btn-sm-outline text-start py-2 px-3 d-flex align-items-center justify-content-between">
                                    <span><i class="bi bi-journals me-2 text-info"></i> View Enrolled Subjects</span>
                                    <i class="bi bi-chevron-right text-secondary small"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/student/profile" class="btn btn-sm-outline text-start py-2 px-3 d-flex align-items-center justify-content-between">
                                    <span><i class="bi bi-person-gear me-2 text-warning"></i> Manage Profile & Password</span>
                                    <i class="bi bi-chevron-right text-secondary small"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/navigation.js"></script>
</body>
</html>

