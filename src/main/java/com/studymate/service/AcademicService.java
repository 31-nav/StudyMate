package com.studymate.service;

import com.studymate.dao.*;
import com.studymate.exception.ResourceNotFoundException;
import com.studymate.exception.ValidationException;
import com.studymate.model.entity.*;

import java.time.LocalDateTime;
import java.util.List;

public class AcademicService {

    private final CourseDao courseDao;
    private final SemesterDao semesterDao;
    private final SubjectDao subjectDao;
    private final ResourceCategoryDao categoryDao;
    private final AuditLogDao auditLogDao;

    public AcademicService() {
        this(new CourseDao(), new SemesterDao(), new SubjectDao(), new ResourceCategoryDao(), new AuditLogDao());
    }

    public AcademicService(CourseDao courseDao, SemesterDao semesterDao,
                           SubjectDao subjectDao, ResourceCategoryDao categoryDao, AuditLogDao auditLogDao) {
        this.courseDao = courseDao;
        this.semesterDao = semesterDao;
        this.subjectDao = subjectDao;
        this.categoryDao = categoryDao;
        this.auditLogDao = auditLogDao;
    }

    // --- Courses ---
    public List<Course> getAllActiveCourses() {
        return courseDao.findAllActive();
    }

    public List<Course> getAllCourses() {
        return courseDao.findAll();
    }

    public Course getCourseById(Long id) {
        return courseDao.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Course not found with id: " + id));
    }

    public Course createCourse(String code, String name, String description, int totalSemesters, User adminUser) {
        if (code == null || code.isBlank() || name == null || name.isBlank()) {
            throw new ValidationException("Course code and name are required");
        }
        if (courseDao.findByCode(code.trim()).isPresent()) {
            throw new ValidationException("Course with code '" + code + "' already exists");
        }

        Course course = new Course(code.trim().toUpperCase(), name.trim(), description, totalSemesters);
        Course saved = courseDao.save(course);

        // Auto-create semester entries for convenience
        for (int i = 1; i <= totalSemesters; i++) {
            Semester sem = new Semester(saved, i, "Semester " + i, "Academic Semester " + i);
            semesterDao.save(sem);
        }

        auditLogDao.save(new AuditLog(adminUser, "COURSE_CREATED", "Course", saved.getId().toString(),
                "Created course: " + saved.getName(), null));

        return saved;
    }

    // --- Semesters ---
    public List<Semester> getSemestersByCourse(Long courseId) {
        return semesterDao.findByCourseId(courseId);
    }

    public Semester getSemesterById(Long id) {
        return semesterDao.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Semester not found with id: " + id));
    }

    // --- Subjects ---
    public List<Subject> getSubjectsByCourseAndSemester(Long courseId, Long semesterId) {
        return subjectDao.findByCourseAndSemester(courseId, semesterId);
    }

    public List<Subject> getSubjectsByCourse(Long courseId) {
        return subjectDao.findByCourse(courseId);
    }

    public Subject getSubjectById(Long id) {
        return subjectDao.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Subject not found with id: " + id));
    }

    public Subject createSubject(Long courseId, Long semesterId, String code, String name,
                                 String description, int creditHours, User adminUser) {
        if (code == null || code.isBlank() || name == null || name.isBlank()) {
            throw new ValidationException("Subject code and name are required");
        }

        Course course = getCourseById(courseId);
        Semester semester = getSemesterById(semesterId);

        Subject subject = new Subject(course, semester, code.trim().toUpperCase(), name.trim(), description, creditHours);
        Subject saved = subjectDao.save(subject);

        auditLogDao.save(new AuditLog(adminUser, "SUBJECT_CREATED", "Subject", saved.getId().toString(),
                "Created subject: " + saved.getName() + " (" + saved.getCode() + ")", null));

        return saved;
    }

    public Subject updateSubject(Long id, String name, String description, int creditHours, boolean active, User adminUser) {
        Subject subject = getSubjectById(id);
        subject.setName(name.trim());
        subject.setDescription(description);
        subject.setCreditHours(creditHours);
        subject.setActive(active);
        subject.setUpdatedAt(LocalDateTime.now());

        Subject updated = subjectDao.update(subject);

        auditLogDao.save(new AuditLog(adminUser, "SUBJECT_UPDATED", "Subject", updated.getId().toString(),
                "Updated subject: " + updated.getName(), null));

        return updated;
    }

    public void deleteSubject(Long id, User adminUser) {
        Subject subject = getSubjectById(id);
        subjectDao.delete(subject);

        auditLogDao.save(new AuditLog(adminUser, "SUBJECT_DELETED", "Subject", id.toString(),
                "Deleted subject: " + subject.getName(), null));
    }

    public List<Subject> searchSubjects(String query, Long courseId, Long semesterId, int offset, int limit) {
        return subjectDao.searchSubjects(query, courseId, semesterId, offset, limit);
    }

    public long countSubjects(String query, Long courseId, Long semesterId) {
        return subjectDao.countSubjects(query, courseId, semesterId);
    }

    // --- Categories ---
    public List<ResourceCategory> getAllCategories() {
        return categoryDao.findAllOrdered();
    }

    public ResourceCategory getCategoryById(Long id) {
        return categoryDao.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Category not found with id: " + id));
    }
}

