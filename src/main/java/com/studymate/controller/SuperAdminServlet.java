package com.studymate.controller;

import com.studymate.dto.response.UserDto;
import com.studymate.model.entity.AuditLog;
import com.studymate.model.entity.User;
import com.studymate.service.AuditService;
import com.studymate.service.DashboardService;
import com.studymate.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {
    "/superadmin/dashboard",
    "/superadmin/administrators",
    "/superadmin/administrators/invite",
    "/superadmin/administrators/toggle",
    "/superadmin/audit-logs",
    "/superadmin/settings"
})
public class SuperAdminServlet extends HttpServlet {

    private final DashboardService dashboardService = new DashboardService();
    private final UserService userService = new UserService();
    private final AuditService auditService = new AuditService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        switch (servletPath) {
            case "/superadmin/dashboard" -> showDashboard(req, resp);
            case "/superadmin/administrators" -> showAdministrators(req, resp);
            case "/superadmin/audit-logs" -> showAuditLogs(req, resp);
            case "/superadmin/settings" -> showSettings(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        switch (servletPath) {
            case "/superadmin/administrators/invite" -> handleInviteAdmin(req, resp);
            case "/superadmin/administrators/toggle" -> handleToggleAdminStatus(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Object> data = dashboardService.getSuperAdminDashboardData();
        for (Map.Entry<String, Object> entry : data.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }
        req.setAttribute("admins", userService.getAllAdministrators());
        req.getRequestDispatcher("/WEB-INF/views/superadmin/dashboard.jsp").forward(req, resp);
    }

    private void showAdministrators(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<User> admins = userService.getAllAdministrators();
        req.setAttribute("admins", admins);
        req.getRequestDispatcher("/WEB-INF/views/superadmin/administrators.jsp").forward(req, resp);
    }

    private void handleInviteAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto superAdminDto = (UserDto) req.getSession().getAttribute("currentUser");
        User superAdmin = userService.getUserById(superAdminDto.getId());

        String email = req.getParameter("email");
        String role = req.getParameter("role");

        try {
            userService.inviteAdministrator(email, role, superAdmin);
            req.getSession().setAttribute("flashSuccess", "Administrator invitation dispatched to: " + email);
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/superadmin/administrators");
    }

    private void handleToggleAdminStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto superAdminDto = (UserDto) req.getSession().getAttribute("currentUser");
        User superAdmin = userService.getUserById(superAdminDto.getId());

        try {
            Long adminId = Long.parseLong(req.getParameter("id"));
            if (adminId.equals(superAdmin.getId())) {
                req.getSession().setAttribute("flashError", "You cannot deactivate your own Super Admin account!");
            } else {
                userService.toggleUserActiveStatus(adminId, superAdmin);
                req.getSession().setAttribute("flashSuccess", "Administrator status updated successfully!");
            }
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/superadmin/administrators");
    }

    private void showAuditLogs(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<AuditLog> logs = auditService.getRecentAuditLogs(0, 50);
        req.setAttribute("logs", logs);
        req.getRequestDispatcher("/WEB-INF/views/superadmin/audit-logs.jsp").forward(req, resp);
    }

    private void showSettings(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/superadmin/settings.jsp").forward(req, resp);
    }
}

