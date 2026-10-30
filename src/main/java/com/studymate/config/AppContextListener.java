package com.studymate.config;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@WebListener
public class AppContextListener implements ServletContextListener {

    private static final Logger logger = LoggerFactory.getLogger(AppContextListener.class);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("=================================================");
        logger.info("Initializing StudyMate LMS Application Context");
        logger.info("Tagline: {}", AppConfig.getAppTagline());
        logger.info("=================================================");

        try {
            // 1. Initialize file storage directory
            StorageConfig.initStorage();

            // 2. Initialize Hibernate SessionFactory early
            HibernateUtil.getSessionFactory();

            // 3. Verify JDBC connectivity
            boolean connected = DatabaseConfig.testConnection();
            if (connected) {
                logger.info("Database connection established successfully.");
            } else {
                logger.warn("Database connection could not be verified on startup. Check configuration.");
            }

            logger.info("StudyMate application initialized successfully.");
        } catch (Exception e) {
            logger.error("Error during StudyMate context initialization: {}", e.getMessage(), e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("Shutting down StudyMate application context...");
        try {
            HibernateUtil.shutdown();
        } catch (Exception e) {
            logger.error("Error shutting down Hibernate SessionFactory", e);
        }
        logger.info("StudyMate context destroyed.");
    }
}

