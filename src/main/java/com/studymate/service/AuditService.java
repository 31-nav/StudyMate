package com.studymate.service;

import com.studymate.dao.AuditLogDao;
import com.studymate.model.entity.AuditLog;
import com.studymate.model.entity.User;

import java.util.List;

public class AuditService {

    private final AuditLogDao auditLogDao;

    public AuditService() {
        this(new AuditLogDao());
    }

    public AuditService(AuditLogDao auditLogDao) {
        this.auditLogDao = auditLogDao;
    }

    public void logAction(User user, String action, String entityType, String entityId, String details, String ipAddress) {
        auditLogDao.save(new AuditLog(user, action, entityType, entityId, details, ipAddress));
    }

    public List<AuditLog> getRecentAuditLogs(int offset, int limit) {
        return auditLogDao.findRecent(offset, limit);
    }
}

