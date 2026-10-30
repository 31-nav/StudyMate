<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Page Not Found"/>
</jsp:include>
<body class="sm-body d-flex flex-column min-vh-100">
    <jsp:include page="/WEB-INF/views/components/navbar.jsp"/>

    <main class="flex-grow-1 d-flex align-items-center py-5">
        <div class="container text-center">
            <div class="sm-glass-card p-5 rounded-4 max-w-lg mx-auto border border-secondary border-opacity-20 shadow-2xl">
                <div class="display-1 fw-bolder text-primary mb-2">404</div>
                <h2 class="fw-bold text-light mb-3">Resource Missing in Action</h2>
                <p class="text-secondary mb-4">
                    The course, subject, or educational resource you were navigating towards doesn't exist, was moved, or has been archived.
                </p>
                <div class="d-flex justify-content-center gap-3">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light">
                        <i class="bi bi-house me-1"></i> Home
                    </a>
                    <a href="${pageContext.request.contextPath}/resources" class="btn btn-primary">
                        <i class="bi bi-search me-1"></i> Browse Library
                    </a>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/components/footer.jsp"/>
</body>
</html>

