# Changelog: StudyMate

All notable changes to the StudyMate Learning Management System are documented in this file.

The project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-10-30 - Production Release

### Added
- **Core Architecture**:
  - Implemented pure Jakarta EE 10 web application with Java 21 LTS runtime.
  - Zero third-party backend framework dependencies (strictly no Spring Boot, no Node.js).
  - Configured Apache Tomcat 10.1.34 deployment descriptor (`web.xml`).
- **Database & Persistence**:
  - Designed and deployed PostgreSQL 16 schema with 20 normalized relational tables.
  - Initialized seed database with 3 roles, 3 default users, 3 academic programs, 9 subjects, and 11 resource categories.
  - Implemented Hibernate ORM 6.4 entity management and transaction processing.
  - Integrated HikariCP 5.1 connection pooling for high-throughput concurrency.
  - Implemented `JdbcReportingDao` for high-efficiency direct SQL multi-table reporting.
- **Security & RBAC**:
  - Implemented `SecurityHeadersFilter` injecting strict CSP, HSTS, X-Frame-Options, and XSS protection.
  - Implemented `CsrfFilter` with cryptographically random session-bound tokens.
  - Implemented `AuthenticationFilter` and `AuthorizationFilter` enforcing role boundaries (`ROLE_STUDENT`, `ROLE_ADMIN`, `ROLE_SUPER_ADMIN`).
  - Added BCrypt password hashing (Cost Factor 12) with CSPRNG salting.
  - Added SHA-256 deterministic token hashing for email verification and password resets.
  - Implemented session fixation protection via pre-authentication session destruction.
  - Enforced physical upload isolation outside web root (`C:/StudyMate/storage/uploads/`).
- **Web Tier (Servlets & Views)**:
  - Developed 10 Jakarta Servlets: `HomeServlet`, `AuthServlet`, `DashboardServlet`, `CourseServlet`, `SubjectServlet`, `ResourceServlet`, `BookmarkServlet`, `NotificationServlet`, `AdminServlet`, and `SuperAdminServlet`.
  - Built 22 JSP 3.1 views styled with custom Glassmorphism CSS design system.
  - Created high-resolution inline document and diagram viewer with non-blocking 8KB buffered streaming.
  - Added asynchronous Vanilla JavaScript modules for theme switching, bookmark toggling, navigation, and PDF controls.
- **Verification & Documentation**:
  - Created 25 automated unit and integration tests (JUnit 5 + Mockito) with 100% passing status.
  - Created complete architectural documentation suite (19 markdown technical guides + 6 Mermaid diagrams).
  - Deployed and verified live application on port `8080` (HTTP 200 OK).

---

## [0.2.0] - 2026-10-30 - Architecture & Service Prototyping
- Prototyped DAO layer and domain entities.
- Implemented `AuthService`, `AcademicService`, `ResourceService`, and `AuditService`.
- Built initial JSP layouts and Bootstrap component integration.

---

## [0.1.0] - 2026-10-30 - Inception & Toolchain Provisioning
- Established project repository and Maven build definition (`pom.xml`).
- Provisioned portable OpenJDK 21 LTS, Apache Maven 3.9.9, PostgreSQL 16.6, and Apache Tomcat 10.1.34.
- Defined initial project specifications and branding identity.

