# Administrator & Super Administrator Operations Manual: StudyMate

This manual details administrative workflows, academic curriculum governance, resource lifecycle management, user oversight, and security auditing within the StudyMate platform.

---

## 1. Administrative Roles & Hierarchy

StudyMate defines two administrative authorization levels:

| Role Code | Operational Scope | Key Capabilities |
|---|---|---|
| **`ROLE_ADMIN`** | Departmental & Academic Management | Manage courses, semesters, subjects, upload study materials, publish bulletins, view student rosters. |
| **`ROLE_SUPER_ADMIN`** | System Governance & Institutional Control | Provision/deactivate administrators, inspect security audit logs, modify system settings, access all data. |

---

## 2. Administrator Workflows (`ROLE_ADMIN`)

### 2.1 Navigating the Admin Dashboard
Upon signing in at `/auth/login`, administrators are routed to `/admin/dashboard`.
- **KPI Metrics**: Total active students, courses, subjects, uploaded materials, cumulative views, and downloads.
- **Recent Uploads**: Quick-action table showing the last 10 published resources.
- **Quick Actions**: Shortcuts to upload files, create subjects, or post announcements.

### 2.2 Managing Courses & Semesters
1. Navigate to **"Courses"** (`/admin/courses`).
2. Click **"+ Add New Course"**.
3. Supply:
   - **Course Name**: e.g., *Bachelor of Technology in Computer Science*
   - **Course Code**: e.g., *BTECH-CS* (Must be unique)
   - **Description**: Brief overview of degree scope.
4. Click **"Save Course"**. Once created, default semesters (Semesters 1 through 8) are established automatically.

### 2.3 Managing Subjects
1. Navigate to **"Subjects"** (`/admin/subjects`).
2. Click **"+ Add Subject"**.
3. Select the parent **Course** and **Semester**.
4. Enter **Subject Title** (e.g., *Distributed Operating Systems*) and **Subject Code** (e.g., *CS402*).
5. Click **"Create Subject"**.

### 2.4 Uploading & Publishing Learning Materials
1. Navigate to **"Resources"** (`/admin/resources`).
2. Click the **"Upload Resource"** button to open the upload modal.
3. Complete the metadata fields:
   - **Resource Title**: Clear, descriptive academic title.
   - **Subject**: Choose target subject from dropdown.
   - **Category**: Select *Lecture Notes*, *Lecture Slides*, *Past Papers*, *Lab Manuals*, or *Syllabus Guides*.
   - **File Payload**: Choose a `.pdf`, `.png`, `.jpg`, `.jpeg`, `.gif`, `.webp`, or `.svg` file (up to 50MB).
   - **Downloadable Toggle**: Enable or disable direct file downloads by students.
4. Click **"Publish Resource"**. The system validates MIME types, stores the file securely in external storage, and indexes the resource metadata.

### 2.5 Publishing Institutional Announcements
1. Navigate to **"Announcements"** (`/admin/announcements`).
2. Click **"New Announcement"**.
3. Provide Headline, Body Text, Priority (`NORMAL`, `HIGH`, `URGENT`), and Target Course (or leave blank to broadcast globally).
4. Submitting publishes the notice and automatically dispatches notifications to enrolled students.

---

## 3. Super Administrator Control Plane (`ROLE_SUPER_ADMIN`)

Super Administrators have exclusive access to `/superadmin/*`.

### 3.1 Provisioning Administrator Accounts
1. Navigate to **"Administrators"** (`/superadmin/administrators`).
2. Click **"+ Invite Administrator"**.
3. Enter Administrator's Full Name, Institutional Email, and temporary password.
4. Select initial status (Active / Suspended).
5. Click **"Create Administrator"**. The account is created with `ROLE_ADMIN` assigned.

### 3.2 Activating & Deactivating Administrators
- In the Administrators table, toggle the status switch on any administrator row.
- Deactivating an administrator immediately prevents subsequent logins without deleting historical audit logs or uploaded assets.

### 3.3 Security Audit Trail Inspection
1. Navigate to **"Audit Logs"** (`/superadmin/audit-logs`).
2. Review tamper-evident logs capturing:
   - Exact UTC Timestamp.
   - User ID & Email.
   - Action Code (e.g., `LOGIN_FAILURE`, `CREATE_SUBJECT`, `UPLOAD_RESOURCE`).
   - Target Entity ID.
   - Remote Client IP Address.
   - Browser User-Agent Header.

### 3.4 Dynamic System Configuration
1. Navigate to **"System Settings"** (`/superadmin/settings`).
2. Edit system-wide variables:
   - `PLATFORM_NAME`: Title rendered across headers and emails.
   - `STORAGE_UPLOAD_PATH`: Filesystem directory for uploaded files.
   - `MAX_UPLOAD_SIZE_MB`: Maximum permitted file upload size.
   - `MAINTENANCE_MODE`: Boolean switch to restrict non-admin access.
3. Click **"Save Configuration"**. Changes take effect dynamically without requiring server restart.

