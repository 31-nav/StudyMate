package com.studymate.controller;

import com.studymate.dao.JdbcReportingDao;
import com.studymate.service.AcademicService;
import com.studymate.service.ResourceService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

@WebServlet(urlPatterns = {"", "/home", "/about", "/features", "/contact"})
public class HomeServlet extends HttpServlet {

    private final JdbcReportingDao jdbcReportingDao = new JdbcReportingDao();
    private final AcademicService academicService = new AcademicService();
    private final ResourceService resourceService = new ResourceService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        // Pass platform statistics to the landing page
        Map<String, Long> stats = jdbcReportingDao.getPlatformOverviewStatistics();
        req.setAttribute("stats", stats);
        req.setAttribute("featuredCourses", academicService.getAllActiveCourses());
        req.setAttribute("recentUploads", resourceService.getRecentResources(4));

        if ("/about".equals(path)) {
            req.setAttribute("activeSection", "about");
        } else if ("/features".equals(path)) {
            req.setAttribute("activeSection", "features");
        } else if ("/contact".equals(path)) {
            req.setAttribute("activeSection", "contact");
        } else {
            req.setAttribute("activeSection", "home");
        }

        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}

