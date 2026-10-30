package com.studymate.dao;

import com.studymate.config.HibernateUtil;
import com.studymate.model.entity.RecentlyViewed;
import com.studymate.model.entity.Resource;
import com.studymate.model.entity.User;
import org.hibernate.Hibernate;
import org.hibernate.query.Query;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class RecentlyViewedDao extends AbstractHibernateDao<RecentlyViewed, Long> {

    public RecentlyViewedDao() {
        super(RecentlyViewed.class);
    }

    public List<RecentlyViewed> findByUserId(Long userId, int limit) {
        return HibernateUtil.executeWithResult(session -> {
            Query<RecentlyViewed> q = session.createQuery(
                    "SELECT rv FROM RecentlyViewed rv " +
                    "JOIN FETCH rv.resource r " +
                    "JOIN FETCH r.subject " +
                    "JOIN FETCH r.category " +
                    "WHERE rv.user.id = :uId " +
                    "ORDER BY rv.viewedAt DESC", RecentlyViewed.class
            );
            q.setParameter("uId", userId);
            q.setMaxResults(limit);
            List<RecentlyViewed> list = q.getResultList();
            for (RecentlyViewed rv : list) {
                Hibernate.initialize(rv.getResource().getFiles());
            }
            return list;
        });
    }

    public void recordAccess(User user, Resource resource) {
        HibernateUtil.executeInTransaction(session -> {
            Query<RecentlyViewed> q = session.createQuery(
                    "FROM RecentlyViewed rv WHERE rv.user.id = :uId AND rv.resource.id = :rId",
                    RecentlyViewed.class
            );
            q.setParameter("uId", user.getId());
            q.setParameter("rId", resource.getId());
            Optional<RecentlyViewed> existing = q.uniqueResultOptional();

            if (existing.isPresent()) {
                RecentlyViewed rv = existing.get();
                rv.incrementAccess();
                session.merge(rv);
            } else {
                RecentlyViewed newEntry = new RecentlyViewed(user, resource);
                session.persist(newEntry);
            }
        });
    }
}

