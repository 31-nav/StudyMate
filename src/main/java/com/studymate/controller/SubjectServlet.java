package com.studymate.controller;

import com.studymate.dto.response.UserDto;
import com.studymate.model.entity.Course;
import com.studymate.model.entity.Semester;
import com.studymate.model.entity.Subject;
import com.studymate.model.entity.User;
import com.studymate.service.AcademicService;
import com.studymate.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/subjects", "/student/subjects", "/admin/subjects", "/admin/subjects/create", "/admin/subjects/update", "/admin/subjects/delete"})
public class SubjectServlet extends HttpServlet {

    private final AcademicService academicService = new AcademicService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        String courseIdStr = req.getParameter("courseId");
        String semesterIdStr = req.getParameter("semesterId");
        String query = req.getParameter("q");

        Long courseId = null;
        Long semesterId = null;
        try {
            if (courseIdStr != null && !courseIdStr.isBlank()) courseId = Long.parseLong(courseIdStr);
            if (semesterIdStr != null && !semesterIdStr.isBlank()) semesterId = Long.parseLong(semesterIdStr);
        } catch (NumberFormatException ignored) {}

        List<Subject> subjects;
        if (courseId != null && semesterId != null) {
            subjects = academicService.getSubjectsByCourseAndSemester(courseId, semesterId);
        } else if (courseId != null) {
            subjects = academicService.getSubjectsByCourse(courseId);
        } else {
            subjects = academicService.searchSubjects(query, courseId, semesterId, 0, 50);
        }

        List<Course> courses = academicService.getAllActiveCourses();
        req.setAttribute("subjects", subjects);
        req.setAttribute("courses", courses);
        req.setAttribute("selectedCourseId", courseId);
        req.setAttribute("selectedSemesterId", semesterId);

        if (courseId != null) {
            req.setAttribute("semesters", academicService.getSemestersByCourse(courseId));
        }

        if (servletPath.startsWith("/admin")) {
            req.getRequestDispatcher("/WEB-INF/views/admin/subjects.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/WEB-INF/views/student/subjects.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUserDto = (UserDto) req.getSession().getAttribute("currentUser");
        User adminUser = userService.getUserById(currentUserDto.getId());

        String servletPath = req.getServletPath();

        if ("/admin/subjects/create".equals(servletPath)) {
            try {
                Long courseId = Long.parseLong(req.getParameter("courseId"));
                Long semesterId = Long.parseLong(req.getParameter("semesterId"));
                String code = req.getParameter("code");
                String name = req.getParameter("name");
                String description = req.getParameter("description");
                int creditHours = Integer.parseInt(req.getParameter("creditHours"));

                academicService.createSubject(courseId, semesterId, code, name, description, creditHours, adminUser);
                req.getSession().setAttribute("flashSuccess", "Subject '" + name + "' added successfully!");
            } catch (Exception e) {
                req.getSession().setAttribute("flashError", "Failed to create subject: " + e.getMessage());
            }

        } else if ("/admin/subjects/update".equals(servletPath)) {
            try {
                Long id = Long.parseLong(req.getParameter("id"));
                String name = req.getParameter("name");
                String description = req.getParameter("description");
                int creditHours = Integer.parseInt(req.getParameter("creditHours"));
                boolean active = "on".equalsIgnoreCase(req.getParameter("active")) || "true".equalsIgnoreCase(req.getParameter("active"));

                academicService.updateSubject(id, name, description, creditHours, active, adminUser);
                req.getSession().setAttribute("flashSuccess", "Subject updated successfully!");
            } catch (Exception e) {
                req.getSession().setAttribute("flashError", "Failed to update subject: " + e.getMessage());
            }

        } else if ("/admin/subjects/delete".equals(servletPath)) {
            try {
                Long id = Long.parseLong(req.getParameter("id"));
                academicService.deleteSubject(id, adminUser);
                req.getSession().setAttribute("flashSuccess", "Subject deleted successfully!");
            } catch (Exception e) {
                req.getSession().setAttribute("flashError", "Failed to delete subject: " + e.getMessage());
            }
        }

        resp.sendRedirect(req.getContextPath() + "/admin/subjects");
    }
}
