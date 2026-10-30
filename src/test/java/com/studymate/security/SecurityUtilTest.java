package com.studymate.security;

import com.studymate.util.PasswordUtil;
import com.studymate.util.SecurityUtil;
import com.studymate.util.TokenUtil;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Security & Cryptographic Utilities Test")
class SecurityUtilTest {

    @Test
    @DisplayName("Password hashing produces unique BCrypt hashes and verifies accurately")
    void testPasswordHashingAndVerification() {
        String rawPassword = "StudyMate@2026Password!";
        String hash1 = PasswordUtil.hashPassword(rawPassword);
        String hash2 = PasswordUtil.hashPassword(rawPassword);

        assertNotNull(hash1);
        assertNotNull(hash2);
        assertNotEquals(hash1, hash2, "BCrypt salts must differ on every hash invocation");
        assertTrue(hash1.startsWith("$2a$") || hash1.startsWith("$2b$") || hash1.startsWith("$2y$"));

        assertTrue(PasswordUtil.verifyPassword(rawPassword, hash1), "Valid password must verify against its hash");
        assertTrue(PasswordUtil.verifyPassword(rawPassword, hash2), "Valid password must verify against salt 2");
        assertFalse(PasswordUtil.verifyPassword("WrongPassword123", hash1), "Incorrect password must fail verification");
        assertFalse(PasswordUtil.verifyPassword("", hash1), "Empty password must fail verification");
        assertFalse(PasswordUtil.verifyPassword(null, hash1), "Null password must fail verification");
    }

    @Test
    @DisplayName("Secure CSPRNG token generation creates non-colliding tokens")
    void testSecureTokenGeneration() {
        String token1 = TokenUtil.generateSecureToken();
        String token2 = TokenUtil.generateSecureToken();

        assertNotNull(token1);
        assertNotNull(token2);
        assertNotEquals(token1, token2, "CSPRNG tokens must never collide");
        assertTrue(token1.length() >= 40, "Token should be at least 40 hex/base64url characters");
    }

    @Test
    @DisplayName("Token SHA-256 hashing produces deterministic 64-char hex strings")
    void testTokenHashingAndVerification() {
        String rawToken = TokenUtil.generateSecureToken();
        String hash = TokenUtil.hashToken(rawToken);

        assertNotNull(hash);
        assertEquals(64, hash.length(), "SHA-256 hex string must be exactly 64 characters");
        assertEquals(hash, TokenUtil.hashToken(rawToken), "SHA-256 hash must be deterministic");

        assertTrue(TokenUtil.verifyToken(rawToken, hash), "Raw token must match its SHA-256 hash");
        assertFalse(TokenUtil.verifyToken("tampered-token", hash), "Tampered token must fail verification");
    }

    @Test
    @DisplayName("HTML sanitization strips potential XSS injection tags")
    void testHtmlSanitization() {
        String malicious = "<script>alert('pwned')</script>Hello <b>World</b>";
        String clean = SecurityUtil.sanitizeHtml(malicious);

        assertNotNull(clean);
        assertFalse(clean.contains("<script>"), "Sanitized string must not contain script tags");
        assertTrue(clean.contains("&lt;script&gt;"), "Sanitized string must escape script tags into HTML entities");
    }
}
