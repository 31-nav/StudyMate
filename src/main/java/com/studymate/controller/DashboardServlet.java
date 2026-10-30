package com.studymate.controller;

import com.studymate.dto.response.UserDto;
import com.studymate.exception.ValidationException;
import com.studymate.model.entity.User;
import com.studymate.service.AcademicService;
import com.studymate.service.AuthService;
import com.studymate.service.DashboardService;
import com.studymate.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;

@WebServlet(urlPatterns = {"/student/dashboard", "/student/profile", "/student/change-password"})
public class DashboardServlet extends HttpServlet {

    private final DashboardService dashboardService = new DashboardService();
    private final UserService userService = new UserService();
    private final AuthService authService = new AuthService();
    private final AcademicService academicService = new AcademicService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        UserDto currentUserDto = (UserDto) session.getAttribute("currentUser");
        User user = userService.getUserById(currentUserDto.getId());

        String servletPath = req.getServletPath();

        if ("/student/profile".equals(servletPath)) {
            req.setAttribute("user", user);
            req.setAttribute("courses", academicService.getAllActiveCourses());
            if (user.getCourse() != null) {
                req.setAttribute("semesters", academicService.getSemestersByCourse(user.getCourse().getId()));
            }
            req.getRequestDispatcher("/WEB-INF/views/student/profile.jsp").forward(req, resp);
            return;
        }

        // Student Dashboard view
        Map<String, Object> dashboardData = dashboardService.getStudentDashboardData(user);
        for (Map.Entry<String, Object> entry : dashboardData.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }
        req.setAttribute("user", user);
        req.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        UserDto currentUserDto = (UserDto) session.getAttribute("currentUser");

        String servletPath = req.getServletPath();

        if ("/student/profile".equals(servletPath)) {
            String fullName = req.getParameter("fullName");
            String rollNumber = req.getParameter("rollNumber");
            Long courseId = null;
            Long semesterId = null;

            try {
                if (req.getParameter("courseId") != null && !req.getParameter("courseId").isBlank()) {
                    courseId = Long.parseLong(req.getParameter("courseId"));
                }
                if (req.getParameter("semesterId") != null && !req.getParameter("semesterId").isBlank()) {
                    semesterId = Long.parseLong(req.getParameter("semesterId"));
                }

                User updated = userService.updateProfile(currentUserDto.getId(), fullName, rollNumber, courseId, semesterId);
                session.setAttribute("currentUser", UserDto.fromEntity(updated));
                session.setAttribute("flashSuccess", "Profile updated successfully!");
            } catch (Exception e) {
                session.setAttribute("flashError", "Failed to update profile: " + e.getMessage());
            }
            resp.sendRedirect(req.getContextPath() + "/student/profile");

        } else if ("/student/change-password".equals(servletPath)) {
            String currentPassword = req.getParameter("currentPassword");
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");

            try {
                authService.changePassword(currentUserDto.getId(), currentPassword, newPassword, confirmPassword);
                session.setAttribute("flashSuccess", "Password updated successfully!");
            } catch (ValidationException e) {
                session.setAttribute("flashError", e.getMessage());
            }
            resp.sendRedirect(req.getContextPath() + "/student/profile");
        }
    }
}

