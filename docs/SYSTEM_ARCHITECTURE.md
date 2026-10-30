# System Architecture: StudyMate

## 1. Architectural Philosophy

StudyMate is architected as a modular, monolithic **Model-View-Controller (MVC)** web application built entirely on standard **Jakarta EE 10** specifications and **Java 21 LTS**.

The system deliberately avoids complex, transient JavaScript micro-frameworks and bulky frameworks like Spring Boot in favor of well-defined, standardized, and performant Java platform fundamentals:
- **Predictable Request Lifecycle**: Clear HTTP dispatching through Jakarta Servlets and standard Filters.
- **Strong Type Safety**: Standard Java domain models, Service-layer transaction boundaries, and Hibernate ORM.
- **High Concurrency & Low Memory Footprint**: Standard Tomcat 10 worker threads, HikariCP connection pooling, and buffered I/O streaming.

---

## 2. Multi-Tier Layered Architecture

```
+-------------------------------------------------------------------+
|                        Client Browser                             |
|  HTML5 + CSS3 (Glassmorphism) + Vanilla JS ES6+ + Bootstrap 5.3   |
+-------------------------------------------------------------------+
                                  | HTTP / HTTPS Requests
                                  v
+-------------------------------------------------------------------+
|                     Filter & Security Interceptors                |
|  - SecurityHeadersFilter (CSP, HSTS, X-Frame, XSS)                |
|  - CsrfFilter (Session-bound cryptographic nonces)               |
|  - AuthenticationFilter (Session verification & redirects)        |
|  - AuthorizationFilter (RBAC: Student, Admin, SuperAdmin)         |
+-------------------------------------------------------------------+
                                  |
                                  v
+-------------------------------------------------------------------+
|                     Controller Tier (Jakarta Servlets)            |
|  - HomeServlet              - AuthServlet                         |
|  - DashboardServlet         - CourseServlet                       |
|  - SubjectServlet           - ResourceServlet                     |
|  - BookmarkServlet          - NotificationServlet                 |
|  - AdminServlet             - SuperAdminServlet                   |
+-------------------------------------------------------------------+
                                  |
                                  v
+-------------------------------------------------------------------+
|                      Service Tier (Business Logic)                |
|  - AuthService              - AcademicService                     |
|  - ResourceService          - PersonalizationService              |
|  - AnnouncementService      - UserService                         |
|  - AuditService             - DashboardService                    |
+-------------------------------------------------------------------+
                                  |
                                  +-----------------------+
                                  |                       |
                                  v                       v
+-------------------------------------+ +---------------------------+
|          Hibernate ORM 6.4          | |    Direct JDBC (HikariCP) |
|  - JPA Entity Lifecycle             | |  - JdbcReportingDao       |
|  - Transaction Management           | |  - Complex Aggregates     |
|  - Relational Mapping (HQL)         | |  - Raw Analytical Queries |
+-------------------------------------+ +---------------------------+
                                  |                       |
                                  v                       v
+-------------------------------------------------------------------+
|                      PostgreSQL 16.6 Database                     |
|  20 Normalized Tables, Foreign Keys, Unique Indexes, Cascades     |
+-------------------------------------------------------------------+
                                  |
                                  v
+-------------------------------------------------------------------+
|                   Physical File System Storage                    |
|  C:/StudyMate/storage/uploads/ (Isolated outside Web Root)        |
+-------------------------------------------------------------------+
```

---

## 3. Layer Breakdown & Responsibilities

### 1. Presentation Tier (JSP + JSTL + Vanilla JS)
- Renders dynamic HTML server-side using Jakarta Server Pages (JSP 3.1) and Jakarta Standard Tag Library (JSTL 3.0).
- Pure Vanilla JavaScript modules handle UI interactivity:
  - `theme.js`: Dark/light mode theme toggling and local state persistence.
  - `bookmarks.js`: Asynchronous AJAX bookmark toggle with CSRF header injection.
  - `navigation.js`: Sidebar toggling, modal manipulation, and dropdown controls.
  - `resource-viewer.js`: PDF and image viewer zoom controls and full-screen modes.

### 2. Security & Filter Pipeline
1. **SecurityHeadersFilter**: Intercepts every inbound request to inject secure HTTP response headers (Strict-Transport-Security, Content-Security-Policy, X-Frame-Options, X-Content-Type-Options).
2. **CsrfFilter**: Generates and attaches a session-scoped anti-CSRF token. Validates the incoming token on all state-modifying requests (`POST`, `PUT`, `DELETE`).
3. **AuthenticationFilter**: Intercepts paths under `/student/*`, `/admin/*`, and `/superadmin/*` to ensure an active `UserSessionDto` is present.
4. **AuthorizationFilter**: Inspects the authenticated user's assigned role against required URL route permissions.

### 3. Controller Tier (Java Servlets)
- Extends `jakarta.servlet.http.HttpServlet`.
- Decoupled from business logic:
  - Extracts and validates HTTP parameters.
  - Dispatches to corresponding Service methods.
  - Attaches model attributes to `HttpServletRequest`.
  - Forwards to target JSP views or issues HTTP 302 redirects.

### 4. Service Tier (Business Logic)
- Pure Java domain services managing business rules, transactions, and audit logging.
- Manages cross-cutting concerns such as password hashing via `SecurityUtil`, file validation via `FileValidator`, and event auditing via `AuditService`.

### 5. Persistence Tier
- **Hibernate ORM**: Used for all standard domain entity operations (Users, Courses, Subjects, Resources, Bookmarks). Handles object lifecycle, lazy loading, and transactional consistency.
- **Direct JDBC**: Used specifically within `JdbcReportingDao` for multi-join dashboard queries and system statistics to bypass Hibernate hydration overhead.

---

## 4. File Storage Architecture

```
Web Root (C:\StudyMate\src\main\webapp\)
├── assets/ (public static CSS, JS, SVG logos)
└── WEB-INF/ (protected JSP views)

Upload Storage (C:\StudyMate\storage\uploads\)  <-- EXTERNALLY ISOLATED
├── 2026/
│   ├── 10/
│   │   ├── 9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d.pdf
│   │   └── 4f8a2c1e-8e4a-4c2a-9f1b-3c4d5e6f7a8b.png
```

- Uploaded binaries are never written to the public web application root.
- Each uploaded file is assigned a randomized UUID storage key to prevent filename collisions and enumeration attacks.
- Files are served exclusively through `ResourceServlet` with strict role-based access checks and custom streaming headers (`Content-Disposition: inline; filename="..."`).

