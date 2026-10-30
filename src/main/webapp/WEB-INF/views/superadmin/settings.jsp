<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<jsp:include page="/WEB-INF/views/components/header.jsp">
    <jsp:param name="pageTitle" value="System Settings"/>
</jsp:include>
<body class="sm-body">
    <div class="d-flex min-vh-100">
        <jsp:include page="/WEB-INF/views/components/admin-sidebar.jsp">
            <jsp:param name="activeMenu" value="settings"/>
        </jsp:include>

        <div class="sm-main-wrapper flex-grow-1 d-flex flex-column">
            <jsp:include page="/WEB-INF/views/components/topbar.jsp"/>

            <main class="container-fluid p-4 p-lg-5 flex-grow-1">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="h3 fw-bold text-light mb-1">Platform Settings & Environment</h2>
                        <p class="text-secondary small mb-0">System parameters, storage location, mail adapter, and security boundaries.</p>
                    </div>
                </div>

                <div class="row g-4">
                    <div class="col-lg-6">
                        <div class="sm-card p-4 rounded-4 mb-4">
                            <h5 class="fw-bold text-light mb-3"><i class="bi bi-hdd text-primary me-2"></i> File Storage Engine</h5>
                            <div class="d-flex flex-column gap-3 text-secondary small">
                                <div>
                                    <span class="d-block text-secondary text-uppercase fw-semibold" style="font-size: 0.7rem;">Storage Location</span>
                                    <code class="text-light">C:\StudyMate\storage\uploads</code>
                                    <div class="text-success small mt-1"><i class="bi bi-shield-check"></i> Isolated strictly outside servlet web root</div>
                                </div>
                                <div>
                                    <span class="d-block text-secondary text-uppercase fw-semibold" style="font-size: 0.7rem;">Maximum File Upload Limit</span>
                                    <span class="text-light">50 MB per individual file</span>
                                </div>
                                <div>
                                    <span class="d-block text-secondary text-uppercase fw-semibold" style="font-size: 0.7rem;">File Naming Strategy</span>
                                    <span class="text-light">UUID v4 storage key with SHA-256 integrity hash</span>
                                </div>
                            </div>
                        </div>

                        <div class="sm-card p-4 rounded-4 mb-4">
                            <h5 class="fw-bold text-light mb-3"><i class="bi bi-envelope text-info me-2"></i> Mail Delivery Gateway</h5>
                            <div class="d-flex flex-column gap-3 text-secondary small">
                                <div>
                                    <span class="d-block text-secondary text-uppercase fw-semibold" style="font-size: 0.7rem;">Configured Adapter</span>
                                    <span class="badge bg-primary-subtle text-primary">Jakarta Mail / DevMailAdapter</span>
                                </div>
                                <div>
                                    <span class="d-block text-secondary text-uppercase fw-semibold" style="font-size: 0.7rem;">Token Expiration</span>
                                    <span class="text-light">Verification tokens: 24h &bull; Password reset tokens: 1h</span>
                                </div>
                                <div>
                                    <span class="d-block text-secondary text-uppercase fw-semibold" style="font-size: 0.7rem;">Token Security</span>
                                    <span class="text-light">CSPRNG generated (32 bytes) with SHA-256 storage hash</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="sm-card p-4 rounded-4 mb-4">
                            <h5 class="fw-bold text-light mb-3"><i class="bi bi-shield-lock text-warning me-2"></i> Security & Cryptography</h5>
                            <div class="d-flex flex-column gap-3 text-secondary small">
                                <div class="d-flex justify-content-between">
                                    <span>Password Hashing:</span>
                                    <span class="text-light fw-medium">BCrypt (12 cost factor)</span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span>CSRF Defense:</span>
                                    <span class="text-success fw-medium">Synchronizer Token Filter Active</span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span>Session Protection:</span>
                                    <span class="text-light fw-medium">ID regeneration upon login</span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span>Security Headers:</span>
                                    <span class="text-success fw-medium">HSTS, X-Frame-Options, X-Content-Type-Options</span>
                                </div>
                            </div>
                        </div>

                        <div class="sm-card p-4 rounded-4">
                            <h5 class="fw-bold text-light mb-3"><i class="bi bi-cpu text-success me-2"></i> Runtime Architecture</h5>
                            <div class="d-flex flex-column gap-3 text-secondary small">
                                <div class="d-flex justify-content-between">
                                    <span>Application:</span>
                                    <span class="text-light fw-medium">StudyMate v1.0.0</span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span>Java Specification:</span>
                                    <span class="text-light fw-medium">Java 21 LTS (Jakarta EE 10)</span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span>Database:</span>
                                    <span class="text-light fw-medium">PostgreSQL 16.6 via HikariCP</span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span>Deployment Target:</span>
                                    <span class="text-light fw-medium">Apache Tomcat 10.1</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/navigation.js"></script>
</body>
</html>

