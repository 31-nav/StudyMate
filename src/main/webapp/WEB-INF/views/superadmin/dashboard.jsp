<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Super Admin Governance"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp">
            <jsp:param name="activeMenu" value="admin-dashboard"/>
        </jsp:include>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle mb-1">Highest Authority Clearance</span>
                        <h2 class="h3 fw-bold text-light mb-1">Super Admin Governance Portal</h2>
                        <p class="text-secondary small mb-0">Platform infrastructure oversight, administrator delegation, and security audit monitoring.</p>
                    </div>

                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/superadmin/administrators" class="btn btn-warning fw-semibold text-dark d-flex align-items-center gap-2">
                            <i class="bi bi-person-plus-fill"></i> Manage Administrators
                        </a>
                    </div>
                </div>

                <!-- Flash Alerts -->
                <c:if test="${not empty sessionScope.flashSuccess}">
                    <div class="alert alert-success alert-dismissible fade show small py-2 px-3 border-0 bg-success bg-opacity-20 text-success mb-4" role="alert">
                        <i class="bi bi-check-circle me-1"></i> <c:out value="${sessionScope.flashSuccess}"/>
                        <button type="button" class="btn-close btn-close-white small p-2" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="flashSuccess" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.flashError}">
                    <div class="alert alert-danger alert-dismissible fade show small py-2 px-3 border-0 bg-danger bg-opacity-20 text-danger mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle me-1"></i> <c:out value="${sessionScope.flashError}"/>
                        <button type="button" class="btn-close btn-close-white small p-2" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="flashError" scope="session"/>
                </c:if>

                <!-- System KPI Cards -->
                <div class="row g-3 mb-4">
                    <div class="col-sm-6 col-xl-3">
                        <div class="sm-card p-3 rounded-4 h-100 d-flex align-items-center gap-3">
                            <div class="p-3 rounded-3 bg-danger bg-opacity-10 text-danger fs-3">
                                <i class="bi bi-shield-lock"></i>
                            </div>
                            <div>
                                <h3 class="fw-bold text-light mb-0">${stats['totalAdmins'] != null ? stats['totalAdmins'] : 1}</h3>
                                <small class="text-secondary">Authorized Admins</small>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-xl-3">
                        <div class="sm-card p-3 rounded-4 h-100 d-flex align-items-center gap-3">
                            <div class="p-3 rounded-3 bg-primary bg-opacity-10 text-primary fs-3">
                                <i class="bi bi-people"></i>
                            </div>
                            <div>
                                <h3 class="fw-bold text-light mb-0">${stats['totalStudents'] != null ? stats['totalStudents'] : 0}</h3>
                                <small class="text-secondary">Registered Students</small>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-xl-3">
                        <div class="sm-card p-3 rounded-4 h-100 d-flex align-items-center gap-3">
                            <div class="p-3 rounded-3 bg-success bg-opacity-10 text-success fs-3">
                                <i class="bi bi-database-check"></i>
                            </div>
                            <div>
                                <h3 class="fw-bold text-light mb-0">${stats['totalResources'] != null ? stats['totalResources'] : 0}</h3>
                                <small class="text-secondary">Library Assets</small>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-xl-3">
                        <div class="sm-card p-3 rounded-4 h-100 d-flex align-items-center gap-3">
                            <div class="p-3 rounded-3 bg-info bg-opacity-10 text-info fs-3">
                                <i class="bi bi-hdd-network"></i>
                            </div>
                            <div>
                                <h3 class="fw-bold text-light mb-0">PostgreSQL 16</h3>
                                <small class="text-secondary">Database Health: Active</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row g-4">
                    <!-- Administrators List -->
                    <div class="col-lg-8">
                        <div class="sm-card p-4 rounded-4 mb-4">
                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <h5 class="fw-bold text-light mb-0">System Administrators</h5>
                                <a href="${pageContext.request.contextPath}/superadmin/administrators" class="text-primary small text-decoration-none">
                                    Full Roster <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>

                            <div class="table-responsive">
                                <table class="table sm-table align-middle">
                                    <thead>
                                        <tr>
                                            <th>Administrator</th>
                                            <th>Role</th>
                                            <th>Status</th>
                                            <th>Last Login</th>
                                            <th class="text-end">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="adm" items="${admins}">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center gap-2">
                                                        <div class="sm-avatar-xs bg-warning text-dark rounded-circle d-flex align-items-center justify-content-center fw-bold">
                                                            ${adm.fullName.substring(0, 1).toUpperCase()}
                                                        </div>
                                                        <div>
                                                            <div class="fw-semibold text-light"><c:out value="${adm.fullName}"/></div>
                                                            <div class="text-secondary small"><c:out value="${adm.email}"/></div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge ${adm.role.roleName == 'ROLE_SUPER_ADMIN' ? 'bg-danger text-light' : 'bg-warning-subtle text-warning'}">
                                                        ${adm.role.roleName}
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge ${adm.active ? 'bg-success-subtle text-success' : 'bg-secondary-subtle text-secondary'}">
                                                        ${adm.active ? 'Active' : 'Suspended'}
                                                    </span>
                                                </td>
                                                <td><small class="text-secondary"><fmt:formatDate value="${adm.lastLoginAt != null ? adm.lastLoginAt : adm.createdAt}" pattern="MMM dd, HH:mm"/></small></td>
                                                <td class="text-end">
                                                    <c:if test="${adm.role.roleName != 'ROLE_SUPER_ADMIN'}">
                                                        <form action="${pageContext.request.contextPath}/superadmin/administrators/toggle" method="post" class="d-inline">
                                                            <input type="hidden" name="_csrf" value="${csrfToken}">
                                                            <input type="hidden" name="id" value="${adm.id}">
                                                            <button type="submit" class="btn btn-sm ${adm.active ? 'btn-outline-danger' : 'btn-outline-success'} py-1 px-2">
                                                                ${adm.active ? 'Deactivate' : 'Activate'}
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Quick System Specs -->
                    <div class="col-lg-4">
                        <div class="sm-card p-4 rounded-4 mb-4">
                            <h5 class="fw-bold text-light mb-3">Platform Environment</h5>
                            <div class="d-flex flex-column gap-3 text-secondary small">
                                <div class="d-flex justify-content-between">
                                    <span>Java Runtime:</span>
                                    <span class="text-light fw-medium">Java 21 LTS (Jakarta EE 10)</span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span>Servlet Container:</span>
                                    <span class="text-light fw-medium">Apache Tomcat 10.1.34</span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span>Persistence:</span>
                                    <span class="text-light fw-medium">Hibernate 6.4 + Direct JDBC</span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span>Database:</span>
                                    <span class="text-light fw-medium">PostgreSQL 16.6</span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span>Security Enforcer:</span>
                                    <span class="text-light fw-medium">BCrypt 12 + CSRF Tokens</span>
                                </div>
                            </div>
                        </div>

                        <div class="sm-card p-4 rounded-4">
                            <h5 class="fw-bold text-light mb-3">Super Admin Actions</h5>
                            <div class="d-flex flex-column gap-2">
                                <a href="${pageContext.request.contextPath}/superadmin/audit-logs" class="btn btn-sm-outline text-start py-2 px-3 d-flex align-items-center justify-content-between">
                                    <span><i class="bi bi-journal-text me-2 text-warning"></i> Enterprise Audit Logs</span>
                                    <i class="bi bi-chevron-right text-secondary small"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/superadmin/settings" class="btn btn-sm-outline text-start py-2 px-3 d-flex align-items-center justify-content-between">
                                    <span><i class="bi bi-sliders me-2 text-info"></i> System Settings & Storage</span>
                                    <i class="bi bi-chevron-right text-secondary small"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/navigation.js"></script>
</body>
</html>

