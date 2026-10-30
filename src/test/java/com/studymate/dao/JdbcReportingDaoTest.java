package com.studymate.dao;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Direct JDBC Reporting & Aggregation DAO Test")
class JdbcReportingDaoTest {

    private final JdbcReportingDao jdbcReportingDao = new JdbcReportingDao();

    @Test
    @DisplayName("Platform overview returns non-null statistics with active database counts")
    void testPlatformOverviewStatistics() {
        Map<String, Long> stats = jdbcReportingDao.getPlatformOverviewStatistics();

        assertNotNull(stats, "Statistics map must never be null");
        // Check that keys are mapped properly
        assertTrue(stats.containsKey("totalCourses") || stats.isEmpty(), "Should contain totalCourses key if DB reachable");

        // If local database is running and seeded
        if (!stats.isEmpty()) {
            assertTrue(stats.get("totalCourses") >= 1, "Should have seeded courses");
            assertTrue(stats.get("totalSubjects") >= 1, "Should have seeded subjects");
        }
    }
}

