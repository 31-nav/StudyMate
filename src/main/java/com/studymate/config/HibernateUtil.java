package com.studymate.config;

import com.studymate.model.entity.*;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.cfg.Environment;
import org.hibernate.service.ServiceRegistry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Properties;
import java.util.function.Consumer;
import java.util.function.Function;

/**
 * Manages the Hibernate SessionFactory and contextual sessions.
 */
public final class HibernateUtil {

    private static final Logger logger = LoggerFactory.getLogger(HibernateUtil.class);
    private static volatile SessionFactory sessionFactory;

    private HibernateUtil() {}

    public static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            synchronized (HibernateUtil.class) {
                if (sessionFactory == null) {
                    sessionFactory = buildSessionFactory();
                }
            }
        }
        return sessionFactory;
    }

    private static SessionFactory buildSessionFactory() {
        try {
            Configuration configuration = new Configuration();

            // Load hibernate properties from AppConfig
            Properties settings = new Properties();
            settings.put(Environment.JAKARTA_JDBC_DRIVER, AppConfig.getDbDriver());
            settings.put(Environment.JAKARTA_JDBC_URL, AppConfig.getDatabaseUrl());
            settings.put(Environment.JAKARTA_JDBC_USER, AppConfig.getDbUsername());
            settings.put(Environment.JAKARTA_JDBC_PASSWORD, AppConfig.getDbPassword());

            if (AppConfig.getDatabaseUrl().contains("h2")) {
                settings.put(Environment.DIALECT, "org.hibernate.dialect.H2Dialect");
            } else {
                settings.put(Environment.DIALECT, "org.hibernate.dialect.PostgreSQLDialect");
            }

            settings.put(Environment.HBM2DDL_AUTO, AppConfig.getHibernateHbm2DdlAuto());
            settings.put(Environment.SHOW_SQL, String.valueOf(AppConfig.isHibernateShowSql()));
            settings.put(Environment.FORMAT_SQL, "true");
            settings.put(Environment.CURRENT_SESSION_CONTEXT_CLASS, "thread");
            settings.put(Environment.POOL_SIZE, "10");

            configuration.setProperties(settings);

            // Register all entity classes
            configuration.addAnnotatedClass(User.class);
            configuration.addAnnotatedClass(Role.class);
            configuration.addAnnotatedClass(Permission.class);
            configuration.addAnnotatedClass(Course.class);
            configuration.addAnnotatedClass(Semester.class);
            configuration.addAnnotatedClass(Subject.class);
            configuration.addAnnotatedClass(ResourceCategory.class);
            configuration.addAnnotatedClass(Resource.class);
            configuration.addAnnotatedClass(ResourceFile.class);
            configuration.addAnnotatedClass(Bookmark.class);
            configuration.addAnnotatedClass(RecentlyViewed.class);
            configuration.addAnnotatedClass(Announcement.class);
            configuration.addAnnotatedClass(Notification.class);
            configuration.addAnnotatedClass(DownloadLog.class);
            configuration.addAnnotatedClass(AuditLog.class);
            configuration.addAnnotatedClass(PasswordResetToken.class);
            configuration.addAnnotatedClass(EmailVerificationToken.class);
            configuration.addAnnotatedClass(AdministratorInvitation.class);

            ServiceRegistry serviceRegistry = new StandardServiceRegistryBuilder()
                    .applySettings(configuration.getProperties()).build();

            logger.info("Initializing Hibernate SessionFactory for URL: {}", AppConfig.getDatabaseUrl());
            return configuration.buildSessionFactory(serviceRegistry);

        } catch (Exception e) {
            logger.error("Initial SessionFactory creation failed: {}", e.getMessage(), e);
            throw new ExceptionInInitializerError(e);
        }
    }

    public static Session openSession() {
        return getSessionFactory().openSession();
    }

    public static Session getCurrentSession() {
        return getSessionFactory().getCurrentSession();
    }

    /**
     * Executes an operation inside a managed transaction and returns a result.
     */
    public static <R> R executeWithResult(Function<Session, R> action) {
        Transaction tx = null;
        try (Session session = openSession()) {
            tx = session.beginTransaction();
            R result = action.apply(session);
            tx.commit();
            return result;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                try {
                    tx.rollback();
                } catch (Exception rbEx) {
                    logger.error("Failed to rollback transaction", rbEx);
                }
            }
            throw new RuntimeException("Database transaction failed: " + e.getMessage(), e);
        }
    }

    /**
     * Executes an operation inside a managed transaction without return value.
     */
    public static void executeInTransaction(Consumer<Session> action) {
        executeWithResult(session -> {
            action.accept(session);
            return null;
        });
    }

    public static void shutdown() {
        if (sessionFactory != null && !sessionFactory.isClosed()) {
            logger.info("Closing Hibernate SessionFactory...");
            sessionFactory.close();
            sessionFactory = null;
        }
    }
}

