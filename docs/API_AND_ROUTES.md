# API & URL Routing Reference: StudyMate

## 1. Route Architecture Overview

StudyMate routes are structured cleanly into four distinct zones:
- **Public Zone**: Open to anonymous visitors (Landing, Catalog, Public Course lists).
- **Authentication Zone (`/auth/*`)**: Registration, verification, login, and password recovery.
- **Student Workspace (`/student/*`)**: Protected by `AuthenticationFilter` and `ROLE_STUDENT`.
- **Administrative Portal (`/admin/*`)**: Protected by `AuthorizationFilter` and `ROLE_ADMIN`.
- **SuperAdmin Control Plane (`/superadmin/*`)**: Protected by `AuthorizationFilter` and `ROLE_SUPER_ADMIN`.

---

## 2. Public & Authentication Endpoints

| URL Pattern | HTTP Method | Required Role | CSRF Protected | Output Type | Description |
|---|---|---|---|---|---|
| `/` or `/home` | `GET` | Anonymous | No | HTML | Public landing page with dynamic statistics |
| `/courses` | `GET` | Anonymous | No | HTML | Public course and degree catalog |
| `/subjects` | `GET` | Anonymous | No | HTML | Public subject browsing |
| `/auth/login` | `GET` | Anonymous | No | HTML | Renders login page |
| `/auth/login` | `POST` | Anonymous | Yes | 302 Redirect | Authenticates credentials and starts session |
| `/auth/register` | `GET` | Anonymous | No | HTML | Renders student registration form |
| `/auth/register` | `POST` | Anonymous | Yes | 302 Redirect | Registers student and dispatches verification |
| `/auth/verify-email` | `GET` | Anonymous | No | HTML / 302 | Verifies email token |
| `/auth/forgot-password` | `GET` | Anonymous | No | HTML | Renders password reset request form |
| `/auth/forgot-password` | `POST` | Anonymous | Yes | 302 Redirect | Dispatches password reset token link |
| `/auth/reset-password` | `GET` | Anonymous | No | HTML | Renders password reset execution form |
| `/auth/reset-password` | `POST` | Anonymous | Yes | 302 Redirect | Updates password hash in database |
| `/auth/logout` | `POST` | Any Authenticated | Yes | 302 Redirect | Destroys session and clears cookies |

---

## 3. Student Workspace Endpoints (`/student/*`)

| URL Pattern | HTTP Method | Required Role | CSRF Protected | Output Type | Description |
|---|---|---|---|---|---|
| `/student/dashboard` | `GET` | `ROLE_STUDENT` | No | HTML | Student overview, recent views, bookmarks |
| `/student/courses` | `GET` | `ROLE_STUDENT` | No | HTML | Enrolled and available courses |
| `/student/subjects` | `GET` | `ROLE_STUDENT` | No | HTML | Subjects mapped to student course/semester |
| `/student/resources` | `GET` | `ROLE_STUDENT` | No | HTML | Resource browser with search & category filters |
| `/student/resources/view` | `GET` | `ROLE_STUDENT` | No | HTML | In-depth resource view with embedded viewer |
| `/student/resources/stream` | `GET` | `ROLE_STUDENT` | No | Binary Stream | Authenticated inline stream for PDFs/images |
| `/student/resources/download`| `GET` | `ROLE_STUDENT` | No | Binary Stream | File download attachment stream |
| `/student/bookmarks` | `GET` | `ROLE_STUDENT` | No | HTML | Dedicated bookmarked resources workspace |
| `/student/bookmarks/toggle` | `POST` | `ROLE_STUDENT` | Yes | JSON | Asynchronous bookmark toggle |
| `/student/announcements` | `GET` | `ROLE_STUDENT` | No | HTML | Institutional announcements bulletin |
| `/student/notifications` | `GET` | `ROLE_STUDENT` | No | HTML | In-app notification center |
| `/student/notifications/read`| `POST` | `ROLE_STUDENT` | Yes | JSON | Marks notification as read |
| `/student/profile` | `GET` | `ROLE_STUDENT` | No | HTML | Student personal profile workspace |
| `/student/profile/update` | `POST` | `ROLE_STUDENT` | Yes | 302 Redirect | Updates profile information |
| `/student/profile/password`| `POST` | `ROLE_STUDENT` | Yes | 302 Redirect | Updates user password |

---

## 4. Administrator Operations Endpoints (`/admin/*`)

| URL Pattern | HTTP Method | Required Role | CSRF Protected | Output Type | Description |
|---|---|---|---|---|---|
| `/admin/dashboard` | `GET` | `ROLE_ADMIN` | No | HTML | Administrator KPI overview and quick actions |
| `/admin/students` | `GET` | `ROLE_ADMIN` | No | HTML | Student roster, verification status, search |
| `/admin/courses` | `GET` | `ROLE_ADMIN` | No | HTML | Course management list |
| `/admin/courses/create` | `POST` | `ROLE_ADMIN` | Yes | 302 Redirect | Creates new academic course |
| `/admin/subjects` | `GET` | `ROLE_ADMIN` | No | HTML | Subject governance table |
| `/admin/subjects/create` | `POST` | `ROLE_ADMIN` | Yes | 302 Redirect | Creates new curriculum subject |
| `/admin/resources` | `GET` | `ROLE_ADMIN` | No | HTML | Resource management table & upload modal |
| `/admin/resources/create` | `POST` | `ROLE_ADMIN` | Yes | 302 Redirect | Multipart upload and resource metadata creation |
| `/admin/resources/delete` | `POST` | `ROLE_ADMIN` | Yes | 302 Redirect | Soft-deletes or purges educational asset |
| `/admin/announcements` | `GET` | `ROLE_ADMIN` | No | HTML | Announcement management table |
| `/admin/announcements/create`| `POST` | `ROLE_ADMIN` | Yes | 302 Redirect | Publishes institutional announcement |
| `/admin/logs` | `GET` | `ROLE_ADMIN` | No | HTML | Departmental activity audit log viewer |

---

## 5. Super Administrator Control Plane (`/superadmin/*`)

| URL Pattern | HTTP Method | Required Role | CSRF Protected | Output Type | Description |
|---|---|---|---|---|---|
| `/superadmin/dashboard` | `GET` | `ROLE_SUPER_ADMIN` | No | HTML | Institution-wide analytics and system health |
| `/superadmin/administrators` | `GET` | `ROLE_SUPER_ADMIN` | No | HTML | Administrative staff management roster |
| `/superadmin/administrators/create` | `POST` | `ROLE_SUPER_ADMIN` | Yes | 302 Redirect | Provisions new Administrator account |
| `/superadmin/administrators/toggle` | `POST` | `ROLE_SUPER_ADMIN` | Yes | 302 Redirect | Activates/Deactivates administrator access |
| `/superadmin/audit-logs` | `GET` | `ROLE_SUPER_ADMIN` | No | HTML | System-wide security audit trail |
| `/superadmin/settings` | `GET` | `ROLE_SUPER_ADMIN` | No | HTML | Global platform configuration editor |
| `/superadmin/settings/update` | `POST` | `ROLE_SUPER_ADMIN` | Yes | 302 Redirect | Updates system settings in database |

