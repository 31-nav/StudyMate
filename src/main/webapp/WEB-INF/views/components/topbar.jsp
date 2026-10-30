<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="sm-topbar d-flex align-items-center justify-content-between px-4 py-3 border-bottom border-secondary border-opacity-10">
    <div class="d-flex align-items-center gap-3">
        <button type="button" class="btn btn-sm-outline d-lg-none" id="sidebarToggleBtn" aria-label="Toggle sidebar">
            <i class="bi bi-list fs-5"></i>
        </button>
        <form class="d-none d-md-flex align-items-center sm-search-bar" action="${pageContext.request.contextPath}/resources" method="get">
            <i class="bi bi-search text-secondary ms-3"></i>
            <input type="text" name="q" class="form-control bg-transparent border-0 shadow-none ps-2" 
                   placeholder="Search courses, subjects, notes, past papers..." 
                   value="<c:out value='${param.q}'/>">
            <button type="submit" class="btn btn-sm btn-sm-primary me-1 px-3">Search</button>
        </form>
    </div>

    <div class="d-flex align-items-center gap-3">
        <!-- Theme Switcher -->
        <button type="button" class="btn btn-sm-outline btn-theme-toggle p-2 rounded-circle" title="Toggle theme">
            <i class="bi bi-moon-stars theme-toggle-icon"></i>
        </button>

        <!-- Notifications Indicator -->
        <a href="${pageContext.request.contextPath}/student/notifications" 
           class="btn btn-sm-outline position-relative p-2 rounded-circle" title="Notifications">
            <i class="bi bi-bell"></i>
            <c:if test="${unreadNotificationCount > 0}">
                <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger border border-dark rounded-circle">
                    <span class="visually-hidden">New alerts</span>
                </span>
            </c:if>
        </a>

        <!-- Profile Dropdown -->
        <div class="dropdown">
            <button class="btn btn-sm-outline d-flex align-items-center gap-2 py-1 px-2 rounded-pill dropdown-toggle border-0" 
                    type="button" data-bs-toggle="dropdown" aria-expanded="false">
                <div class="sm-avatar-xs bg-primary text-white rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width: 32px; height: 32px; font-size: 0.85rem;">
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser.fullName}">
                            ${sessionScope.currentUser.fullName.substring(0, 1).toUpperCase()}
                        </c:when>
                        <c:otherwise>U</c:otherwise>
                    </c:choose>
                </div>
                <span class="d-none d-sm-inline text-light fw-medium small">
                    <c:out value="${sessionScope.currentUser.fullName}"/>
                </span>
            </button>
            <ul class="dropdown-menu dropdown-menu-end sm-glass-dropdown shadow-lg mt-2 py-2">
                <li class="px-3 py-2 border-bottom border-secondary border-opacity-10">
                    <div class="fw-semibold text-light"><c:out value="${sessionScope.currentUser.fullName}"/></div>
                    <div class="text-secondary small text-truncate" style="max-width: 180px;"><c:out value="${sessionScope.currentUser.email}"/></div>
                    <span class="badge bg-primary-subtle text-primary mt-1">${sessionScope.currentUser.role.roleName}</span>
                </li>
                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/student/profile"><i class="bi bi-person me-2"></i> My Profile</a></li>
                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/student/bookmarks"><i class="bi bi-bookmark me-2"></i> Saved Resources</a></li>
                <c:if test="${sessionScope.currentUser.role.roleName == 'ROLE_ADMIN' || sessionScope.currentUser.role.roleName == 'ROLE_SUPER_ADMIN'}">
                    <li><hr class="dropdown-divider border-secondary border-opacity-10"></li>
                    <li><a class="dropdown-item py-2 text-warning" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer me-2"></i> Admin Console</a></li>
                </c:if>
                <c:if test="${sessionScope.currentUser.role.roleName == 'ROLE_SUPER_ADMIN'}">
                    <li><a class="dropdown-item py-2 text-info" href="${pageContext.request.contextPath}/superadmin/dashboard"><i class="bi bi-shield-lock me-2"></i> Super Admin Panel</a></li>
                </c:if>
                <li><hr class="dropdown-divider border-secondary border-opacity-10"></li>
                <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/auth/logout"><i class="bi bi-box-arrow-right me-2"></i> Sign Out</a></li>
            </ul>
        </div>
    </div>
</header>

