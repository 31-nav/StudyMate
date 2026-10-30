<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Manage Administrators"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp">
            <jsp:param name="activeMenu" value="administrators"/>
        </jsp:include>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="h3 fw-bold text-light mb-1">Administrator Delegation</h2>
                        <p class="text-secondary small mb-0">Authorize staff members, manage department admins, and control administrative credentials.</p>
                    </div>

                    <button type="button" class="btn btn-warning fw-semibold text-dark d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#inviteAdminModal">
                        <i class="bi bi-person-plus-fill"></i> Invite Administrator
                    </button>
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

                <div class="sm-card p-4 rounded-4">
                    <div class="table-responsive">
                        <table class="table sm-table align-middle">
                            <thead>
                                <tr>
                                    <th>Administrator</th>
                                    <th>Role Clearance</th>
                                    <th>Email Verified</th>
                                    <th>Status</th>
                                    <th>Joined</th>
                                    <th>Last Activity</th>
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
                                            <span class="badge ${adm.emailVerified ? 'bg-success-subtle text-success' : 'bg-warning-subtle text-warning'}">
                                                ${adm.emailVerified ? 'Verified' : 'Pending'}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge ${adm.active ? 'bg-success-subtle text-success' : 'bg-secondary-subtle text-secondary'}">
                                                ${adm.active ? 'Active' : 'Suspended'}
                                            </span>
                                        </td>
                                        <td><small class="text-secondary"><fmt:formatDate value="${adm.createdAt}" pattern="MMM dd, yyyy"/></small></td>
                                        <td><small class="text-secondary"><fmt:formatDate value="${adm.lastLoginAt != null ? adm.lastLoginAt : adm.createdAt}" pattern="MMM dd, HH:mm"/></small></td>
                                        <td class="text-end">
                                            <c:if test="${adm.role.roleName != 'ROLE_SUPER_ADMIN'}">
                                                <form action="${pageContext.request.contextPath}/superadmin/administrators/toggle" method="post" class="d-inline">
                                                    <input type="hidden" name="_csrf" value="${csrfToken}">
                                                    <input type="hidden" name="id" value="${adm.id}">
                                                    <button type="submit" class="btn btn-sm ${adm.active ? 'btn-outline-danger' : 'btn-outline-success'} py-1 px-2">
                                                        ${adm.active ? 'Suspend' : 'Activate'}
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
            </main>
        </div>
    </div>

    <!-- Invite Admin Modal -->
    <div class="modal fade" id="inviteAdminModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content sm-glass-card border-secondary border-opacity-25">
                <div class="modal-header border-bottom border-secondary border-opacity-10">
                    <h5 class="modal-title text-light fw-bold">Invite Administrator</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/superadmin/administrators/invite" method="post">
                    <input type="hidden" name="_csrf" value="${csrfToken}">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label text-light small fw-medium">Institutional Email Address</label>
                            <input type="email" name="email" class="form-control sm-form-control" placeholder="faculty@university.edu" required>
                            <div class="form-text text-secondary" style="font-size: 0.72rem;">An invitation token will be dispatched to this address.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-light small fw-medium">Administrative Role</label>
                            <select name="role" class="form-select sm-form-control" required>
                                <option value="ROLE_ADMIN">ROLE_ADMIN (Standard Department Admin)</option>
                                <option value="ROLE_SUPER_ADMIN">ROLE_SUPER_ADMIN (Full Governance Access)</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer border-top border-secondary border-opacity-10">
                        <button type="button" class="btn btn-sm-outline" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-warning text-dark fw-semibold">Dispatch Invitation</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/navigation.js"></script>
</body>
</html>

