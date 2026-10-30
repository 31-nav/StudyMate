package com.studymate.filter;

import com.studymate.dto.response.UserDto;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/superadmin/*"})
public class AuthorizationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (request instanceof HttpServletRequest httpReq && response instanceof HttpServletResponse httpResp) {
            HttpSession session = httpReq.getSession(false);
            UserDto currentUser = session != null ? (UserDto) session.getAttribute("currentUser") : null;

            if (currentUser == null) {
                httpResp.sendRedirect(httpReq.getContextPath() + "/auth/login");
                return;
            }

            String path = httpReq.getServletPath();

            if (path.startsWith("/superadmin") && !currentUser.isSuperAdmin()) {
                httpResp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied: Super Administrator privilege required");
                return;
            }

            if (path.startsWith("/admin") && !currentUser.isAdmin()) {
                httpResp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied: Administrator privilege required");
                return;
            }
        }

        chain.doFilter(request, response);
    }
}

