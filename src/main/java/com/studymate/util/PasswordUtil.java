package com.studymate.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Password hashing and verification using BCrypt.
 */
public final class PasswordUtil {

    private static final int BCRYPT_LOG_ROUNDS = 12;

    private PasswordUtil() {}

    /**
     * Hashes a plaintext password using BCrypt with salt rounds.
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be empty");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_LOG_ROUNDS));
    }

    /**
     * Verifies a candidate plain password against a stored BCrypt hash.
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null || hashedPassword.isEmpty()) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }

    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        return checkPassword(plainPassword, hashedPassword);
    }

    /**
     * Checks password strength: at least 8 chars, containing uppercase, lowercase, digit, and special char.
     */
    public static boolean isStrongPassword(String password) {
        if (password == null || password.length() < 8) return false;
        boolean hasUpper = false;
        boolean hasLower = false;
        boolean hasDigit = false;
        boolean hasSpecial = false;

        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) hasUpper = true;
            else if (Character.isLowerCase(c)) hasLower = true;
            else if (Character.isDigit(c)) hasDigit = true;
            else hasSpecial = true;
        }
        return hasUpper && hasLower && hasDigit && hasSpecial;
    }
}
