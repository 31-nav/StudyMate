package com.studymate.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Direct JDBC Configuration and Connection Provider.
 * Used for direct SQL reporting, complex aggregation queries, and database health checks.
 */
public final class DatabaseConfig {

    private static final Logger logger = LoggerFactory.getLogger(DatabaseConfig.class);

    static {
        try {
            Class.forName(AppConfig.getDbDriver());
        } catch (ClassNotFoundException e) {
            logger.error("Failed to load JDBC driver: {}", AppConfig.getDbDriver(), e);
        }
    }

    private DatabaseConfig() {}

    /**
     * Obtains a new JDBC connection.
     * Callers MUST close this connection (prefer try-with-resources).
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                AppConfig.getDatabaseUrl(),
                AppConfig.getDbUsername(),
                AppConfig.getDbPassword()
        );
    }

    /**
     * Tests whether the database connection is live.
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            logger.warn("Database connection test failed: {}", e.getMessage());
            return false;
        }
    }
}

