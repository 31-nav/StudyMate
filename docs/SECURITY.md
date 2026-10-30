# Security & Compliance Guide: StudyMate

## 1. Security Architecture & Threat Model

StudyMate is engineered under a comprehensive **Defense-in-Depth** model designed to safeguard sensitive academic credentials, curriculum intellectual property, and student privacy.

Every layer of the application—from HTTP transport to file storage—enforces strict security controls.

```
+-------------------------------------------------------------------------+
| Layer 1: HTTP Transport & Response Headers                              |
| CSP, HSTS, X-Frame-Options (SAMEORIGIN), X-Content-Type-Options         |
+-------------------------------------------------------------------------+
                                    │
                                    ▼
+-------------------------------------------------------------------------+
| Layer 2: Filter-Level Interception                                      |
| CsrfFilter, AuthenticationFilter, AuthorizationFilter (RBAC)            |
+-------------------------------------------------------------------------+
                                    │
                                    ▼
+-------------------------------------------------------------------------+
| Layer 3: Application & Controller Logic                                 |
| Session Fixation Protection, Input Validation, Role Assertion           |
+-------------------------------------------------------------------------+
                                    │
                                    ▼
+-------------------------------------------------------------------------+
| Layer 4: Cryptography & Authentication Service                          |
| BCrypt (Cost 12), SHA-256 Hashed Tokens, CSPRNG SecureRandom            |
+-------------------------------------------------------------------------+
                                    │
                                    ▼
+-------------------------------------------------------------------------+
| Layer 5: Data Access & Storage Isolation                                |
| Parameterized HQL/PreparedStatements, External UUID File Storage        |
+-------------------------------------------------------------------------+
```

---

## 2. Authentication & Credential Safeguards

### 2.1 BCrypt Password Hashing
- Passwords are never stored in plaintext or reversible formats.
- Hashed using the **BCrypt algorithm** with a work cost factor of **12** and cryptographically random 128-bit salts.
- Automatically defends against high-speed GPU/ASIC rainbow table cracking.

### 2.2 Token Protection (Verification & Reset)
- Email verification and password reset tokens are generated using `java.security.SecureRandom` (32 bytes / 256 bits of cryptographic entropy).
- Tokens transmitted to users are **never stored raw in the database**.
- The database stores only the deterministic **SHA-256 hash** of the token. If the database is compromised, attackers cannot use leaked token records to hijack accounts.

### 2.3 Session Fixation Defense
- Upon successful authentication, the existing pre-authentication session is destroyed immediately via `session.invalidate()`.
- A brand new session is generated via `request.getSession(true)` with a fresh JSESSIONID cookie.
- Session cookies are protected with the `HttpOnly` attribute, preventing JavaScript access and XSS-based cookie extraction.

---

## 3. Cross-Site Request Forgery (CSRF) Mitigation

StudyMate enforces universal Anti-CSRF protection via `CsrfFilter`:
1. **Token Generation**: A unique 32-character CSPRNG token is generated and bound to each authenticated user session (`session.getAttribute("CSRF_TOKEN")`).
2. **Form Injection**: All HTML forms rendered via JSP include a hidden CSRF input field:
   ```html
   <input type="hidden" name="csrf_token" value="${sessionScope.CSRF_TOKEN}" />
   ```
3. **AJAX Header Support**: Single-page requests (such as bookmark toggles) read the CSRF token from the `<meta name="csrf-token" content="...">` header and transmit it via `X-CSRF-Token`.
4. **Mandatory Enforcement**: Any state-changing HTTP request (`POST`, `PUT`, `DELETE`) lacking a matching CSRF token is immediately rejected with `HTTP 403 Forbidden`.

---

## 4. Cross-Site Scripting (XSS) & Content Security Policy (CSP)

### View Escaping
- JSPs exclusively use JSTL `<c:out value="${...}" />` or standard XML-escaped expressions to render user-supplied content.
- Direct output scriptlets (`<%= ... %>`) are strictly prohibited in the codebase.

### Strict Content Security Policy
Injected via `SecurityHeadersFilter` on every HTTP response:
```http
Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://fonts.googleapis.com; font-src 'self' https://cdn.jsdelivr.net https://fonts.gstatic.com data:; img-src 'self' data: https: blob:; frame-src 'self' blob:; connect-src 'self';
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
Referrer-Policy: strict-origin-when-cross-origin
```

---

## 5. SQL Injection Immunity

1. **Hibernate HQL**: All Hibernate queries use named parameter binding (`:param`), completely eliminating string concatenation:
   ```java
   session.createQuery("FROM User u WHERE u.email = :email", User.class)
          .setParameter("email", email)
          .uniqueResult();
   ```
2. **JDBC PreparedStatements**: Direct reporting queries in `JdbcReportingDao` strictly use `java.sql.PreparedStatement` with typed parameter placeholders (`?`).

---

## 6. File Upload Security & Path Traversal Prevention

Educational file uploads present critical security risks (remote code execution, path traversal, malicious executables). StudyMate enforces multi-layered upload validation:

1. **Magic Byte / MIME Type Verification**: Validates that file content headers match allowed MIME types (`application/pdf`, `image/png`, `image/jpeg`, etc.).
2. **Extension Whitelisting**: Strictly permits only `.pdf`, `.png`, `.jpg`, `.jpeg`, `.gif`, `.webp`, and `.svg`. Dangerous extensions (`.jsp`, `.exe`, `.sh`, `.bat`) are immediately rejected.
3. **Path Traversal Sanitization**: Filenames are processed with `Paths.get(name).getFileName().toString()` to strip any directory traversal attempts (`../../`).
4. **Randomized Storage Keys**: Physical files on disk are named using randomized UUIDs (e.g., `3f9a8b1c-....pdf`), preventing directory enumeration attacks.
5. **Physical Web-Root Isolation**: Binary assets reside in `C:\StudyMate\storage\uploads\`, entirely outside Tomcat's web context. Direct HTTP access to physical files is impossible.

---

## 7. Tamper-Evident Security Audit Trails

All security-critical actions are recorded synchronously in the `audit_logs` table via `AuditService`:
- User Logins (Success and Failure with reason)
- User Registrations & Password Resets
- Administrative Account Provisioning & Status Toggles
- Resource Uploads & Deletions
- System Configuration Modifications

Each audit log entry captures:
- Timestamp (UTC)
- Actor User ID (or NULL for unauthenticated attempts)
- Action Code (e.g., `LOGIN_FAILURE`, `RESOURCE_UPLOAD`)
- Target Entity Name & Entity ID
- Remote IP Address (`request.getRemoteAddr()`)
- Client User-Agent Header

