package com.studymate.dao;

import com.studymate.config.DatabaseConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Direct JDBC implementation for high-efficiency reporting, statistical aggregation,
 * and high-throughput logging operations.
 */
public class JdbcReportingDao {

    private static final Logger logger = LoggerFactory.getLogger(JdbcReportingDao.class);

    /**
     * Aggregates real system statistics directly from PostgreSQL tables using JDBC.
     */
    public Map<String, Long> getPlatformOverviewStatistics() {
        Map<String, Long> stats = new HashMap<>();

        String sql = """
            SELECT
                (SELECT COUNT(*) FROM users u JOIN user_roles ur ON u.id = ur.user_id JOIN roles r ON ur.role_id = r.id WHERE r.name = 'ROLE_STUDENT') as total_students,
                (SELECT COUNT(*) FROM subjects WHERE is_active = true) as total_subjects,
                (SELECT COUNT(*) FROM resources WHERE is_archived = false) as total_resources,
                (SELECT COALESCE(SUM(download_count), 0) FROM resources) as total_downloads,
                (SELECT COALESCE(SUM(view_count), 0) FROM resources) as total_views,
                (SELECT COUNT(*) FROM courses WHERE is_active = true) as total_courses
        """;

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                stats.put("totalStudents", rs.getLong("total_students"));
                stats.put("totalSubjects", rs.getLong("total_subjects"));
                stats.put("totalResources", rs.getLong("total_resources"));
                stats.put("totalDownloads", rs.getLong("total_downloads"));
                stats.put("totalViews", rs.getLong("total_views"));
                stats.put("totalCourses", rs.getLong("total_courses"));
            }
        } catch (SQLException e) {
            logger.error("Error executing platform statistics query via JDBC", e);
        }

        return stats;
    }

    /**
     * Fetches resource distribution grouped by category using direct parameterized SQL.
     */
    public List<Map<String, Object>> getResourceDistributionByCategory() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT rc.name as category_name, rc.icon, COUNT(r.id) as resource_count
            FROM resource_categories rc
            LEFT JOIN resources r ON rc.id = r.category_id AND r.is_archived = false
            GROUP BY rc.id, rc.name, rc.icon, rc.display_order
            ORDER BY rc.display_order ASC
        """;

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("categoryName", rs.getString("category_name"));
                row.put("icon", rs.getString("icon"));
                row.put("count", rs.getLong("resource_count"));
                list.add(row);
            }
        } catch (SQLException e) {
            logger.error("Error fetching resource category distribution via JDBC", e);
        }
        return list;
    }

    /**
     * Records a file download log using JDBC PreparedStatement.
     */
    public void recordDownloadLog(Long userId, Long resourceId, Long fileId, String ipAddress, String userAgent) {
        String sql = """
            INSERT INTO download_logs (user_id, resource_id, file_id, ip_address, user_agent, downloaded_at)
            VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
        """;

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);
            ps.setLong(2, resourceId);
            if (fileId != null) {
                ps.setLong(3, fileId);
            } else {
                ps.setNull(3, java.sql.Types.BIGINT);
            }
            ps.setString(4, ipAddress != null ? ipAddress : "127.0.0.1");
            ps.setString(5, userAgent != null && userAgent.length() > 500 ? userAgent.substring(0, 500) : userAgent);

            ps.executeUpdate();
        } catch (SQLException e) {
            logger.error("Error recording download log via JDBC", e);
        }
    }

    /**
     * Retrieves recent download logs with joined resource title and student email.
     */
    public List<Map<String, Object>> getRecentDownloads(int limit) {
        List<Map<String, Object>> downloads = new ArrayList<>();
        String sql = """
            SELECT dl.id, dl.downloaded_at, u.full_name, u.email, r.title as resource_title
            FROM download_logs dl
            JOIN users u ON dl.user_id = u.id
            JOIN resources r ON dl.resource_id = r.id
            ORDER BY dl.downloaded_at DESC
            LIMIT ?
        """;

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", rs.getLong("id"));
                    map.put("downloadedAt", rs.getTimestamp("downloaded_at"));
                    map.put("studentName", rs.getString("full_name"));
                    map.put("studentEmail", rs.getString("email"));
                    map.put("resourceTitle", rs.getString("resource_title"));
                    downloads.add(map);
                }
            }
        } catch (SQLException e) {
            logger.error("Error retrieving recent download logs via JDBC", e);
        }
        return downloads;
    }
}

