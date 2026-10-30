# Hibernate ORM Guide: StudyMate

## 1. Hibernate 6.4 Overview in StudyMate

StudyMate uses **Hibernate ORM 6.4** as its primary object-relational mapping and transactional persistence engine. 

Hibernate manages the persistence lifecycle for all 18 domain entities, handles relational mappings, enforces database constraints, and isolates database dialect specifics for PostgreSQL 16.

---

## 2. SessionFactory & Lifecycle (`HibernateUtil`)

The `HibernateUtil` class encapsulates the bootstrapping and lifecycle of the immutable `SessionFactory`. It is initialized eagerly at application startup via `ServletContextListener` and cleanly closed on container shutdown.

```java
package com.studymate.config;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class HibernateUtil {
    private static final Logger logger = LoggerFactory.getLogger(HibernateUtil.class);
    private static final SessionFactory sessionFactory = buildSessionFactory();

    private static SessionFactory buildSessionFactory() {
        try {
            return new Configuration().configure("hibernate.cfg.xml").buildSessionFactory();
        } catch (Throwable ex) {
            logger.error("Initial SessionFactory creation failed.", ex);
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static void shutdown() {
        if (sessionFactory != null && !sessionFactory.isClosed()) {
            sessionFactory.close();
        }
    }
}
```

---

## 3. Configuration (`hibernate.cfg.xml`)

StudyMate's Hibernate configuration specifies connection parameters, PostgreSQL 16 dialect, thread-bound current session context, and entity class registrations:

```xml
<hibernate-configuration>
    <session-factory>
        <property name="hibernate.connection.driver_class">org.postgresql.Driver</property>
        <property name="hibernate.connection.url">jdbc:postgresql://localhost:5432/studymate</property>
        <property name="hibernate.connection.username">postgres</property>
        <property name="hibernate.connection.password">postgres</property>

        <!-- HikariCP Integration -->
        <property name="hibernate.connection.provider_class">
            org.hibernate.hikaricp.internal.HikariCPConnectionProvider
        </property>
        <property name="hibernate.hikari.minimumIdle">5</property>
        <property name="hibernate.hikari.maximumPoolSize">20</property>
        <property name="hibernate.hikari.idleTimeout">30000</property>

        <!-- Dialect & SQL Formatting -->
        <property name="hibernate.dialect">org.hibernate.dialect.PostgreSQLDialect</property>
        <property name="hibernate.show_sql">false</property>
        <property name="hibernate.format_sql">false</property>
        <property name="hibernate.hbm2ddl.auto">validate</property>

        <!-- Entity Registrations -->
        <mapping class="com.studymate.model.User"/>
        <mapping class="com.studymate.model.Role"/>
        <mapping class="com.studymate.model.Course"/>
        <mapping class="com.studymate.model.Semester"/>
        <mapping class="com.studymate.model.Subject"/>
        <mapping class="com.studymate.model.Resource"/>
        <mapping class="com.studymate.model.ResourceFile"/>
        <mapping class="com.studymate.model.ResourceCategory"/>
        <mapping class="com.studymate.model.UserBookmark"/>
        <mapping class="com.studymate.model.UserRecentView"/>
        <mapping class="com.studymate.model.Announcement"/>
        <mapping class="com.studymate.model.Notification"/>
        <mapping class="com.studymate.model.AuditLog"/>
        <mapping class="com.studymate.model.SystemSetting"/>
        <mapping class="com.studymate.model.VerificationToken"/>
        <mapping class="com.studymate.model.PasswordReset"/>
    </session-factory>
</hibernate-configuration>
```

---

## 4. Transaction Management Pattern

All DAO operations that modify database state follow a strict `try-with-resources` pattern with explicit transaction rollback on error:

```java
public void save(User user) {
    Transaction transaction = null;
    try (Session session = HibernateUtil.getSessionFactory().openSession()) {
        transaction = session.beginTransaction();
        session.persist(user);
        transaction.commit();
    } catch (Exception e) {
        if (transaction != null && transaction.isActive()) {
            transaction.rollback();
        }
        logger.error("Failed to persist user: {}", user.getEmail(), e);
        throw new DaoException("Error saving user entity", e);
    }
}
```

---

## 5. Eliminating N+1 Queries with HQL `JOIN FETCH`

When loading entities with relational collections (e.g., retrieving a Resource along with its Category, Subject, and File metadata), StudyMate uses HQL `JOIN FETCH` clauses to execute a single optimized SQL join:

```java
public Optional<Resource> findByIdWithDetails(Long id) {
    try (Session session = HibernateUtil.getSessionFactory().openSession()) {
        String hql = "SELECT r FROM Resource r " +
                     "JOIN FETCH r.subject s " +
                     "JOIN FETCH r.category c " +
                     "LEFT JOIN FETCH r.files " +
                     "WHERE r.id = :id";
        Resource resource = session.createQuery(hql, Resource.class)
                                   .setParameter("id", id)
                                   .uniqueResult();
        return Optional.ofNullable(resource);
    }
}
```
This guarantees zero lazy initialization exceptions (`LazyInitializationException`) when serializing resource details in the presentation layer.

