package com.studymate.filter;

import com.studymate.util.SecurityUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

@WebFilter("/*")
public class CsrfFilter implements Filter {

    // Methods that require CSRF token validation
    private static final Set<String> STATE_CHANGING_METHODS = Set.of("POST", "PUT", "DELETE", "PATCH");

    // URLs that can bypass CSRF check (e.g. login & initial public registration before session is trusted)
    private static final Set<String> EXEMPT_PATHS = Set.of(
            "/auth/login",
            "/auth/register"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (request instanceof HttpServletRequest httpReq && response instanceof HttpServletResponse httpResp) {
            String method = httpReq.getMethod().toUpperCase();
            String path = httpReq.getServletPath();

            // Ensure CSRF token is available in session for all GET requests and forms
            HttpSession session = httpReq.getSession(true);
            String csrfToken = SecurityUtil.getOrCreateCsrfToken(session);
            httpReq.setAttribute("csrfToken", csrfToken);

            // If state-changing request, validate CSRF unless exempt
            if (STATE_CHANGING_METHODS.contains(method)) {
                boolean isExempt = EXEMPT_PATHS.stream().anyMatch(path::startsWith);
                if (!isExempt) {
                    if (!SecurityUtil.validateCsrfToken(httpReq)) {
                        httpResp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        httpResp.setContentType("application/json");
                        httpResp.getWriter().write("{\"success\":false,\"message\":\"Invalid or missing CSRF token\"}");
                        return;
                    }
                }
            }
        }

        chain.doFilter(request, response);
    }
}

