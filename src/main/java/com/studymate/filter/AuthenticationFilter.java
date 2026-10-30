package com.studymate.filter;

import com.studymate.dto.response.UserDto;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/student/*", "/admin/*", "/superadmin/*", "/resources/download/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (request instanceof HttpServletRequest httpReq && response instanceof HttpServletResponse httpResp) {
            HttpSession session = httpReq.getSession(false);
            UserDto currentUser = session != null ? (UserDto) session.getAttribute("currentUser") : null;

            if (currentUser == null) {
                String targetUri = httpReq.getRequestURI();
                String query = httpReq.getQueryString();
                if (query != null && !query.isBlank()) {
                    targetUri += "?" + query;
                }

                // If AJAX request, return 401 Unauthorized
                String xRequestedWith = httpReq.getHeader("X-Requested-With");
                if ("XMLHttpRequest".equalsIgnoreCase(xRequestedWith)) {
                    httpResp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    httpResp.setContentType("application/json");
                    httpResp.getWriter().write("{\"success\":false,\"message\":\"Session expired. Please log in.\"}");
                    return;
                }

                httpResp.sendRedirect(httpReq.getContextPath() + "/auth/login?redirect=" +
                        java.net.URLEncoder.encode(targetUri, java.nio.charset.StandardCharsets.UTF_8));
                return;
            }
        }

        chain.doFilter(request, response);
    }
}

