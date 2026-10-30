package com.studymate.dao;

import com.studymate.config.HibernateUtil;
import com.studymate.model.entity.Announcement;
import org.hibernate.query.Query;

import java.time.LocalDateTime;
import java.util.List;

public class AnnouncementDao extends AbstractHibernateDao<Announcement, Long> {

    public AnnouncementDao() {
        super(Announcement.class);
    }

    public List<Announcement> findActiveAnnouncementsForStudent(Long courseId, Long semesterId, int limit) {
        return HibernateUtil.executeWithResult(session -> {
            String hql = "SELECT a FROM Announcement a " +
                         "JOIN FETCH a.createdBy " +
                         "WHERE a.published = true " +
                         "AND (a.expiresAt IS NULL OR a.expiresAt > :now) " +
                         "AND (a.targetAudience IN ('ALL', 'STUDENTS') " +
                         "     OR (a.targetAudience = 'COURSE' AND a.course.id = :cId AND (a.semester IS NULL OR a.semester.id = :sId))) " +
                         "ORDER BY a.priority DESC, a.publishedAt DESC";

            Query<Announcement> q = session.createQuery(hql, Announcement.class);
            q.setParameter("now", LocalDateTime.now());
            q.setParameter("cId", courseId != null ? courseId : -1L);
            q.setParameter("sId", semesterId != null ? semesterId : -1L);
            q.setMaxResults(limit);
            return q.getResultList();
        });
    }

    public List<Announcement> findAllRecent(int offset, int limit) {
        return HibernateUtil.executeWithResult(session -> {
            Query<Announcement> q = session.createQuery(
                    "SELECT a FROM Announcement a JOIN FETCH a.createdBy ORDER BY a.createdAt DESC",
                    Announcement.class
            );
            q.setFirstResult(offset);
            q.setMaxResults(limit);
            return q.getResultList();
        });
    }
}

