package com.studymate.dao;

import com.studymate.config.HibernateUtil;
import com.studymate.model.entity.Subject;
import org.hibernate.query.Query;

import java.util.List;
import java.util.Optional;

public class SubjectDao extends AbstractHibernateDao<Subject, Long> {

    public SubjectDao() {
        super(Subject.class);
    }

    public List<Subject> findByCourseAndSemester(Long courseId, Long semesterId) {
        return HibernateUtil.executeWithResult(session -> {
            Query<Subject> q = session.createQuery(
                    "FROM Subject s WHERE s.course.id = :cId AND s.semester.id = :sId AND s.active = true ORDER BY s.name ASC",
                    Subject.class
            );
            q.setParameter("cId", courseId);
            q.setParameter("sId", semesterId);
            return q.getResultList();
        });
    }

    public List<Subject> findByCourse(Long courseId) {
        return HibernateUtil.executeWithResult(session -> {
            Query<Subject> q = session.createQuery(
                    "FROM Subject s WHERE s.course.id = :cId AND s.active = true ORDER BY s.semester.semesterNumber ASC, s.name ASC",
                    Subject.class
            );
            q.setParameter("cId", courseId);
            return q.getResultList();
        });
    }

    public List<Subject> searchSubjects(String query, Long courseId, Long semesterId, int offset, int limit) {
        return HibernateUtil.executeWithResult(session -> {
            StringBuilder hql = new StringBuilder("FROM Subject s WHERE 1=1");
            if (query != null && !query.isBlank()) {
                hql.append(" AND (LOWER(s.name) LIKE LOWER(:q) OR LOWER(s.code) LIKE LOWER(:q) OR LOWER(s.description) LIKE LOWER(:q))");
            }
            if (courseId != null) {
                hql.append(" AND s.course.id = :cId");
            }
            if (semesterId != null) {
                hql.append(" AND s.semester.id = :sId");
            }
            hql.append(" ORDER BY s.course.name ASC, s.semester.semesterNumber ASC, s.name ASC");

            Query<Subject> q = session.createQuery(hql.toString(), Subject.class);
            if (query != null && !query.isBlank()) {
                q.setParameter("q", "%" + query.trim() + "%");
            }
            if (courseId != null) {
                q.setParameter("cId", courseId);
            }
            if (semesterId != null) {
                q.setParameter("sId", semesterId);
            }
            q.setFirstResult(offset);
            q.setMaxResults(limit);
            return q.getResultList();
        });
    }

    public long countSubjects(String query, Long courseId, Long semesterId) {
        return HibernateUtil.executeWithResult(session -> {
            StringBuilder hql = new StringBuilder("SELECT COUNT(s) FROM Subject s WHERE 1=1");
            if (query != null && !query.isBlank()) {
                hql.append(" AND (LOWER(s.name) LIKE LOWER(:q) OR LOWER(s.code) LIKE LOWER(:q) OR LOWER(s.description) LIKE LOWER(:q))");
            }
            if (courseId != null) {
                hql.append(" AND s.course.id = :cId");
            }
            if (semesterId != null) {
                hql.append(" AND s.semester.id = :sId");
            }

            Query<Long> q = session.createQuery(hql.toString(), Long.class);
            if (query != null && !query.isBlank()) {
                q.setParameter("q", "%" + query.trim() + "%");
            }
            if (courseId != null) {
                q.setParameter("cId", courseId);
            }
            if (semesterId != null) {
                q.setParameter("sId", semesterId);
            }
            return q.getSingleResult();
        });
    }

    public Optional<Subject> findByCodeAndCourse(String code, Long courseId) {
        return HibernateUtil.executeWithResult(session -> {
            Query<Subject> q = session.createQuery(
                    "FROM Subject s WHERE s.code = :code AND s.course.id = :cId", Subject.class
            );
            q.setParameter("code", code);
            q.setParameter("cId", courseId);
            return q.uniqueResultOptional();
        });
    }
}

