<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Activity & Audit Logs"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp">
            <jsp:param name="activeMenu" value="logs"/>
        </jsp:include>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="h3 fw-bold text-light mb-1">Activity & Telemetry Logs</h2>
                        <p class="text-secondary small mb-0">System events, administrative modifications, security tracking, and file downloads.</p>
                    </div>
                </div>

                <div class="row g-4">
                    <!-- Audit Trail -->
                    <div class="col-lg-7">
                        <div class="sm-card p-4 rounded-4 mb-4">
                            <h5 class="fw-bold text-light mb-3"><i class="bi bi-shield-check text-warning me-2"></i> Administrative Audit Trail</h5>
                            <div class="table-responsive">
                                <table class="table sm-table align-middle">
                                    <thead>
                                        <tr>
                                            <th>Timestamp</th>
                                            <th>Action</th>
                                            <th>Target</th>
                                            <th>Performed By</th>
                                            <th>IP Address</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty recentAuditLogs}">
                                                <c:forEach var="log" items="${recentAuditLogs}">
                                                    <tr>
                                                        <td><small class="text-secondary"><fmt:formatDate value="${log.createdAt}" pattern="MMM dd, HH:mm:ss"/></small></td>
                                                        <td><span class="badge bg-primary-subtle text-primary small">${log.action}</span></td>
                                                        <td><small class="text-light">${log.entityName} #${log.entityId}</small></td>
                                                        <td><small class="text-secondary">${log.performedBy.fullName}</small></td>
                                                        <td><code class="small">${log.ipAddress}</code></td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="5" class="text-center py-4 text-secondary">No audit logs recorded yet.</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Download Telemetry -->
                    <div class="col-lg-5">
                        <div class="sm-card p-4 rounded-4 mb-4">
                            <h5 class="fw-bold text-light mb-3"><i class="bi bi-download text-primary me-2"></i> Recent File Downloads</h5>
                            <div class="table-responsive">
                                <table class="table sm-table align-middle">
                                    <thead>
                                        <tr>
                                            <th>Resource</th>
                                            <th>User</th>
                                            <th>Time</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty recentDownloads}">
                                                <c:forEach var="dl" items="${recentDownloads}">
                                                    <tr>
                                                        <td>
                                                            <div class="fw-semibold text-light text-truncate" style="max-width: 160px;">
                                                                <c:out value="${dl.resource.title}"/>
                                                            </div>
                                                        </td>
                                                        <td><small class="text-secondary"><c:out value="${dl.user != null ? dl.user.fullName : 'Guest'}"/></small></td>
                                                        <td><small class="text-secondary"><fmt:formatDate value="${dl.downloadedAt}" pattern="MMM dd, HH:mm"/></small></td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="3" class="text-center py-4 text-secondary">No downloads registered yet.</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
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

