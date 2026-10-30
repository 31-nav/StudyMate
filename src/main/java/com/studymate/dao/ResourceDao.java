package com.studymate.dao;

import com.studymate.config.HibernateUtil;
import com.studymate.model.entity.Resource;
import com.studymate.model.enums.ResourceType;
import org.hibernate.Hibernate;
import org.hibernate.query.Query;

import java.util.List;
import java.util.Optional;

public class ResourceDao extends AbstractHibernateDao<Resource, Long> {

    public ResourceDao() {
        super(Resource.class);
    }

    public Optional<Resource> findByIdWithDetails(Long id) {
        return HibernateUtil.executeWithResult(session -> {
            Query<Resource> q = session.createQuery(
                    "SELECT r FROM Resource r " +
                    "JOIN FETCH r.course " +
                    "JOIN FETCH r.semester " +
                    "JOIN FETCH r.subject " +
                    "JOIN FETCH r.category " +
                    "JOIN FETCH r.uploadedBy " +
                    "LEFT JOIN FETCH r.files " +
                    "WHERE r.id = :id AND r.archived = false", Resource.class
            );
            q.setParameter("id", id);
            return q.uniqueResultOptional();
        });
    }

    public List<Resource> searchResources(String keyword, Long courseId, Long semesterId,
                                          Long subjectId, Long categoryId, ResourceType type,
                                          String sortBy, int offset, int limit) {
        return HibernateUtil.executeWithResult(session -> {
            StringBuilder hql = new StringBuilder(
                    "SELECT DISTINCT r FROM Resource r " +
                    "JOIN FETCH r.course c " +
                    "JOIN FETCH r.semester sem " +
                    "JOIN FETCH r.subject sub " +
                    "JOIN FETCH r.category cat " +
                    "JOIN FETCH r.uploadedBy u " +
                    "WHERE r.archived = false AND r.visibility = 'PUBLIC'"
            );

            applyFilters(hql, keyword, courseId, semesterId, subjectId, categoryId, type);

            // Sorting
            if ("popular".equalsIgnoreCase(sortBy)) {
                hql.append(" ORDER BY r.downloadCount DESC, r.viewCount DESC");
            } else if ("views".equalsIgnoreCase(sortBy)) {
                hql.append(" ORDER BY r.viewCount DESC");
            } else if ("title".equalsIgnoreCase(sortBy)) {
                hql.append(" ORDER BY r.title ASC");
            } else {
                hql.append(" ORDER BY r.createdAt DESC");
            }

            Query<Resource> q = session.createQuery(hql.toString(), Resource.class);
            setParameters(q, keyword, courseId, semesterId, subjectId, categoryId, type);
            q.setFirstResult(offset);
            q.setMaxResults(limit);

            List<Resource> results = q.getResultList();
            // Initialize files for preview
            for (Resource res : results) {
                Hibernate.initialize(res.getFiles());
            }
            return results;
        });
    }

    public long countSearchResources(String keyword, Long courseId, Long semesterId,
                                     Long subjectId, Long categoryId, ResourceType type) {
        return HibernateUtil.executeWithResult(session -> {
            StringBuilder hql = new StringBuilder(
                    "SELECT COUNT(DISTINCT r) FROM Resource r " +
                    "JOIN r.course c JOIN r.semester sem JOIN r.subject sub JOIN r.category cat " +
                    "WHERE r.archived = false AND r.visibility = 'PUBLIC'"
            );

            applyFilters(hql, keyword, courseId, semesterId, subjectId, categoryId, type);

            Query<Long> q = session.createQuery(hql.toString(), Long.class);
            setParameters(q, keyword, courseId, semesterId, subjectId, categoryId, type);
            return q.getSingleResult();
        });
    }

    private void applyFilters(StringBuilder hql, String keyword, Long courseId, Long semesterId,
                              Long subjectId, Long categoryId, ResourceType type) {
        if (keyword != null && !keyword.isBlank()) {
            hql.append(" AND (LOWER(r.title) LIKE LOWER(:kw) OR LOWER(r.description) LIKE LOWER(:kw) ")
               .append("OR LOWER(r.tags) LIKE LOWER(:kw) OR LOWER(sub.name) LIKE LOWER(:kw) ")
               .append("OR LOWER(c.name) LIKE LOWER(:kw))");
        }
        if (courseId != null) hql.append(" AND c.id = :cId");
        if (semesterId != null) hql.append(" AND sem.id = :sId");
        if (subjectId != null) hql.append(" AND sub.id = :subId");
        if (categoryId != null) hql.append(" AND cat.id = :catId");
        if (type != null) hql.append(" AND r.resourceType = :type");
    }

    private void setParameters(Query<?> q, String keyword, Long courseId, Long semesterId,
                               Long subjectId, Long categoryId, ResourceType type) {
        if (keyword != null && !keyword.isBlank()) q.setParameter("kw", "%" + keyword.trim() + "%");
        if (courseId != null) q.setParameter("cId", courseId);
        if (semesterId != null) q.setParameter("sId", semesterId);
        if (subjectId != null) q.setParameter("subId", subjectId);
        if (categoryId != null) q.setParameter("catId", categoryId);
        if (type != null) q.setParameter("type", type);
    }

    public void incrementViewCount(Long resourceId) {
        HibernateUtil.executeInTransaction(session -> {
            Query<?> q = session.createQuery("UPDATE Resource r SET r.viewCount = r.viewCount + 1 WHERE r.id = :id");
            q.setParameter("id", resourceId);
            q.executeUpdate();
        });
    }

    public void incrementDownloadCount(Long resourceId) {
        HibernateUtil.executeInTransaction(session -> {
            Query<?> q = session.createQuery("UPDATE Resource r SET r.downloadCount = r.downloadCount + 1 WHERE r.id = :id");
            q.setParameter("id", resourceId);
            q.executeUpdate();
        });
    }

    public List<Resource> findRecentResources(int limit) {
        return searchResources(null, null, null, null, null, null, "latest", 0, limit);
    }

    public List<Resource> findBySubjectId(Long subjectId) {
        return searchResources(null, null, null, subjectId, null, null, "latest", 0, 100);
    }
}

