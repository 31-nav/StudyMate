package com.studymate.service;

import com.studymate.dao.*;
import com.studymate.dto.request.RegisterRequest;
import com.studymate.email.EmailService;
import com.studymate.exception.AuthenticationException;
import com.studymate.exception.ValidationException;
import com.studymate.model.entity.*;
import com.studymate.util.PasswordUtil;
import com.studymate.util.TokenUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
@DisplayName("Authentication & Student Lifecycle Service Test")
class AuthServiceTest {

    @Mock private UserDao userDao;
    @Mock private RoleDao roleDao;
    @Mock private CourseDao courseDao;
    @Mock private SemesterDao semesterDao;
    @Mock private TokenDao tokenDao;
    @Mock private AuditLogDao auditLogDao;
    @Mock private EmailService emailService;

    private AuthService authService;

    @BeforeEach
    void setUp() {
        authService = new AuthService(userDao, roleDao, courseDao, semesterDao, tokenDao, auditLogDao, emailService);
    }

    @Test
    @DisplayName("Successful student registration saves user, hashes password, assigns STUDENT role, and sends verification email")
    void testRegisterStudentSuccess() {
        RegisterRequest req = new RegisterRequest();
        req.setFullName("Alexander Hamilton");
        req.setEmail("alex@university.edu");
        req.setRollNumber("CS2026-001");
        req.setPassword("SecurePass@2026");
        req.setConfirmPassword("SecurePass@2026");
        req.setAgreeTerms(true);

        when(userDao.existsByEmail("alex@university.edu")).thenReturn(false);
        Role studentRole = new Role("ROLE_STUDENT", "Student Role");
        when(roleDao.findByName("ROLE_STUDENT")).thenReturn(Optional.of(studentRole));

        when(userDao.save(any(User.class))).thenAnswer(invocation -> {
            User u = invocation.getArgument(0);
            u.setId(101L);
            return u;
        });

        User result = authService.registerStudent(req);

        assertNotNull(result);
        assertEquals("alex@university.edu", result.getEmail());
        assertEquals("Alexander Hamilton", result.getFullName());
        assertTrue(PasswordUtil.checkPassword("SecurePass@2026", result.getPasswordHash()), "Password must be BCrypt hashed");
        assertTrue(result.getRoles().contains(studentRole), "Must assign ROLE_STUDENT strictly");

        verify(tokenDao, times(1)).saveVerificationToken(any(EmailVerificationToken.class));
        verify(emailService, times(1)).sendVerificationEmail(eq("alex@university.edu"), eq("Alexander Hamilton"), anyString());
        verify(auditLogDao, times(1)).save(any(AuditLog.class));
    }

    @Test
    @DisplayName("Registration fails when full name is shorter than 2 characters")
    void testRegisterStudentShortName() {
        RegisterRequest req = new RegisterRequest();
        req.setFullName("A");
        req.setEmail("alex@university.edu");
        req.setPassword("SecurePass@2026");
        req.setConfirmPassword("SecurePass@2026");
        req.setAgreeTerms(true);

        ValidationException ex = assertThrows(ValidationException.class, () -> authService.registerStudent(req));
        assertTrue(ex.getMessage().contains("Full name is required"));
    }

    @Test
    @DisplayName("Registration fails with invalid email format")
    void testRegisterStudentInvalidEmail() {
        RegisterRequest req = new RegisterRequest();
        req.setFullName("Alexander Hamilton");
        req.setEmail("not-an-email");
        req.setPassword("SecurePass@2026");
        req.setConfirmPassword("SecurePass@2026");
        req.setAgreeTerms(true);

        ValidationException ex = assertThrows(ValidationException.class, () -> authService.registerStudent(req));
        assertTrue(ex.getMessage().toLowerCase().contains("valid email"));
    }

    @Test
    @DisplayName("Registration fails when passwords do not match")
    void testRegisterStudentPasswordMismatch() {
        RegisterRequest req = new RegisterRequest();
        req.setFullName("Alexander Hamilton");
        req.setEmail("alex@university.edu");
        req.setPassword("SecurePass@2026");
        req.setConfirmPassword("DifferentPass@2026");
        req.setAgreeTerms(true);

        ValidationException ex = assertThrows(ValidationException.class, () -> authService.registerStudent(req));
        assertTrue(ex.getMessage().contains("Passwords do not match"));
    }

    @Test
    @DisplayName("Registration fails when terms and conditions are not accepted")
    void testRegisterStudentDisagreeTerms() {
        RegisterRequest req = new RegisterRequest();
        req.setFullName("Alexander Hamilton");
        req.setEmail("alex@university.edu");
        req.setPassword("SecurePass@2026");
        req.setConfirmPassword("SecurePass@2026");
        req.setAgreeTerms(false);

        ValidationException ex = assertThrows(ValidationException.class, () -> authService.registerStudent(req));
        assertTrue(ex.getMessage().toLowerCase().contains("terms and conditions"));
    }

    @Test
    @DisplayName("Registration prevents duplicate email registration")
    void testRegisterStudentDuplicateEmail() {
        RegisterRequest req = new RegisterRequest();
        req.setFullName("Alexander Hamilton");
        req.setEmail("alex@university.edu");
        req.setRollNumber("CS2026-001");
        req.setPassword("SecurePass@2026");
        req.setConfirmPassword("SecurePass@2026");
        req.setAgreeTerms(true);

        when(userDao.existsByEmail("alex@university.edu")).thenReturn(true);

        ValidationException ex = assertThrows(ValidationException.class, () -> authService.registerStudent(req));
        assertTrue(ex.getMessage().contains("already exists"));
    }

    @Test
    @DisplayName("Email verification succeeds with valid token and marks user verified")
    void testVerifyEmailSuccess() {
        String rawToken = "sample-valid-token-12345";
        String tokenHash = TokenUtil.hashToken(rawToken);

        User user = new User("alex@university.edu", "hash", "Alexander Hamilton");
        user.setId(101L);
        user.setVerified(false);

        EmailVerificationToken token = new EmailVerificationToken(user, tokenHash, LocalDateTime.now().plusHours(24));
        when(tokenDao.findVerificationTokenByHash(tokenHash)).thenReturn(Optional.of(token));

        boolean verified = authService.verifyEmail(rawToken);

        assertTrue(verified);
        assertTrue(user.isVerified(), "User account must be marked verified");
        assertTrue(token.isUsed(), "Token must be invalidated after consumption");
        verify(userDao, times(1)).update(user);
        verify(emailService, times(1)).sendWelcomeEmail(eq("alex@university.edu"), eq("Alexander Hamilton"));
    }

    @Test
    @DisplayName("Email verification rejects expired token")
    void testVerifyEmailExpired() {
        String rawToken = "expired-token-12345";
        String tokenHash = TokenUtil.hashToken(rawToken);

        User user = new User("alex@university.edu", "hash", "Alexander Hamilton");
        user.setId(101L);
        EmailVerificationToken token = new EmailVerificationToken(user, tokenHash, LocalDateTime.now().minusHours(2));
        when(tokenDao.findVerificationTokenByHash(tokenHash)).thenReturn(Optional.of(token));

        ValidationException ex = assertThrows(ValidationException.class, () -> authService.verifyEmail(rawToken));
        assertTrue(ex.getMessage().contains("expired"));
    }

    @Test
    @DisplayName("Successful login returns authenticated user and updates last login timestamp")
    void testLoginSuccess() {
        String password = "CorrectPassword@2026";
        String hash = PasswordUtil.hashPassword(password);

        User user = new User("student@studymate.edu", hash, "Active Student");
        user.setId(101L);
        user.setVerified(true);
        user.setActive(true);

        when(userDao.findByEmailOrRoll("student@studymate.edu")).thenReturn(Optional.of(user));

        User loggedIn = authService.login("student@studymate.edu", password, "127.0.0.1");

        assertNotNull(loggedIn);
        assertEquals("Active Student", loggedIn.getFullName());
        assertNotNull(loggedIn.getLastLoginAt());
        verify(userDao, times(1)).update(user);
    }

    @Test
    @DisplayName("Login rejects incorrect password and records audit attempt")
    void testLoginIncorrectPassword() {
        String hash = PasswordUtil.hashPassword("CorrectPassword@2026");
        User user = new User("student@studymate.edu", hash, "Active Student");
        user.setId(101L);
        user.setActive(true);

        when(userDao.findByEmailOrRoll("student@studymate.edu")).thenReturn(Optional.of(user));

        AuthenticationException ex = assertThrows(AuthenticationException.class,
                () -> authService.login("student@studymate.edu", "WrongPassword", "127.0.0.1"));

        assertEquals("Invalid credentials entered", ex.getMessage());
        verify(auditLogDao, times(1)).save(any(AuditLog.class));
    }

    @Test
    @DisplayName("Login rejects disabled/locked user account")
    void testLoginDisabledAccount() {
        User user = new User("student@studymate.edu", "hash", "Suspended Student");
        user.setId(101L);
        user.setActive(false);

        when(userDao.findByEmailOrRoll("student@studymate.edu")).thenReturn(Optional.of(user));

        AuthenticationException ex = assertThrows(AuthenticationException.class,
                () -> authService.login("student@studymate.edu", "anyPassword", "127.0.0.1"));

        assertTrue(ex.getMessage().contains("disabled"));
    }

    @Test
    @DisplayName("Password reset succeeds and securely updates BCrypt hash")
    void testResetPasswordSuccess() {
        String rawToken = "valid-reset-token-777";
        String tokenHash = TokenUtil.hashToken(rawToken);

        User user = new User("alex@university.edu", PasswordUtil.hashPassword("OldPass@2026"), "Alexander Hamilton");
        user.setId(101L);
        PasswordResetToken token = new PasswordResetToken(user, tokenHash, LocalDateTime.now().plusHours(1));

        when(tokenDao.findResetTokenByHash(tokenHash)).thenReturn(Optional.of(token));

        authService.resetPassword(rawToken, "BrandNewPass@2026", "BrandNewPass@2026");

        assertTrue(PasswordUtil.checkPassword("BrandNewPass@2026", user.getPasswordHash()));
        assertTrue(token.isUsed());
        verify(userDao, times(1)).update(user);
    }
}
