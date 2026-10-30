package com.studymate.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;

/**
 * Central Application Configuration.
 * Loads settings from system environment variables, optional .env / application.properties,
 * with safe development defaults.
 */
public final class AppConfig {

    private static final Logger logger = LoggerFactory.getLogger(AppConfig.class);
    private static final Properties properties = new Properties();

    static {
        // 1. Try loading from .env or application.properties if available
        File envFile = new File(".env");
        if (!envFile.exists()) {
            envFile = new File("C:/StudyMate/.env");
        }
        if (envFile.exists() && envFile.canRead()) {
            try (InputStream in = new FileInputStream(envFile)) {
                properties.load(in);
                logger.info("Loaded configuration from {}", envFile.getAbsolutePath());
            } catch (Exception e) {
                logger.warn("Could not read .env file: {}", e.getMessage());
            }
        }
    }

    private AppConfig() {}

    public static String get(String key, String defaultValue) {
        // System property > System environment variable > .env properties file > defaultValue
        String sysProp = System.getProperty(key);
        if (sysProp != null && !sysProp.isBlank()) {
            return sysProp;
        }

        String envVal = System.getenv(key);
        if (envVal != null && !envVal.isBlank()) {
            return envVal;
        }

        String propVal = properties.getProperty(key);
        if (propVal != null && !propVal.isBlank()) {
            return propVal;
        }

        return defaultValue;
    }

    public static int getInt(String key, int defaultValue) {
        String val = get(key, null);
        if (val == null) return defaultValue;
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public static long getLong(String key, long defaultValue) {
        String val = get(key, null);
        if (val == null) return defaultValue;
        try {
            return Long.parseLong(val.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public static boolean getBoolean(String key, boolean defaultValue) {
        String val = get(key, null);
        if (val == null) return defaultValue;
        return Boolean.parseBoolean(val.trim());
    }

    // Application properties
    public static String getAppName() {
        return get("APP_NAME", "StudyMate");
    }

    public static String getAppTagline() {
        return get("APP_TAGLINE", "Your Learning. Your Space.");
    }

    public static String getAppBaseUrl() {
        return get("APP_BASE_URL", "http://localhost:8080/studymate");
    }

    public static String getAppSecret() {
        return get("APP_SECRET", "studymate_secure_development_secret_key_2026_xyz");
    }

    // Database
    public static String getDbDriver() {
        return get("DB_DRIVER", "org.postgresql.Driver");
    }

    public static String getDatabaseUrl() {
        return get("DATABASE_URL", "jdbc:postgresql://localhost:5432/studymate");
    }

    public static String getDbUsername() {
        return get("DB_USERNAME", "postgres");
    }

    public static String getDbPassword() {
        return get("DB_PASSWORD", "postgres");
    }

    public static String getHibernateHbm2DdlAuto() {
        return get("HIBERNATE_HBM2DDL_AUTO", "update");
    }

    public static boolean isHibernateShowSql() {
        return getBoolean("HIBERNATE_SHOW_SQL", false);
    }

    // Mail
    public static String getMailHost() {
        return get("MAIL_HOST", "smtp.gmail.com");
    }

    public static int getMailPort() {
        return getInt("MAIL_PORT", 587);
    }

    public static String getMailUsername() {
        return get("MAIL_USERNAME", "notifications@studymate.edu");
    }

    public static String getMailPassword() {
        return get("MAIL_PASSWORD", "");
    }

    public static String getMailFrom() {
        return get("MAIL_FROM", "StudyMate <notifications@studymate.edu>");
    }

    public static boolean isMailDevMode() {
        return getBoolean("MAIL_DEV_MODE", true);
    }

    // Storage
    public static String getStoragePath() {
        return get("STORAGE_PATH", "C:/StudyMate/storage/uploads");
    }

    public static long getMaxUploadSize() {
        return getLong("MAX_UPLOAD_SIZE", 52428800L); // 50MB
    }

    // Tokens
    public static int getPasswordResetExpiryHours() {
        return getInt("PASSWORD_RESET_TOKEN_VALIDITY_HOURS", 2);
    }

    public static int getEmailVerificationExpiryHours() {
        return getInt("EMAIL_VERIFICATION_TOKEN_VALIDITY_HOURS", 24);
    }

    public static int getAdminInviteExpiryHours() {
        return getInt("ADMIN_INVITATION_TOKEN_VALIDITY_HOURS", 48);
    }
}

