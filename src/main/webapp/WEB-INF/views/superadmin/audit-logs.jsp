<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="System Audit Logs"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp">
            <jsp:param name="activeMenu" value="audit-logs"/>
        </jsp:include>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="h3 fw-bold text-light mb-1">System Audit & Compliance Log</h2>
                        <p class="text-secondary small mb-0">Immutable record of authentication, data modifications, permission changes, and security events.</p>
                    </div>
                </div>

                <div class="sm-card p-4 rounded-4">
                    <div class="table-responsive">
                        <table class="table sm-table align-middle">
                            <thead>
                                <tr>
                                    <th>Timestamp</th>
                                    <th>Action</th>
                                    <th>Entity</th>
                                    <th>Entity ID</th>
                                    <th>Actor</th>
                                    <th>Client IP</th>
                                    <th>Details</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty logs}">
                                        <c:forEach var="log" items="${logs}">
                                            <tr>
                                                <td><small class="text-secondary"><fmt:formatDate value="${log.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></small></td>
                                                <td>
                                                    <span class="badge ${log.action.startsWith('CREATE') || log.action.startsWith('REGISTER') ? 'bg-success-subtle text-success' : (log.action.startsWith('DELETE') ? 'bg-danger-subtle text-danger' : 'bg-primary-subtle text-primary')}">
                                                        ${log.action}
                                                    </span>
                                                </td>
                                                <td><small class="text-light">${log.entityName}</small></td>
                                                <td><code>#${log.entityId}</code></td>
                                                <td>
                                                    <div class="small fw-medium text-light"><c:out value="${log.performedBy.fullName}"/></div>
                                                    <div class="text-secondary" style="font-size: 0.7rem;"><c:out value="${log.performedBy.email}"/></div>
                                                </td>
                                                <td><code class="small">${log.ipAddress}</code></td>
                                                <td><small class="text-secondary text-truncate d-block" style="max-width: 250px;"><c:out value="${log.details}"/></small></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" class="text-center py-4 text-secondary">No audit entries recorded yet.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/navigation.js"></script>
</body>
</html>

