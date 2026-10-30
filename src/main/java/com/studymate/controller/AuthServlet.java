package com.studymate.controller;

import com.studymate.dto.request.LoginRequest;
import com.studymate.dto.request.RegisterRequest;
import com.studymate.dto.request.ResetPasswordRequest;
import com.studymate.dto.response.UserDto;
import com.studymate.exception.AuthenticationException;
import com.studymate.exception.ValidationException;
import com.studymate.model.entity.User;
import com.studymate.service.AcademicService;
import com.studymate.service.AuthService;
import com.studymate.util.SecurityUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {

    private final AuthService authService = new AuthService();
    private final AcademicService academicService = new AcademicService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || "/".equals(pathInfo)) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        switch (pathInfo) {
            case "/login" -> showLoginForm(req, resp);
            case "/register" -> showRegisterForm(req, resp);
            case "/verify-email" -> handleVerifyEmail(req, resp);
            case "/forgot-password" -> showForgotPasswordForm(req, resp);
            case "/reset-password" -> showResetPasswordForm(req, resp);
            case "/logout" -> handleLogout(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        switch (pathInfo) {
            case "/login" -> handleLogin(req, resp);
            case "/register" -> handleRegister(req, resp);
            case "/forgot-password" -> handleForgotPassword(req, resp);
            case "/reset-password" -> handleResetPassword(req, resp);
            case "/logout" -> handleLogout(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showLoginForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // If already logged in, redirect to appropriate dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            UserDto user = (UserDto) session.getAttribute("currentUser");
            redirectToDashboard(user, req, resp);
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String identifier = req.getParameter("identifier");
        String password = req.getParameter("password");
        String redirect = req.getParameter("redirect");

        try {
            User user = authService.login(identifier, password, req.getRemoteAddr());

            // Prevent Session Fixation: change session ID on authentication
            HttpSession session = req.getSession();
            req.changeSessionId();

            UserDto userDto = UserDto.fromEntity(user);
            session.setAttribute("currentUser", userDto);

            // Re-generate CSRF token for the authenticated session
            SecurityUtil.getOrCreateCsrfToken(session);

            if (redirect != null && !redirect.isBlank() && redirect.startsWith(req.getContextPath())) {
                resp.sendRedirect(redirect);
            } else {
                redirectToDashboard(userDto, req, resp);
            }

        } catch (AuthenticationException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("identifier", identifier);
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
        }
    }

    private void showRegisterForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String inviteToken = req.getParameter("inviteToken");
        req.setAttribute("courses", academicService.getAllActiveCourses());
        req.setAttribute("inviteToken", inviteToken);
        req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String inviteToken = req.getParameter("inviteToken");

        // If registering via administrator invitation
        if (inviteToken != null && !inviteToken.isBlank()) {
            handleAdminInviteRegister(req, resp, inviteToken);
            return;
        }

        // Standard student registration
        RegisterRequest registerReq = new RegisterRequest();
        registerReq.setFullName(req.getParameter("fullName"));
        registerReq.setEmail(req.getParameter("email"));
        registerReq.setRollNumber(req.getParameter("rollNumber"));
        registerReq.setPassword(req.getParameter("password"));
        registerReq.setConfirmPassword(req.getParameter("confirmPassword"));

        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr != null && !courseIdStr.isBlank()) {
            try { registerReq.setCourseId(Long.parseLong(courseIdStr)); } catch (NumberFormatException ignored) {}
        }

        String semesterIdStr = req.getParameter("semesterId");
        if (semesterIdStr != null && !semesterIdStr.isBlank()) {
            try { registerReq.setSemesterId(Long.parseLong(semesterIdStr)); } catch (NumberFormatException ignored) {}
        }

        registerReq.setAgreeTerms("on".equalsIgnoreCase(req.getParameter("agreeTerms"))
                || "true".equalsIgnoreCase(req.getParameter("agreeTerms")));

        try {
            authService.registerStudent(registerReq);
            req.getSession().setAttribute("flashSuccess",
                    "Registration successful! Please check your email inbox to verify your account.");
            resp.sendRedirect(req.getContextPath() + "/auth/login");
        } catch (ValidationException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("courses", academicService.getAllActiveCourses());
            req.setAttribute("reg", registerReq);
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
        }
    }

    private void handleAdminInviteRegister(HttpServletRequest req, HttpServletResponse resp, String inviteToken)
            throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        try {
            User adminUser = authService.registerInvitedAdmin(inviteToken, fullName, password, confirmPassword);
            req.getSession().setAttribute("flashSuccess",
                    "Administrator account activated! You may now sign in.");
            resp.sendRedirect(req.getContextPath() + "/auth/login");
        } catch (ValidationException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("inviteToken", inviteToken);
            req.setAttribute("courses", academicService.getAllActiveCourses());
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
        }
    }

    private void handleVerifyEmail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        try {
            authService.verifyEmail(token);
            req.setAttribute("verified", true);
            req.setAttribute("message", "Your email has been successfully verified! You can now access all StudyMate features.");
        } catch (ValidationException e) {
            req.setAttribute("verified", false);
            req.setAttribute("message", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/auth/verify-email.jsp").forward(req, resp);
    }

    private void showForgotPasswordForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(req, resp);
    }

    private void handleForgotPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        authService.requestPasswordReset(email);

        req.setAttribute("submitted", true);
        req.setAttribute("message", "If an account exists for that email, a password reset link has been dispatched.");
        req.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(req, resp);
    }

    private void showResetPasswordForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        req.setAttribute("token", token);
        req.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(req, resp);
    }

    private void handleResetPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        try {
            authService.resetPassword(token, newPassword, confirmPassword);
            req.getSession().setAttribute("flashSuccess", "Password reset successful! Please log in with your new password.");
            resp.sendRedirect(req.getContextPath() + "/auth/login");
        } catch (ValidationException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("token", token);
            req.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(req, resp);
        }
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/auth/login?logout=true");
    }

    private void redirectToDashboard(UserDto user, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (user.isSuperAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/superadmin/dashboard");
        } else if (user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        }
    }
}

