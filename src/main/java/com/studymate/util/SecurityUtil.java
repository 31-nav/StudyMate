package com.studymate.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.security.SecureRandom;
import java.util.Base64;

/**
 * Security helpers for CSRF tokens, XSS output encoding, and safe redirection.
 */
public final class SecurityUtil {

    public static final String CSRF_TOKEN_SESSION_ATTR = "CSRF_TOKEN";
    public static final String CSRF_HEADER_NAME = "X-CSRF-TOKEN";
    public static final String CSRF_PARAM_NAME = "_csrf";

    private static final SecureRandom RANDOM = new SecureRandom();

    private SecurityUtil() {}

    /**
     * Gets existing CSRF token or creates and stores a new one in the session.
     */
    public static String getOrCreateCsrfToken(HttpSession session) {
        if (session == null) return null;
        String token = (String) session.getAttribute(CSRF_TOKEN_SESSION_ATTR);
        if (token == null || token.isBlank()) {
            byte[] bytes = new byte[32];
            RANDOM.nextBytes(bytes);
            token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
            session.setAttribute(CSRF_TOKEN_SESSION_ATTR, token);
        }
        return token;
    }

    /**
     * Validates whether the request submitted a valid CSRF token.
     */
    public static boolean validateCsrfToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        String sessionToken = (String) session.getAttribute(CSRF_TOKEN_SESSION_ATTR);
        if (sessionToken == null) return false;

        // Check header first, then form parameter
        String requestToken = request.getHeader(CSRF_HEADER_NAME);
        if (requestToken == null || requestToken.isBlank()) {
            requestToken = request.getParameter(CSRF_PARAM_NAME);
        }

        return requestToken != null && sessionToken.equals(requestToken.trim());
    }

    /**
     * Basic HTML escaping to prevent Cross-Site Scripting (XSS).
     */
    public static String escapeHtml(String input) {
        if (input == null) return "";
        StringBuilder sb = new StringBuilder(input.length());
        for (char c : input.toCharArray()) {
            switch (c) {
                case '<' -> sb.append("&lt;");
                case '>' -> sb.append("&gt;");
                case '&' -> sb.append("&amp;");
                case '"' -> sb.append("&quot;");
                case '\'' -> sb.append("&#x27;");
                case '/' -> sb.append("&#x2F;");
                default -> sb.append(c);
            }
        }
        return sb.toString();
    }

    public static String sanitizeHtml(String input) {
        return escapeHtml(input);
    }
}
