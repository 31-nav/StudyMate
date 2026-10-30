package com.studymate.dao;

import com.studymate.config.HibernateUtil;
import com.studymate.model.entity.Course;
import org.hibernate.query.Query;

import java.util.List;
import java.util.Optional;

public class CourseDao extends AbstractHibernateDao<Course, Long> {

    public CourseDao() {
        super(Course.class);
    }

    public List<Course> findAllActive() {
        return HibernateUtil.executeWithResult(session ->
                session.createQuery("FROM Course c WHERE c.active = true ORDER BY c.name ASC", Course.class)
                        .getResultList()
        );
    }

    public Optional<Course> findByCode(String code) {
        return HibernateUtil.executeWithResult(session -> {
            Query<Course> q = session.createQuery("FROM Course c WHERE c.code = :code", Course.class);
            q.setParameter("code", code);
            return q.uniqueResultOptional();
        });
    }
}

