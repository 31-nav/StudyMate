<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="sm-sidebar d-flex flex-column p-3">
    <!-- Brand Header -->
    <div class="d-flex align-items-center justify-content-between mb-4 px-2">
        <a href="${pageContext.request.contextPath}/student/dashboard" class="d-flex align-items-center text-decoration-none">
            <img src="${pageContext.request.contextPath}/assets/images/studymate-logo.svg" alt="StudyMate Logo" height="36">
        </a>
        <button type="button" class="btn btn-sm btn-sm-outline d-lg-none" id="sidebarCloseBtn" aria-label="Close sidebar">
            <i class="bi bi-x-lg"></i>
        </button>
    </div>

    <!-- Navigation Menu -->
    <ul class="nav nav-pills flex-column mb-auto gap-1">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/student/dashboard" 
               class="nav-link sm-nav-link ${activeMenu == 'dashboard' ? 'active' : ''}">
                <i class="bi bi-grid-1x2 me-2"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/courses" 
               class="nav-link sm-nav-link ${activeMenu == 'courses' ? 'active' : ''}">
                <i class="bi bi-mortarboard me-2"></i>
                <span>Courses</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/subjects" 
               class="nav-link sm-nav-link ${activeMenu == 'subjects' ? 'active' : ''}">
                <i class="bi bi-book me-2"></i>
                <span>Subjects</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/resources" 
               class="nav-link sm-nav-link ${activeMenu == 'resources' ? 'active' : ''}">
                <i class="bi bi-folder2-open me-2"></i>
                <span>Browse Library</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/student/bookmarks" 
               class="nav-link sm-nav-link ${activeMenu == 'bookmarks' ? 'active' : ''}">
                <i class="bi bi-bookmark-star me-2"></i>
                <span>Saved Bookmarks</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/student/announcements" 
               class="nav-link sm-nav-link ${activeMenu == 'announcements' ? 'active' : ''}">
                <i class="bi bi-megaphone me-2"></i>
                <span>Announcements</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/student/notifications" 
               class="nav-link sm-nav-link ${activeMenu == 'notifications' ? 'active' : ''}">
                <i class="bi bi-bell me-2"></i>
                <span>Notifications</span>
                <c:if test="${unreadNotificationCount > 0}">
                    <span class="badge bg-danger rounded-pill ms-auto">${unreadNotificationCount}</span>
                </c:if>
            </a>
        </li>

        <li class="my-3 border-top border-secondary border-opacity-10"></li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/student/profile" 
               class="nav-link sm-nav-link ${activeMenu == 'profile' ? 'active' : ''}">
                <i class="bi bi-person-gear me-2"></i>
                <span>My Profile</span>
            </a>
        </li>
    </ul>

    <!-- Bottom User Section -->
    <div class="sm-user-card p-3 rounded-3 mt-auto border border-secondary border-opacity-10">
        <div class="d-flex align-items-center gap-3">
            <div class="sm-avatar bg-primary text-white rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width: 40px; height: 40px;">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser.fullName}">
                        ${sessionScope.currentUser.fullName.substring(0, 1).toUpperCase()}
                    </c:when>
                    <c:otherwise>S</c:otherwise>
                </c:choose>
            </div>
            <div class="overflow-hidden">
                <h6 class="mb-0 text-truncate fw-semibold text-light fs-6">
                    <c:out value="${sessionScope.currentUser.fullName}"/>
                </h6>
                <small class="text-secondary text-truncate d-block" style="font-size: 0.75rem;">
                    <c:out value="${sessionScope.currentUser.email}"/>
                </small>
            </div>
            <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-sm btn-sm-outline ms-auto text-danger" title="Logout">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </div>
</aside>

