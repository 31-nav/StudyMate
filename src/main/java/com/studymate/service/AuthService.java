package com.studymate.service;

import com.studymate.config.AppConfig;
import com.studymate.dao.*;
import com.studymate.dto.request.RegisterRequest;
import com.studymate.email.EmailFactory;
import com.studymate.email.EmailService;
import com.studymate.exception.AuthenticationException;
import com.studymate.exception.ValidationException;
import com.studymate.model.entity.*;
import com.studymate.util.PasswordUtil;
import com.studymate.util.TokenUtil;
import com.studymate.util.ValidationUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.util.Optional;

public class AuthService {

    private static final Logger logger = LoggerFactory.getLogger(AuthService.class);

    private final UserDao userDao;
    private final RoleDao roleDao;
    private final CourseDao courseDao;
    private final SemesterDao semesterDao;
    private final TokenDao tokenDao;
    private final AuditLogDao auditLogDao;
    private final EmailService emailService;

    public AuthService() {
        this(new UserDao(), new RoleDao(), new CourseDao(), new SemesterDao(),
             new TokenDao(), new AuditLogDao(), EmailFactory.getEmailService());
    }

    public AuthService(UserDao userDao, RoleDao roleDao, CourseDao courseDao,
                       SemesterDao semesterDao, TokenDao tokenDao, AuditLogDao auditLogDao,
                       EmailService emailService) {
        this.userDao = userDao;
        this.roleDao = roleDao;
        this.courseDao = courseDao;
        this.semesterDao = semesterDao;
        this.tokenDao = tokenDao;
        this.auditLogDao = auditLogDao;
        this.emailService = emailService;
    }

    /**
     * Public Student Registration.
     * Enforces STUDENT role assignment strictly (prevents administrative privilege escalation).
     */
    public User registerStudent(RegisterRequest req) {
        if (req == null) throw new ValidationException("Registration data required");

        // Field validations
        if (req.getFullName() == null || req.getFullName().trim().length() < 2) {
            throw new ValidationException("Full name is required (minimum 2 characters)");
        }
        if (!ValidationUtil.isValidEmail(req.getEmail())) {
            throw new ValidationException("Please provide a valid email address");
        }
        if (!ValidationUtil.isValidRollNumber(req.getRollNumber())) {
            throw new ValidationException("Invalid student roll number format");
        }
        if (req.getPassword() == null || !PasswordUtil.isStrongPassword(req.getPassword())) {
            throw new ValidationException("Password must be at least 8 characters and include uppercase, lowercase, numbers, and special characters");
        }
        if (!req.getPassword().equals(req.getConfirmPassword())) {
            throw new ValidationException("Passwords do not match");
        }
        if (!req.isAgreeTerms()) {
            throw new ValidationException("You must accept the terms and conditions to register");
        }

        // Duplicate check
        if (userDao.existsByEmail(req.getEmail())) {
            throw new ValidationException("An account with this email address already exists");
        }

        // Create user entity
        User user = new User();
        user.setEmail(req.getEmail().trim().toLowerCase());
        user.setPasswordHash(PasswordUtil.hashPassword(req.getPassword()));
        user.setFullName(req.getFullName().trim());
        user.setRollNumber(req.getRollNumber() != null ? req.getRollNumber().trim() : null);
        user.setActive(true);
        user.setVerified(false); // Requires verification

        // Associate course and semester if provided
        if (req.getCourseId() != null) {
            courseDao.findById(req.getCourseId()).ifPresent(user::setCourse);
        }
        if (req.getSemesterId() != null) {
            semesterDao.findById(req.getSemesterId()).ifPresent(user::setSemester);
        }

        // Strictly assign ROLE_STUDENT
        Role studentRole = roleDao.findByName("ROLE_STUDENT")
                .orElseGet(() -> roleDao.save(new Role("ROLE_STUDENT", "Student Role")));
        user.getRoles().add(studentRole);

        User savedUser = userDao.save(user);

        // Generate email verification token
        String rawToken = TokenUtil.generateSecureToken();
        String tokenHash = TokenUtil.hashToken(rawToken);
        LocalDateTime expiry = LocalDateTime.now().plusHours(AppConfig.getEmailVerificationExpiryHours());

        EmailVerificationToken verificationToken = new EmailVerificationToken(savedUser, tokenHash, expiry);
        tokenDao.saveVerificationToken(verificationToken);

        // Dispatch verification email
        emailService.sendVerificationEmail(savedUser.getEmail(), savedUser.getFullName(), rawToken);

        // Audit log
        auditLogDao.save(new AuditLog(savedUser, "USER_REGISTERED", "User", (savedUser.getId() != null ? savedUser.getId().toString() : "0"),
                "Registered new student account", null));

        logger.info("Registered student account for email: {}", savedUser.getEmail());
        return savedUser;
    }

    /**
     * Verifies student email using the raw token.
     */
    public boolean verifyEmail(String rawToken) {
        if (rawToken == null || rawToken.isBlank()) {
            throw new ValidationException("Verification token is missing");
        }
        String tokenHash = TokenUtil.hashToken(rawToken);
        Optional<EmailVerificationToken> tokenOpt = tokenDao.findVerificationTokenByHash(tokenHash);

        if (tokenOpt.isEmpty()) {
            throw new ValidationException("Invalid or unrecognized verification token");
        }

        EmailVerificationToken token = tokenOpt.get();
        if (token.isUsed()) {
            throw new ValidationException("This verification link has already been used");
        }
        if (token.isExpired()) {
            throw new ValidationException("This verification link has expired. Please request a new one.");
        }

        token.markUsed();
        tokenDao.updateVerificationToken(token);

        User user = token.getUser();
        user.setVerified(true);
        userDao.update(user);

        emailService.sendWelcomeEmail(user.getEmail(), user.getFullName());

        auditLogDao.save(new AuditLog(user, "EMAIL_VERIFIED", "User", (user.getId() != null ? user.getId().toString() : "0"),
                "Verified email address", null));

        logger.info("Successfully verified email for user: {}", user.getEmail());
        return true;
    }

    /**
     * Authenticates user with email or roll number and password.
     */
    public User login(String identifier, String password, String ipAddress) {
        if (identifier == null || identifier.isBlank() || password == null || password.isBlank()) {
            throw new AuthenticationException("Please enter your identifier and password");
        }

        Optional<User> userOpt = userDao.findByEmailOrRoll(identifier);
        if (userOpt.isEmpty()) {
            throw new AuthenticationException("Invalid credentials entered");
        }

        User user = userOpt.get();
        if (!user.isActive()) {
            throw new AuthenticationException("Your account is currently disabled. Please contact an administrator.");
        }

        if (!PasswordUtil.checkPassword(password, user.getPasswordHash())) {
            auditLogDao.save(new AuditLog(user, "LOGIN_FAILED", "User", (user.getId() != null ? user.getId().toString() : "0"),
                    "Failed password attempt", ipAddress));
            throw new AuthenticationException("Invalid credentials entered");
        }

        // Optional: Warn if student has not verified email yet
        if (!user.isVerified() && user.isStudent()) {
            throw new AuthenticationException("Please verify your email address before logging in. Check your inbox.");
        }

        user.setLastLoginAt(LocalDateTime.now());
        userDao.update(user);

        auditLogDao.save(new AuditLog(user, "LOGIN_SUCCESS", "User", (user.getId() != null ? user.getId().toString() : "0"),
                "Successful user authentication", ipAddress));

        return user;
    }

    /**
     * Initiates password reset. Emits generic response to protect against user enumeration.
     */
    public void requestPasswordReset(String email) {
        if (email == null || !ValidationUtil.isValidEmail(email)) return;

        Optional<User> userOpt = userDao.findByEmail(email);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            String rawToken = TokenUtil.generateSecureToken();
            String tokenHash = TokenUtil.hashToken(rawToken);
            LocalDateTime expiry = LocalDateTime.now().plusHours(AppConfig.getPasswordResetExpiryHours());

            PasswordResetToken resetToken = new PasswordResetToken(user, tokenHash, expiry);
            tokenDao.saveResetToken(resetToken);

            emailService.sendPasswordResetEmail(user.getEmail(), user.getFullName(), rawToken);

            auditLogDao.save(new AuditLog(user, "PASSWORD_RESET_REQUESTED", "User", (user.getId() != null ? user.getId().toString() : "0"),
                    "Password reset token generated", null));
        }
    }

    /**
     * Resets password given valid raw reset token.
     */
    public void resetPassword(String rawToken, String newPassword, String confirmPassword) {
        if (rawToken == null || rawToken.isBlank()) {
            throw new ValidationException("Reset token is missing");
        }
        if (newPassword == null || !PasswordUtil.isStrongPassword(newPassword)) {
            throw new ValidationException("New password does not meet complexity requirements");
        }
        if (!newPassword.equals(confirmPassword)) {
            throw new ValidationException("Passwords do not match");
        }

        String tokenHash = TokenUtil.hashToken(rawToken);
        Optional<PasswordResetToken> tokenOpt = tokenDao.findResetTokenByHash(tokenHash);

        if (tokenOpt.isEmpty()) {
            throw new ValidationException("Invalid or unrecognized password reset token");
        }

        PasswordResetToken token = tokenOpt.get();
        if (token.isUsed() || token.isExpired()) {
            throw new ValidationException("Password reset link is expired or already used");
        }

        User user = token.getUser();
        user.setPasswordHash(PasswordUtil.hashPassword(newPassword));
        user.setUpdatedAt(LocalDateTime.now());
        userDao.update(user);

        token.markUsed();
        tokenDao.updateResetToken(token);

        emailService.sendPasswordChangedNotification(user.getEmail(), user.getFullName());

        auditLogDao.save(new AuditLog(user, "PASSWORD_RESET_COMPLETED", "User", (user.getId() != null ? user.getId().toString() : "0"),
                "Password reset completed via token", null));
    }

    /**
     * Changes user password when already authenticated.
     */
    public void changePassword(Long userId, String currentPassword, String newPassword, String confirmPassword) {
        User user = userDao.findById(userId)
                .orElseThrow(() -> new ValidationException("User not found"));

        if (!PasswordUtil.checkPassword(currentPassword, user.getPasswordHash())) {
            throw new ValidationException("Current password entered is incorrect");
        }
        if (newPassword == null || !PasswordUtil.isStrongPassword(newPassword)) {
            throw new ValidationException("New password does not meet complexity requirements");
        }
        if (!newPassword.equals(confirmPassword)) {
            throw new ValidationException("New passwords do not match");
        }

        user.setPasswordHash(PasswordUtil.hashPassword(newPassword));
        user.setUpdatedAt(LocalDateTime.now());
        userDao.update(user);

        emailService.sendPasswordChangedNotification(user.getEmail(), user.getFullName());

        auditLogDao.save(new AuditLog(user, "PASSWORD_CHANGED", "User", user.getId().toString(),
                "User changed password from profile settings", null));
    }

    /**
     * Registers an invited administrator with a valid token.
     */
    public User registerInvitedAdmin(String rawToken, String fullName, String password, String confirmPassword) {
        if (rawToken == null || rawToken.isBlank()) {
            throw new ValidationException("Invitation token is missing");
        }
        String tokenHash = TokenUtil.hashToken(rawToken);
        AdministratorInvitation invitation = tokenDao.findInvitationByHash(tokenHash)
                .orElseThrow(() -> new ValidationException("Invalid or unrecognized administrator invitation"));

        if (invitation.isAccepted() || invitation.isExpired()) {
            throw new ValidationException("This invitation has expired or has already been accepted");
        }
        if (fullName == null || fullName.trim().length() < 2) {
            throw new ValidationException("Full name is required");
        }
        if (!PasswordUtil.isStrongPassword(password)) {
            throw new ValidationException("Password does not meet complexity requirements");
        }
        if (!password.equals(confirmPassword)) {
            throw new ValidationException("Passwords do not match");
        }

        User adminUser = new User();
        adminUser.setEmail(invitation.getEmail());
        adminUser.setFullName(fullName.trim());
        adminUser.setPasswordHash(PasswordUtil.hashPassword(password));
        adminUser.setActive(true);
        adminUser.setVerified(true);

        Role adminRole = roleDao.findByName("ROLE_" + invitation.getAssignedRole())
                .orElseGet(() -> roleDao.findByName("ROLE_ADMIN").orElseThrow());
        adminUser.getRoles().add(adminRole);

        User savedAdmin = userDao.save(adminUser);

        invitation.markAccepted();
        tokenDao.updateInvitation(invitation);

        auditLogDao.save(new AuditLog(savedAdmin, "ADMIN_INVITE_ACCEPTED", "User", savedAdmin.getId().toString(),
                "Accepted administrator invitation", null));

        return savedAdmin;
    }
}
