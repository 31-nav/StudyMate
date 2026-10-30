package com.studymate.controller;

import com.studymate.dto.response.UserDto;
import com.studymate.model.entity.Course;
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

@WebServlet(urlPatterns = {"/courses", "/student/courses", "/admin/courses", "/admin/courses/create"})
public class CourseServlet extends HttpServlet {

    private final AcademicService academicService = new AcademicService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();
        List<Course> courses = academicService.getAllCourses();
        req.setAttribute("courses", courses);

        if (servletPath.startsWith("/admin")) {
            req.getRequestDispatcher("/WEB-INF/views/admin/courses.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/WEB-INF/views/student/courses.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUserDto = (UserDto) req.getSession().getAttribute("currentUser");
        User adminUser = userService.getUserById(currentUserDto.getId());

        String code = req.getParameter("code");
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        int totalSemesters = 8;
        try {
            totalSemesters = Integer.parseInt(req.getParameter("totalSemesters"));
        } catch (Exception ignored) {}

        try {
            academicService.createCourse(code, name, description, totalSemesters, adminUser);
            req.getSession().setAttribute("flashSuccess", "Course '" + name + "' created successfully!");
        } catch (Exception e) {
            req.getSession().setAttribute("flashError", e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin/courses");
    }
}
