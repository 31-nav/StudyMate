# Requirements Specification: StudyMate

This document formalizes the functional and non-functional requirements governing the design, implementation, and verification of StudyMate.

---

## 1. Functional Requirements (FR)

### Module 1: Authentication & Account Management
- **FR-01: Public Student Registration**: The system shall permit public users to register an account by providing Full Name, Email, Password, University Roll Number, Course, and Semester. The system MUST assign `ROLE_STUDENT` exclusively.
- **FR-02: Email Verification**: Upon registration, the system shall generate a cryptographically secure token, hash it using SHA-256 for database persistence, and require token verification before granting access to protected features.
- **FR-03: Multi-Role Authentication**: The system shall authenticate users via email and password, verifying hashes using BCrypt (cost factor 12), and route users to their respective role dashboard.
- **FR-04: Password Reset Workflow**: The system shall provide an automated password reset mechanism utilizing time-limited, single-use SHA-256 hashed reset tokens.
- **FR-05: Session Management**: The system shall invalidate previous sessions upon authentication (session fixation defense), set `HttpOnly` cookie flags, and maintain idle session expiration (30 minutes).

### Module 2: Academic Hierarchy & Resource Catalog
- **FR-06: Academic Hierarchy**: The system shall organize learning materials under a four-tier hierarchy: Course (Degree/Program) → Semester → Subject → Resource Category.
- **FR-07: Resource Ingestion & Validation**: The system shall permit Administrators and Super Administrators to upload learning assets (PDF, PNG, JPG, GIF, WebP, SVG) with strict MIME type and extension validation up to 50MB per file.
- **FR-08: Binary Isolation**: The system shall store physical files in an external directory outside the web application context root, persisting only metadata and UUID storage keys in PostgreSQL.
- **FR-09: Inline Document & Diagram Viewer**: The system shall stream permitted resources directly to the browser for inline rendering via `<iframe src="/student/resources/stream?id=...">` or `<img>` elements without exposing physical disk paths.
- **FR-10: Controlled Downloads**: The system shall enforce download permissions (`is_downloadable = true`) and increment resource download counters upon each verified file download.

### Module 3: Personalization & Engagement
- **FR-11: Bookmark Management**: The system shall allow students to toggle bookmarks on any learning asset via asynchronous REST/JSON requests and review all saved assets in a dedicated Bookmarks workspace.
- **FR-12: Recent Activity Tracking**: The system shall automatically record student resource views into `user_recent_views` to display a "Recently Viewed" rail on the student dashboard.
- **FR-13: Announcements & Notifications**: The system shall enable Administrators to publish institutional announcements (global or course-specific) and automatically dispatch in-app notifications to affected students.

### Module 4: Administration & Governance
- **FR-14: Administrator Provisioning**: The system shall allow Super Administrators to create and invite new Administrators with customizable activation statuses.
- **FR-15: Security Audit Logging**: The system shall log security-relevant actions (Logins, Failed Logins, Resource Uploads, Subject Creations, User Activations) recording User ID, Action, Entity, IP Address, User Agent, and Timestamp.
- **FR-16: Dynamic System Settings**: The system shall enable Super Administrators to modify global platform configuration (Platform Name, Upload Directory, Max File Size, Maintenance Mode) stored in the database.

---

## 2. Non-Functional Requirements (NFR)

### Performance & Scalability
- **NFR-01: Response Latency**: Server-side page generation for dynamic views shall complete in under 150ms under typical loads. Direct JDBC analytical queries must execute in under 30ms.
- **NFR-02: Connection Pooling**: Database connections shall be pooled via HikariCP, configured with a minimum of 5 idle connections and a maximum of 20 active connections.
- **NFR-03: Scalable File Streaming**: Document streaming shall use buffered I/O streams with an 8KB buffer size to support concurrent multi-megabyte file streaming without consuming excessive JVM heap space.

### Security & Data Protection
- **NFR-04: Password Storage**: Passwords must be hashed using BCrypt with a minimum cost factor of 12 and unique 128-bit salts.
- **NFR-05: Anti-CSRF Protection**: All state-modifying requests (`POST`, `PUT`, `DELETE`) must validate a cryptographically random, session-bound CSRF token.
- **NFR-06: Strict HTTP Headers**: Responses must include `Content-Security-Policy`, `X-Content-Type-Options: nosniff`, `X-Frame-Options: SAMEORIGIN`, and `X-XSS-Protection: 1; mode=block`.
- **NFR-07: SQL Injection Immunity**: All database queries must use parameterized HQL/JPQL via Hibernate or prepared statements (`java.sql.PreparedStatement`) via JDBC. Concatenated SQL strings are strictly prohibited.
- **NFR-08: Path Traversal Defense**: All user-supplied filenames must be sanitized against path manipulation (`..`, `/`, `\`) before resolving storage paths.

### Usability & Compatibility
- **NFR-09: Responsive UI**: The presentation layer must render seamlessly across desktops, tablets, and smartphones using CSS3 flexbox/grid and Bootstrap 5.3 utilities.
- **NFR-10: Theme Support**: The UI must support instant switching between Dark Mode and Light Mode with client-side persistence in `localStorage`.

---

## 3. Requirements Traceability Matrix

| Requirement | Implementation Component | Verification Test Case |
|---|---|---|
| **FR-01, FR-02** | `AuthServlet`, `AuthService`, `UserDao` | `AuthServiceTest#testRegisterStudent_Success` |
| **FR-03** | `AuthServlet`, `AuthService`, `SecurityUtil` | `AuthServiceTest#testAuthenticate_Success` |
| **FR-04** | `AuthServlet`, `AuthService` | `AuthServiceTest#testResetPassword_Success` |
| **FR-06** | `CourseServlet`, `SubjectServlet`, `AcademicService` | `AcademicServiceTest#testCreateCourse_Success` |
| **FR-07, FR-08, FR-09** | `ResourceServlet`, `ResourceService`, `ResourceFile` | `ResourceServiceTest#testCreateResource_PdfSuccess` |
| **FR-11, FR-12** | `BookmarkServlet`, `PersonalizationService` | `PersonalizationService` Manual Integration |
| **FR-15** | `AuditService`, `AuditLogDao`, `AuditLog` | Automated logging verified across test flows |
| **NFR-04, NFR-05** | `SecurityUtil`, `CsrfFilter` | `SecurityUtilTest#testHashPasswordAndVerify` |
| **NFR-08** | `ResourceService`, `FileValidator` | `ResourceServiceTest#testCreateResource_PathTraversalSanitized` |

