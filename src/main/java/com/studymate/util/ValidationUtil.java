package com.studymate.util;

import java.util.Set;
import java.util.regex.Pattern;

/**
 * Validates input parameters, emails, file types, and URLs.
 */
public final class ValidationUtil {

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,63}$"
    );

    private static final Pattern ROLL_NUMBER_PATTERN = Pattern.compile(
            "^[A-Za-z0-9_-]{3,50}$"
    );

    // Permitted file extensions
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of(
            "pdf", "jpg", "jpeg", "png", "webp",
            "doc", "docx", "ppt", "pptx", "txt"
    );

    // Dangerous executable extensions strictly forbidden
    private static final Set<String> FORBIDDEN_EXTENSIONS = Set.of(
            "exe", "bat", "cmd", "sh", "bin", "dll", "vbs", "ps1", "war", "ear", "jar", "class", "jsp", "php", "py"
    );

    private ValidationUtil() {}

    public static boolean isValidEmail(String email) {
        if (email == null || email.isBlank()) return false;
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidRollNumber(String rollNumber) {
        if (rollNumber == null || rollNumber.isBlank()) return true; // Optional field
        return ROLL_NUMBER_PATTERN.matcher(rollNumber.trim()).matches();
    }

    public static boolean isAllowedFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) return false;
        String ext = getFileExtension(filename).toLowerCase();
        if (FORBIDDEN_EXTENSIONS.contains(ext)) return false;
        return ALLOWED_EXTENSIONS.contains(ext);
    }

    public static String getFileExtension(String filename) {
        if (filename == null) return "";
        int dotIndex = filename.lastIndexOf('.');
        if (dotIndex >= 0 && dotIndex < filename.length() - 1) {
            return filename.substring(dotIndex + 1);
        }
        return "";
    }

    public static String sanitizeFilename(String filename) {
        if (filename == null) return "unnamed_file";
        // Remove any path traversal patterns
        String cleaned = filename.replace("\\", "/");
        int slashIndex = cleaned.lastIndexOf('/');
        if (slashIndex >= 0) {
            cleaned = cleaned.substring(slashIndex + 1);
        }
        // Remove potentially dangerous control characters
        return cleaned.replaceAll("[^a-zA-Z0-9._-]", "_");
    }

    public static boolean isValidUrl(String url) {
        if (url == null || url.isBlank()) return false;
        String lower = url.trim().toLowerCase();
        return lower.startsWith("http://") || lower.startsWith("https://");
    }
}

