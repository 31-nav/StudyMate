package com.studymate.service;

import com.studymate.dao.AnnouncementDao;
import com.studymate.dao.AuditLogDao;
import com.studymate.exception.ResourceNotFoundException;
import com.studymate.exception.ValidationException;
import com.studymate.model.entity.Announcement;
import com.studymate.model.entity.AuditLog;
import com.studymate.model.entity.User;
import com.studymate.model.enums.Priority;
import com.studymate.model.enums.TargetAudience;

import java.time.LocalDateTime;
import java.util.List;

public class AnnouncementService {

    private final AnnouncementDao announcementDao;
    private final AuditLogDao auditLogDao;

    public AnnouncementService() {
        this(new AnnouncementDao(), new AuditLogDao());
    }

    public AnnouncementService(AnnouncementDao announcementDao, AuditLogDao auditLogDao) {
        this.announcementDao = announcementDao;
        this.auditLogDao = auditLogDao;
    }

    public List<Announcement> getActiveAnnouncementsForStudent(Long courseId, Long semesterId, int limit) {
        return announcementDao.findActiveAnnouncementsForStudent(courseId, semesterId, limit);
    }

    public List<Announcement> getAllRecentAnnouncements(int offset, int limit) {
        return announcementDao.findAllRecent(offset, limit);
    }

    public Announcement createAnnouncement(String title, String content, Priority priority,
                                           TargetAudience audience, User author) {
        if (title == null || title.isBlank() || content == null || content.isBlank()) {
            throw new ValidationException("Announcement title and content are required");
        }

        Announcement a = new Announcement();
        a.setTitle(title.trim());
        a.setContent(content.trim());
        a.setPriority(priority != null ? priority : Priority.NORMAL);
        a.setTargetAudience(audience != null ? audience : TargetAudience.ALL);
        a.setCreatedBy(author);
        a.setPublished(true);
        a.setPublishedAt(LocalDateTime.now());

        Announcement saved = announcementDao.save(a);

        auditLogDao.save(new AuditLog(author, "ANNOUNCEMENT_CREATED", "Announcement", saved.getId().toString(),
                "Published announcement: " + saved.getTitle(), null));

        return saved;
    }

    public void deleteAnnouncement(Long id, User admin) {
        Announcement a = announcementDao.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Announcement not found"));
        announcementDao.delete(a);

        auditLogDao.save(new AuditLog(admin, "ANNOUNCEMENT_DELETED", "Announcement", id.toString(),
                "Deleted announcement: " + a.getTitle(), null));
    }
}

