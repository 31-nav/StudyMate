<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Sign In"/>
</jsp:include>
<body class="sm-body d-flex flex-column min-vh-100">
    <jsp:include page="/WEB-INF/views/components/navbar.jsp"/>

    <main class="flex-grow-1 d-flex align-items-center py-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-7 col-lg-5 col-xl-4">
                    <div class="sm-glass-card p-4 p-sm-5 rounded-4 shadow-2xl border border-secondary border-opacity-20 position-relative">
                        <!-- Header -->
                        <div class="text-center mb-4">
                            <img src="${pageContext.request.contextPath}/assets/images/studymate-logo.svg" alt="StudyMate Logo" height="38" class="mb-3">
                            <h3 class="fw-bold text-light mb-1">Welcome Back</h3>
                            <p class="text-secondary small">Sign in with your email or university identifier</p>
                        </div>

                        <!-- Flash Alerts -->
                        <c:if test="${not empty sessionScope.flashSuccess}">
                            <div class="alert alert-success alert-dismissible fade show small py-2 px-3 border-0 bg-success bg-opacity-20 text-success mb-3" role="alert">
                                <i class="bi bi-check-circle me-1"></i> <c:out value="${sessionScope.flashSuccess}"/>
                                <button type="button" class="btn-close btn-close-white small p-2" data-bs-dismiss="alert"></button>
                            </div>
                            <c:remove var="flashSuccess" scope="session"/>
                        </c:if>

                        <c:if test="${param.logout == 'true'}">
                            <div class="alert alert-info alert-dismissible fade show small py-2 px-3 border-0 bg-info bg-opacity-20 text-info mb-3" role="alert">
                                <i class="bi bi-info-circle me-1"></i> You have successfully signed out.
                                <button type="button" class="btn-close btn-close-white small p-2" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show small py-2 px-3 border-0 bg-danger bg-opacity-20 text-danger mb-3" role="alert">
                                <i class="bi bi-exclamation-triangle me-1"></i> <c:out value="${errorMessage}"/>
                                <button type="button" class="btn-close btn-close-white small p-2" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Login Form -->
                        <form action="${pageContext.request.contextPath}/auth/login" method="post" id="loginForm" novalidate>
                            <input type="hidden" name="_csrf" value="${csrfToken}">
                            <input type="hidden" name="redirect" value="<c:out value='${param.redirect}'/>">

                            <div class="mb-3">
                                <label for="identifier" class="form-label text-light small fw-medium">Email or Roll Number</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-transparent border-secondary border-opacity-25 text-secondary">
                                        <i class="bi bi-envelope"></i>
                                    </span>
                                    <input type="text" class="form-control sm-form-control" id="identifier" name="identifier" 
                                           placeholder="student@studymate.edu" required autofocus
                                           value="<c:out value='${identifier}'/>">
                                </div>
                            </div>

                            <div class="mb-3">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <label for="password" class="form-label text-light small fw-medium mb-0">Password</label>
                                    <a href="${pageContext.request.contextPath}/auth/forgot-password" class="text-decoration-none small text-primary">Forgot password?</a>
                                </div>
                                <div class="input-group">
                                    <span class="input-group-text bg-transparent border-secondary border-opacity-25 text-secondary">
                                        <i class="bi bi-lock"></i>
                                    </span>
                                    <input type="password" class="form-control sm-form-control" id="password" name="password" 
                                           placeholder="••••••••" required>
                                    <button class="btn btn-outline-secondary border-opacity-25" type="button" id="togglePasswordBtn">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="d-flex align-items-center mb-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                                    <label class="form-check-label text-secondary small" for="rememberMe">
                                        Keep me logged in
                                    </label>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold shadow-sm mb-3">
                                Sign In
                            </button>
                        </form>

                        <div class="text-center pt-3 border-top border-secondary border-opacity-10">
                            <span class="text-secondary small">Don't have an account yet? </span>
                            <a href="${pageContext.request.contextPath}/auth/register" class="text-primary fw-semibold small text-decoration-none">Sign Up</a>
                        </div>

                        <!-- Quick Demo Credentials for Review -->
                        <div class="mt-4 pt-3 border-top border-secondary border-opacity-10 text-center">
                            <span class="text-secondary" style="font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px;">Quick Demo Access</span>
                            <div class="d-flex justify-content-center gap-1 mt-2">
                                <button type="button" class="btn btn-sm btn-sm-outline px-2 py-1" style="font-size: 0.72rem;" onclick="fillDemo('student@studymate.edu', 'StudyMate@2026')">Student</button>
                                <button type="button" class="btn btn-sm btn-sm-outline px-2 py-1" style="font-size: 0.72rem;" onclick="fillDemo('admin@studymate.edu', 'StudyMate@2026')">Admin</button>
                                <button type="button" class="btn btn-sm btn-sm-outline px-2 py-1" style="font-size: 0.72rem;" onclick="fillDemo('superadmin@studymate.edu', 'StudyMate@2026')">Super Admin</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/components/footer.jsp"/>

    <script>
        function fillDemo(id, pass) {
            document.getElementById('identifier').value = id;
            document.getElementById('password').value = pass;
        }

        const toggleBtn = document.getElementById('togglePasswordBtn');
        const passInput = document.getElementById('password');
        if (toggleBtn && passInput) {
            toggleBtn.addEventListener('click', () => {
                const isPass = passInput.getAttribute('type') === 'password';
                passInput.setAttribute('type', isPass ? 'text' : 'password');
                toggleBtn.querySelector('i').classList.toggle('bi-eye');
                toggleBtn.querySelector('i').classList.toggle('bi-eye-slash');
            });
        }
    </script>
</body>
</html>

