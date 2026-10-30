<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Manage Courses"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp">
            <jsp:param name="activeMenu" value="courses"/>
        </jsp:include>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="h3 fw-bold text-light mb-1">Degree Programs & Courses</h2>
                        <p class="text-secondary small mb-0">Configure academic programs, curriculum structures, and semester progressions.</p>
                    </div>

                    <button type="button" class="btn btn-primary fw-semibold d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#createCourseModal">
                        <i class="bi bi-plus-lg"></i> Create Program
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

                <!-- Courses List -->
                <div class="row g-4">
                    <c:forEach var="c" items="${courses}">
                        <div class="col-md-6 col-xl-4">
                            <div class="sm-card h-100 p-4 rounded-4 d-flex flex-column">
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <span class="badge bg-primary-subtle text-primary fs-6 fw-bold">${c.courseCode}</span>
                                    <span class="badge bg-secondary-subtle text-secondary">${c.totalSemesters} Semesters</span>
                                </div>
                                <h4 class="fw-bold text-light mb-2"><c:out value="${c.courseName}"/></h4>
                                <p class="text-secondary small mb-4 flex-grow-1"><c:out value="${c.description}"/></p>

                                <div class="pt-3 border-top border-secondary border-opacity-10 d-flex justify-content-between align-items-center">
                                    <span class="text-secondary small">Status: <span class="text-success fw-medium">Active</span></span>
                                    <a href="${pageContext.request.contextPath}/admin/subjects?courseId=${c.id}" class="btn btn-sm btn-sm-outline">
                                        Manage Subjects <i class="bi bi-arrow-right ms-1"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </main>
        </div>
    </div>

    <!-- Create Course Modal -->
    <div class="modal fade" id="createCourseModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content sm-glass-card border-secondary border-opacity-25">
                <div class="modal-header border-bottom border-secondary border-opacity-10">
                    <h5 class="modal-title text-light fw-bold">Create Degree Program</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/courses/create" method="post">
                    <input type="hidden" name="_csrf" value="${csrfToken}">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label text-light small fw-medium">Course Code</label>
                            <input type="text" name="code" class="form-control sm-form-control" placeholder="e.g. BTECH-CSE" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-light small fw-medium">Course Name</label>
                            <input type="text" name="name" class="form-control sm-form-control" placeholder="e.g. B.Tech Computer Science & Engineering" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-light small fw-medium">Total Semesters</label>
                            <input type="number" name="totalSemesters" class="form-control sm-form-control" value="8" min="1" max="12" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-light small fw-medium">Description</label>
                            <textarea name="description" class="form-control sm-form-control" rows="3" placeholder="Overview of curriculum and academic focus"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-top border-secondary border-opacity-10">
                        <button type="button" class="btn btn-sm-outline" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Create Program</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/navigation.js"></script>
</body>
</html>

