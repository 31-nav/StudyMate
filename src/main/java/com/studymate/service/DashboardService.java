package com.studymate.service;

import com.studymate.dao.*;
import com.studymate.model.entity.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardService {

    private final JdbcReportingDao jdbcReportingDao;
    private final ResourceDao resourceDao;
    private final SubjectDao subjectDao;
    private final BookmarkDao bookmarkDao;
    private final RecentlyViewedDao recentlyViewedDao;
    private final AnnouncementDao announcementDao;
    private final NotificationDao notificationDao;
    private final AuditLogDao auditLogDao;

    public DashboardService() {
        this(new JdbcReportingDao(), new ResourceDao(), new SubjectDao(), new BookmarkDao(),
             new RecentlyViewedDao(), new AnnouncementDao(), new NotificationDao(), new AuditLogDao());
    }

    public DashboardService(JdbcReportingDao jdbcReportingDao, ResourceDao resourceDao,
                            SubjectDao subjectDao, BookmarkDao bookmarkDao,
                            RecentlyViewedDao recentlyViewedDao, AnnouncementDao announcementDao,
                            NotificationDao notificationDao, AuditLogDao auditLogDao) {
        this.jdbcReportingDao = jdbcReportingDao;
        this.resourceDao = resourceDao;
        this.subjectDao = subjectDao;
        this.bookmarkDao = bookmarkDao;
        this.recentlyViewedDao = recentlyViewedDao;
        this.announcementDao = announcementDao;
        this.notificationDao = notificationDao;
        this.auditLogDao = auditLogDao;
    }

    /**
     * Builds real database-backed statistics and lists for the Student dashboard.
     */
    public Map<String, Object> getStudentDashboardData(User student) {
        Map<String, Object> data = new HashMap<>();

        Long courseId = student.getCourse() != null ? student.getCourse().getId() : null;
        Long semesterId = student.getSemester() != null ? student.getSemester().getId() : null;

        // Enrolled subjects
        List<Subject> subjects = List.of();
        if (courseId != null && semesterId != null) {
            subjects = subjectDao.findByCourseAndSemester(courseId, semesterId);
        } else if (courseId != null) {
            subjects = subjectDao.findByCourse(courseId);
        }
        data.put("enrolledSubjects", subjects);
        data.put("totalSubjectsCount", (long) subjects.size());

        // Bookmarks & Recently Viewed
        long bookmarkCount = bookmarkDao.countByUserId(student.getId());
        List<Bookmark> recentBookmarks = bookmarkDao.findByUserId(student.getId());
        List<RecentlyViewed> recentlyViewed = recentlyViewedDao.findByUserId(student.getId(), 5);
        data.put("bookmarkCount", bookmarkCount);
        data.put("recentBookmarks", recentBookmarks);
        data.put("recentlyViewed", recentlyViewed);

        // Platform resources & recent uploads
        long totalResources = resourceDao.count();
        List<Resource> recentUploads = resourceDao.findRecentResources(6);
        data.put("totalResources", totalResources);
        data.put("recentUploads", recentUploads);

        // Announcements & Notifications
        List<Announcement> announcements = announcementDao.findActiveAnnouncementsForStudent(courseId, semesterId, 5);
        long unreadNotifications = notificationDao.countUnreadByUserId(student.getId());
        data.put("announcements", announcements);
        data.put("unreadNotifications", unreadNotifications);

        return data;
    }

    /**
     * Builds data-focused statistics for the Admin dashboard.
     */
    public Map<String, Object> getAdminDashboardData() {
        Map<String, Object> data = new HashMap<>();

        Map<String, Long> overviewStats = jdbcReportingDao.getPlatformOverviewStatistics();
        data.putAll(overviewStats);

        data.put("categoryDistribution", jdbcReportingDao.getResourceDistributionByCategory());
        data.put("recentUploads", resourceDao.findRecentResources(8));
        data.put("recentDownloads", jdbcReportingDao.getRecentDownloads(5));
        data.put("recentAuditLogs", auditLogDao.findRecent(0, 8));

        return data;
    }

    /**
     * Builds global governance statistics for the Super Admin dashboard.
     */
    public Map<String, Object> getSuperAdminDashboardData() {
        Map<String, Object> data = getAdminDashboardData();
        data.put("recentAuditLogs", auditLogDao.findRecent(0, 15));
        return data;
    }
}

