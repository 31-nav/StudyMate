package com.studymate.dao;

import com.studymate.config.HibernateUtil;
import com.studymate.model.entity.Notification;
import org.hibernate.query.Query;

import java.time.LocalDateTime;
import java.util.List;

public class NotificationDao extends AbstractHibernateDao<Notification, Long> {

    public NotificationDao() {
        super(Notification.class);
    }

    public List<Notification> findByUserId(Long userId, int limit) {
        return HibernateUtil.executeWithResult(session -> {
            Query<Notification> q = session.createQuery(
                    "FROM Notification n WHERE n.user.id = :uId ORDER BY n.createdAt DESC",
                    Notification.class
            );
            q.setParameter("uId", userId);
            q.setMaxResults(limit);
            return q.getResultList();
        });
    }

    public long countUnreadByUserId(Long userId) {
        return HibernateUtil.executeWithResult(session -> {
            Query<Long> q = session.createQuery(
                    "SELECT COUNT(n) FROM Notification n WHERE n.user.id = :uId AND n.read = false",
                    Long.class
            );
            q.setParameter("uId", userId);
            return q.getSingleResult();
        });
    }

    public void markAllAsRead(Long userId) {
        HibernateUtil.executeInTransaction(session -> {
            Query<?> q = session.createQuery(
                    "UPDATE Notification n SET n.read = true, n.readAt = :now WHERE n.user.id = :uId AND n.read = false"
            );
            q.setParameter("now", LocalDateTime.now());
            q.setParameter("uId", userId);
            q.executeUpdate();
        });
    }
}

