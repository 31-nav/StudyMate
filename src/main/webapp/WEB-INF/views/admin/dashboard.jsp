<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Administrator Overview"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp">
            <jsp:param name="activeMenu" value="admin-dashboard"/>
        </jsp:include>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <!-- Header -->
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <span class="badge bg-warning-subtle text-warning border border-warning-subtle mb-1">Administrative Operations</span>
                        <h2 class="h3 fw-bold text-light mb-1">System Command Dashboard</h2>
                        <p class="text-secondary small mb-0">Platform overview, learning metrics, and academic inventory management.</p>
                    </div>

                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/admin/resources" class="btn btn-primary fw-semibold d-flex align-items-center gap-2">
                            <i class="bi bi-cloud-arrow-up"></i> Manage Resources
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

                <!-- Platform Live KPI Cards -->
                <div class="row g-3 mb-4">
                    <div class="col-sm-6 col-xl-3">
                        <div class="sm-card p-3 rounded-4 h-100 d-flex align-items-center gap-3">
                            <div class="p-3 rounded-3 bg-primary bg-opacity-10 text-primary fs-3">
                                <i class="bi bi-mortarboard"></i>
                            </div>
                            <div>
                                <h3 class="fw-bold text-light mb-0">${stats['totalCourses'] != null ? stats['totalCourses'] : 0}</h3>
                                <small class="text-secondary">Degree Programs</small>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-xl-3">
                        <div class="sm-card p-3 rounded-4 h-100 d-flex align-items-center gap-3">
                            <div class="p-3 rounded-3 bg-success bg-opacity-10 text-success fs-3">
                                <i class="bi bi-journal-bookmark"></i>
                            </div>
                            <div>
                                <h3 class="fw-bold text-light mb-0">${stats['totalSubjects'] != null ? stats['totalSubjects'] : 0}</h3>
                                <small class="text-secondary">Active Subjects</small>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-xl-3">
                        <div class="sm-card p-3 rounded-4 h-100 d-flex align-items-center gap-3">
                            <div class="p-3 rounded-3 bg-warning bg-opacity-10 text-warning fs-3">
                                <i class="bi bi-files"></i>
                            </div>
                            <div>
                                <h3 class="fw-bold text-light mb-0">${stats['totalResources'] != null ? stats['totalResources'] : 0}</h3>
                                <small class="text-secondary">Published Materials</small>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-xl-3">
                        <div class="sm-card p-3 rounded-4 h-100 d-flex align-items-center gap-3">
                            <div class="p-3 rounded-3 bg-info bg-opacity-10 text-info fs-3">
                                <i class="bi bi-people"></i>
                            </div>
                            <div>
                                <h3 class="fw-bold text-light mb-0">${stats['totalStudents'] != null ? stats['totalStudents'] : 0}</h3>
                                <small class="text-secondary">Enrolled Students</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row g-4">
                    <!-- Recent Uploads Table -->
                    <div class="col-lg-8">
                        <div class="sm-card p-4 rounded-4 mb-4">
                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <h5 class="fw-bold text-light mb-0">Recent Resource Uploads</h5>
                                <a href="${pageContext.request.contextPath}/admin/resources" class="text-primary small text-decoration-none">
                                    Manage All <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>

                            <div class="table-responsive">
                                <table class="table sm-table align-middle">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>Subject</th>
                                            <th>Category</th>
                                            <th>Type</th>
                                            <th>Uploaded By</th>
                                            <th class="text-end">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty recentUploads}">
                                                <c:forEach var="res" items="${recentUploads}">
                                                    <tr>
                                                        <td>
                                                            <div class="fw-semibold text-light text-truncate" style="max-width: 200px;">
                                                                <c:out value="${res.title}"/>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-secondary-subtle text-secondary">
                                                                <c:out value="${res.subject.subjectCode}"/>
                                                            </span>
                                                        </td>
                                                        <td><small class="text-secondary"><c:out value="${res.category.categoryName}"/></small></td>
                                                        <td>
                                                            <span class="badge ${res.resourceType == 'PDF' ? 'bg-danger-subtle text-danger' : 'bg-primary-subtle text-primary'}">
                                                                ${res.resourceType}
                                                            </span>
                                                        </td>
                                                        <td><small class="text-secondary"><c:out value="${res.uploadedBy.fullName}"/></small></td>
                                                        <td class="text-end">
                                                            <a href="${pageContext.request.contextPath}/resources/view?id=${res.id}" class="btn btn-sm btn-sm-outline p-1" title="Preview">
                                                                <i class="bi bi-eye"></i>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="6" class="text-center py-4 text-secondary">No materials uploaded yet.</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Students Widget -->
                    <div class="col-lg-4">
                        <div class="sm-card p-4 rounded-4 mb-4">
                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <h5 class="fw-bold text-light mb-0">Recent Registrations</h5>
                                <a href="${pageContext.request.contextPath}/admin/students" class="text-primary small text-decoration-none">
                                    All Students
                                </a>
                            </div>

                            <c:choose>
                                <c:when test="${not empty recentStudents}">
                                    <div class="d-flex flex-column gap-3">
                                        <c:forEach var="student" items="${recentStudents}">
                                            <div class="p-3 rounded-3 sm-glass-item d-flex align-items-center justify-content-between">
                                                <div class="d-flex align-items-center gap-3 overflow-hidden">
                                                    <div class="sm-avatar-xs bg-primary text-white rounded-circle d-flex align-items-center justify-content-center fw-bold">
                                                        ${student.fullName.substring(0, 1).toUpperCase()}
                                                    </div>
                                                    <div class="overflow-hidden">
                                                        <div class="fw-semibold text-light small text-truncate"><c:out value="${student.fullName}"/></div>
                                                        <div class="text-secondary" style="font-size: 0.72rem;"><c:out value="${student.email}"/></div>
                                                    </div>
                                                </div>
                                                <span class="badge ${student.active ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'} small">
                                                    ${student.active ? 'Active' : 'Locked'}
                                                </span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4 text-secondary small">No registered students yet.</div>
                                </c:otherwise>
                            </c:choose>
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

