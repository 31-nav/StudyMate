<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar navbar-expand-lg sm-glass-nav sticky-top py-3">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/home">
            <img src="${pageContext.request.contextPath}/assets/images/studymate-logo.svg" alt="StudyMate Logo" height="42">
        </a>

        <button class="navbar-toggler border-0 shadow-none text-light" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain" aria-controls="navbarMain" aria-expanded="false" aria-label="Toggle navigation">
            <i class="bi bi-list fs-2"></i>
        </button>

        <div class="collapse navbar-collapse" id="navbarMain">
            <ul class="navbar-nav mx-auto mb-2 mb-lg-0 gap-3 fw-medium">
                <li class="nav-item">
                    <a class="nav-link ${activeSection == 'home' ? 'active text-primary fw-semibold' : ''}" href="${pageContext.request.contextPath}/home">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activeSection == 'features' ? 'active text-primary fw-semibold' : ''}" href="${pageContext.request.contextPath}/features">Features</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activeSection == 'about' ? 'active text-primary fw-semibold' : ''}" href="${pageContext.request.contextPath}/about">About</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activeSection == 'contact' ? 'active text-primary fw-semibold' : ''}" href="${pageContext.request.contextPath}/contact">Contact</a>
                </li>
            </ul>

            <div class="d-flex align-items-center gap-3">
                <!-- Theme toggle button -->
                <button type="button" class="btn btn-sm-outline btn-theme-toggle p-2 rounded-circle" title="Toggle theme">
                    <i class="bi bi-moon-stars theme-toggle-icon"></i>
                </button>

                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-sm-primary d-flex align-items-center gap-2">
                            <i class="bi bi-speedometer2"></i> Dashboard
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-sm-outline">Log In</a>
                        <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-sm-primary">Get Started</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

