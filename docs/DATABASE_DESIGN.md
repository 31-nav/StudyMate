# Database Design & Schema Specification: StudyMate

## 1. Database Architecture & Design Principles

The StudyMate persistence layer is hosted on **PostgreSQL 16.6**. The schema is strictly normalized to Third Normal Form (3NF) to eliminate data redundancy while maintaining high relational integrity.

Key Design Tenets:
- **Relational Integrity**: Foreign key constraints with explicit `ON DELETE CASCADE` or `ON DELETE SET NULL` semantics.
- **Surrogate Primary Keys**: All relational tables utilize `BIGSERIAL` (64-bit integer auto-increment) primary keys.
- **Optimized Indexing**: B-Tree indexes placed on all foreign keys, lookup tokens, and frequently filtered columns (`email`, `token_hash`, `course_id`, `subject_id`).
- **Auditability**: Timestamp columns (`created_at`, `updated_at`) enforced across all major transactional tables.

---

## 2. Table Specifications (20 Tables)

### 2.1 Identity & Access Control

#### `roles`
Stores core application roles.
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Unique role identifier |
| `name` | VARCHAR(50) | NOT NULL, UNIQUE | Role name (`ROLE_STUDENT`, `ROLE_ADMIN`, `ROLE_SUPER_ADMIN`) |
| `description` | VARCHAR(255) | NULL | Descriptive explanation |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT NOW() | Record creation timestamp |

#### `users`
Primary user table for all user types.
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Unique user ID |
| `email` | VARCHAR(255) | NOT NULL, UNIQUE | User login email (case-insensitive indexing) |
| `password_hash` | VARCHAR(255) | NOT NULL | BCrypt hashed password (cost factor 12) |
| `full_name` | VARCHAR(150) | NOT NULL | User's full display name |
| `roll_number` | VARCHAR(50) | NULL | Student university identifier |
| `course_id` | BIGINT | FK -> `courses(id)` ON DELETE SET NULL | Associated course program |
| `semester_id` | BIGINT | FK -> `semesters(id)` ON DELETE SET NULL | Associated active semester |
| `is_active` | BOOLEAN | NOT NULL, DEFAULT TRUE | Account active/suspended flag |
| `is_verified` | BOOLEAN | NOT NULL, DEFAULT FALSE | Email verification status |
| `last_login_at` | TIMESTAMP | NULL | Timestamp of most recent login |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT NOW() | Account registration timestamp |
| `updated_at` | TIMESTAMP | NOT NULL, DEFAULT NOW() | Last update timestamp |

#### `user_roles`
Junction table implementing many-to-many relationship between users and roles.
| Column | Type | Constraints | Description |
|---|---|---|---|
| `user_id` | BIGINT | PK, FK -> `users(id)` ON DELETE CASCADE | Target user |
| `role_id` | BIGINT | PK, FK -> `roles(id)` ON DELETE CASCADE | Assigned role |

#### `verification_tokens`
Stores SHA-256 hashed email verification tokens.
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Token record ID |
| `user_id` | BIGINT | NOT NULL, FK -> `users(id)` ON DELETE CASCADE | Associated user |
| `token_hash` | VARCHAR(64) | NOT NULL, UNIQUE | SHA-256 hash of random token |
| `expires_at` | TIMESTAMP | NOT NULL | Expiration timestamp (24h) |
| `is_used` | BOOLEAN | NOT NULL, DEFAULT FALSE | Single-use flag |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT NOW() | Issuance timestamp |

#### `password_resets`
Stores SHA-256 hashed password reset tokens.
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Reset token record ID |
| `user_id` | BIGINT | NOT NULL, FK -> `users(id)` ON DELETE CASCADE | Associated user |
| `token_hash` | VARCHAR(64) | NOT NULL, UNIQUE | SHA-256 hash of reset token |
| `expires_at` | TIMESTAMP | NOT NULL | Expiration timestamp (1h) |
| `is_used` | BOOLEAN | NOT NULL, DEFAULT FALSE | Single-use flag |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT NOW() | Issuance timestamp |

---

### 2.2 Academic Structure

#### `courses`
Represents academic degrees or programs (e.g., Computer Science, Mechanical Engineering).
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Course identifier |
| `name` | VARCHAR(150) | NOT NULL | Full course title |
| `code` | VARCHAR(50) | NOT NULL, UNIQUE | Unique course code (e.g., `CS-BS`) |
| `description` | TEXT | NULL | Course curriculum overview |
| `is_active` | BOOLEAN | NOT NULL, DEFAULT TRUE | Status flag |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT NOW() | Creation timestamp |

#### `semesters`
Academic terms belonging to a course.
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Semester identifier |
| `name` | VARCHAR(100) | NOT NULL | Semester name (e.g., Semester 1) |
| `semester_number` | INT | NOT NULL | Numeric semester sequence (1-10) |
| `course_id` | BIGINT | NOT NULL, FK -> `courses(id)` ON DELETE CASCADE | Parent course |
| `is_active` | BOOLEAN | NOT NULL, DEFAULT TRUE | Status flag |

#### `subjects`
Curricular subjects taught within a course and semester.
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Subject identifier |
| `name` | VARCHAR(150) | NOT NULL | Subject title |
| `code` | VARCHAR(50) | NOT NULL, UNIQUE | Unique subject code (e.g., `CS201`) |
| `course_id` | BIGINT | NOT NULL, FK -> `courses(id)` ON DELETE CASCADE | Parent course |
| `semester_id` | BIGINT | NOT NULL, FK -> `semesters(id)` ON DELETE CASCADE | Parent semester |
| `is_active` | BOOLEAN | NOT NULL, DEFAULT TRUE | Active flag |

---

### 2.3 Educational Resources

#### `resource_categories`
Classification for learning assets (Notes, Slides, Past Papers, Lab Manuals, Reference Guides).
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Category ID |
| `name` | VARCHAR(100) | NOT NULL, UNIQUE | Display name |
| `slug` | VARCHAR(100) | NOT NULL, UNIQUE | URL-safe slug |
| `description` | TEXT | NULL | Category description |
| `icon_class` | VARCHAR(50) | NOT NULL, DEFAULT 'bi-folder' | Bootstrap icon class |

#### `resources`
Central metadata entity for learning materials.
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Resource ID |
| `title` | VARCHAR(255) | NOT NULL | Resource title |
| `description` | TEXT | NULL | Detailed resource summary |
| `resource_type` | VARCHAR(50) | NOT NULL | `DOCUMENT`, `IMAGE`, `LINK` |
| `subject_id` | BIGINT | NOT NULL, FK -> `subjects(id)` ON DELETE CASCADE | Parent subject |
| `category_id` | BIGINT | NOT NULL, FK -> `resource_categories(id)` | Parent category |
| `uploader_id` | BIGINT | NOT NULL, FK -> `users(id)` | Author/uploader ID |
| `external_url` | VARCHAR(500) | NULL | URL if type is `LINK` |
| `is_downloadable` | BOOLEAN | NOT NULL, DEFAULT TRUE | Allow direct file download |
| `is_published` | BOOLEAN | NOT NULL, DEFAULT TRUE | Publish status |
| `view_count` | BIGINT | NOT NULL, DEFAULT 0 | Cumulative views |
| `download_count` | BIGINT | NOT NULL, DEFAULT 0 | Cumulative downloads |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT NOW() | Upload timestamp |

#### `resource_files`
Physical file metadata linked to a resource.
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | File record ID |
| `resource_id` | BIGINT | NOT NULL, FK -> `resources(id)` ON DELETE CASCADE | Associated resource |
| `file_name` | VARCHAR(255) | NOT NULL | Original uploaded filename |
| `file_path` | VARCHAR(500) | NOT NULL | Storage path / UUID key |
| `file_size` | BIGINT | NOT NULL | File size in bytes |
| `mime_type` | VARCHAR(100) | NOT NULL | Verified MIME type |
| `storage_type` | VARCHAR(50) | NOT NULL, DEFAULT 'LOCAL' | Storage provider |

---

### 2.4 Personalization & Engagement

#### `user_bookmarks`
Stores student saved resources.
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Bookmark ID |
| `user_id` | BIGINT | NOT NULL, FK -> `users(id)` ON DELETE CASCADE | Student user |
| `resource_id` | BIGINT | NOT NULL, FK -> `resources(id)` ON DELETE CASCADE | Saved resource |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT NOW() | Bookmark timestamp |

#### `user_recent_views`
Maintains a log of recently opened resources per student.
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Record ID |
| `user_id` | BIGINT | NOT NULL, FK -> `users(id)` ON DELETE CASCADE | Student user |
| `resource_id` | BIGINT | NOT NULL, FK -> `resources(id)` ON DELETE CASCADE | Accessed resource |
| `viewed_at` | TIMESTAMP | NOT NULL, DEFAULT NOW() | Access timestamp |

#### `announcements`
Institutional broadcast notices.
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Announcement ID |
| `title` | VARCHAR(255) | NOT NULL | Headline |
| `content` | TEXT | NOT NULL | Notice body |
| `author_id` | BIGINT | NOT NULL, FK -> `users(id)` | Authoring Admin |
| `target_course_id` | BIGINT | NULL, FK -> `courses(id)` ON DELETE SET NULL | Target course or NULL (all) |
| `priority` | VARCHAR(50) | NOT NULL, DEFAULT 'NORMAL' | `LOW`, `NORMAL`, `HIGH`, `URGENT` |
| `is_published` | BOOLEAN | NOT NULL, DEFAULT TRUE | Visibility flag |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT NOW() | Published timestamp |

#### `notifications`
In-app user notifications.
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Notification ID |
| `user_id` | BIGINT | NOT NULL, FK -> `users(id)` ON DELETE CASCADE | Recipient student |
| `title` | VARCHAR(255) | NOT NULL | Brief summary |
| `message` | TEXT | NOT NULL | Notification body |
| `notification_type` | VARCHAR(50) | NOT NULL, DEFAULT 'GENERAL' | Type indicator |
| `link_url` | VARCHAR(255) | NULL | Action link |
| `is_read` | BOOLEAN | NOT NULL, DEFAULT FALSE | Read state |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT NOW() | Creation timestamp |

---

### 2.5 Governance & System

#### `audit_logs`
Security and administrative audit trail.
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Log entry ID |
| `user_id` | BIGINT | NULL, FK -> `users(id)` ON DELETE SET NULL | Actor user |
| `action` | VARCHAR(100) | NOT NULL | Action code (e.g. `LOGIN_SUCCESS`) |
| `entity_name` | VARCHAR(100) | NOT NULL | Target entity (e.g. `User`, `Resource`) |
| `entity_id` | VARCHAR(100) | NULL | Affected record ID |
| `ip_address` | VARCHAR(50) | NULL | Client IP |
| `user_agent` | VARCHAR(255) | NULL | Browser User-Agent header |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT NOW() | Log timestamp |

#### `system_settings`
Dynamic platform configuration settings.
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Setting ID |
| `key` | VARCHAR(100) | NOT NULL, UNIQUE | Configuration key |
| `value` | TEXT | NOT NULL | Configuration value |
| `category` | VARCHAR(50) | NOT NULL, DEFAULT 'GENERAL' | Settings group |
| `description` | VARCHAR(255) | NULL | Setting description |

#### `tags` & `resource_tags`
Taxonomy tags for flexible keyword indexing.
| Table | Key Columns | Description |
|---|---|---|
| `tags` | `id`, `name` (UNIQUE), `slug` | Keyword registry |
| `resource_tags` | `resource_id` (FK), `tag_id` (FK) | Many-to-many tag attachment |

#### `user_preferences`
User personalization attributes (theme preference, email notification toggle).
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PRIMARY KEY | Preference record ID |
| `user_id` | BIGINT | NOT NULL, UNIQUE, FK -> `users(id)` | Target user |
| `theme` | VARCHAR(20) | NOT NULL, DEFAULT 'dark' | UI theme preference |
| `email_notifications` | BOOLEAN | NOT NULL, DEFAULT TRUE | Email notification toggle |

