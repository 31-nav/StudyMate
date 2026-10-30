package com.studymate.email;

import com.studymate.config.AppConfig;

public final class EmailFactory {

    private static final EmailService INSTANCE = createEmailService();

    private EmailFactory() {}

    private static EmailService createEmailService() {
        if (!AppConfig.isMailDevMode() && !AppConfig.getMailPassword().isBlank()) {
            return new JakartaMailService();
        }
        return new DevMailAdapter();
    }

    public static EmailService getEmailService() {
        return INSTANCE;
    }
}

