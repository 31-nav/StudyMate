package com.studymate.dao;

import com.studymate.config.HibernateUtil;
import com.studymate.model.entity.Bookmark;
import org.hibernate.Hibernate;
import org.hibernate.query.Query;

import java.util.List;
import java.util.Optional;

public class BookmarkDao extends AbstractHibernateDao<Bookmark, Long> {

    public BookmarkDao() {
        super(Bookmark.class);
    }

    public List<Bookmark> findByUserId(Long userId) {
        return HibernateUtil.executeWithResult(session -> {
            Query<Bookmark> q = session.createQuery(
                    "SELECT b FROM Bookmark b " +
                    "JOIN FETCH b.resource r " +
                    "JOIN FETCH r.subject " +
                    "JOIN FETCH r.category " +
                    "WHERE b.user.id = :uId " +
                    "ORDER BY b.createdAt DESC", Bookmark.class
            );
            q.setParameter("uId", userId);
            List<Bookmark> list = q.getResultList();
            for (Bookmark b : list) {
                Hibernate.initialize(b.getResource().getFiles());
            }
            return list;
        });
    }

    public Optional<Bookmark> findByUserAndResource(Long userId, Long resourceId) {
        return HibernateUtil.executeWithResult(session -> {
            Query<Bookmark> q = session.createQuery(
                    "FROM Bookmark b WHERE b.user.id = :uId AND b.resource.id = :rId", Bookmark.class
            );
            q.setParameter("uId", userId);
            q.setParameter("rId", resourceId);
            return q.uniqueResultOptional();
        });
    }

    public boolean isBookmarked(Long userId, Long resourceId) {
        return findByUserAndResource(userId, resourceId).isPresent();
    }

    public void removeByUserAndResource(Long userId, Long resourceId) {
        HibernateUtil.executeInTransaction(session -> {
            Query<?> q = session.createQuery(
                    "DELETE FROM Bookmark b WHERE b.user.id = :uId AND b.resource.id = :rId"
            );
            q.setParameter("uId", userId);
            q.setParameter("rId", resourceId);
            q.executeUpdate();
        });
    }

    public long countByUserId(Long userId) {
        return HibernateUtil.executeWithResult(session -> {
            Query<Long> q = session.createQuery(
                    "SELECT COUNT(b) FROM Bookmark b WHERE b.user.id = :uId", Long.class
            );
            q.setParameter("uId", userId);
            return q.getSingleResult();
        });
    }
}

