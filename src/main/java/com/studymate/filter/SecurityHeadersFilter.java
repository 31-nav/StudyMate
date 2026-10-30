package com.studymate.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter("/*")
public class SecurityHeadersFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (response instanceof HttpServletResponse httpResp) {
            // Anti-MIME-sniffing
            httpResp.setHeader("X-Content-Type-Options", "nosniff");

            // Prevent clickjacking while allowing same-origin embedding (needed for internal PDF viewer)
            httpResp.setHeader("X-Frame-Options", "SAMEORIGIN");

            // Cross-site scripting filter
            httpResp.setHeader("X-XSS-Protection", "1; mode=block");

            // Referrer policy
            httpResp.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");

            // Modern Content Security Policy (allowing Bootstrap, Bootstrap Icons, PDF.js)
            httpResp.setHeader("Content-Security-Policy",
                    "default-src 'self'; " +
                    "script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; " +
                    "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://fonts.googleapis.com; " +
                    "font-src 'self' https://cdn.jsdelivr.net https://fonts.gstatic.com data:; " +
                    "img-src 'self' data: https: blob:; " +
                    "frame-src 'self' blob:; " +
                    "connect-src 'self';");
        }

        chain.doFilter(request, response);
    }
}

