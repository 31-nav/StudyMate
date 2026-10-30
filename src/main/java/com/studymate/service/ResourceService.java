package com.studymate.service;

import com.studymate.dao.*;
import com.studymate.exception.AuthorizationException;
import com.studymate.exception.ResourceNotFoundException;
import com.studymate.exception.ValidationException;
import com.studymate.model.entity.*;
import com.studymate.model.enums.ResourceType;
import com.studymate.model.enums.ResourceVisibility;
import com.studymate.storage.FileStorageService;
import com.studymate.util.ValidationUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.List;

public class ResourceService {

    private static final Logger logger = LoggerFactory.getLogger(ResourceService.class);

    private final ResourceDao resourceDao;
    private final CourseDao courseDao;
    private final SemesterDao semesterDao;
    private final SubjectDao subjectDao;
    private final ResourceCategoryDao categoryDao;
    private final FileStorageService fileStorageService;
    private final JdbcReportingDao jdbcReportingDao;
    private final AuditLogDao auditLogDao;

    public ResourceService() {
        this(new ResourceDao(), new CourseDao(), new SemesterDao(), new SubjectDao(),
             new ResourceCategoryDao(), new FileStorageService(), new JdbcReportingDao(), new AuditLogDao());
    }

    public ResourceService(ResourceDao resourceDao, CourseDao courseDao, SemesterDao semesterDao,
                           SubjectDao subjectDao, ResourceCategoryDao categoryDao,
                           FileStorageService fileStorageService, JdbcReportingDao jdbcReportingDao,
                           AuditLogDao auditLogDao) {
        this.resourceDao = resourceDao;
        this.courseDao = courseDao;
        this.semesterDao = semesterDao;
        this.subjectDao = subjectDao;
        this.categoryDao = categoryDao;
        this.fileStorageService = fileStorageService;
        this.jdbcReportingDao = jdbcReportingDao;
        this.auditLogDao = auditLogDao;
    }

    /**
     * Uploads and creates a new academic resource.
     */
    public Resource createResource(String title, String description, Long courseId, Long semesterId,
                                   Long subjectId, Long categoryId, ResourceType resourceType,
                                   String externalUrl, ResourceVisibility visibility, boolean isDownloadable,
                                   String tags, User uploader,
                                   String originalFilename, String mimeType, long size, InputStream fileStream) {

        if (title == null || title.isBlank()) {
            throw new ValidationException("Resource title is required");
        }
        if (resourceType == null) {
            throw new ValidationException("Resource type must be specified");
        }

        Course course = courseDao.findById(courseId)
                .orElseThrow(() -> new ValidationException("Selected course does not exist"));
        Semester semester = semesterDao.findById(semesterId)
                .orElseThrow(() -> new ValidationException("Selected semester does not exist"));
        Subject subject = subjectDao.findById(subjectId)
                .orElseThrow(() -> new ValidationException("Selected subject does not exist"));
        ResourceCategory category = categoryDao.findById(categoryId)
                .orElseThrow(() -> new ValidationException("Selected category does not exist"));

        Resource resource = new Resource();
        resource.setTitle(title.trim());
        resource.setDescription(description);
        resource.setCourse(course);
        resource.setSemester(semester);
        resource.setSubject(subject);
        resource.setCategory(category);
        resource.setResourceType(resourceType);
        resource.setVisibility(visibility != null ? visibility : ResourceVisibility.PUBLIC);
        resource.setDownloadable(isDownloadable);
        resource.setArchived(false);
        resource.setTags(tags);
        resource.setUploadedBy(uploader);

        // Handle external URL vs binary file
        if (resourceType == ResourceType.EXTERNAL_URL) {
            if (!ValidationUtil.isValidUrl(externalUrl)) {
                throw new ValidationException("Please provide a valid HTTP/HTTPS external link URL");
            }
            resource.setExternalUrl(externalUrl.trim());
            resource.setDownloadable(false);
        } else {
            if (fileStream == null || originalFilename == null || originalFilename.isBlank()) {
                throw new ValidationException("Please choose a file to upload for type: " + resourceType.getLabel());
            }
            ResourceFile storedFile = fileStorageService.storeFile(originalFilename, mimeType, size, fileStream);
            resource.addFile(storedFile);
        }

        Resource saved = resourceDao.save(resource);

        auditLogDao.save(new AuditLog(uploader, "RESOURCE_UPLOADED", "Resource", (saved.getId() != null ? saved.getId().toString() : "0"),
                "Uploaded resource: " + saved.getTitle(), null));

        logger.info("Created resource id={} title='{}'", saved.getId(), saved.getTitle());
        return saved;
    }

    /**
     * Retrieves resource by ID, with view tracking.
     */
    public Resource getResourceById(Long id, boolean incrementView) {
        Resource resource = resourceDao.findByIdWithDetails(id)
                .orElseThrow(() -> new ResourceNotFoundException("Resource not found with id: " + id));

        if (incrementView) {
            resourceDao.incrementViewCount(id);
            resource.setViewCount(resource.getViewCount() + 1);
        }
        return resource;
    }

    /**
     * Search resources with multi-field filtering and pagination.
     */
    public List<Resource> searchResources(String keyword, Long courseId, Long semesterId,
                                          Long subjectId, Long categoryId, ResourceType type,
                                          String sortBy, int offset, int limit) {
        return resourceDao.searchResources(keyword, courseId, semesterId, subjectId, categoryId, type, sortBy, offset, limit);
    }

    public long countSearchResources(String keyword, Long courseId, Long semesterId,
                                     Long subjectId, Long categoryId, ResourceType type) {
        return resourceDao.countSearchResources(keyword, courseId, semesterId, subjectId, categoryId, type);
    }

    /**
     * Handles authorized resource download and records download telemetry.
     */
    public File downloadResource(Long resourceId, User currentUser, String ipAddress, String userAgent) {
        Resource resource = getResourceById(resourceId, false);

        if (!resource.isDownloadable()) {
            throw new AuthorizationException("This resource is not permitted for download");
        }
        if (resource.getResourceType() == ResourceType.EXTERNAL_URL) {
            throw new ValidationException("External link resources cannot be downloaded directly");
        }

        ResourceFile primaryFile = resource.getPrimaryFile();
        if (primaryFile == null) {
            throw new ResourceNotFoundException("No physical file associated with this resource");
        }

        File file = fileStorageService.getFile(primaryFile.getStoredFilename());

        // Increment stats and record download log
        resourceDao.incrementDownloadCount(resourceId);
        jdbcReportingDao.recordDownloadLog(
                currentUser != null ? currentUser.getId() : 0L,
                resourceId,
                primaryFile.getId(),
                ipAddress,
                userAgent
        );

        return file;
    }

    /**
     * Edits resource metadata.
     */
    public Resource updateResource(Long id, String title, String description, Long categoryId,
                                   boolean isDownloadable, String tags, User editor) {
        Resource resource = getResourceById(id, false);

        resource.setTitle(title.trim());
        resource.setDescription(description);
        resource.setDownloadable(isDownloadable);
        resource.setTags(tags);
        resource.setUpdatedAt(LocalDateTime.now());

        if (categoryId != null && !categoryId.equals(resource.getCategory().getId())) {
            categoryDao.findById(categoryId).ifPresent(resource::setCategory);
        }

        Resource updated = resourceDao.update(resource);
        auditLogDao.save(new AuditLog(editor, "RESOURCE_UPDATED", "Resource", id.toString(),
                "Updated metadata for: " + updated.getTitle(), null));

        return updated;
    }

    /**
     * Deletes resource and coordinates physical file deletion.
     */
    public void deleteResource(Long id, User deleter) {
        Resource resource = getResourceById(id, false);

        // Delete physical files
        for (ResourceFile rf : resource.getFiles()) {
            fileStorageService.deletePhysicalFile(rf.getStoredFilename());
        }

        resourceDao.delete(resource);

        auditLogDao.save(new AuditLog(deleter, "RESOURCE_DELETED", "Resource", id.toString(),
                "Deleted resource: " + resource.getTitle(), null));
        logger.info("Deleted resource id={}", id);
    }

    public List<Resource> getRecentResources(int limit) {
        return resourceDao.findRecentResources(limit);
    }
}
