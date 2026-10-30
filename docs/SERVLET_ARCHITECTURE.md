# Servlet & Controller Architecture: StudyMate

## 1. Controller Architecture Overview

StudyMate's web tier is built natively on the **Jakarta Servlet 6.0** specification (`jakarta.servlet.*`). 

Each controller is an independent `HttpServlet` mapped via `@WebServlet` annotations. Servlets adhere strictly to the **Single Responsibility Principle (SRP)**:
- Extracting and sanitizing query parameters and form payloads.
- Invoking Domain Services for business transactions.
- Binding data transfer objects (DTOs) or view models to `HttpServletRequest` attributes.
- Selecting and dispatching to target JSP views via `RequestDispatcher.forward()`, or issuing PRG (Post-Redirect-Get) HTTP 302 redirects.

---

## 2. Servlet Registry (10 Controllers)

| Controller Class | URL Patterns | Responsibility |
|---|---|---|
| `HomeServlet` | `/`, `/home` | Serves public landing page with live dynamic statistics and featured courses |
| `AuthServlet` | `/auth/*` (`/login`, `/register`, `/verify-email`, `/forgot-password`, `/reset-password`, `/logout`) | User authentication, registration, session management, and password recovery |
| `DashboardServlet` | `/student/dashboard` | Student primary workspace: enrolled courses, recent views, bookmarks, active bulletins |
| `CourseServlet` | `/courses`, `/student/courses` | Public and authenticated course catalog browsing and curriculum outlines |
| `SubjectServlet` | `/subjects`, `/student/subjects` | Subject filtering by course and semester; syllabus views |
| `ResourceServlet` | `/resources`, `/student/resources`, `/student/resources/view`, `/student/resources/stream`, `/student/resources/download` | Material search, details modal, inline PDF/image streaming, authenticated file download |
| `BookmarkServlet` | `/student/bookmarks`, `/student/bookmarks/toggle` | Asynchronous bookmark toggling and student bookmark workspace |
| `NotificationServlet` | `/student/notifications`, `/student/notifications/read` | Student in-app notifications and mark-as-read state mutations |
| `AdminServlet` | `/admin/*` (`/dashboard`, `/students`, `/courses`, `/subjects`, `/resources`, `/announcements`, `/logs`) | Faculty/admin operations: content ingestion, syllabus governance, announcements |
| `SuperAdminServlet` | `/superadmin/*` (`/dashboard`, `/administrators`, `/audit-logs`, `/settings`) | System governance: administrator provisioning, audit logs inspection, platform config |

---

## 3. Filter Interceptor Pipeline

The filter pipeline intercepts every inbound request in a deterministic order defined in `web.xml`:

```
Request Inbound
      │
      ▼
[ 1. SecurityHeadersFilter ]  --> Injects CSP, HSTS, X-Frame-Options, X-Content-Type-Options
      │
      ▼
[ 2. CsrfFilter ]             --> Injects/Validates anti-CSRF token on mutating HTTP methods
      │
      ▼
[ 3. AuthenticationFilter ]   --> Verifies active session on /student/*, /admin/*, /superadmin/*
      │
      ▼
[ 4. AuthorizationFilter ]    --> Verifies role privileges (ROLE_STUDENT, ROLE_ADMIN, ROLE_SUPER_ADMIN)
      │
      ▼
[ Target Servlet ]            --> Executes controller logic
      │
      ▼
Response Outbound
```

---

## 4. Multipart File Upload Handling

The `AdminServlet` handles resource uploads using Jakarta's `@MultipartConfig` annotation:

```java
@WebServlet(name = "AdminServlet", urlPatterns = {"/admin/*"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2 MB threshold before writing to temp disk
    maxFileSize = 1024 * 1024 * 50,       // 50 MB maximum per file
    maxRequestSize = 1024 * 1024 * 60     // 60 MB maximum total request
)
public class AdminServlet extends HttpServlet {
    // Controller logic extracting Parts:
    Part filePart = request.getPart("file");
    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
    // Dispatched to ResourceService for validation & storage...
}
```

---

## 5. High-Throughput Binary Streaming (`ResourceServlet`)

To prevent memory leaks and out-of-memory errors when streaming large PDFs or images, `ResourceServlet` implements non-blocking buffered chunked streaming directly to the `ServletOutputStream`:

```java
response.setContentType(resourceFile.getMimeType());
response.setContentLengthLong(file.length());
response.setHeader("Content-Disposition", isDownload 
    ? "attachment; filename=\"" + resourceFile.getFileName() + "\""
    : "inline; filename=\"" + resourceFile.getFileName() + "\"");

try (InputStream in = new BufferedInputStream(new FileInputStream(file));
     OutputStream out = new BufferedOutputStream(response.getOutputStream())) {
    byte[] buffer = new byte[8192]; // 8KB buffer
    int bytesRead;
    while ((bytesRead = in.read(buffer)) != -1) {
        out.write(buffer, 0, bytesRead);
    }
    out.flush();
}
```
Key Benefits:
- Physical disk file paths are never revealed to the browser.
- RAM utilization is capped at 8KB per active stream regardless of whether the document is 1MB or 50MB.
- Seamlessly supports browser PDF renderers and mobile web viewers.

