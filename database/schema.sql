-- ==============================================================================
-- StudyMate Database Schema (PostgreSQL)
-- "Your Learning. Your Space."
-- ==============================================================================

-- Drop tables in reverse order of foreign key dependencies if recreating
DROP TABLE IF EXISTS administrator_invitations CASCADE;
DROP TABLE IF EXISTS email_verification_tokens CASCADE;
DROP TABLE IF EXISTS password_reset_tokens CASCADE;
DROP TABLE IF EXISTS audit_logs CASCADE;
DROP TABLE IF EXISTS download_logs CASCADE;
DROP TABLE IF EXISTS notifications CASCADE;
DROP TABLE IF EXISTS announcements CASCADE;
DROP TABLE IF EXISTS recently_viewed CASCADE;
DROP TABLE IF EXISTS bookmarks CASCADE;
DROP TABLE IF EXISTS resource_files CASCADE;
DROP TABLE IF EXISTS resources CASCADE;
DROP TABLE IF EXISTS resource_categories CASCADE;
DROP TABLE IF EXISTS subjects CASCADE;
DROP TABLE IF EXISTS semesters CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS user_roles CASCADE;
DROP TABLE IF EXISTS role_permissions CASCADE;
DROP TABLE IF EXISTS permissions CASCADE;
DROP TABLE IF EXISTS roles CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- 1. Roles Table
CREATE TABLE roles (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- 2. Permissions Table
CREATE TABLE permissions (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    category VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- 3. Role Permissions Join Table
CREATE TABLE role_permissions (
    role_id BIGINT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id BIGINT NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);

-- 4. Courses Table
CREATE TABLE courses (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    total_semesters INT DEFAULT 8 NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- 5. Semesters Table
CREATE TABLE semesters (
    id BIGSERIAL PRIMARY KEY,
    course_id BIGINT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    semester_number INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT uq_course_semester UNIQUE (course_id, semester_number)
);

-- 6. Users Table
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    roll_number VARCHAR(100),
    course_id BIGINT REFERENCES courses(id) ON DELETE SET NULL,
    semester_id BIGINT REFERENCES semesters(id) ON DELETE SET NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE NOT NULL,
    avatar_url VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_login_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_roll ON users(roll_number);

-- 7. User Roles Join Table
CREATE TABLE user_roles (
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id BIGINT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (user_id, role_id)
);

-- 8. Subjects Table
CREATE TABLE subjects (
    id BIGSERIAL PRIMARY KEY,
    course_id BIGINT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    semester_id BIGINT NOT NULL REFERENCES semesters(id) ON DELETE CASCADE,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    credit_hours INT DEFAULT 3 NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT uq_course_semester_subject_code UNIQUE (course_id, semester_id, code)
);

CREATE INDEX idx_subjects_course ON subjects(course_id);
CREATE INDEX idx_subjects_semester ON subjects(semester_id);

-- 9. Resource Categories Table
CREATE TABLE resource_categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    icon VARCHAR(100) DEFAULT 'bi-folder',
    display_order INT DEFAULT 0 NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- 10. Resources Table
CREATE TABLE resources (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    course_id BIGINT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    semester_id BIGINT NOT NULL REFERENCES semesters(id) ON DELETE CASCADE,
    subject_id BIGINT NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
    category_id BIGINT NOT NULL REFERENCES resource_categories(id) ON DELETE RESTRICT,
    resource_type VARCHAR(50) NOT NULL, -- PDF, IMAGE, DOCUMENT, PRESENTATION, TEXT, EXTERNAL_URL
    external_url VARCHAR(1000),
    visibility VARCHAR(20) DEFAULT 'PUBLIC' NOT NULL, -- PUBLIC, RESTRICTED, PRIVATE
    is_downloadable BOOLEAN DEFAULT TRUE NOT NULL,
    is_archived BOOLEAN DEFAULT FALSE NOT NULL,
    view_count BIGINT DEFAULT 0 NOT NULL,
    download_count BIGINT DEFAULT 0 NOT NULL,
    uploaded_by_user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    tags VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_resources_subject ON resources(subject_id);
CREATE INDEX idx_resources_category ON resources(category_id);
CREATE INDEX idx_resources_title ON resources(title);
CREATE INDEX idx_resources_type ON resources(resource_type);
CREATE INDEX idx_resources_created ON resources(created_at DESC);

-- 11. Resource Files Table (Files stored outside DB, metadata stored here)
CREATE TABLE resource_files (
    id BIGSERIAL PRIMARY KEY,
    resource_id BIGINT NOT NULL REFERENCES resources(id) ON DELETE CASCADE,
    original_filename VARCHAR(255) NOT NULL,
    stored_filename VARCHAR(255) NOT NULL UNIQUE,
    file_path VARCHAR(1000) NOT NULL,
    file_extension VARCHAR(20) NOT NULL,
    mime_type VARCHAR(150) NOT NULL,
    file_size BIGINT NOT NULL,
    storage_hash VARCHAR(64),
    is_primary BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_resource_files_resource ON resource_files(resource_id);

-- 12. Bookmarks Table
CREATE TABLE bookmarks (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    resource_id BIGINT NOT NULL REFERENCES resources(id) ON DELETE CASCADE,
    note VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT uq_user_resource_bookmark UNIQUE (user_id, resource_id)
);

CREATE INDEX idx_bookmarks_user ON bookmarks(user_id);

-- 13. Recently Viewed Table
CREATE TABLE recently_viewed (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    resource_id BIGINT NOT NULL REFERENCES resources(id) ON DELETE CASCADE,
    viewed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    access_count INT DEFAULT 1 NOT NULL,
    CONSTRAINT uq_user_resource_recently_viewed UNIQUE (user_id, resource_id)
);

CREATE INDEX idx_recently_viewed_user ON recently_viewed(user_id, viewed_at DESC);

-- 14. Announcements Table
CREATE TABLE announcements (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'NORMAL' NOT NULL, -- LOW, NORMAL, HIGH, URGENT
    target_audience VARCHAR(50) DEFAULT 'ALL' NOT NULL, -- ALL, STUDENTS, ADMINS, COURSE
    course_id BIGINT REFERENCES courses(id) ON DELETE CASCADE,
    semester_id BIGINT REFERENCES semesters(id) ON DELETE CASCADE,
    is_published BOOLEAN DEFAULT TRUE NOT NULL,
    published_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE,
    created_by_user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_announcements_published ON announcements(is_published, published_at DESC);

-- 15. Notifications Table
CREATE TABLE notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'INFO' NOT NULL, -- INFO, SUCCESS, WARNING, ALERT, RESOURCE, ANNOUNCEMENT
    link_url VARCHAR(500),
    is_read BOOLEAN DEFAULT FALSE NOT NULL,
    read_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_notifications_user_unread ON notifications(user_id, is_read, created_at DESC);

-- 16. Download Logs Table
CREATE TABLE download_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    resource_id BIGINT NOT NULL REFERENCES resources(id) ON DELETE CASCADE,
    file_id BIGINT REFERENCES resource_files(id) ON DELETE SET NULL,
    ip_address VARCHAR(45),
    user_agent VARCHAR(500),
    downloaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_download_logs_resource ON download_logs(resource_id);
CREATE INDEX idx_download_logs_user ON download_logs(user_id);

-- 17. Audit Logs Table
CREATE TABLE audit_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id VARCHAR(100),
    details TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_created ON audit_logs(created_at DESC);

-- 18. Password Reset Tokens Table
CREATE TABLE password_reset_tokens (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL UNIQUE,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    is_used BOOLEAN DEFAULT FALSE NOT NULL,
    used_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_pwd_tokens_hash ON password_reset_tokens(token_hash);

-- 19. Email Verification Tokens Table
CREATE TABLE email_verification_tokens (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL UNIQUE,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    is_used BOOLEAN DEFAULT FALSE NOT NULL,
    used_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_email_tokens_hash ON email_verification_tokens(token_hash);

-- 20. Administrator Invitations Table
CREATE TABLE administrator_invitations (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    token_hash VARCHAR(255) NOT NULL UNIQUE,
    assigned_role VARCHAR(50) DEFAULT 'ADMIN' NOT NULL,
    invited_by_user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    is_accepted BOOLEAN DEFAULT FALSE NOT NULL,
    accepted_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_admin_invites_hash ON administrator_invitations(token_hash);

