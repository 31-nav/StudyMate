package com.studymate.dao;

import com.studymate.config.HibernateUtil;
import com.studymate.model.entity.Semester;
import org.hibernate.query.Query;

import java.util.List;
import java.util.Optional;

public class SemesterDao extends AbstractHibernateDao<Semester, Long> {

    public SemesterDao() {
        super(Semester.class);
    }

    public List<Semester> findByCourseId(Long courseId) {
        return HibernateUtil.executeWithResult(session -> {
            Query<Semester> q = session.createQuery(
                    "FROM Semester s WHERE s.course.id = :courseId ORDER BY s.semesterNumber ASC",
                    Semester.class
            );
            q.setParameter("courseId", courseId);
            return q.getResultList();
        });
    }

    public Optional<Semester> findByCourseAndNumber(Long courseId, int semesterNumber) {
        return HibernateUtil.executeWithResult(session -> {
            Query<Semester> q = session.createQuery(
                    "FROM Semester s WHERE s.course.id = :courseId AND s.semesterNumber = :num",
                    Semester.class
            );
            q.setParameter("courseId", courseId);
            q.setParameter("num", semesterNumber);
            return q.uniqueResultOptional();
        });
    }
}

