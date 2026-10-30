package com.studymate.service;

import com.studymate.dao.*;
import com.studymate.exception.ValidationException;
import com.studymate.model.entity.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Academic Curriculum Service Test")
class AcademicServiceTest {

    @Mock private CourseDao courseDao;
    @Mock private SemesterDao semesterDao;
    @Mock private SubjectDao subjectDao;
    @Mock private ResourceCategoryDao categoryDao;
    @Mock private AuditLogDao auditLogDao;

    private AcademicService academicService;

    @BeforeEach
    void setUp() {
        academicService = new AcademicService(courseDao, semesterDao, subjectDao, categoryDao, auditLogDao);
    }

    @Test
    @DisplayName("Create course succeeds and saves course and audit log")
    void testCreateCourseSuccess() {
        User admin = new User("admin@studymate.edu", "hash", "Admin User");
        when(courseDao.findByCode("BTECH-CS")).thenReturn(Optional.empty());

        when(courseDao.save(any(Course.class))).thenAnswer(invocation -> {
            Course c = invocation.getArgument(0);
            c.setId(10L);
            return c;
        });

        Course course = academicService.createCourse("BTECH-CS", "B.Tech Computer Science", "Engineering course", 8, admin);

        assertNotNull(course);
        assertEquals("BTECH-CS", course.getCourseCode());
        assertEquals("B.Tech Computer Science", course.getCourseName());
        verify(courseDao, times(1)).save(any(Course.class));
        verify(auditLogDao, times(1)).save(any(AuditLog.class));
    }

    @Test
    @DisplayName("Create course rejects blank course code")
    void testCreateCourseBlankCode() {
        User admin = new User("admin@studymate.edu", "hash", "Admin User");

        ValidationException ex = assertThrows(ValidationException.class, () ->
                academicService.createCourse("", "Name", "Desc", 8, admin));
        assertTrue(ex.getMessage().contains("Course code and name are required"));
    }

    @Test
    @DisplayName("Create course rejects duplicate course code")
    void testCreateCourseDuplicateCode() {
        User admin = new User("admin@studymate.edu", "hash", "Admin User");
        when(courseDao.findByCode("BTECH-CS")).thenReturn(Optional.of(new Course("BTECH-CS", "Existing", "Desc", 8)));

        ValidationException ex = assertThrows(ValidationException.class, () ->
                academicService.createCourse("BTECH-CS", "New Name", "Desc", 8, admin));
        assertTrue(ex.getMessage().contains("already exists"));
    }
}

