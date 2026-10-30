<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Degree Programs & Courses"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser}">
                <jsp:include page="/WEB-INF/views/components/sidebar.jsp">
                    <jsp:param name="activeMenu" value="courses"/>
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
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="h3 fw-bold text-light mb-1">Degree Programs & Courses</h2>
                        <p class="text-secondary small mb-0">Select a course to view its semester structures and curriculum subjects.</p>
                    </div>
                </div>

                <div class="row g-4">
                    <c:forEach var="course" items="${courses}">
                        <div class="col-md-6 col-xl-4">
                            <div class="sm-card h-100 p-4 rounded-4 d-flex flex-column">
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <span class="badge bg-primary-subtle text-primary fs-6 fw-bold">${course.courseCode}</span>
                                    <span class="badge bg-secondary-subtle text-secondary">
                                        <i class="bi bi-clock me-1"></i> ${course.totalSemesters} Semesters
                                    </span>
                                </div>
                                <h4 class="fw-bold text-light mb-2"><c:out value="${course.courseName}"/></h4>
                                <p class="text-secondary small mb-4 flex-grow-1"><c:out value="${course.description}"/></p>

                                <div class="pt-3 border-top border-secondary border-opacity-10 d-flex justify-content-between align-items-center">
                                    <span class="text-secondary small">Active Curriculum</span>
                                    <a href="${pageContext.request.contextPath}/subjects?courseId=${course.id}" class="btn btn-sm btn-sm-primary d-flex align-items-center gap-2">
                                        <span>View Subjects</span>
                                        <i class="bi bi-arrow-right"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
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

