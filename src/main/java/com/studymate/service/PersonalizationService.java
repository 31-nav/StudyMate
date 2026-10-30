package com.studymate.service;

import com.studymate.dao.*;
import com.studymate.exception.ResourceNotFoundException;
import com.studymate.model.entity.*;
import com.studymate.model.enums.NotificationType;

import java.util.List;
import java.util.Optional;

public class PersonalizationService {

    private final BookmarkDao bookmarkDao;
    private final RecentlyViewedDao recentlyViewedDao;
    private final NotificationDao notificationDao;
    private final ResourceDao resourceDao;
    private final UserDao userDao;

    public PersonalizationService() {
        this(new BookmarkDao(), new RecentlyViewedDao(), new NotificationDao(),
             new ResourceDao(), new UserDao());
    }

    public PersonalizationService(BookmarkDao bookmarkDao, RecentlyViewedDao recentlyViewedDao,
                                  NotificationDao notificationDao, ResourceDao resourceDao, UserDao userDao) {
        this.bookmarkDao = bookmarkDao;
        this.recentlyViewedDao = recentlyViewedDao;
        this.notificationDao = notificationDao;
        this.resourceDao = resourceDao;
        this.userDao = userDao;
    }

    // --- Bookmarks ---
    public boolean toggleBookmark(Long userId, Long resourceId, String note) {
        Optional<Bookmark> existing = bookmarkDao.findByUserAndResource(userId, resourceId);
        if (existing.isPresent()) {
            bookmarkDao.delete(existing.get());
            return false; // Removed
        } else {
            User user = userDao.findById(userId)
                    .orElseThrow(() -> new ResourceNotFoundException("User not found"));
            Resource resource = resourceDao.findById(resourceId)
                    .orElseThrow(() -> new ResourceNotFoundException("Resource not found"));

            Bookmark bookmark = new Bookmark(user, resource, note);
            bookmarkDao.save(bookmark);
            return true; // Added
        }
    }

    public boolean isBookmarked(Long userId, Long resourceId) {
        return bookmarkDao.isBookmarked(userId, resourceId);
    }

    public List<Bookmark> getUserBookmarks(Long userId) {
        return bookmarkDao.findByUserId(userId);
    }

    public long getBookmarkCount(Long userId) {
        return bookmarkDao.countByUserId(userId);
    }

    // --- Recently Viewed ---
    public void recordRecentlyViewed(User user, Resource resource) {
        if (user != null && resource != null) {
            recentlyViewedDao.recordAccess(user, resource);
        }
    }

    public List<RecentlyViewed> getRecentlyViewed(Long userId, int limit) {
        return recentlyViewedDao.findByUserId(userId, limit);
    }

    // --- Notifications ---
    public List<Notification> getUserNotifications(Long userId, int limit) {
        return notificationDao.findByUserId(userId, limit);
    }

    public long getUnreadNotificationCount(Long userId) {
        return notificationDao.countUnreadByUserId(userId);
    }

    public void markAllNotificationsRead(Long userId) {
        notificationDao.markAllAsRead(userId);
    }

    public void sendNotification(Long userId, String title, String message, NotificationType type, String linkUrl) {
        userDao.findById(userId).ifPresent(user -> {
            Notification n = new Notification(user, title, message, type, linkUrl);
            notificationDao.save(n);
        });
    }
}

