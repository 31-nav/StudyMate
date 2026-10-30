<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="Verify Email"/>
</jsp:include>
<body class="sm-body d-flex flex-column min-vh-100">
    <jsp:include page="/WEB-INF/views/components/navbar.jsp"/>

    <main class="flex-grow-1 d-flex align-items-center py-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-7 col-lg-5">
                    <div class="sm-glass-card p-4 p-sm-5 rounded-4 shadow-2xl border border-secondary border-opacity-20 text-center">
                        <c:choose>
                            <c:when test="${verified}">
                                <div class="mb-4">
                                    <div class="p-3 rounded-circle bg-success bg-opacity-20 text-success d-inline-flex fs-1 mb-3">
                                        <i class="bi bi-patch-check"></i>
                                    </div>
                                    <h3 class="fw-bold text-light mb-2">Email Verified!</h3>
                                    <p class="text-secondary small mb-4">
                                        <c:out value="${message}"/>
                                    </p>
                                    <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-primary px-4 py-2 fw-semibold">
                                        Proceed to Login <i class="bi bi-arrow-right ms-1"></i>
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="mb-4">
                                    <div class="p-3 rounded-circle bg-danger bg-opacity-20 text-danger d-inline-flex fs-1 mb-3">
                                        <i class="bi bi-exclamation-octagon"></i>
                                    </div>
                                    <h3 class="fw-bold text-light mb-2">Verification Failed</h3>
                                    <p class="text-secondary small mb-4">
                                        <c:out value="${message != null ? message : 'The verification token is invalid or has expired.'}"/>
                                    </p>
                                    <div class="d-flex justify-content-center gap-2">
                                        <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-sm-outline">
                                            Back to Login
                                        </a>
                                        <a href="${pageContext.request.contextPath}/contact" class="btn btn-sm-primary">
                                            Contact Support
                                        </a>
                                    </div>
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

