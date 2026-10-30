<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Create Account"/>
</jsp:include>
<body class="sm-body d-flex flex-column min-vh-100">
    <jsp:include page="/WEB-INF/views/components/navbar.jsp"/>

    <main class="flex-grow-1 d-flex align-items-center py-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6 col-xl-5">
                    <div class="sm-glass-card p-4 p-sm-5 rounded-4 shadow-2xl border border-secondary border-opacity-20 position-relative">
                        <!-- Header -->
                        <div class="text-center mb-4">
                            <img src="${pageContext.request.contextPath}/assets/images/studymate-logo.svg" alt="StudyMate Logo" height="38" class="mb-3">
                            <c:choose>
                                <c:when test="${not empty inviteToken}">
                                    <h3 class="fw-bold text-light mb-1">Admin Invitation</h3>
                                    <p class="text-secondary small">Activate your administrator credentials</p>
                                </c:when>
                                <c:otherwise>
                                    <h3 class="fw-bold text-light mb-1">Create Student Space</h3>
                                    <p class="text-secondary small">Join StudyMate to access curated academic materials</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show small py-2 px-3 border-0 bg-danger bg-opacity-20 text-danger mb-3" role="alert">
                                <i class="bi bi-exclamation-triangle me-1"></i> <c:out value="${errorMessage}"/>
                                <button type="button" class="btn-close btn-close-white small p-2" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Form -->
                        <form action="${pageContext.request.contextPath}/auth/register" method="post" id="registerForm" novalidate>
                            <input type="hidden" name="_csrf" value="${csrfToken}">

                            <c:if test="${not empty inviteToken}">
                                <input type="hidden" name="inviteToken" value="<c:out value='${inviteToken}'/>">
                            </c:if>

                            <div class="mb-3">
                                <label for="fullName" class="form-label text-light small fw-medium">Full Name</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-transparent border-secondary border-opacity-25 text-secondary">
                                        <i class="bi bi-person"></i>
                                    </span>
                                    <input type="text" class="form-control sm-form-control" id="fullName" name="fullName" 
                                           placeholder="e.g. Alex Johnson" required 
                                           value="<c:out value='${reg.fullName}'/>">
                                </div>
                            </div>

                            <c:if test="${empty inviteToken}">
                                <div class="mb-3">
                                    <label for="email" class="form-label text-light small fw-medium">Email Address</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-transparent border-secondary border-opacity-25 text-secondary">
                                            <i class="bi bi-envelope"></i>
                                        </span>
                                        <input type="email" class="form-control sm-form-control" id="email" name="email" 
                                               placeholder="alex@university.edu" required
                                               value="<c:out value='${reg.email}'/>">
                                    </div>
                                    <div class="form-text text-secondary" style="font-size: 0.72rem;">We'll dispatch a verification link to this address.</div>
                                </div>

                                <div class="mb-3">
                                    <label for="rollNumber" class="form-label text-light small fw-medium">Roll / Registration Number <span class="text-secondary">(Optional)</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-transparent border-secondary border-opacity-25 text-secondary">
                                            <i class="bi bi-card-heading"></i>
                                        </span>
                                        <input type="text" class="form-control sm-form-control" id="rollNumber" name="rollNumber" 
                                               placeholder="e.g. CS2026-089"
                                               value="<c:out value='${reg.rollNumber}'/>">
                                    </div>
                                </div>

                                <div class="row g-2 mb-3">
                                    <div class="col-sm-6">
                                        <label for="courseId" class="form-label text-light small fw-medium">Degree Program</label>
                                        <select class="form-select sm-form-control" id="courseId" name="courseId">
                                            <option value="">Select Course...</option>
                                            <c:forEach var="c" items="${courses}">
                                                <option value="${c.courseId}" ${reg.courseId == c.courseId ? 'selected' : ''}>
                                                    <c:out value="${c.courseCode}"/> - <c:out value="${c.courseName}"/>
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-sm-6">
                                        <label for="semesterId" class="form-label text-light small fw-medium">Current Semester</label>
                                        <select class="form-select sm-form-control" id="semesterId" name="semesterId">
                                            <option value="">Select Semester...</option>
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
                            </c:if>

                            <div class="row g-2 mb-3">
                                <div class="col-sm-6">
                                    <label for="password" class="form-label text-light small fw-medium">Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-transparent border-secondary border-opacity-25 text-secondary">
                                            <i class="bi bi-lock"></i>
                                        </span>
                                        <input type="password" class="form-control sm-form-control" id="password" name="password" 
                                               placeholder="Min 8 chars" required>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <label for="confirmPassword" class="form-label text-light small fw-medium">Confirm Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-transparent border-secondary border-opacity-25 text-secondary">
                                            <i class="bi bi-shield-check"></i>
                                        </span>
                                        <input type="password" class="form-control sm-form-control" id="confirmPassword" name="confirmPassword" 
                                               placeholder="Re-enter password" required>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="agreeTerms" name="agreeTerms" required ${reg.agreeTerms ? 'checked' : ''}>
                                    <label class="form-check-label text-secondary small" for="agreeTerms">
                                        I accept the <a href="${pageContext.request.contextPath}/terms" class="text-primary">Terms of Service</a> & <a href="${pageContext.request.contextPath}/privacy" class="text-primary">Privacy Policy</a>
                                    </label>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold shadow-sm mb-3">
                                <c:choose>
                                    <c:when test="${not empty inviteToken}">Activate Administrator Account</c:when>
                                    <c:otherwise>Create Account</c:otherwise>
                                </c:choose>
                            </button>
                        </form>

                        <div class="text-center pt-3 border-top border-secondary border-opacity-10">
                            <span class="text-secondary small">Already registered? </span>
                            <a href="${pageContext.request.contextPath}/auth/login" class="text-primary fw-semibold small text-decoration-none">Sign In</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/components/footer.jsp"/>
</body>
</html>

