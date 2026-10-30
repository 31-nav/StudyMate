<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Manage Students"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp">
            <jsp:param name="activeMenu" value="students"/>
        </jsp:include>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="h3 fw-bold text-light mb-1">Student Accounts</h2>
                        <p class="text-secondary small mb-0">Inspect enrolled students, review account verification, and manage access.</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/admin/students" method="get" class="d-flex gap-2">
                        <input type="text" name="q" class="form-control sm-form-control form-control-sm" placeholder="Search name or roll no..." value="<c:out value='${query}'/>">
                        <select name="courseId" class="form-select sm-form-control form-select-sm" onchange="this.form.submit()">
                            <option value="">All Courses</option>
                            <c:forEach var="c" items="${courses}">
                                <option value="${c.id}" ${selectedCourseId == c.id ? 'selected' : ''}><c:out value="${c.courseCode}"/></option>
                            </c:forEach>
                        </select>
                        <button type="submit" class="btn btn-sm btn-primary">Search</button>
                    </form>
                </div>

                <!-- Flash Alerts -->
                <c:if test="${not empty sessionScope.flashSuccess}">
                    <div class="alert alert-success alert-dismissible fade show small py-2 px-3 border-0 bg-success bg-opacity-20 text-success mb-4" role="alert">
                        <i class="bi bi-check-circle me-1"></i> <c:out value="${sessionScope.flashSuccess}"/>
                        <button type="button" class="btn-close btn-close-white small p-2" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="flashSuccess" scope="session"/>
                </c:if>

                <div class="sm-card p-4 rounded-4">
                    <div class="table-responsive">
                        <table class="table sm-table align-middle">
                            <thead>
                                <tr>
                                    <th>Student</th>
                                    <th>Roll / ID</th>
                                    <th>Program</th>
                                    <th>Semester</th>
                                    <th>Verification</th>
                                    <th>Status</th>
                                    <th>Registered</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty students}">
                                        <c:forEach var="s" items="${students}">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center gap-2">
                                                        <div class="sm-avatar-xs bg-primary text-white rounded-circle d-flex align-items-center justify-content-center fw-bold">
                                                            ${s.fullName.substring(0, 1).toUpperCase()}
                                                        </div>
                                                        <div>
                                                            <div class="fw-semibold text-light"><c:out value="${s.fullName}"/></div>
                                                            <div class="text-secondary small"><c:out value="${s.email}"/></div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty s.rollNumber}">
                                                            <code><c:out value="${s.rollNumber}"/></code>
                                                        </c:when>
                                                        <c:otherwise><span class="text-secondary">&mdash;</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty s.course}">
                                                            <span class="badge bg-secondary-subtle text-secondary"><c:out value="${s.course.courseCode}"/></span>
                                                        </c:when>
                                                        <c:otherwise><span class="text-secondary">&mdash;</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty s.semester}">
                                                            <span>Sem ${s.semester.semesterNumber}</span>
                                                        </c:when>
                                                        <c:otherwise><span class="text-secondary">&mdash;</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="badge ${s.emailVerified ? 'bg-success-subtle text-success' : 'bg-warning-subtle text-warning'}">
                                                        ${s.emailVerified ? 'Verified' : 'Unverified'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge ${s.active ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'}">
                                                        ${s.active ? 'Active' : 'Suspended'}
                                                    </span>
                                                </td>
                                                <td><small class="text-secondary"><fmt:formatDate value="${s.createdAt}" pattern="MMM dd, yyyy"/></small></td>
                                                <td class="text-end">
                                                    <form action="${pageContext.request.contextPath}/admin/students/toggle-status" method="post" class="d-inline">
                                                        <input type="hidden" name="_csrf" value="${csrfToken}">
                                                        <input type="hidden" name="id" value="${s.id}">
                                                        <button type="submit" class="btn btn-sm ${s.active ? 'btn-outline-danger' : 'btn-outline-success'} py-1 px-2" title="${s.active ? 'Suspend Account' : 'Activate Account'}">
                                                            <i class="bi ${s.active ? 'bi-lock' : 'bi-unlock'}"></i> ${s.active ? 'Suspend' : 'Activate'}
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8" class="text-center py-4 text-secondary">No student accounts found.</td>
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

