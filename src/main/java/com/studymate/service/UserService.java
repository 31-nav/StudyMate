package com.studymate.service;

import com.studymate.config.AppConfig;
import com.studymate.dao.*;
import com.studymate.email.EmailFactory;
import com.studymate.email.EmailService;
import com.studymate.exception.ResourceNotFoundException;
import com.studymate.exception.ValidationException;
import com.studymate.model.entity.*;
import com.studymate.util.TokenUtil;
import com.studymate.util.ValidationUtil;

import java.time.LocalDateTime;
import java.util.List;

public class UserService {

    private final UserDao userDao;
    private final RoleDao roleDao;
    private final CourseDao courseDao;
    private final SemesterDao semesterDao;
    private final TokenDao tokenDao;
    private final AuditLogDao auditLogDao;
    private final EmailService emailService;

    public UserService() {
        this(new UserDao(), new RoleDao(), new CourseDao(), new SemesterDao(),
             new TokenDao(), new AuditLogDao(), EmailFactory.getEmailService());
    }

    public UserService(UserDao userDao, RoleDao roleDao, CourseDao courseDao,
                       SemesterDao semesterDao, TokenDao tokenDao, AuditLogDao auditLogDao,
                       EmailService emailService) {
        this.userDao = userDao;
        this.roleDao = roleDao;
        this.courseDao = courseDao;
        this.semesterDao = semesterDao;
        this.tokenDao = tokenDao;
        this.auditLogDao = auditLogDao;
        this.emailService = emailService;
    }

    public User getUserById(Long id) {
        return userDao.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));
    }

    public List<User> searchStudents(String query, Long courseId, Long semesterId, int offset, int limit) {
        return userDao.searchStudents(query, courseId, semesterId, offset, limit);
    }

    public long countStudents(String query, Long courseId, Long semesterId) {
        return userDao.countStudents(query, courseId, semesterId);
    }

    public void toggleUserActiveStatus(Long userId, User adminUser) {
        User user = getUserById(userId);

        // Prevent deactivating Super Admin
        if (user.isSuperAdmin()) {
            throw new ValidationException("Super Administrator account cannot be deactivated");
        }

        user.setActive(!user.isActive());
        user.setUpdatedAt(LocalDateTime.now());
        userDao.update(user);

        String action = user.isActive() ? "USER_ACTIVATED" : "USER_DEACTIVATED";
        auditLogDao.save(new AuditLog(adminUser, action, "User", userId.toString(),
                "Changed user active state to: " + user.isActive(), null));
    }

    public User updateProfile(Long userId, String fullName, String rollNumber, Long courseId, Long semesterId) {
        User user = getUserById(userId);

        if (fullName != null && !fullName.isBlank()) {
            user.setFullName(fullName.trim());
        }
        if (rollNumber != null) {
            user.setRollNumber(rollNumber.trim());
        }
        if (courseId != null) {
            courseDao.findById(courseId).ifPresent(user::setCourse);
        }
        if (semesterId != null) {
            semesterDao.findById(semesterId).ifPresent(user::setSemester);
        }
        user.setUpdatedAt(LocalDateTime.now());
        return userDao.update(user);
    }

    // --- Administrator Governance (Super Admin) ---
    public List<User> getAllAdministrators() {
        return userDao.findAllAdmins();
    }

    public String inviteAdministrator(String email, String roleName, User superAdmin) {
        if (!ValidationUtil.isValidEmail(email)) {
            throw new ValidationException("Invalid administrator email address");
        }

        // Check if user already exists
        if (userDao.findByEmail(email).isPresent()) {
            throw new ValidationException("A user with this email address is already registered");
        }

        String rawToken = TokenUtil.generateSecureToken();
        String tokenHash = TokenUtil.hashToken(rawToken);
        LocalDateTime expiry = LocalDateTime.now().plusHours(AppConfig.getAdminInviteExpiryHours());

        String assignedRole = "ADMIN";
        if ("SUPER_ADMIN".equalsIgnoreCase(roleName) || "ROLE_SUPER_ADMIN".equalsIgnoreCase(roleName)) {
            assignedRole = "SUPER_ADMIN";
        }

        AdministratorInvitation invitation = new AdministratorInvitation(
                email.trim().toLowerCase(),
                tokenHash,
                assignedRole,
                superAdmin,
                expiry
        );

        tokenDao.saveInvitation(invitation);
        emailService.sendAdminInvitationEmail(email, superAdmin.getFullName(), rawToken);

        auditLogDao.save(new AuditLog(superAdmin, "ADMIN_INVITED", "AdministratorInvitation", email,
                "Sent admin invitation for role: " + assignedRole, null));

        return rawToken;
    }
}

