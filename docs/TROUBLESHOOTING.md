# Troubleshooting & Diagnostic Guide: StudyMate

This guide provides practical diagnostic procedures and resolutions for common issues encountered during development, testing, and deployment of StudyMate.

---

## 1. Servlet & Container Issues

### Issue 1: Tomcat 10 Duplicate Servlet Mapping Collision
**Symptom**: Tomcat fails to start the `/studymate` context, logging:
```
java.lang.IllegalArgumentException: The servlets named [AdminServlet] and [com.studymate.controller.AdminServlet] are both mapped to the url-pattern [/admin/dashboard] which is not permitted
```
**Cause**: The servlet class is registered via both `@WebServlet` annotation in the Java source file and `<servlet>` / `<servlet-mapping>` blocks in `web.xml`.
**Resolution**: Remove redundant `<servlet>` and `<servlet-mapping>` tags from `web.xml`. Keep `@WebServlet` on servlet classes and reserve `web.xml` for filters, listeners, session configuration, and error pages.

---

## 2. Database & Connection Issues

### Issue 2: PostgreSQL Connection Refused
**Symptom**: `PSQLException: Connection to localhost:5432 refused. Check that the hostname and port are correct and that the postmaster is accepting TCP/IP connections.`
**Cause**: The PostgreSQL database server is not running or is listening on an alternative port.
**Resolution**:
1. Check if PostgreSQL process is active:
   ```powershell
   Get-Process postgres -ErrorAction SilentlyContinue
   ```
2. Start the PostgreSQL cluster:
   ```powershell
   C:\StudyMate\tools\pgsql\bin\postgres.exe -D C:\StudyMate\data\pgdata
   ```
3. Test connectivity using `psql`:
   ```powershell
   C:\StudyMate\tools\pgsql\bin\psql.exe -U postgres -h localhost -d studymate -c "SELECT 1;"
   ```

### Issue 3: Hibernate `LazyInitializationException`
**Symptom**: `org.hibernate.LazyInitializationException: could not initialize proxy [com.studymate.model.Subject#1] - no Session`
**Cause**: Accessing a lazily-loaded association (`fetch = FetchType.LAZY`) after the Hibernate `Session` has closed.
**Resolution**: Update the DAO query to use HQL `JOIN FETCH` (e.g., `SELECT r FROM Resource r JOIN FETCH r.subject WHERE r.id = :id`) so all required associations are eagerly fetched in a single query.

---

## 3. Security & Filter Issues

### Issue 4: HTTP 403 Forbidden on Form Submissions
**Symptom**: Submitting an upload form, password change, or announcement returns `HTTP 403 Forbidden` with message `Invalid or missing CSRF token`.
**Cause**: The form does not include the hidden CSRF token input field, or the user's session has expired.
**Resolution**: Ensure every `<form method="POST">` includes:
```html
<input type="hidden" name="csrf_token" value="${sessionScope.CSRF_TOKEN}">
```
For AJAX requests, verify that the `X-CSRF-Token` header is included in the request headers:
```javascript
headers: {
    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
}
```

---

## 4. File Upload & Storage Issues

### Issue 5: Upload Fails with `NoSuchFileException`
**Symptom**: `java.nio.file.NoSuchFileException: C:\StudyMate\storage\uploads\2026\10\...`
**Cause**: The physical target directory on the filesystem has not been created.
**Resolution**: Ensure `ResourceService` invokes `Files.createDirectories(targetDir)` prior to streaming the upload:
```java
Path uploadDir = Paths.get("C:/StudyMate/storage/uploads");
if (!Files.exists(uploadDir)) {
    Files.createDirectories(uploadDir);
}
```

### Issue 6: File Upload Exceeds Permitted Limit
**Symptom**: `jakarta.servlet.ServletException: org.apache.tomcat.util.http.fileupload.impl.SizeLimitExceededException`
**Cause**: Uploaded file exceeds the 50MB ceiling defined in `@MultipartConfig`.
**Resolution**: Check the file size before uploading. If institutional policy permits larger files, update the `maxFileSize` and `maxRequestSize` parameters in `AdminServlet.java`.

