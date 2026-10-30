-- ==============================================================================
-- StudyMate Seed Data
-- ==============================================================================

-- 1. Insert Default Roles
INSERT INTO roles (id, name, description) VALUES
(1, 'ROLE_STUDENT', 'Enrolled student with access to academic materials, bookmarks and dashboard'),
(2, 'ROLE_ADMIN', 'Department or academic administrator with authority to manage courses, subjects and resources'),
(3, 'ROLE_SUPER_ADMIN', 'Platform super administrator with system-wide privileges and admin governance')
ON CONFLICT (id) DO NOTHING;

SELECT setval('roles_id_seq', (SELECT MAX(id) FROM roles));

-- 2. Insert Permissions
INSERT INTO permissions (name, description, category) VALUES
('RESOURCE_READ', 'Ability to view and preview educational resources', 'RESOURCE'),
('RESOURCE_DOWNLOAD', 'Ability to download permitted files', 'RESOURCE'),
('RESOURCE_CREATE', 'Ability to upload and publish materials', 'RESOURCE'),
('RESOURCE_EDIT', 'Ability to modify resource metadata and files', 'RESOURCE'),
('RESOURCE_DELETE', 'Ability to delete or archive resources', 'RESOURCE'),
('SUBJECT_MANAGE', 'Ability to create, update and delete academic subjects', 'ACADEMIC'),
('COURSE_MANAGE', 'Ability to manage courses and programs', 'ACADEMIC'),
('STUDENT_MANAGE', 'Ability to view and activate/deactivate student accounts', 'USER'),
('ADMIN_MANAGE', 'Ability to invite, manage and govern administrators', 'ADMIN'),
('AUDIT_LOG_VIEW', 'Ability to review administrative audit logs', 'SYSTEM'),
('ANNOUNCEMENT_CREATE', 'Ability to publish platform and course announcements', 'COMMUNICATION')
ON CONFLICT (name) DO NOTHING;

-- 3. Map Role Permissions
-- Student Permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT 1, p.id FROM permissions p WHERE p.name IN ('RESOURCE_READ', 'RESOURCE_DOWNLOAD')
ON CONFLICT DO NOTHING;

-- Admin Permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT 2, p.id FROM permissions p WHERE p.name IN (
    'RESOURCE_READ', 'RESOURCE_DOWNLOAD', 'RESOURCE_CREATE', 'RESOURCE_EDIT', 'RESOURCE_DELETE',
    'SUBJECT_MANAGE', 'COURSE_MANAGE', 'STUDENT_MANAGE', 'ANNOUNCEMENT_CREATE'
)
ON CONFLICT DO NOTHING;

-- Super Admin Permissions (All permissions)
INSERT INTO role_permissions (role_id, permission_id)
SELECT 3, p.id FROM permissions p
ON CONFLICT DO NOTHING;

-- 4. Insert Resource Categories
INSERT INTO resource_categories (id, name, code, description, icon, display_order) VALUES
(1, 'Lecture Notes', 'notes', 'Comprehensive lecture notes, study guides and revision summaries', 'bi-journal-text', 1),
(2, 'Assignments', 'assignments', 'Coursework assignments, problem sets and project tasks', 'bi-clipboard-check', 2),
(3, 'Practical Files', 'practical-files', 'Lab records, experiment outputs and practical work documentation', 'bi-file-earmark-code', 3),
(4, 'Lab Manuals', 'lab-manuals', 'Official laboratory procedures, safety guidelines and experiments', 'bi-book-half', 4),
(5, 'Presentations', 'presentations', 'PowerPoint slides and visual presentations from professors and peers', 'bi-file-earmark-slides', 5),
(6, 'Previous Year Papers', 'pyq-papers', 'Previous examination questions, mid-terms and model answers', 'bi-file-earmark-break', 6),
(7, 'Reference Books', 'reference-books', 'Standard academic textbooks, syllabus recommendations and digital books', 'bi-book', 7),
(8, 'Diagrams & Cheatsheets', 'diagrams', 'Architectural diagrams, circuit layouts and quick syntax sheets', 'bi-diagram-3', 8),
(9, 'Question Banks', 'question-banks', 'Curated question banks and conceptual review questions', 'bi-question-diamond', 9),
(10, 'External Links', 'external-links', 'Curated links to documentation, interactive sandboxes and video courses', 'bi-link-45deg', 10),
(11, 'Other Resources', 'other-resources', 'Miscellaneous educational tools, datasets and templates', 'bi-folder', 11)
ON CONFLICT (id) DO NOTHING;

SELECT setval('resource_categories_id_seq', (SELECT MAX(id) FROM resource_categories));

-- 5. Insert Courses
INSERT INTO courses (id, code, name, description, total_semesters, is_active) VALUES
(1, 'BTECH_CSE', 'B.Tech in Computer Science & Engineering', 'Undergraduate programme covering algorithms, computing systems, software engineering and modern AI', 8, TRUE),
(2, 'BTECH_IT', 'B.Tech in Information Technology', 'Undergraduate programme emphasizing network infrastructure, cloud engineering and enterprise software', 8, TRUE),
(3, 'MCA', 'Master of Computer Applications', 'Postgraduate programme focused on advanced programming, data engineering and modern software architecture', 4, TRUE)
ON CONFLICT (id) DO NOTHING;

SELECT setval('courses_id_seq', (SELECT MAX(id) FROM courses));

-- 6. Insert Semesters for BTECH_CSE
INSERT INTO semesters (id, course_id, semester_number, name, description) VALUES
(1, 1, 1, 'Semester 1', 'Foundational Mathematics and Programming Fundamentals'),
(2, 1, 2, 'Semester 2', 'Data Structures and Digital Electronics'),
(3, 1, 3, 'Semester 3', 'Object-Oriented Programming and Computer Architecture'),
(4, 1, 4, 'Semester 4', 'Database Management Systems and Operating Systems'),
(5, 1, 5, 'Semester 5', 'Computer Networks, Web Technologies and Software Engineering'),
(6, 1, 6, 'Semester 6', 'Artificial Intelligence, Compiler Design and Cloud Computing'),
(7, 1, 7, 'Semester 7', 'Information Security and Electives'),
(8, 1, 8, 'Semester 8', 'Capstone Project and Industry Internship')
ON CONFLICT (id) DO NOTHING;

SELECT setval('semesters_id_seq', (SELECT MAX(id) FROM semesters));

-- 7. Insert Subjects
INSERT INTO subjects (id, course_id, semester_id, code, name, description, credit_hours, is_active) VALUES
(1, 1, 1, 'CS101', 'C Programming', 'Structured programming, pointers, memory allocation and file handling', 4, TRUE),
(2, 1, 2, 'CS201', 'C++ Programming', 'Object-oriented programming, templates, STL and polymorphism', 4, TRUE),
(3, 1, 3, 'CS301', 'Java Programming', 'Core Java, collections, concurrency, streams and enterprise architectures', 4, TRUE),
(4, 1, 3, 'CS302', 'Python Programming', 'Pythonic paradigms, data structures, scientific libraries and scripting', 3, TRUE),
(5, 1, 4, 'CS401', 'Advanced Database Management Systems', 'Relational theory, query optimization, indexing, ACID transactions and NoSQL', 4, TRUE),
(6, 1, 5, 'CS501', 'Advanced Computer Networking', 'OSI model, TCP/IP stack, routing protocols, socket programming and security', 4, TRUE),
(7, 1, 5, 'CS502', 'Software Engineering', 'SDLC, Agile methodologies, architectural patterns, design principles and testing', 3, TRUE),
(8, 1, 5, 'CS503', 'Web Development', 'HTML5, modern CSS, client-server architectures, RESTful APIs and Jakarta Servlets', 3, TRUE),
(9, 1, 6, 'CS601', 'Artificial Intelligence', 'Heuristic search, machine learning foundations, neural networks and knowledge graphs', 4, TRUE)
ON CONFLICT (id) DO NOTHING;

SELECT setval('subjects_id_seq', (SELECT MAX(id) FROM subjects));

-- 8. Insert Default Users (Password for all: StudyMate@2026)
-- Hash generated with BCrypt 12 rounds: $2a$12$KjYmYc4iC0zHqFjT0y6gG.zUa8m0sD1zQJ6GkY5yF0J9fF7qI1L4S
INSERT INTO users (id, email, password_hash, full_name, roll_number, course_id, semester_id, is_active, is_verified) VALUES
(1, 'superadmin@studymate.edu', '$2a$12$KjYmYc4iC0zHqFjT0y6gG.zUa8m0sD1zQJ6GkY5yF0J9fF7qI1L4S', 'StudyMate Super Admin', 'SA-001', 1, 5, TRUE, TRUE),
(2, 'admin@studymate.edu', '$2a$12$KjYmYc4iC0zHqFjT0y6gG.zUa8m0sD1zQJ6GkY5yF0J9fF7qI1L4S', 'Dr. Sarah Mitchell', 'ADM-102', 1, 5, TRUE, TRUE),
(3, 'student@studymate.edu', '$2a$12$KjYmYc4iC0zHqFjT0y6gG.zUa8m0sD1zQJ6GkY5yF0J9fF7qI1L4S', 'Alex Rivera', 'CSE-2026-042', 1, 5, TRUE, TRUE)
ON CONFLICT (id) DO NOTHING;

SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));

-- 9. Assign Roles
INSERT INTO user_roles (user_id, role_id) VALUES
(1, 3), -- Super Admin
(2, 2), -- Admin
(3, 1)  -- Student
ON CONFLICT DO NOTHING;

-- 10. Insert Sample Announcements
INSERT INTO announcements (title, content, priority, target_audience, course_id, semester_id, is_published, created_by_user_id) VALUES
('Welcome to StudyMate!', 'Welcome to StudyMate - Your centralized academic companion. Explore your semester subjects, download study materials, and access your bookmarks anywhere.', 'HIGH', 'ALL', 1, 5, TRUE, 1),
('Mid-Semester Examination Schedule Released', 'The mid-term examination timetable for Computer Science Semester 5 has been finalized. Please review the question banks and lecture notes in your dashboard.', 'NORMAL', 'STUDENTS', 1, 5, TRUE, 2);

-- 11. Insert Sample Resources
INSERT INTO resources (id, title, description, course_id, semester_id, subject_id, category_id, resource_type, external_url, visibility, is_downloadable, is_archived, view_count, download_count, uploaded_by_user_id, tags) VALUES
(1, 'Java Concurrency & Multithreading Guide', 'Comprehensive guide to the Java Memory Model, synchronization primitives, thread pools, and ExecutorService best practices.', 1, 3, 3, 1, 'PDF', NULL, 'PUBLIC', TRUE, FALSE, 28, 14, 2, 'java,concurrency,threads,backend'),
(2, 'Advanced Database Indexing & Query Tuning', 'Detailed notes on B-Tree vs Hash indexes, explain plans, query cost estimation and PostgreSQL optimization strategies.', 1, 4, 5, 1, 'PDF', NULL, 'PUBLIC', TRUE, FALSE, 45, 23, 2, 'dbms,postgresql,indexing,sql'),
(3, 'Official Java 21 LTS Documentation', 'Official Oracle and OpenJDK technical specification and documentation for Java SE 21 features.', 1, 3, 3, 10, 'EXTERNAL_URL', 'https://docs.oracle.com/en/java/javase/21/', 'PUBLIC', FALSE, FALSE, 52, 0, 2, 'java,reference,docs,official'),
(4, 'Software Architecture & Clean Code Patterns', 'Lecture slides examining MVC, Layered Architectures, Dependency Inversion, and SOLID design principles.', 1, 5, 7, 5, 'DOCUMENT', NULL, 'PUBLIC', TRUE, FALSE, 31, 10, 2, 'software-engineering,architecture,solid')
ON CONFLICT (id) DO NOTHING;

SELECT setval('resources_id_seq', (SELECT MAX(id) FROM resources));

-- 12. Insert Sample Notifications for the student
INSERT INTO notifications (user_id, title, message, type, link_url, is_read) VALUES
(3, 'Welcome to StudyMate', 'Your student account is active. Start exploring your enrolled courses and subjects.', 'SUCCESS', '/student/dashboard', FALSE),
(3, 'New Lecture Notes Published', 'Dr. Sarah Mitchell uploaded "Advanced Database Indexing & Query Tuning" for DBMS.', 'RESOURCE', '/resources/view?id=2', FALSE);
