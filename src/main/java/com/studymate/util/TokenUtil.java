package com.studymate.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.HexFormat;

/**
 * Generates cryptographically secure tokens and computes SHA-256 hashes for storage.
 */
public final class TokenUtil {

    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    private TokenUtil() {}

    /**
     * Generates a 48-byte URL-safe cryptographically secure random token string.
     */
    public static String generateSecureToken() {
        byte[] randomBytes = new byte[48];
        SECURE_RANDOM.nextBytes(randomBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
    }

    /**
     * Computes the SHA-256 hash of a raw token.
     * Only this hash is persisted to the database to protect against database leaks.
     */
    public static String hashToken(String rawToken) {
        if (rawToken == null || rawToken.isBlank()) {
            throw new IllegalArgumentException("Token cannot be blank");
        }
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(rawToken.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(hash);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }

    /**
     * Constant-time verification of raw token against stored SHA-256 hash.
     */
    public static boolean verifyToken(String rawToken, String expectedHash) {
        if (rawToken == null || expectedHash == null) return false;
        try {
            String actualHash = hashToken(rawToken);
            return MessageDigest.isEqual(
                    actualHash.getBytes(StandardCharsets.UTF_8),
                    expectedHash.getBytes(StandardCharsets.UTF_8)
            );
        } catch (Exception e) {
            return false;
        }
    }
}
