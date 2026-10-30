package com.studymate.dao;

import com.studymate.config.HibernateUtil;
import com.studymate.model.entity.ResourceCategory;
import org.hibernate.query.Query;

import java.util.List;
import java.util.Optional;

public class ResourceCategoryDao extends AbstractHibernateDao<ResourceCategory, Long> {

    public ResourceCategoryDao() {
        super(ResourceCategory.class);
    }

    public List<ResourceCategory> findAllOrdered() {
        return HibernateUtil.executeWithResult(session ->
                session.createQuery("FROM ResourceCategory rc ORDER BY rc.displayOrder ASC, rc.name ASC", ResourceCategory.class)
                        .getResultList()
        );
    }

    public Optional<ResourceCategory> findByCode(String code) {
        return HibernateUtil.executeWithResult(session -> {
            Query<ResourceCategory> q = session.createQuery(
                    "FROM ResourceCategory rc WHERE rc.code = :code", ResourceCategory.class
            );
            q.setParameter("code", code);
            return q.uniqueResultOptional();
        });
    }
}

