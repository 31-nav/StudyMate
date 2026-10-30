<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<footer class="sm-footer mt-auto pt-5 pb-4 border-top border-secondary border-opacity-10">
    <div class="container">
        <div class="row g-4 mb-4">
            <div class="col-lg-4 col-md-6">
                <div class="d-flex align-items-center mb-3">
                    <img src="${pageContext.request.contextPath}/assets/images/studymate-logo.svg" alt="StudyMate Logo" height="38">
                </div>
                <p class="text-secondary mb-3 pe-lg-4">
                    Your Learning. Your Space. StudyMate is the next-generation academic resource hub empowering students, educators, and institutions with seamless resource discovery and collaboration.
                </p>
                <div class="d-flex gap-2">
                    <a href="https://github.com" target="_blank" class="btn btn-sm-outline btn-sm rounded-circle p-2" title="GitHub"><i class="bi bi-github"></i></a>
                    <a href="https://twitter.com" target="_blank" class="btn btn-sm-outline btn-sm rounded-circle p-2" title="Twitter"><i class="bi bi-twitter-x"></i></a>
                    <a href="https://linkedin.com" target="_blank" class="btn btn-sm-outline btn-sm rounded-circle p-2" title="LinkedIn"><i class="bi bi-linkedin"></i></a>
                </div>
            </div>

            <div class="col-lg-2 col-md-6">
                <h6 class="text-uppercase fw-bold text-light mb-3">Academic</h6>
                <ul class="list-unstyled d-flex flex-column gap-2 text-secondary sm-footer-links">
                    <li><a href="${pageContext.request.contextPath}/courses" class="text-decoration-none text-secondary">Browse Courses</a></li>
                    <li><a href="${pageContext.request.contextPath}/resources?type=NOTES" class="text-decoration-none text-secondary">Lecture Notes</a></li>
                    <li><a href="${pageContext.request.contextPath}/resources?type=PREVIOUS_YEAR_PAPERS" class="text-decoration-none text-secondary">Past Papers</a></li>
                    <li><a href="${pageContext.request.contextPath}/resources?type=SYLLABUS" class="text-decoration-none text-secondary">Syllabi</a></li>
                    <li><a href="${pageContext.request.contextPath}/resources?type=REFERENCE_BOOK" class="text-decoration-none text-secondary">Reference Books</a></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h6 class="text-uppercase fw-bold text-light mb-3">Quick Links</h6>
                <ul class="list-unstyled d-flex flex-column gap-2 text-secondary sm-footer-links">
                    <li><a href="${pageContext.request.contextPath}/home#features" class="text-decoration-none text-secondary">Features</a></li>
                    <li><a href="${pageContext.request.contextPath}/home#about" class="text-decoration-none text-secondary">About StudyMate</a></li>
                    <li><a href="${pageContext.request.contextPath}/home#how-it-works" class="text-decoration-none text-secondary">How It Works</a></li>
                    <li><a href="${pageContext.request.contextPath}/auth/register" class="text-decoration-none text-secondary">Student Registration</a></li>
                    <li><a href="${pageContext.request.contextPath}/auth/login" class="text-decoration-none text-secondary">Student Portal</a></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h6 class="text-uppercase fw-bold text-light mb-3">Security & Compliance</h6>
                <p class="text-secondary small mb-3">
                    Engineered with Jakarta EE 10, Hibernate ORM, and PostgreSQL. End-to-end tokenized auth, CSRF defense, and granular RBAC.
                </p>
                <div class="d-flex align-items-center gap-2 mb-2">
                    <span class="badge bg-success-subtle text-success border border-success-subtle">
                        <i class="bi bi-shield-check me-1"></i> SSL/TLS Ready
                    </span>
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                        <i class="bi bi-lock me-1"></i> BCrypt 12-Rounds
                    </span>
                </div>
                <!-- Subtle Admin Login link per requirements -->
                <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/auth/login?role=admin" class="text-secondary text-decoration-none small opacity-50 hover-opacity-100">
                        <i class="bi bi-shield-lock me-1"></i> Administrator Access
                    </a>
                </div>
            </div>
        </div>

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center pt-4 border-top border-secondary border-opacity-10 text-secondary small">
            <div>
                &copy; 2026 StudyMate. All rights reserved. &bull; <em>Your Learning. Your Space.</em>
            </div>
            <div class="d-flex gap-3 mt-2 mt-md-0">
                <a href="${pageContext.request.contextPath}/privacy" class="text-secondary text-decoration-none">Privacy Policy</a>
                <span>&bull;</span>
                <a href="${pageContext.request.contextPath}/terms" class="text-secondary text-decoration-none">Terms of Service</a>
                <span>&bull;</span>
                <a href="${pageContext.request.contextPath}/contact" class="text-secondary text-decoration-none">Support</a>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- StudyMate Navigation Script -->
<script src="${pageContext.request.contextPath}/assets/js/navigation.js"></script>

