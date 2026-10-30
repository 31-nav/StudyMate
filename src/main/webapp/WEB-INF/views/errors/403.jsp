<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Access Forbidden"/>
</jsp:include>
<body class="sm-body d-flex flex-column min-vh-100">
    <jsp:include page="/WEB-INF/views/components/navbar.jsp"/>

    <main class="flex-grow-1 d-flex align-items-center py-5">
        <div class="container text-center">
            <div class="sm-glass-card p-5 rounded-4 max-w-lg mx-auto border border-danger border-opacity-20 shadow-2xl">
                <div class="p-3 rounded-circle bg-danger bg-opacity-20 text-danger d-inline-flex fs-1 mb-3">
                    <i class="bi bi-shield-x"></i>
                </div>
                <h2 class="fw-bold text-light mb-2">403 &mdash; Access Restricted</h2>
                <p class="text-secondary mb-4">
                    You do not have the required role or permission clearance to access this area of StudyMate. If you believe this is an error, please reach out to your faculty administrator.
                </p>
                <div class="d-flex justify-content-center gap-3">
                    <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-primary">
                        <i class="bi bi-arrow-left me-1"></i> Return to Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-outline-light">
                        Switch Account
                    </a>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/components/footer.jsp"/>
</body>
</html>

