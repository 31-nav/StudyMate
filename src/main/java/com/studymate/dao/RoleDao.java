package com.studymate.dao;

import com.studymate.config.HibernateUtil;
import com.studymate.model.entity.Role;
import org.hibernate.query.Query;

import java.util.Optional;

public class RoleDao extends AbstractHibernateDao<Role, Long> {

    public RoleDao() {
        super(Role.class);
    }

    public Optional<Role> findByName(String name) {
        return HibernateUtil.executeWithResult(session -> {
            Query<Role> q = session.createQuery("FROM Role r WHERE r.name = :name", Role.class);
            q.setParameter("name", name);
            return q.uniqueResultOptional();
        });
    }
}

