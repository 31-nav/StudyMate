# Authentication & Account Lifecycle Flow: StudyMate

## 1. Authentication Lifecycle Overview

StudyMate implements a zero-trust, multi-tiered authentication and account lifecycle system tailored to educational institutions.

The system supports three user roles:
- **`ROLE_STUDENT`**: Public self-registration, restricted to learning materials and student workspace.
- **`ROLE_ADMIN`**: Departmental faculty/administrators provisioned by SuperAdmin.
- **`ROLE_SUPER_ADMIN`**: Institutional deans and system administrators with global privileges.

---

## 2. Student Self-Registration Workflow

```
[ User Browser ]                      [ AuthServlet ]                    [ AuthService ]                   [ Database ]
       │                                     │                                  │                               │
       │─── 1. Submits Registration Form ───>│                                  │                               │
       │    (Name, Email, Password, Course)  │                                  │                               │
       │                                     │─── 2. Validates Request DTO ────>│                               │
       │                                     │                                  │─── 3. Check Email Exists ────>│
       │                                     │                                  │<─── No Duplicate Found ───────│
       │                                     │                                  │                               │
       │                                     │                                  │─── 4. Hash Password (BCrypt) ─│
       │                                     │                                  │─── 5. Generate Secure Token ──│
       │                                     │                                  │─── 6. Hash Token (SHA-256) ───│
       │                                     │                                  │                               │
       │                                     │                                  │─── 7. Save User & Token ─────>│
       │                                     │<── 8. Registration Success ──────│                               │
       │<── 9. Redirects to Verify Page ─────│                                  │                               │
```

### Security Rules Enforced:
1. **Strict Role Assignment**: Registration always assigns `ROLE_STUDENT`. Any role parameter submitted by the client is discarded.
2. **Password Complexity**: Minimum 8 characters with at least one uppercase letter, one digit, and one special character.
3. **Token Hashing**: Plaintext tokens are sent only to the user; the database persists only cryptographic SHA-256 hashes (`token_hash`), protecting against database leak token reuse.

---

## 3. Login & Session Establishment Workflow

```
[ User Browser ]                      [ AuthServlet ]                    [ AuthService ]                   [ Database ]
       │                                     │                                  │                               │
       │─── 1. Submits Login (Email/Pass) ──>│                                  │                               │
       │                                     │─── 2. authenticate(email, pass) ─>│                               │
       │                                     │                                  │─── 3. Query User By Email ───>│
       │                                     │                                  │<── Returns User & Roles ──────│
       │                                     │                                  │                               │
       │                                     │                                  │─── 4. BCrypt.checkpw() ───────│
       │                                     │                                  │─── 5. Verify Active/Verified ─│
       │                                     │<── 6. Returns UserSessionDto ────│                               │
       │                                     │                                  │                               │
       │                                     │─── 7. Invalidate Old Session ───>│                               │
       │                                     │─── 8. Create New Session ────────│                               │
       │                                     │─── 9. Bind Session Attributes ───│                               │
       │<── 10. HTTP 302 Redirect to Role ───│    (user_id, roles, csrf_token)  │                               │
       │    Dashboard (Student/Admin/Super)  │                                  │                               │
```

### Session Fixation Protection
Upon successful credential validation:
1. `request.getSession().invalidate()` is called to destroy the pre-authentication session ID.
2. `request.getSession(true)` creates a fresh, cryptographically distinct session.
3. User identity, roles, and a new anti-CSRF token are stored in the fresh session.

---

## 4. Email Verification Workflow

1. The student navigates to `/auth/verify-email?token=<PLAINTEXT_TOKEN>`.
2. `AuthService` computes `SHA256(PLAINTEXT_TOKEN)` and queries `verification_tokens` for an unused, non-expired matching record.
3. If valid:
   - Sets `is_used = true` on the token.
   - Sets `is_verified = true` on the associated `users` record.
   - Redirects to `/auth/login` with a success alert: *"Email verified successfully! You may now sign in."*

---

## 5. Password Reset Workflow

1. **Request Reset**: User enters their email at `/auth/forgot-password`.
2. **Token Generation**: If the email exists, a 32-byte CSPRNG token is generated with a 60-minute expiration.
3. **Dispatch**: The reset link `/auth/reset-password?token=<PLAINTEXT_TOKEN>` is generated.
4. **Execution**: The user submits a new password along with the token. The token hash is verified, `password_hash` is updated with a new BCrypt salt, and the token is invalidated.

