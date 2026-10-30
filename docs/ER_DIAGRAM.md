# Entity-Relationship (ER) Diagram: StudyMate

## 1. Visual Entity-Relationship Model

The following diagram illustrates the relational structure, primary keys, foreign keys, and cardinalities across the StudyMate persistence model.

```mermaid
erDiagram
    ROLES ||--o{ USER_ROLES : "assigned to"
    USERS ||--o{ USER_ROLES : "holds"
    USERS ||--o{ VERIFICATION_TOKENS : "has"
    USERS ||--o{ PASSWORD_RESETS : "requests"
    USERS ||--o{ USER_RECENT_VIEWS : "tracks"
    USERS ||--o{ USER_BOOKMARKS : "saves"
    USERS ||--o{ NOTIFICATIONS : "receives"
    USERS ||--o{ AUDIT_LOGS : "triggers"
    USERS ||--o{ RESOURCES : "uploads"
    USERS ||--o{ ANNOUNCEMENTS : "publishes"

    COURSES ||--o{ SEMESTERS : "contains"
    COURSES ||--o{ SUBJECTS : "belongs to"
    SEMESTERS ||--o{ SUBJECTS : "schedules"
    COURSES ||--o{ ANNOUNCEMENTS : "targets"

    SUBJECTS ||--o{ RESOURCES : "categorized in"
    RESOURCE_CATEGORIES ||--o{ RESOURCES : "classifies"
    RESOURCES ||--o{ RESOURCE_FILES : "stores"
    RESOURCES ||--o{ USER_BOOKMARKS : "referenced in"
    RESOURCES ||--o{ USER_RECENT_VIEWS : "tracked in"

    USERS {
        bigint id PK
        varchar email UK
        varchar password_hash
        varchar full_name
        varchar roll_number
        bigint course_id FK
        bigint semester_id FK
        boolean is_active
        boolean is_verified
    }

    ROLES {
        bigint id PK
        varchar name UK
        varchar description
    }

    COURSES {
        bigint id PK
        varchar name
        varchar code UK
        boolean is_active
    }

    SEMESTERS {
        bigint id PK
        varchar name
        integer semester_number
        bigint course_id FK
    }

    SUBJECTS {
        bigint id PK
        varchar name
        varchar code UK
        bigint course_id FK
        bigint semester_id FK
    }

    RESOURCE_CATEGORIES {
        bigint id PK
        varchar name UK
        varchar slug UK
    }

    RESOURCES {
        bigint id PK
        varchar title
        varchar resource_type
        bigint subject_id FK
        bigint category_id FK
        bigint uploader_id FK
        boolean is_downloadable
        boolean is_published
    }

    RESOURCE_FILES {
        bigint id PK
        bigint resource_id FK
        varchar file_name
        varchar file_path
        bigint file_size
        varchar mime_type
    }

    USER_BOOKMARKS {
        bigint id PK
        bigint user_id FK
        bigint resource_id FK
    }

    USER_RECENT_VIEWS {
        bigint id PK
        bigint user_id FK
        bigint resource_id FK
        timestamp viewed_at
    }

    ANNOUNCEMENTS {
        bigint id PK
        varchar title
        bigint author_id FK
        bigint target_course_id FK
        varchar priority
    }

    NOTIFICATIONS {
        bigint id PK
        bigint user_id FK
        varchar title
        boolean is_read
    }

    AUDIT_LOGS {
        bigint id PK
        bigint user_id FK
        varchar action
        varchar entity_name
        timestamp created_at
    }
```

---

## 2. Cardinality & Relational Semantics

### Many-to-Many Relationships
1. **Users and Roles (`users` ↔ `roles`)**:
   - Resolved via the junction table `user_roles(user_id, role_id)`.
   - A user may possess multiple roles (e.g., an Administrator who is also enrolled as a Student).
   - Deletion of a user or role cascades cleanly through `user_roles`.

2. **Resources and Tags (`resources` ↔ `tags`)**:
   - Resolved via `resource_tags(resource_id, tag_id)`.
   - Allows multi-dimensional tagging and discovery across departmental boundaries.

### One-to-Many Hierarchies
1. **Academic Hierarchy (`courses` → `semesters` → `subjects`)**:
   - Each course contains multiple semesters (typically 6-8).
   - Each semester and course pair hosts multiple subjects.
   - Deleting a course cascades to its semesters and associated subjects.

2. **Resource Ingestion (`subjects` / `resource_categories` → `resources` → `resource_files`)**:
   - Each subject and category classifies multiple resources.
   - Each resource has one or more binary files (`resource_files`).

3. **Student Activity Logs (`users` → `user_bookmarks`, `user_recent_views`)**:
   - Personalization data is isolated per student.
   - If a resource is deleted, bookmarks and recent views pointing to it are cascaded automatically.

