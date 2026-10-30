package com.studymate.email;

import com.studymate.config.AppConfig;
import com.studymate.config.MailConfig;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.nio.charset.StandardCharsets;

public class JakartaMailService implements EmailService {

    private static final Logger logger = LoggerFactory.getLogger(JakartaMailService.class);

    private void sendHtmlEmail(String toEmail, String subject, String htmlContent) {
        try {
            Session session = Session.getInstance(MailConfig.getSmtpProperties(), new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(AppConfig.getMailUsername(), AppConfig.getMailPassword());
                }
            });

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(AppConfig.getMailFrom()));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject, StandardCharsets.UTF_8.name());
            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            logger.info("Email successfully dispatched to {}", toEmail);
        } catch (Exception e) {
            logger.error("Failed to send email to {}: {}", toEmail, e.getMessage(), e);
            throw new RuntimeException("Email delivery failed: " + e.getMessage(), e);
        }
    }

    @Override
    public void sendWelcomeEmail(String toEmail, String fullName) {
        String subject = "Welcome to StudyMate - Your Learning. Your Space.";
        String html = EmailTemplates.buildWelcomeEmail(fullName, AppConfig.getAppBaseUrl());
        sendHtmlEmail(toEmail, subject, html);
    }

    @Override
    public void sendVerificationEmail(String toEmail, String fullName, String rawToken) {
        String verifyUrl = AppConfig.getAppBaseUrl() + "/auth/verify-email?token=" + rawToken;
        String subject = "Verify Your StudyMate Account";
        String html = EmailTemplates.buildVerificationEmail(fullName, verifyUrl);
        sendHtmlEmail(toEmail, subject, html);
    }

    @Override
    public void sendPasswordResetEmail(String toEmail, String fullName, String rawToken) {
        String resetUrl = AppConfig.getAppBaseUrl() + "/auth/reset-password?token=" + rawToken;
        String subject = "StudyMate Password Reset Request";
        String html = EmailTemplates.buildPasswordResetEmail(fullName, resetUrl, AppConfig.getPasswordResetExpiryHours());
        sendHtmlEmail(toEmail, subject, html);
    }

    @Override
    public void sendPasswordChangedNotification(String toEmail, String fullName) {
        String subject = "StudyMate Security Alert: Password Changed";
        String html = EmailTemplates.buildPasswordChangedAlert(fullName, AppConfig.getAppBaseUrl());
        sendHtmlEmail(toEmail, subject, html);
    }

    @Override
    public void sendAdminInvitationEmail(String toEmail, String invitedByName, String rawToken) {
        String inviteUrl = AppConfig.getAppBaseUrl() + "/auth/register?inviteToken=" + rawToken;
        String subject = "You've been invited as an Administrator on StudyMate";
        String html = EmailTemplates.buildAdminInvitationEmail(invitedByName, inviteUrl, AppConfig.getAdminInviteExpiryHours());
        sendHtmlEmail(toEmail, subject, html);
    }
}

