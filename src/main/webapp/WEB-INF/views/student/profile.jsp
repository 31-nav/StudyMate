<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="My Profile"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <jsp:include page="/WEB-INF/views/components/sidebar.jsp">
            <jsp:param name="activeMenu" value="profile"/>
        </jsp:include>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="h3 fw-bold text-light mb-1">Student Profile & Settings</h2>
                        <p class="text-secondary small mb-0">Manage your personal details, academic enrollment, and account credentials.</p>
                    </div>
                </div>

                <!-- Flash Messages -->
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

                <div class="row g-4">
                    <!-- Profile Information Card -->
                    <div class="col-lg-7">
                        <div class="sm-card p-4 rounded-4 mb-4">
                            <h5 class="fw-bold text-light mb-3">Academic Identity</h5>

                            <form action="${pageContext.request.contextPath}/student/profile" method="post">
                                <input type="hidden" name="_csrf" value="${csrfToken}">

                                <div class="mb-3">
                                    <label class="form-label text-light small fw-medium">Full Name</label>
                                    <input type="text" name="fullName" class="form-control sm-form-control" value="<c:out value='${user.fullName}'/>" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-light small fw-medium">Email Address</label>
                                    <input type="email" class="form-control sm-form-control text-secondary" value="<c:out value='${user.email}'/>" readonly disabled>
                                    <div class="form-text text-secondary" style="font-size: 0.72rem;">Email address cannot be modified once verified.</div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-light small fw-medium">Roll / Registration Number</label>
                                    <input type="text" name="rollNumber" class="form-control sm-form-control" value="<c:out value='${user.rollNumber}'/>">
                                </div>

                                <div class="row g-3 mb-4">
                                    <div class="col-sm-6">
                                        <label class="form-label text-light small fw-medium">Degree Program</label>
                                        <select name="courseId" class="form-select sm-form-control">
                                            <option value="">No Course Assigned</option>
                                            <c:forEach var="c" items="${courses}">
                                                <option value="${c.id}" ${user.course != null && user.course.id == c.id ? 'selected' : ''}>
                                                    <c:out value="${c.courseCode}"/> - <c:out value="${c.courseName}"/>
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="col-sm-6">
                                        <label class="form-label text-light small fw-medium">Enrolled Semester</label>
                                        <select name="semesterId" class="form-select sm-form-control">
                                            <option value="">Select Semester</option>
                                            <option value="1" ${user.semester != null && user.semester.semesterNumber == 1 ? 'selected' : ''}>Semester 1</option>
                                            <option value="2" ${user.semester != null && user.semester.semesterNumber == 2 ? 'selected' : ''}>Semester 2</option>
                                            <option value="3" ${user.semester != null && user.semester.semesterNumber == 3 ? 'selected' : ''}>Semester 3</option>
                                            <option value="4" ${user.semester != null && user.semester.semesterNumber == 4 ? 'selected' : ''}>Semester 4</option>
                                            <option value="5" ${user.semester != null && user.semester.semesterNumber == 5 ? 'selected' : ''}>Semester 5</option>
                                            <option value="6" ${user.semester != null && user.semester.semesterNumber == 6 ? 'selected' : ''}>Semester 6</option>
                                            <option value="7" ${user.semester != null && user.semester.semesterNumber == 7 ? 'selected' : ''}>Semester 7</option>
                                            <option value="8" ${user.semester != null && user.semester.semesterNumber == 8 ? 'selected' : ''}>Semester 8</option>
                                        </select>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary px-4 py-2 fw-semibold">
                                    Save Changes
                                </button>
                            </form>
                        </div>
                    </div>

                    <!-- Change Password Card -->
                    <div class="col-lg-5">
                        <div class="sm-card p-4 rounded-4 mb-4">
                            <h5 class="fw-bold text-light mb-3">Security & Password</h5>

                            <form action="${pageContext.request.contextPath}/student/change-password" method="post">
                                <input type="hidden" name="_csrf" value="${csrfToken}">

                                <div class="mb-3">
                                    <label class="form-label text-light small fw-medium">Current Password</label>
                                    <input type="password" name="currentPassword" class="form-control sm-form-control" placeholder="••••••••" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label text-light small fw-medium">New Password</label>
                                    <input type="password" name="newPassword" class="form-control sm-form-control" placeholder="Min 8 characters" required>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label text-light small fw-medium">Confirm New Password</label>
                                    <input type="password" name="confirmPassword" class="form-control sm-form-control" placeholder="Repeat new password" required>
                                </div>

                                <button type="submit" class="btn btn-outline-warning w-100 py-2 fw-semibold">
                                    Update Password
                                </button>
                            </form>
                        </div>

                        <!-- Account Status Information -->
                        <div class="sm-card p-4 rounded-4">
                            <h6 class="text-uppercase fw-semibold text-secondary small mb-3">Account Badges</h6>
                            <div class="d-flex flex-column gap-2 text-secondary small">
                                <div class="d-flex justify-content-between">
                                    <span>Verification Status</span>
                                    <span class="badge ${user.emailVerified ? 'bg-success-subtle text-success' : 'bg-warning-subtle text-warning'}">
                                        ${user.emailVerified ? 'Email Verified' : 'Pending Verification'}
                                    </span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span>Primary Role</span>
                                    <span class="badge bg-primary-subtle text-primary">${user.role.roleName}</span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span>Member Since</span>
                                    <span class="text-light"><fmt:formatDate value="${user.createdAt}" pattern="MMM yyyy"/></span>
                                </div>
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

