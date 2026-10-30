<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Curriculum Subjects"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser}">
                <jsp:include page="/WEB-INF/views/components/sidebar.jsp">
                    <jsp:param name="activeMenu" value="subjects"/>
                </jsp:include>
            </c:when>
        </c:choose>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>
                </c:when>
                <c:otherwise>
                    <jsp:include page="/WEB-INF/views/components/navbar.jsp"/>
                </c:otherwise>
            </c:choose>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <!-- Page Header & Filter Form -->
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="h3 fw-bold text-light mb-1">Academic Subjects</h2>
                        <p class="text-secondary small mb-0">Browse enrolled courses, syllabus outlines, and subject study materials.</p>
                    </div>

                    <!-- Course & Semester Filter -->
                    <form action="${pageContext.request.contextPath}/subjects" method="get" class="d-flex flex-wrap gap-2">
                        <select name="courseId" class="form-select sm-form-control form-select-sm" style="min-width: 180px;" onchange="this.form.submit()">
                            <option value="">All Degree Programs</option>
                            <c:forEach var="c" items="${courses}">
                                <option value="${c.id}" ${selectedCourseId == c.id ? 'selected' : ''}>
                                    <c:out value="${c.courseCode}"/> - <c:out value="${c.courseName}"/>
                                </option>
                            </c:forEach>
                        </select>

                        <c:if test="${not empty semesters}">
                            <select name="semesterId" class="form-select sm-form-control form-select-sm" style="min-width: 140px;" onchange="this.form.submit()">
                                <option value="">All Semesters</option>
                                <c:forEach var="s" items="${semesters}">
                                    <option value="${s.id}" ${selectedSemesterId == s.id ? 'selected' : ''}>
                                        Semester ${s.semesterNumber}
                                    </option>
                                </c:forEach>
                            </select>
                        </c:if>
                    </form>
                </div>

                <!-- Subjects Grid -->
                <div class="row g-4">
                    <c:choose>
                        <c:when test="${not empty subjects}">
                            <c:forEach var="sub" items="${subjects}">
                                <div class="col-md-6 col-xl-4">
                                    <div class="sm-card h-100 p-4 rounded-4 d-flex flex-column">
                                        <div class="d-flex align-items-center justify-content-between mb-3">
                                            <span class="badge bg-primary-subtle text-primary fw-bold">${sub.subjectCode}</span>
                                            <span class="badge bg-secondary-subtle text-secondary">
                                                Semester ${sub.semester.semesterNumber} &bull; ${sub.credits} Credits
                                            </span>
                                        </div>
                                        <h4 class="fw-bold text-light mb-2"><c:out value="${sub.subjectName}"/></h4>
                                        <p class="text-secondary small mb-3 flex-grow-1"><c:out value="${sub.description}"/></p>

                                        <div class="mb-3">
                                            <small class="text-secondary d-block mb-1">Degree Program:</small>
                                            <span class="badge bg-dark border border-secondary border-opacity-25 text-light">
                                                <i class="bi bi-mortarboard me-1"></i> <c:out value="${sub.course.courseName}"/>
                                            </span>
                                        </div>

                                        <div class="pt-3 border-top border-secondary border-opacity-10 d-flex justify-content-between align-items-center">
                                            <a href="${pageContext.request.contextPath}/resources?subjectId=${sub.id}" class="btn btn-sm btn-sm-primary w-100 d-flex align-items-center justify-content-center gap-2">
                                                <i class="bi bi-folder2-open"></i>
                                                <span>Access Learning Materials</span>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12 text-center py-5">
                                <div class="sm-glass-card p-5 rounded-4 max-w-md mx-auto">
                                    <i class="bi bi-journal-x fs-1 text-secondary opacity-50 mb-3 d-block"></i>
                                    <h4 class="fw-bold text-light mb-1">No Subjects Found</h4>
                                    <p class="text-secondary small mb-0">Try clearing the course filter or selecting a different academic program.</p>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>

            <c:if test="${empty sessionScope.currentUser}">
                <jsp:include page="/WEB-INF/views/components/footer.jsp"/>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/navigation.js"></script>
</body>
</html>

