# Direct JDBC & Reporting Guide: StudyMate

## 1. Architectural Justification for Direct JDBC

While **Hibernate ORM** excels at transactional entity operations (creating users, persisting uploads, toggling bookmarks), it introduces significant memory overhead and query translation complexity when executing analytical queries spanning multiple aggregated tables.

StudyMate resolves this by introducing a dedicated **Direct JDBC Reporting Layer** via `JdbcReportingDao`.

### When to Use Hibernate vs. Direct JDBC

| Operational Task | Preferred Technology | Rationale |
|---|---|---|
| Domain entity creation, updates, deletes | **Hibernate ORM** | Enforces entity constraints, manages cascading deletes, handles object identity. |
| Single-entity lookups by primary key | **Hibernate ORM** | Clean type safety and session caching. |
| Multi-table statistical aggregation | **Direct JDBC** | Bypasses entity instantiation overhead; runs direct SQL engine aggregates. |
| Dashboard KPI overview counters | **Direct JDBC** | Single-trip SQL combining multiple scalar counts into one light DTO. |
| Exporting bulk reporting data | **Direct JDBC** | Efficient cursor streaming with minimal JVM heap impact. |

---

## 2. HikariCP Connection Pooling (`DatabaseConfig`)

Direct JDBC operations utilize an independent, highly optimized **HikariCP** datasource configured in `DatabaseConfig`:

```java
package com.studymate.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;

public class DatabaseConfig {
    private static final HikariDataSource dataSource;

    static {
        HikariConfig config = new HikariConfig();
        config.setDriverClassName("org.postgresql.Driver");
        config.setJdbcUrl("jdbc:postgresql://localhost:5432/studymate");
        config.setUsername("postgres");
        config.setPassword("postgres");
        config.setMaximumPoolSize(15);
        config.setMinimumIdle(5);
        config.setIdleTimeout(30000);
        config.setConnectionTimeout(10000);
        config.setPoolName("StudyMate-HikariCP-Pool");

        dataSource = new HikariDataSource(config);
    }

    public static DataSource getDataSource() {
        return dataSource;
    }
}
```

---

## 3. High-Efficiency Analytical Querying (`JdbcReportingDao`)

The `JdbcReportingDao` executes optimized aggregation queries to power the Admin and SuperAdmin dashboards.

### Example: Single-Query Platform Overview Statistics
Rather than querying 6 separate Hibernate entities sequentially, `JdbcReportingDao` executes a single optimized query returning all platform counters:

```java
public PlatformStatsDto getPlatformOverviewStatistics() {
    String sql = "SELECT " +
                 "  (SELECT COUNT(*) FROM users WHERE is_active = true) AS total_users, " +
                 "  (SELECT COUNT(*) FROM courses WHERE is_active = true) AS total_courses, " +
                 "  (SELECT COUNT(*) FROM subjects WHERE is_active = true) AS total_subjects, " +
                 "  (SELECT COUNT(*) FROM resources WHERE is_published = true) AS total_resources, " +
                 "  (SELECT COALESCE(SUM(view_count), 0) FROM resources) AS total_views, " +
                 "  (SELECT COALESCE(SUM(download_count), 0) FROM resources) AS total_downloads";

    try (Connection conn = DatabaseConfig.getDataSource().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            return new PlatformStatsDto(
                rs.getLong("total_users"),
                rs.getLong("total_courses"),
                rs.getLong("total_subjects"),
                rs.getLong("total_resources"),
                rs.getLong("total_views"),
                rs.getLong("total_downloads")
            );
        }
        return new PlatformStatsDto();
    } catch (SQLException e) {
        logger.error("Error executing platform overview statistics query", e);
        throw new DaoException("Failed to load platform statistics", e);
    }
}
```

---

## 4. Prepared Statement Security Best Practices

1. **Zero String Concatenation**: No user-supplied input is ever concatenated into SQL query strings.
2. **Type-Safe Parameter Binding**: Every variable is bound using appropriate `ps.setLong()`, `ps.setString()`, or `ps.setBoolean()` methods.
3. **Deterministic Resource Closing**: Connections, Statements, and ResultSets are closed via Java 7+ `try-with-resources` to eliminate connection leaks.

