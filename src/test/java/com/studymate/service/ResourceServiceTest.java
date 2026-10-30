package com.studymate.service;

import com.studymate.dao.*;
import com.studymate.exception.ResourceNotFoundException;
import com.studymate.exception.ValidationException;
import com.studymate.model.entity.*;
import com.studymate.model.enums.ResourceType;
import com.studymate.model.enums.ResourceVisibility;
import com.studymate.storage.FileStorageService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.api.io.TempDir;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.nio.file.Path;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
@DisplayName("Academic Resource Service Test")
class ResourceServiceTest {

    @Mock private ResourceDao resourceDao;
    @Mock private CourseDao courseDao;
    @Mock private SemesterDao semesterDao;
    @Mock private SubjectDao subjectDao;
    @Mock private ResourceCategoryDao categoryDao;
    @Mock private JdbcReportingDao jdbcReportingDao;
    @Mock private AuditLogDao auditLogDao;

    @TempDir
    Path tempStorageDir;

    private FileStorageService fileStorageService;
    private ResourceService resourceService;

    @BeforeEach
    void setUp() {
        fileStorageService = new FileStorageService(tempStorageDir);
        resourceService = new ResourceService(resourceDao, courseDao, semesterDao, subjectDao,
                categoryDao, fileStorageService, jdbcReportingDao, auditLogDao);
    }

    @Test
    @DisplayName("Creating resource fails when title is missing")
    void testCreateResourceMissingTitle() {
        User admin = new User("admin@studymate.edu", "hash", "Admin User");
        ValidationException ex = assertThrows(ValidationException.class, () ->
                resourceService.createResource(
                        "", "Desc", 1L, 1L, 1L, 1L,
                        ResourceType.PDF, null, ResourceVisibility.PUBLIC, true,
                        "tags", admin, "file.pdf", "application/pdf", 1024, null
                ));
        assertTrue(ex.getMessage().toLowerCase().contains("title is required"));
    }

    @Test
    @DisplayName("Creating external resource requires valid URL")
    void testCreateResourceExternalUrlRequired() {
        User admin = new User("admin@studymate.edu", "hash", "Admin User");

        when(courseDao.findById(1L)).thenReturn(Optional.of(new Course("CS", "Computer Science", "Desc", 8)));
        when(semesterDao.findById(1L)).thenReturn(Optional.of(new Semester(1)));
        when(subjectDao.findById(1L)).thenReturn(Optional.of(new Subject("CS101", "Intro to CS", 4)));
        when(categoryDao.findById(1L)).thenReturn(Optional.of(new ResourceCategory("Notes", "Desc")));

        ValidationException ex = assertThrows(ValidationException.class, () ->
                resourceService.createResource(
                        "Sample Web Link", "Desc", 1L, 1L, 1L, 1L,
                        ResourceType.EXTERNAL_URL, null, ResourceVisibility.PUBLIC, false,
                        "tags", admin, null, null, 0, null
                ));
        assertTrue(ex.getMessage().toLowerCase().contains("external link url"));
    }

    @Test
    @DisplayName("Creating PDF resource successfully stores file and generates ResourceFile entity")
    void testCreatePdfResourceSuccess() {
        User admin = new User("admin@studymate.edu", "hash", "Admin User");
        Course course = new Course("CS", "Computer Science", "Desc", 8);
        Semester sem = new Semester(1);
        Subject subject = new Subject("CS101", "Intro to CS", 4);
        ResourceCategory category = new ResourceCategory("Notes", "Desc");

        when(courseDao.findById(1L)).thenReturn(Optional.of(course));
        when(semesterDao.findById(1L)).thenReturn(Optional.of(sem));
        when(subjectDao.findById(1L)).thenReturn(Optional.of(subject));
        when(categoryDao.findById(1L)).thenReturn(Optional.of(category));

        when(resourceDao.save(any(Resource.class))).thenAnswer(invocation -> {
            Resource r = invocation.getArgument(0);
            r.setId(555L);
            return r;
        });

        byte[] fakePdfBytes = "%PDF-1.4 test binary content".getBytes();
        InputStream stream = new ByteArrayInputStream(fakePdfBytes);

        Resource saved = resourceService.createResource(
                "Lecture 01 Notes", "Introductory notes", 1L, 1L, 1L, 1L,
                ResourceType.PDF, null, ResourceVisibility.PUBLIC, true,
                "intro, cs101", admin, "lecture1.pdf", "application/pdf", fakePdfBytes.length, stream
        );

        assertNotNull(saved);
        assertEquals("Lecture 01 Notes", saved.getTitle());
        assertNotNull(saved.getPrimaryFile());
        assertEquals("lecture1.pdf", saved.getPrimaryFile().getOriginalFilename());
        assertTrue(saved.getPrimaryFile().getStoredFilename().endsWith(".pdf"));
        verify(resourceDao, times(1)).save(any(Resource.class));
        verify(auditLogDao, times(1)).save(any(AuditLog.class));
    }

    @Test
    @DisplayName("File storage blocks path traversal attempts in uploaded filenames")
    void testFileStoragePathTraversalPrevention() {
        byte[] fakePdfBytes = "%PDF-1.4 sample".getBytes();
        InputStream stream = new ByteArrayInputStream(fakePdfBytes);

        // Path traversal payload
        String maliciousFilename = "../../etc/passwd.pdf";
        ResourceFile file = fileStorageService.storeFile(maliciousFilename, "application/pdf", fakePdfBytes.length, stream);

        assertNotNull(file);
        // Stored filename must be a clean UUID and stay inside tempStorageDir
        assertFalse(file.getStoredFilename().contains(".."));
        assertTrue(file.getFilePath().startsWith(tempStorageDir.toString()));
    }

    @Test
    @DisplayName("Get resource by id throws ResourceNotFoundException when non-existent")
    void testGetResourceNotFound() {
        when(resourceDao.findById(9999L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class, () -> resourceService.getResourceById(9999L, false));
    }
}
