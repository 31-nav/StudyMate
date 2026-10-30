package com.studymate.email;

public final class EmailTemplates {

    private EmailTemplates() {}

    private static String wrapInLayout(String title, String heading, String bodyContent) {
        return """
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>%s</title>
                <style>
                    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; background-color: #0f172a; color: #f8fafc; margin: 0; padding: 24px; }
                    .container { max-width: 600px; margin: 0 auto; background: #1e293b; border-radius: 16px; border: 1px solid rgba(255,255,255,0.1); overflow: hidden; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.5); }
                    .header { background: linear-gradient(135deg, #3b82f6 0%%, #8b5cf6 100%%); padding: 32px 24px; text-align: center; }
                    .logo-text { font-size: 28px; font-weight: 800; color: #ffffff; letter-spacing: -0.5px; margin: 0; }
                    .tagline { font-size: 14px; color: rgba(255,255,255,0.85); margin-top: 4px; font-weight: 400; }
                    .content { padding: 32px 24px; line-height: 1.6; color: #cbd5e1; font-size: 15px; }
                    .content h2 { color: #ffffff; margin-top: 0; font-size: 20px; font-weight: 600; }
                    .btn-wrapper { text-align: center; margin: 32px 0; }
                    .btn { display: inline-block; background: linear-gradient(135deg, #3b82f6, #6366f1); color: #ffffff !important; text-decoration: none; padding: 14px 32px; border-radius: 8px; font-weight: 600; font-size: 15px; }
                    .footer { padding: 20px 24px; background: #0f172a; text-align: center; font-size: 12px; color: #64748b; border-top: 1px solid rgba(255,255,255,0.05); }
                    .note-box { background: rgba(59, 130, 246, 0.1); border-left: 4px solid #3b82f6; padding: 12px 16px; border-radius: 4px; margin: 20px 0; font-size: 13px; color: #93c5fd; }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <h1 class="logo-text">StudyMate</h1>
                        <div class="tagline">Your Learning. Your Space.</div>
                    </div>
                    <div class="content">
                        <h2>%s</h2>
                        %s
                    </div>
                    <div class="footer">
                        &copy; 2026 StudyMate LMS. All rights reserved.<br>
                        This is an automated system email. Please do not reply.
                    </div>
                </div>
            </body>
            </html>
            """.formatted(title, heading, bodyContent);
    }

    public static String buildWelcomeEmail(String fullName, String loginUrl) {
        String body = """
            <p>Hello <strong>%s</strong>,</p>
            <p>Welcome to <strong>StudyMate</strong>! Your centralized digital learning space is now ready.</p>
            <p>With StudyMate you can:</p>
            <ul>
                <li>Browse lecture notes, lab manuals, and previous year papers</li>
                <li>Preview and download course materials instantly</li>
                <li>Bookmark your essential subjects and resources</li>
                <li>Receive timely class announcements and updates</li>
            </ul>
            <div class="btn-wrapper">
                <a href="%s/auth/login" class="btn">Go to Dashboard</a>
            </div>
            """.formatted(fullName, loginUrl);
        return wrapInLayout("Welcome to StudyMate", "Your Academic Journey Starts Here", body);
    }

    public static String buildVerificationEmail(String fullName, String verifyUrl) {
        String body = """
            <p>Hello <strong>%s</strong>,</p>
            <p>Thank you for registering on StudyMate. Please confirm your email address by clicking the verification button below:</p>
            <div class="btn-wrapper">
                <a href="%s" class="btn">Verify Email Address</a>
            </div>
            <div class="note-box">
                This verification link is single-use and will expire in 24 hours. If you did not create a StudyMate account, please ignore this email.
            </div>
            <p style="font-size: 12px; word-break: break-all; color: #94a3b8;">
                If the button does not work, copy and paste this link into your browser:<br>
                <a href="%s" style="color: #60a5fa;">%s</a>
            </p>
            """.formatted(fullName, verifyUrl, verifyUrl, verifyUrl);
        return wrapInLayout("Verify Email", "Confirm Your Account", body);
    }

    public static String buildPasswordResetEmail(String fullName, String resetUrl, int expiryHours) {
        String body = """
            <p>Hello <strong>%s</strong>,</p>
            <p>We received a request to reset your StudyMate account password. Click the button below to set a new password:</p>
            <div class="btn-wrapper">
                <a href="%s" class="btn">Reset Password</a>
            </div>
            <div class="note-box">
                This link will expire in <strong>%d hours</strong>. If you did not request a password reset, no action is required; your password remains unchanged.
            </div>
            <p style="font-size: 12px; word-break: break-all; color: #94a3b8;">
                Link: <a href="%s" style="color: #60a5fa;">%s</a>
            </p>
            """.formatted(fullName, resetUrl, expiryHours, resetUrl, resetUrl);
        return wrapInLayout("Reset Password", "Password Recovery Request", body);
    }

    public static String buildPasswordChangedAlert(String fullName, String loginUrl) {
        String body = """
            <p>Hello <strong>%s</strong>,</p>
            <p>The password for your StudyMate account was successfully updated.</p>
            <div class="note-box" style="border-left-color: #22c55e; background: rgba(34, 197, 94, 0.1); color: #86efac;">
                If you made this change, you can safely disregard this message. If you did not authorize this change, please contact your administrator immediately.
            </div>
            <div class="btn-wrapper">
                <a href="%s/auth/login" class="btn">Log In to Account</a>
            </div>
            """.formatted(fullName, loginUrl);
        return wrapInLayout("Password Changed", "Security Alert: Password Updated", body);
    }

    public static String buildAdminInvitationEmail(String invitedByName, String inviteUrl, int expiryHours) {
        String body = """
            <p>Hello,</p>
            <p>You have been invited by <strong>%s</strong> to join StudyMate as an <strong>Administrator</strong>.</p>
            <p>As an administrator, you will be able to manage academic subjects, publish lecture resources, and review student activity.</p>
            <div class="btn-wrapper">
                <a href="%s" class="btn">Accept Invitation & Create Account</a>
            </div>
            <div class="note-box">
                This invitation link is valid for <strong>%d hours</strong>.
            </div>
            """.formatted(invitedByName, inviteUrl, expiryHours);
        return wrapInLayout("Administrator Invitation", "You're Invited to Administer StudyMate", body);
    }
}

