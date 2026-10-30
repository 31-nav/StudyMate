package com.studymate.dao;

import com.studymate.config.HibernateUtil;
import org.hibernate.Session;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;

public abstract class AbstractHibernateDao<T, ID extends Serializable> implements GenericDao<T, ID> {

    protected final Class<T> entityClass;

    protected AbstractHibernateDao(Class<T> entityClass) {
        this.entityClass = entityClass;
    }

    protected Session getSession() {
        return HibernateUtil.getCurrentSession();
    }

    @Override
    public T save(T entity) {
        return HibernateUtil.executeWithResult(session -> {
            session.persist(entity);
            return entity;
        });
    }

    @Override
    public T update(T entity) {
        return HibernateUtil.executeWithResult(session -> session.merge(entity));
    }

    @Override
    public void delete(T entity) {
        HibernateUtil.executeInTransaction(session -> session.remove(entity));
    }

    @Override
    public void deleteById(ID id) {
        HibernateUtil.executeInTransaction(session -> {
            T entity = session.get(entityClass, id);
            if (entity != null) {
                session.remove(entity);
            }
        });
    }

    @Override
    public Optional<T> findById(ID id) {
        return HibernateUtil.executeWithResult(session -> Optional.ofNullable(session.get(entityClass, id)));
    }

    @Override
    public List<T> findAll() {
        return HibernateUtil.executeWithResult(session ->
                session.createQuery("FROM " + entityClass.getSimpleName(), entityClass).getResultList()
        );
    }

    @Override
    public long count() {
        return HibernateUtil.executeWithResult(session ->
                session.createQuery("SELECT COUNT(e) FROM " + entityClass.getSimpleName() + " e", Long.class)
                        .getSingleResult()
        );
    }
}

