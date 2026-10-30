<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Forgot Password"/>
</jsp:include>
<body class="sm-body d-flex flex-column min-vh-100">
    <jsp:include page="/WEB-INF/views/components/navbar.jsp"/>

    <main class="flex-grow-1 d-flex align-items-center py-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-7 col-lg-5 col-xl-4">
                    <div class="sm-glass-card p-4 p-sm-5 rounded-4 shadow-2xl border border-secondary border-opacity-20 text-center">
                        <div class="p-3 rounded-circle bg-primary bg-opacity-20 text-primary d-inline-flex fs-2 mb-3">
                            <i class="bi bi-key"></i>
                        </div>
                        <h3 class="fw-bold text-light mb-2">Reset Password</h3>
                        <p class="text-secondary small mb-4">
                            Enter your registered email address and we will dispatch a secure reset link.
                        </p>

                        <c:choose>
                            <c:when test="${submitted}">
                                <div class="alert alert-success small py-3 px-3 border-0 bg-success bg-opacity-20 text-success mb-4 text-start">
                                    <div class="d-flex align-items-center gap-2 mb-1">
                                        <i class="bi bi-envelope-check fs-5"></i>
                                        <strong class="text-light">Check Your Inbox</strong>
                                    </div>
                                    <p class="mb-0"><c:out value="${message}"/></p>
                                </div>
                                <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-outline-light w-100 py-2">
                                    Return to Sign In
                                </a>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/auth/forgot-password" method="post" novalidate>
                                    <input type="hidden" name="_csrf" value="${csrfToken}">

                                    <div class="mb-4 text-start">
                                        <label for="email" class="form-label text-light small fw-medium">Registered Email</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-transparent border-secondary border-opacity-25 text-secondary">
                                                <i class="bi bi-envelope"></i>
                                            </span>
                                            <input type="email" class="form-control sm-form-control" id="email" name="email" 
                                                   placeholder="student@studymate.edu" required autofocus>
                                        </div>
                                    </div>

                                    <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold shadow-sm mb-3">
                                        Send Reset Link
                                    </button>
                                </form>

                                <div class="pt-3 border-top border-secondary border-opacity-10">
                                    <a href="${pageContext.request.contextPath}/auth/login" class="text-secondary small text-decoration-none">
                                        <i class="bi bi-arrow-left me-1"></i> Back to Sign In
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/components/footer.jsp"/>
</body>
</html>

