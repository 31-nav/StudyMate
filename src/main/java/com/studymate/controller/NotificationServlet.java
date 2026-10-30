package com.studymate.controller;

import com.studymate.dto.response.ApiResponse;
import com.studymate.dto.response.UserDto;
import com.studymate.model.entity.Announcement;
import com.studymate.model.entity.Notification;
import com.studymate.service.AnnouncementService;
import com.studymate.service.PersonalizationService;
import com.studymate.util.JsonUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/student/notifications", "/student/notifications/read-all", "/student/announcements"})
public class NotificationServlet extends HttpServlet {

    private final PersonalizationService personalizationService = new PersonalizationService();
    private final AnnouncementService announcementService = new AnnouncementService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto user = (UserDto) req.getSession().getAttribute("currentUser");
        String servletPath = req.getServletPath();

        if ("/student/announcements".equals(servletPath)) {
            List<Announcement> announcements = announcementService.getActiveAnnouncementsForStudent(
                    user.getCourseId(), user.getSemesterId(), 20
            );
            req.setAttribute("announcements", announcements);
            req.getRequestDispatcher("/WEB-INF/views/student/announcements.jsp").forward(req, resp);
        } else {
            List<Notification> notifications = personalizationService.getUserNotifications(user.getId(), 50);
            req.setAttribute("notifications", notifications);
            req.getRequestDispatcher("/WEB-INF/views/student/notifications.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto user = (UserDto) req.getSession().getAttribute("currentUser");
        personalizationService.markAllNotificationsRead(user.getId());

        String accept = req.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            resp.setContentType("application/json");
            resp.getWriter().write(JsonUtil.toJson(ApiResponse.ok("Notifications marked as read")));
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/notifications");
        }
    }
}

