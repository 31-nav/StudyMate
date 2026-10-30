package com.studymate.dao;

import com.studymate.config.HibernateUtil;
import com.studymate.model.entity.User;
import org.hibernate.query.Query;

import java.util.List;
import java.util.Optional;

public class UserDao extends AbstractHibernateDao<User, Long> {

    public UserDao() {
        super(User.class);
    }

    public Optional<User> findByEmail(String email) {
        if (email == null) return Optional.empty();
        return HibernateUtil.executeWithResult(session -> {
            Query<User> query = session.createQuery(
                    "FROM User u WHERE LOWER(u.email) = LOWER(:email)", User.class
            );
            query.setParameter("email", email.trim());
            return query.uniqueResultOptional();
        });
    }

    public boolean existsByEmail(String email) {
        return findByEmail(email).isPresent();
    }

    public Optional<User> findByRollNumber(String rollNumber) {
        if (rollNumber == null || rollNumber.isBlank()) return Optional.empty();
        return HibernateUtil.executeWithResult(session -> {
            Query<User> query = session.createQuery(
                    "FROM User u WHERE u.rollNumber = :roll", User.class
            );
            query.setParameter("roll", rollNumber.trim());
            return query.uniqueResultOptional();
        });
    }

    public Optional<User> findByEmailOrRoll(String identifier) {
        if (identifier == null || identifier.isBlank()) return Optional.empty();
        String idTrim = identifier.trim();
        return HibernateUtil.executeWithResult(session -> {
            Query<User> query = session.createQuery(
                    "FROM User u WHERE LOWER(u.email) = LOWER(:id) OR u.rollNumber = :id", User.class
            );
            query.setParameter("id", idTrim);
            return query.uniqueResultOptional();
        });
    }

    public List<User> searchStudents(String query, Long courseId, Long semesterId, int offset, int limit) {
        return HibernateUtil.executeWithResult(session -> {
            StringBuilder hql = new StringBuilder(
                    "SELECT DISTINCT u FROM User u JOIN u.roles r WHERE r.name = 'ROLE_STUDENT'"
            );
            if (query != null && !query.isBlank()) {
                hql.append(" AND (LOWER(u.fullName) LIKE LOWER(:q) OR LOWER(u.email) LIKE LOWER(:q) OR LOWER(u.rollNumber) LIKE LOWER(:q))");
            }
            if (courseId != null) {
                hql.append(" AND u.course.id = :courseId");
            }
            if (semesterId != null) {
                hql.append(" AND u.semester.id = :semesterId");
            }
            hql.append(" ORDER BY u.createdAt DESC");

            Query<User> q = session.createQuery(hql.toString(), User.class);
            if (query != null && !query.isBlank()) {
                q.setParameter("q", "%" + query.trim() + "%");
            }
            if (courseId != null) {
                q.setParameter("courseId", courseId);
            }
            if (semesterId != null) {
                q.setParameter("semesterId", semesterId);
            }
            q.setFirstResult(offset);
            q.setMaxResults(limit);
            return q.getResultList();
        });
    }

    public long countStudents(String query, Long courseId, Long semesterId) {
        return HibernateUtil.executeWithResult(session -> {
            StringBuilder hql = new StringBuilder(
                    "SELECT COUNT(DISTINCT u) FROM User u JOIN u.roles r WHERE r.name = 'ROLE_STUDENT'"
            );
            if (query != null && !query.isBlank()) {
                hql.append(" AND (LOWER(u.fullName) LIKE LOWER(:q) OR LOWER(u.email) LIKE LOWER(:q) OR LOWER(u.rollNumber) LIKE LOWER(:q))");
            }
            if (courseId != null) {
                hql.append(" AND u.course.id = :courseId");
            }
            if (semesterId != null) {
                hql.append(" AND u.semester.id = :semesterId");
            }

            Query<Long> q = session.createQuery(hql.toString(), Long.class);
            if (query != null && !query.isBlank()) {
                q.setParameter("q", "%" + query.trim() + "%");
            }
            if (courseId != null) {
                q.setParameter("courseId", courseId);
            }
            if (semesterId != null) {
                q.setParameter("semesterId", semesterId);
            }
            return q.getSingleResult();
        });
    }

    public List<User> findAllAdmins() {
        return HibernateUtil.executeWithResult(session ->
                session.createQuery(
                        "SELECT DISTINCT u FROM User u JOIN u.roles r WHERE r.name IN ('ROLE_ADMIN', 'ROLE_SUPER_ADMIN') ORDER BY u.fullName ASC",
                        User.class
                ).getResultList()
        );
    }
}
