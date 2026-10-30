# Agent Guidelines for StudyMate

This document provides operational context, architectural guardrails, coding standards, and execution procedures for autonomous AI agents maintaining, modifying, or testing the **StudyMate** codebase.

---

## 1. Architectural Guardrails (Non-Negotiable)

1. **Pure Jakarta EE 10 Stack**:
   - Backend MUST use Java 21 LTS with standard Java Servlets (`jakarta.servlet.*`), JSP 3.1, and JSTL 3.0.
   - Do NOT introduce **Spring Boot**, **Spring Framework**, **Micronaut**, or **Quarkus**.
   - Do NOT introduce Node.js, Python, or Go backends.
2. **Frontend Conventions**:
   - Modern semantic HTML5, CSS3 (Glassmorphism design system in `/assets/css/studymate.css`), and Vanilla JavaScript ES6+.
   - Do NOT introduce **React**, **Vue**, **Angular**, **Svelte**, or modern frontend bundlers (Webpack, Vite) into the core webapp.
3. **Dual Persistence Layer**:
   - **Hibernate ORM 6.4**: Primary persistence layer for JPA entities, transactional mutations, and relationship management.
   - **Direct JDBC (HikariCP / `JdbcReportingDao`)**: Dedicated for complex multi-table analytical aggregations and dashboard reporting.
   - Do NOT duplicate business operations across both layers. Keep transactional mutations in Hibernate and analytical aggregations in JDBC.
4. **Security & RBAC Enforcement**:
   - Never rely on frontend UI hiding for authorization. All authorization MUST be verified server-side in `AuthorizationFilter` or domain service checks.
   - Role identifiers are strictly: `ROLE_STUDENT`, `ROLE_ADMIN`, and `ROLE_SUPER_ADMIN`.
   - Public registration MUST always assign `ROLE_STUDENT`. Never accept role parameters from public requests.
   - Password hashing MUST use BCrypt (cost factor 12). Tokens must be hashed using SHA-256 before database storage.
5. **Physical Storage**:
   - Uploaded files MUST be stored outside the web root (`C:\StudyMate\storage\uploads`).
   - File access must be served exclusively through authenticated streaming endpoints (`ResourceServlet`), never via direct static URLs.

---

## 2. Directory Layout & Key Locations

- **Toolchain**:
  - JDK 21: `C:\StudyMate\tools\jdk-21`
  - Maven 3.9: `C:\StudyMate\tools\maven`
  - PostgreSQL 16: `C:\StudyMate\tools\pgsql`
  - Tomcat 10: `C:\StudyMate\tools\tomcat-10`
  - Local Maven Repo: `C:\StudyMate\.m2\repository`
- **Application Files**:
  - Source Code: `src/main/java/com/studymate/`
  - Webapp & JSP Views: `src/main/webapp/WEB-INF/views/`
  - Static Assets: `src/main/webapp/assets/`
  - Unit/Integration Tests: `src/test/java/com/studymate/`
  - Database Scripts: `database/schema.sql` and `database/seed.sql`
  - Binary Upload Storage: `storage/uploads/`

---

## 3. Build & Test Procedures

### Maven Execution
Always use the local Maven wrapper script or set `M2_HOME` and specify the custom local repository:
```powershell
powershell -ExecutionPolicy Bypass -File C:\StudyMate\run-mvn.ps1 clean compile
```
Or directly:
```powershell
cmd.exe /c "set JAVA_HOME=C:\StudyMate\tools\jdk-21&& C:\StudyMate\tools\maven\bin\mvn.cmd clean test -Dmaven.repo.local=C:\StudyMate\.m2\repository"
```

### Automated Testing Rules
- Every new service method must have corresponding unit tests in `src/test/java/com/studymate/`.
- Mockito tests on Java 21 must account for bytecode agent attachments. Use `@MockitoSettings(strictness = Strictness.LENIENT)` where appropriate.
- If running Maven tests on Windows outside sandbox isolation, use `BypassSandbox: true` so Maven Surefire can communicate over loopback IPC sockets.

---

## 4. Deployment Procedures

### WAR Packaging
```powershell
cmd.exe /c "set JAVA_HOME=C:\StudyMate\tools\jdk-21&& C:\StudyMate\tools\maven\bin\mvn.cmd package -DskipTests -Dmaven.repo.local=C:\StudyMate\.m2\repository"
```
The resulting WAR is located at `target/studymate.war`.

### Tomcat Deployment
1. Copy `target/studymate.war` to `C:\StudyMate\tools\tomcat-10\webapps\studymate.war`.
2. Ensure PostgreSQL is active on port `5432` (`postgres.exe -D C:\StudyMate\data\pgdata`).
3. Start Tomcat:
```powershell
cmd.exe /c "set CATALINA_HOME=C:\StudyMate\tools\tomcat-10&& set JAVA_HOME=C:\StudyMate\tools\jdk-21&& cd /d C:\StudyMate\tools\tomcat-10\bin&& catalina.bat run"
```
4. Context path: `http://localhost:8080/studymate/`.

---

## 5. Web.xml vs @WebServlet Rule
**Crucial Tomcat 10 Requirement**:
Do NOT map the same servlet class in both `web.xml` (`<servlet>` / `<servlet-mapping>`) and with `@WebServlet` annotations. Doing so causes Tomcat 10 to throw `IllegalArgumentException: The servlets named [...] are both mapped to the url-pattern which is not permitted` and aborts context initialization.
Keep `@WebServlet` on servlet classes, and keep `web.xml` dedicated to:
- `<filter>` and `<filter-mapping>`
- `<listener>`
- `<session-config>`
- `<error-page>`
- `<welcome-file-list>`

---

## 6. Coding & Styling Standards
- **Java**: Follow Google Java Style Guide. All methods should include Javadoc explaining intent, parameters, and exceptions thrown.
- **Transactions**: Every mutating Hibernate operation must be wrapped in `try (Session session = HibernateUtil.getSessionFactory().openSession()) { Transaction tx = session.beginTransaction(); ... tx.commit(); }`.
- **JSP Views**: Use JSTL tags (`<c:forEach>`, `<c:if>`, `<c:out>`) for presentation logic. NEVER use raw Java scriptlets (`<% ... %>`) in modern JSPs.
- **CSS**: Adhere to the CSS variable tokens in `studymate.css` (`--bg-primary`, `--accent-primary`, `--glass-bg`, etc.).

