package com.studymate.email;

public interface EmailService {
    void sendWelcomeEmail(String toEmail, String fullName);
    void sendVerificationEmail(String toEmail, String fullName, String rawToken);
    void sendPasswordResetEmail(String toEmail, String fullName, String rawToken);
    void sendPasswordChangedNotification(String toEmail, String fullName);
    void sendAdminInvitationEmail(String toEmail, String invitedByName, String rawToken);
}

