<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="System Error"/>
</jsp:include>
<body class="sm-body d-flex flex-column min-vh-100">
    <jsp:include page="/WEB-INF/views/components/navbar.jsp"/>

    <main class="flex-grow-1 d-flex align-items-center py-5">
        <div class="container text-center">
            <div class="sm-glass-card p-5 rounded-4 max-w-lg mx-auto border border-secondary border-opacity-20 shadow-2xl">
                <div class="display-1 fw-bolder text-danger mb-2">500</div>
                <h2 class="fw-bold text-light mb-2">Something Went Awry</h2>
                <p class="text-secondary mb-4">
                    The server encountered an unexpected situation while processing your academic request. Our internal telemetry logs have captured this incident.
                </p>
                <div class="d-flex justify-content-center gap-3">
                    <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-primary">
                        <i class="bi bi-house me-1"></i> Return Home
                    </a>
                    <button type="button" class="btn btn-outline-light" onclick="window.location.reload()">
                        <i class="bi bi-arrow-clockwise me-1"></i> Retry
                    </button>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/components/footer.jsp"/>
</body>
</html>

