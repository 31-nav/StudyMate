package com.studymate.config;

import java.util.Properties;

/**
 * Jakarta Mail SMTP session configuration properties.
 */
public final class MailConfig {

    private MailConfig() {}

    public static Properties getSmtpProperties() {
        Properties props = new Properties();
        props.put("mail.smtp.host", AppConfig.getMailHost());
        props.put("mail.smtp.port", String.valueOf(AppConfig.getMailPort()));
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
        props.put("mail.smtp.connectiontimeout", "5000");
        props.put("mail.smtp.timeout", "5000");
        return props;
    }
}

