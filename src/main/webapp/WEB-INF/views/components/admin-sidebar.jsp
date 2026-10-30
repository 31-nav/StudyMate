<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="sm-sidebar d-flex flex-column p-3">
    <!-- Brand Header -->
    <div class="d-flex align-items-center justify-content-between mb-4 px-2">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center text-decoration-none">
            <img src="${pageContext.request.contextPath}/assets/images/studymate-logo.svg" alt="StudyMate Logo" height="36">
        </a>
        <button type="button" class="btn btn-sm btn-sm-outline d-lg-none" id="sidebarCloseBtn" aria-label="Close sidebar">
            <i class="bi bi-x-lg"></i>
        </button>
    </div>

    <div class="px-2 mb-2">
        <span class="badge bg-warning-subtle text-warning border border-warning-subtle text-uppercase letter-spacing-1 small">
            <i class="bi bi-shield-check me-1"></i> Admin Portal
        </span>
    </div>

    <!-- Navigation Menu -->
    <ul class="nav nav-pills flex-column mb-auto gap-1">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/dashboard" 
               class="nav-link sm-nav-link ${activeMenu == 'admin-dashboard' ? 'active' : ''}">
                <i class="bi bi-speedometer2 me-2"></i>
                <span>Overview</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/students" 
               class="nav-link sm-nav-link ${activeMenu == 'students' ? 'active' : ''}">
                <i class="bi bi-people me-2"></i>
                <span>Students</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/courses" 
               class="nav-link sm-nav-link ${activeMenu == 'courses' ? 'active' : ''}">
                <i class="bi bi-mortarboard me-2"></i>
                <span>Courses & Programs</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/subjects" 
               class="nav-link sm-nav-link ${activeMenu == 'subjects' ? 'active' : ''}">
                <i class="bi bi-journals me-2"></i>
                <span>Subjects</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/resources" 
               class="nav-link sm-nav-link ${activeMenu == 'resources' ? 'active' : ''}">
                <i class="bi bi-cloud-arrow-up me-2"></i>
                <span>Manage Resources</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/announcements" 
               class="nav-link sm-nav-link ${activeMenu == 'announcements' ? 'active' : ''}">
                <i class="bi bi-megaphone me-2"></i>
                <span>Announcements</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/logs" 
               class="nav-link sm-nav-link ${activeMenu == 'logs' ? 'active' : ''}">
                <i class="bi bi-activity me-2"></i>
                <span>Activity Logs</span>
            </a>
        </li>

        <!-- Super Admin Section -->
        <c:if test="${sessionScope.currentUser.role.roleName == 'ROLE_SUPER_ADMIN'}">
            <li class="my-3 border-top border-secondary border-opacity-10"></li>
            <div class="px-2 mb-1 text-uppercase text-secondary small fw-semibold" style="font-size: 0.7rem; letter-spacing: 0.5px;">
                Super Admin Governance
            </div>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/superadmin/administrators" 
                   class="nav-link sm-nav-link ${activeMenu == 'administrators' ? 'active' : ''}">
                    <i class="bi bi-shield-lock me-2"></i>
                    <span>Administrators</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/superadmin/audit-logs" 
                   class="nav-link sm-nav-link ${activeMenu == 'audit-logs' ? 'active' : ''}">
                    <i class="bi bi-journal-text me-2"></i>
                    <span>Audit Logs</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/superadmin/settings" 
                   class="nav-link sm-nav-link ${activeMenu == 'settings' ? 'active' : ''}">
                    <i class="bi bi-sliders me-2"></i>
                    <span>System Settings</span>
                </a>
            </li>
        </c:if>

        <li class="my-3 border-top border-secondary border-opacity-10"></li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/student/dashboard" 
               class="nav-link sm-nav-link text-info">
                <i class="bi bi-arrow-left-circle me-2"></i>
                <span>Student View</span>
            </a>
        </li>
    </ul>

    <!-- Bottom User Section -->
    <div class="sm-user-card p-3 rounded-3 mt-auto border border-secondary border-opacity-10">
        <div class="d-flex align-items-center gap-3">
            <div class="sm-avatar bg-warning text-dark rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width: 40px; height: 40px;">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser.fullName}">
                        ${sessionScope.currentUser.fullName.substring(0, 1).toUpperCase()}
                    </c:when>
                    <c:otherwise>A</c:otherwise>
                </c:choose>
            </div>
            <div class="overflow-hidden">
                <h6 class="mb-0 text-truncate fw-semibold text-light fs-6">
                    <c:out value="${sessionScope.currentUser.fullName}"/>
                </h6>
                <small class="text-warning text-truncate d-block" style="font-size: 0.75rem;">
                    ${sessionScope.currentUser.role.roleName}
                </small>
            </div>
            <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-sm btn-sm-outline ms-auto text-danger" title="Logout">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </div>
</aside>

