package com.studymate.email;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Development & Testing Email Adapter.
 * Records all dispatched emails in-memory and outputs details to logger,
 * guaranteeing seamless offline and local development without requiring live SMTP credentials.
 */
public class DevMailAdapter implements EmailService {

    private static final Logger logger = LoggerFactory.getLogger(DevMailAdapter.class);

    public record SentEmail(String toEmail, String subject, String token, LocalDateTime sentAt) {}

    private static final List<SentEmail> SENT_EMAILS = Collections.synchronizedList(new ArrayList<>());
    private static volatile String lastSentVerificationToken;
    private static volatile String lastSentResetToken;
    private static volatile String lastSentInvitationToken;

    public static List<SentEmail> getSentEmails() {
        return new ArrayList<>(SENT_EMAILS);
    }

    public static String getLastSentVerificationToken() {
        return lastSentVerificationToken;
    }

    public static String getLastSentResetToken() {
        return lastSentResetToken;
    }

    public static String getLastSentInvitationToken() {
        return lastSentInvitationToken;
    }

    public static void clear() {
        SENT_EMAILS.clear();
        lastSentVerificationToken = null;
        lastSentResetToken = null;
        lastSentInvitationToken = null;
    }

    @Override
    public void sendWelcomeEmail(String toEmail, String fullName) {
        SENT_EMAILS.add(new SentEmail(toEmail, "Welcome to StudyMate", null, LocalDateTime.now()));
        logger.info("[DEV MAIL] Welcome email dispatched to {} ({})", toEmail, fullName);
    }

    @Override
    public void sendVerificationEmail(String toEmail, String fullName, String rawToken) {
        lastSentVerificationToken = rawToken;
        SENT_EMAILS.add(new SentEmail(toEmail, "Verify Email", rawToken, LocalDateTime.now()));
        logger.info("[DEV MAIL] Verification email to {}. Token: {}", toEmail, rawToken);
    }

    @Override
    public void sendPasswordResetEmail(String toEmail, String fullName, String rawToken) {
        lastSentResetToken = rawToken;
        SENT_EMAILS.add(new SentEmail(toEmail, "Password Reset", rawToken, LocalDateTime.now()));
        logger.info("[DEV MAIL] Password reset email to {}. Token: {}", toEmail, rawToken);
    }

    @Override
    public void sendPasswordChangedNotification(String toEmail, String fullName) {
        SENT_EMAILS.add(new SentEmail(toEmail, "Password Changed Alert", null, LocalDateTime.now()));
        logger.info("[DEV MAIL] Password changed notification to {}", toEmail);
    }

    @Override
    public void sendAdminInvitationEmail(String toEmail, String invitedByName, String rawToken) {
        lastSentInvitationToken = rawToken;
        SENT_EMAILS.add(new SentEmail(toEmail, "Admin Invitation", rawToken, LocalDateTime.now()));
        logger.info("[DEV MAIL] Admin invitation to {}. Token: {}", toEmail, rawToken);
    }
}

