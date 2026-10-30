package com.studymate.controller;

import com.studymate.dto.response.UserDto;
import com.studymate.model.entity.*;
import com.studymate.model.enums.ResourceType;
import com.studymate.model.enums.ResourceVisibility;
import com.studymate.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

@WebServlet(urlPatterns = {
    "/resources/*",
    "/student/resources",
    "/admin/resources",
    "/admin/resources/upload",
    "/admin/resources/update",
    "/admin/resources/delete"
})
@MultipartConfig(
    fileSizeThreshold = 1048576,    // 1MB
    maxFileSize = 52428800,         // 50MB
    maxRequestSize = 62914560       // 60MB
)
public class ResourceServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ResourceServlet.class);

    private final ResourceService resourceService = new ResourceService();
    private final AcademicService academicService = new AcademicService();
    private final PersonalizationService personalizationService = new PersonalizationService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();
        String pathInfo = req.getPathInfo();

        if ("/resources/raw".equals(servletPath) || (servletPath.equals("/resources") && "/raw".equals(pathInfo))) {
            streamRawFile(req, resp, false);
            return;
        } else if ("/resources/download".equals(servletPath) || (servletPath.equals("/resources") && "/download".equals(pathInfo))) {
            streamRawFile(req, resp, true);
            return;
        } else if ("/resources/view".equals(servletPath) || (servletPath.equals("/resources") && "/view".equals(pathInfo))) {
            viewResourcePage(req, resp);
            return;
        }

        if (servletPath.startsWith("/admin")) {
            showAdminResourceList(req, resp);
        } else {
            showStudentResourceCatalog(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        if ("/admin/resources/upload".equals(servletPath)) {
            handleUpload(req, resp);
        } else if ("/admin/resources/update".equals(servletPath)) {
            handleUpdate(req, resp);
        } else if ("/admin/resources/delete".equals(servletPath)) {
            handleDelete(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showStudentResourceCatalog(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("q");
        String courseIdStr = req.getParameter("courseId");
        String semesterIdStr = req.getParameter("semesterId");
        String subjectIdStr = req.getParameter("subjectId");
        String categoryIdStr = req.getParameter("categoryId");
        String typeStr = req.getParameter("type");
        String sort = req.getParameter("sort");
        String pageStr = req.getParameter("page");

        Long courseId = parseLong(courseIdStr);
        Long semesterId = parseLong(semesterIdStr);
        Long subjectId = parseLong(subjectIdStr);
        Long categoryId = parseLong(categoryIdStr);

        ResourceType type = null;
        if (typeStr != null && !typeStr.isBlank()) {
            try { type = ResourceType.valueOf(typeStr.toUpperCase()); } catch (IllegalArgumentException ignored) {}
        }

        int page = 1;
        int pageSize = 12;
        if (pageStr != null) {
            try { page = Math.max(1, Integer.parseInt(pageStr)); } catch (NumberFormatException ignored) {}
        }
        int offset = (page - 1) * pageSize;

        List<Resource> resources = resourceService.searchResources(keyword, courseId, semesterId, subjectId, categoryId, type, sort, offset, pageSize);
        long totalCount = resourceService.countSearchResources(keyword, courseId, semesterId, subjectId, categoryId, type);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        // Populate filter drop-down options
        req.setAttribute("resources", resources);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("courses", academicService.getAllActiveCourses());
        req.setAttribute("categories", academicService.getAllCategories());

        if (courseId != null) {
            req.setAttribute("semesters", academicService.getSemestersByCourse(courseId));
            req.setAttribute("subjects", academicService.getSubjectsByCourse(courseId));
        }

        req.setAttribute("selectedCourseId", courseId);
        req.setAttribute("selectedSemesterId", semesterId);
        req.setAttribute("selectedSubjectId", subjectId);
        req.setAttribute("selectedCategoryId", categoryId);
        req.setAttribute("selectedType", typeStr);
        req.setAttribute("selectedSort", sort);
        req.setAttribute("keyword", keyword);

        req.getRequestDispatcher("/WEB-INF/views/student/resources.jsp").forward(req, resp);
    }

    private void showAdminResourceList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("q");
        List<Resource> resources = resourceService.searchResources(keyword, null, null, null, null, null, "latest", 0, 100);

        req.setAttribute("resources", resources);
        req.setAttribute("courses", academicService.getAllActiveCourses());
        req.setAttribute("categories", academicService.getAllCategories());
        req.getRequestDispatcher("/WEB-INF/views/admin/resources.jsp").forward(req, resp);
    }

    private void viewResourcePage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = parseLong(req.getParameter("id"));
        if (id == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing resource ID");
            return;
        }

        try {
            Resource resource = resourceService.getResourceById(id, true);

            UserDto currentUserDto = (UserDto) req.getSession().getAttribute("currentUser");
            if (currentUserDto != null) {
                User user = userService.getUserById(currentUserDto.getId());
                personalizationService.recordRecentlyViewed(user, resource);
                req.setAttribute("isBookmarked", personalizationService.isBookmarked(user.getId(), id));
            }

            req.setAttribute("resource", resource);
            req.getRequestDispatcher("/WEB-INF/views/student/view-resource.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Resource not found");
        }
    }

    private void streamRawFile(HttpServletRequest req, HttpServletResponse resp, boolean isDownload) throws IOException {
        Long id = parseLong(req.getParameter("id"));
        if (id == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing resource ID");
            return;
        }

        try {
            UserDto currentUserDto = (UserDto) req.getSession().getAttribute("currentUser");
            User currentUser = currentUserDto != null ? userService.getUserById(currentUserDto.getId()) : null;

            File file = resourceService.downloadResource(id, currentUser, req.getRemoteAddr(), req.getHeader("User-Agent"));
            Resource resource = resourceService.getResourceById(id, false);
            ResourceFile primaryFile = resource.getPrimaryFile();

            String mimeType = primaryFile != null ? primaryFile.getMimeType() : "application/octet-stream";
            resp.setContentType(mimeType);
            resp.setContentLengthLong(file.length());

            String dispositionType = isDownload ? "attachment" : "inline";
            String filename = primaryFile != null ? primaryFile.getOriginalFilename() : file.getName();
            resp.setHeader("Content-Disposition", dispositionType + "; filename=\"" + filename.replace("\"", "") + "\"");

            try (FileInputStream fis = new FileInputStream(file);
                 OutputStream os = resp.getOutputStream()) {
                IOUtils.copy(fis, os);
                os.flush();
            }

        } catch (Exception e) {
            logger.error("Error streaming resource file: {}", e.getMessage());
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        }
    }

    private void handleUpload(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUserDto = (UserDto) req.getSession().getAttribute("currentUser");
        User adminUser = userService.getUserById(currentUserDto.getId());

        String title = req.getParameter("title");
        String description = req.getParameter("description");
        Long courseId = parseLong(req.getParameter("courseId"));
        Long semesterId = parseLong(req.getParameter("semesterId"));
        Long subjectId = parseLong(req.getParameter("subjectId"));
        Long categoryId = parseLong(req.getParameter("categoryId"));
        String typeStr = req.getParameter("resourceType");
        String externalUrl = req.getParameter("externalUrl");
        boolean isDownloadable = "on".equalsIgnoreCase(req.getParameter("isDownloadable")) || "true".equalsIgnoreCase(req.getParameter("isDownloadable"));
        String tags = req.getParameter("tags");

        ResourceType resourceType = ResourceType.PDF;
        if (typeStr != null) {
            try { resourceType = ResourceType.valueOf(typeStr.toUpperCase()); } catch (Exception ignored) {}
        }

        Part filePart = null;
        try {
            filePart = req.getPart("file");
        } catch (Exception ignored) {}

        try {
            String originalFilename = null;
            String mimeType = null;
            long size = 0;
            java.io.InputStream stream = null;

            if (filePart != null && filePart.getSize() > 0) {
                originalFilename = filePart.getSubmittedFileName();
                mimeType = filePart.getContentType();
                size = filePart.getSize();
                stream = filePart.getInputStream();
            }

            resourceService.createResource(
                    title, description, courseId, semesterId, subjectId, categoryId,
                    resourceType, externalUrl, ResourceVisibility.PUBLIC, isDownloadable,
                    tags, adminUser, originalFilename, mimeType, size, stream
            );

            req.getSession().setAttribute("flashSuccess", "Resource '" + title + "' published successfully!");
        } catch (Exception e) {
            logger.error("Upload failed: {}", e.getMessage(), e);
            req.getSession().setAttribute("flashError", "Upload failed: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin/resources");
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUserDto = (UserDto) req.getSession().getAttribute("currentUser");
        User adminUser = userService.getUserById(currentUserDto.getId());

        Long id = parseLong(req.getParameter("id"));
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        Long categoryId = parseLong(req.getParameter("categoryId"));
        boolean isDownloadable = "on".equalsIgnoreCase(req.getParameter("isDownloadable")) || "true".equalsIgnoreCase(req.getParameter("isDownloadable"));
        String tags = req.getParameter("tags");

        try {
            resourceService.updateResource(id, title, description, categoryId, isDownloadable, tags, adminUser);
            req.getSession().setAttribute("flashSuccess", "Resource updated successfully!");
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", "Failed to update resource: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin/resources");
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUserDto = (UserDto) req.getSession().getAttribute("currentUser");
        User adminUser = userService.getUserById(currentUserDto.getId());

        Long id = parseLong(req.getParameter("id"));
        try {
            resourceService.deleteResource(id, adminUser);
            req.getSession().setAttribute("flashSuccess", "Resource deleted successfully!");
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", "Failed to delete resource: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin/resources");
    }

    private Long parseLong(String val) {
        if (val == null || val.isBlank()) return null;
        try { return Long.parseLong(val.trim()); } catch (NumberFormatException e) { return null; }
    }
}

