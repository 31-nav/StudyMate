package com.studymate.dao;

import com.studymate.config.HibernateUtil;
import com.studymate.model.entity.AuditLog;
import org.hibernate.query.Query;

import java.util.List;

public class AuditLogDao extends AbstractHibernateDao<AuditLog, Long> {

    public AuditLogDao() {
        super(AuditLog.class);
    }

    public List<AuditLog> findRecent(int offset, int limit) {
        return HibernateUtil.executeWithResult(session -> {
            Query<AuditLog> q = session.createQuery(
                    "SELECT a FROM AuditLog a LEFT JOIN FETCH a.user ORDER BY a.createdAt DESC",
                    AuditLog.class
            );
            q.setFirstResult(offset);
            q.setMaxResults(limit);
            return q.getResultList();
        });
    }

    public List<AuditLog> findByAction(String action, int limit) {
        return HibernateUtil.executeWithResult(session -> {
            Query<AuditLog> q = session.createQuery(
                    "SELECT a FROM AuditLog a LEFT JOIN FETCH a.user WHERE a.action = :action ORDER BY a.createdAt DESC",
                    AuditLog.class
            );
            q.setParameter("action", action);
            q.setMaxResults(limit);
            return q.getResultList();
        });
    }
}

