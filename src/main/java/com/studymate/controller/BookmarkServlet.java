package com.studymate.controller;

import com.studymate.dto.response.ApiResponse;
import com.studymate.dto.response.UserDto;
import com.studymate.model.entity.Bookmark;
import com.studymate.service.PersonalizationService;
import com.studymate.util.JsonUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/student/bookmarks", "/student/bookmarks/toggle"})
public class BookmarkServlet extends HttpServlet {

    private final PersonalizationService personalizationService = new PersonalizationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto user = (UserDto) req.getSession().getAttribute("currentUser");
        List<Bookmark> bookmarks = personalizationService.getUserBookmarks(user.getId());
        req.setAttribute("bookmarks", bookmarks);
        req.getRequestDispatcher("/WEB-INF/views/student/bookmarks.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto user = (UserDto) req.getSession().getAttribute("currentUser");
        String resourceIdStr = req.getParameter("resourceId");
        String note = req.getParameter("note");

        try {
            Long resourceId = Long.parseLong(resourceIdStr);
            boolean bookmarked = personalizationService.toggleBookmark(user.getId(), resourceId, note);

            String accept = req.getHeader("Accept");
            if (accept != null && accept.contains("application/json")) {
                resp.setContentType("application/json");
                resp.getWriter().write(JsonUtil.toJson(ApiResponse.ok(
                        bookmarked ? "Resource saved to bookmarks" : "Resource removed from bookmarks",
                        Map.of("bookmarked", bookmarked)
                )));
            } else {
                resp.sendRedirect(req.getContextPath() + "/student/bookmarks");
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("application/json");
            resp.getWriter().write(JsonUtil.toJson(ApiResponse.error("Failed to update bookmark: " + e.getMessage())));
        }
    }
}

