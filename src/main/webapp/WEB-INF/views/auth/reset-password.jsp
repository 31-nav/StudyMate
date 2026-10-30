<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Set New Password"/>
</jsp:include>
<body class="sm-body d-flex flex-column min-vh-100">
    <jsp:include page="/WEB-INF/views/components/navbar.jsp"/>

    <main class="flex-grow-1 d-flex align-items-center py-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-7 col-lg-5 col-xl-4">
                    <div class="sm-glass-card p-4 p-sm-5 rounded-4 shadow-2xl border border-secondary border-opacity-20 text-center">
                        <div class="p-3 rounded-circle bg-warning bg-opacity-20 text-warning d-inline-flex fs-2 mb-3">
                            <i class="bi bi-shield-lock"></i>
                        </div>
                        <h3 class="fw-bold text-light mb-2">New Password</h3>
                        <p class="text-secondary small mb-4">
                            Choose a strong, unique password for your account.
                        </p>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show small py-2 px-3 border-0 bg-danger bg-opacity-20 text-danger mb-3 text-start" role="alert">
                                <i class="bi bi-exclamation-triangle me-1"></i> <c:out value="${errorMessage}"/>
                                <button type="button" class="btn-close btn-close-white small p-2" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/auth/reset-password" method="post" novalidate>
                            <input type="hidden" name="_csrf" value="${csrfToken}">
                            <input type="hidden" name="token" value="<c:out value='${token}'/>">

                            <div class="mb-3 text-start">
                                <label for="newPassword" class="form-label text-light small fw-medium">New Password</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-transparent border-secondary border-opacity-25 text-secondary">
                                        <i class="bi bi-lock"></i>
                                    </span>
                                    <input type="password" class="form-control sm-form-control" id="newPassword" name="newPassword" 
                                           placeholder="At least 8 characters" required autofocus>
                                </div>
                            </div>

                            <div class="mb-4 text-start">
                                <label for="confirmPassword" class="form-label text-light small fw-medium">Confirm New Password</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-transparent border-secondary border-opacity-25 text-secondary">
                                        <i class="bi bi-shield-check"></i>
                                    </span>
                                    <input type="password" class="form-control sm-form-control" id="confirmPassword" name="confirmPassword" 
                                           placeholder="Repeat password" required>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold shadow-sm mb-3">
                                Update Password
                            </button>
                        </form>

                        <div class="pt-3 border-top border-secondary border-opacity-10">
                            <a href="${pageContext.request.contextPath}/auth/login" class="text-secondary small text-decoration-none">
                                <i class="bi bi-arrow-left me-1"></i> Back to Sign In
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/components/footer.jsp"/>
</body>
</html>

