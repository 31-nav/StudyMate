<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Manage Subjects"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp">
            <jsp:param name="activeMenu" value="subjects"/>
        </jsp:include>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="h3 fw-bold text-light mb-1">Curriculum Subjects</h2>
                        <p class="text-secondary small mb-0">Manage course modules, semester assignments, and credit structures.</p>
                    </div>

                    <button type="button" class="btn btn-primary fw-semibold d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#createSubjectModal">
                        <i class="bi bi-plus-lg"></i> Add New Subject
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
                                    <th>Subject Code</th>
                                    <th>Subject Name</th>
                                    <th>Course</th>
                                    <th>Semester</th>
                                    <th>Credits</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty subjects}">
                                        <c:forEach var="s" items="${subjects}">
                                            <tr>
                                                <td><span class="badge bg-primary-subtle text-primary fw-bold">${s.subjectCode}</span></td>
                                                <td>
                                                    <div class="fw-semibold text-light"><c:out value="${s.subjectName}"/></div>
                                                    <small class="text-secondary text-truncate d-block" style="max-width: 280px;"><c:out value="${s.description}"/></small>
                                                </td>
                                                <td><span class="badge bg-secondary-subtle text-secondary"><c:out value="${s.course.courseCode}"/></span></td>
                                                <td>Semester ${s.semester.semesterNumber}</td>
                                                <td>${s.credits} Credits</td>
                                                <td>
                                                    <span class="badge ${s.active ? 'bg-success-subtle text-success' : 'bg-secondary-subtle text-secondary'}">
                                                        ${s.active ? 'Active' : 'Inactive'}
                                                    </span>
                                                </td>
                                                <td class="text-end">
                                                    <form action="${pageContext.request.contextPath}/admin/subjects/delete" method="post" class="d-inline" onsubmit="return confirm('Delete this subject and its resources?')">
                                                        <input type="hidden" name="_csrf" value="${csrfToken}">
                                                        <input type="hidden" name="id" value="${s.id}">
                                                        <button type="submit" class="btn btn-sm btn-sm-outline text-danger p-1" title="Delete">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" class="text-center py-4 text-secondary">No subjects registered yet.</td>
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

    <!-- Create Subject Modal -->
    <div class="modal fade" id="createSubjectModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content sm-glass-card border-secondary border-opacity-25">
                <div class="modal-header border-bottom border-secondary border-opacity-10">
                    <h5 class="modal-title text-light fw-bold">Add Subject</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/subjects/create" method="post">
                    <input type="hidden" name="_csrf" value="${csrfToken}">
                    <div class="modal-body">
                        <div class="row g-2 mb-3">
                            <div class="col-sm-6">
                                <label class="form-label text-light small fw-medium">Course</label>
                                <select name="courseId" class="form-select sm-form-control" required>
                                    <c:forEach var="c" items="${courses}">
                                        <option value="${c.id}"><c:out value="${c.courseCode}"/> - <c:out value="${c.courseName}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-sm-6">
                                <label class="form-label text-light small fw-medium">Semester ID</label>
                                <select name="semesterId" class="form-select sm-form-control" required>
                                    <option value="1">Semester 1</option>
                                    <option value="2">Semester 2</option>
                                    <option value="3">Semester 3</option>
                                    <option value="4">Semester 4</option>
                                    <option value="5">Semester 5</option>
                                    <option value="6">Semester 6</option>
                                    <option value="7">Semester 7</option>
                                    <option value="8">Semester 8</option>
                                </select>
                            </div>
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-sm-6">
                                <label class="form-label text-light small fw-medium">Subject Code</label>
                                <input type="text" name="code" class="form-control sm-form-control" placeholder="e.g. CS301" required>
                            </div>
                            <div class="col-sm-6">
                                <label class="form-label text-light small fw-medium">Credit Hours</label>
                                <input type="number" name="creditHours" class="form-control sm-form-control" value="4" min="1" max="10" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-light small fw-medium">Subject Name</label>
                            <input type="text" name="name" class="form-control sm-form-control" placeholder="e.g. Operating Systems" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-light small fw-medium">Description</label>
                            <textarea name="description" class="form-control sm-form-control" rows="2" placeholder="Course outline and core syllabus topics"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-top border-secondary border-opacity-10">
                        <button type="button" class="btn btn-sm-outline" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Subject</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/navigation.js"></script>
</body>
</html>

