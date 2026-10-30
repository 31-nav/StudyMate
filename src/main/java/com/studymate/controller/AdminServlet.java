package com.studymate.controller;

import com.studymate.dto.response.UserDto;
import com.studymate.model.entity.Announcement;
import com.studymate.model.entity.Course;
import com.studymate.model.entity.User;
import com.studymate.model.enums.Priority;
import com.studymate.model.enums.TargetAudience;
import com.studymate.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {
    "/admin/dashboard",
    "/admin/students",
    "/admin/students/toggle-status",
    "/admin/announcements",
    "/admin/announcements/create",
    "/admin/announcements/delete",
    "/admin/logs"
})
public class AdminServlet extends HttpServlet {

    private final DashboardService dashboardService = new DashboardService();
    private final UserService userService = new UserService();
    private final AcademicService academicService = new AcademicService();
    private final AnnouncementService announcementService = new AnnouncementService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        switch (servletPath) {
            case "/admin/dashboard" -> showDashboard(req, resp);
            case "/admin/students" -> showStudents(req, resp);
            case "/admin/announcements" -> showAnnouncements(req, resp);
            case "/admin/logs" -> showLogs(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        switch (servletPath) {
            case "/admin/students/toggle-status" -> handleToggleStudentStatus(req, resp);
            case "/admin/announcements/create" -> handleCreateAnnouncement(req, resp);
            case "/admin/announcements/delete" -> handleDeleteAnnouncement(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Object> data = dashboardService.getAdminDashboardData();
        for (Map.Entry<String, Object> entry : data.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    private void showStudents(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String query = req.getParameter("q");
        String courseIdStr = req.getParameter("courseId");
        String semesterIdStr = req.getParameter("semesterId");
        String pageStr = req.getParameter("page");

        Long courseId = null;
        Long semesterId = null;
        try {
            if (courseIdStr != null && !courseIdStr.isBlank()) courseId = Long.parseLong(courseIdStr);
            if (semesterIdStr != null && !semesterIdStr.isBlank()) semesterId = Long.parseLong(semesterIdStr);
        } catch (NumberFormatException ignored) {}

        int page = 1;
        int pageSize = 15;
        if (pageStr != null) {
            try { page = Math.max(1, Integer.parseInt(pageStr)); } catch (NumberFormatException ignored) {}
        }
        int offset = (page - 1) * pageSize;

        List<User> students = userService.searchStudents(query, courseId, semesterId, offset, pageSize);
        long totalStudents = userService.countStudents(query, courseId, semesterId);
        int totalPages = (int) Math.ceil((double) totalStudents / pageSize);

        req.setAttribute("students", students);
        req.setAttribute("totalCount", totalStudents);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("courses", academicService.getAllActiveCourses());
        req.setAttribute("selectedCourseId", courseId);
        req.setAttribute("query", query);

        req.getRequestDispatcher("/WEB-INF/views/admin/students.jsp").forward(req, resp);
    }

    private void handleToggleStudentStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto adminDto = (UserDto) req.getSession().getAttribute("currentUser");
        User adminUser = userService.getUserById(adminDto.getId());

        try {
            Long studentId = Long.parseLong(req.getParameter("id"));
            userService.toggleUserActiveStatus(studentId, adminUser);
            req.getSession().setAttribute("flashSuccess", "Student account status updated!");
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin/students");
    }

    private void showAnnouncements(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Announcement> announcements = announcementService.getAllRecentAnnouncements(0, 50);
        req.setAttribute("announcements", announcements);
        req.getRequestDispatcher("/WEB-INF/views/admin/announcements.jsp").forward(req, resp);
    }

    private void handleCreateAnnouncement(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto adminDto = (UserDto) req.getSession().getAttribute("currentUser");
        User adminUser = userService.getUserById(adminDto.getId());

        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String priorityStr = req.getParameter("priority");
        String audienceStr = req.getParameter("audience");

        Priority priority = Priority.NORMAL;
        try { if (priorityStr != null) priority = Priority.valueOf(priorityStr); } catch (Exception ignored) {}

        TargetAudience audience = TargetAudience.ALL;
        try { if (audienceStr != null) audience = TargetAudience.valueOf(audienceStr); } catch (Exception ignored) {}

        try {
            announcementService.createAnnouncement(title, content, priority, audience, adminUser);
            req.getSession().setAttribute("flashSuccess", "Announcement published successfully!");
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", "Failed to publish announcement: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin/announcements");
    }

    private void handleDeleteAnnouncement(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto adminDto = (UserDto) req.getSession().getAttribute("currentUser");
        User adminUser = userService.getUserById(adminDto.getId());

        try {
            Long id = Long.parseLong(req.getParameter("id"));
            announcementService.deleteAnnouncement(id, adminUser);
            req.getSession().setAttribute("flashSuccess", "Announcement deleted!");
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin/announcements");
    }

    private void showLogs(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Object> data = dashboardService.getAdminDashboardData();
        req.setAttribute("recentAuditLogs", data.get("recentAuditLogs"));
        req.setAttribute("recentDownloads", data.get("recentDownloads"));
        req.getRequestDispatcher("/WEB-INF/views/admin/logs.jsp").forward(req, resp);
    }
}

