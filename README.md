# StudyMate

<p align="center">
  <img src="src/main/webapp/assets/images/studymate-logo.svg" alt="StudyMate Logo" width="220" />
</p>

<p align="center">
  <strong>Your Learning. Your Space.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Java-21%20LTS-007396?style=flat&logo=openjdk&logoColor=white" alt="Java 21" />
  <img src="https://img.shields.io/badge/Jakarta%20EE-10.0-F58220?style=flat&logo=eclipse-ide&logoColor=white" alt="Jakarta EE 10" />
  <img src="https://img.shields.io/badge/Servlet%20API-6.0-red?style=flat" alt="Servlet 6.0" />
  <img src="https://img.shields.io/badge/Hibernate%20ORM-6.4-59666C?style=flat&logo=hibernate&logoColor=white" alt="Hibernate ORM" />
  <img src="https://img.shields.io/badge/PostgreSQL-16.6-336791?style=flat&logo=postgresql&logoColor=white" alt="PostgreSQL" />
  <img src="https://img.shields.io/badge/Apache%20Tomcat-10.1-F8DC75?style=flat&logo=apache-tomcat&logoColor=black" alt="Tomcat 10" />
  <img src="https://img.shields.io/badge/Tests-25%20Passing-brightgreen?style=flat" alt="Tests" />
  <img src="https://img.shields.io/badge/License-MIT-blue?style=flat" alt="License" />
</p>

---

## 1. Overview & Vision

**StudyMate** is an enterprise-grade, production-ready Learning Management System (LMS) and Educational Resource Management Platform engineered specifically for higher education institutions, academies, and universities. 

Built with **pure Java 21 LTS**, **Jakarta EE 10 Servlets**, **JSP 3.1**, **JSTL 3.0**, **Hibernate ORM 6.4**, **JDBC**, and **PostgreSQL 16**, StudyMate deliberately adheres to classic, robust MVC software architecture without heavy frontend frameworks or unnecessary microservice overhead.

The platform provides a centralized, high-performance digital repository where students discover, preview, download, and bookmark learning materials organized by academic programs, semesters, and subjects, while empowering faculty and administrators with comprehensive course governance, resource lifecycle workflows, and granular security audit trails.

---

## 2. Key Features

### 🎓 Student Workspace
- **Academic Hierarchy Navigation**: Seamlessly filter learning assets by Academic Program (Course), Semester, and Subject.
- **Embedded Document Viewer**: High-fidelity inline viewing of PDF documents and educational diagrams/images with zero third-party cloud dependence.
- **Personalized Learning**: One-click bookmarking of materials and automated tracking of recently accessed resources.
- **Controlled Downloads**: Secure, authenticated streaming for permitted educational assets with automated download accounting.
- **Real-time Notifications & Announcements**: Instant broadcast alerts for academic updates, syllabus changes, and departmental notices.
- **Student Profile Management**: Password changing, personal information updates, and academic progress tracking.

### 🛡️ Administrator Portal
- **Academic Governance**: Complete lifecycle management of Courses, Semesters, Subjects, and Resource Categories.
- **Resource Management**: Multipart drag-and-drop file uploading with strict MIME verification, metadata enrichment, and access controls.
- **Student Oversight**: Inspect enrolled student rosters, verification statuses, and academic activity logs.
- **Announcement Broadcasting**: Publish targeted or global institutional bulletins with rich markdown formatting and priority tiers.
- **Resource Analytics**: Track views, downloads, and engagement metrics across departments.

### ⚡ Super Administrator Control Plane
- **Administrator Provisioning**: Invite, onboard, activate, and deactivate administrative staff members.
- **Platform Audit Trail**: Comprehensive, tamper-evident security audit logs capturing IP addresses, user agents, actions, and timestamps.
- **System Configuration**: Real-time management of platform parameters, institutional metadata, and storage thresholds.
- **Global Overview**: Unified multi-departmental reporting and aggregate metrics powered by optimized direct JDBC queries.

---

## 3. Technology Stack & Architectural Principles

StudyMate follows strict architectural guardrails:

| Layer | Technologies Employed |
|---|---|
| **Presentation Layer** | HTML5, CSS3 Glassmorphism System, Vanilla JavaScript ES6+, Bootstrap 5.3, JSP 3.1, JSTL 3.0 |
| **Controller & Routing** | Jakarta Servlet API 6.0 (`jakarta.servlet.*`), Custom Filter Pipeline |
| **Service Layer** | Pure Java 21 Domain Services, Bean Validation (`Hibernate Validator 8.0`) |
| **Persistence Layer** | Hibernate ORM 6.4 (JPA Entities, Transactions) & Direct JDBC (`HikariCP 5.1`, `JdbcReportingDao`) |
| **Database Engine** | PostgreSQL 16.6 with relational constraints, cascading keys, and partial indexes |
| **Security & Cryptography** | BCrypt password hashing (Cost Factor 12), CSPRNG SecureRandom, SHA-256 token hashes |
| **File Storage** | Dedicated local filesystem directory isolated outside the web root (`storage/uploads`) |
| **Web Server / Servlet Container** | Apache Tomcat 10.1.34 |
| **Build & Dependency Tool** | Apache Maven 3.9.9 |

> **Strict Architectural Boundary**: Zero Spring Boot, zero React/Angular/Vue, zero Node/Python runtimes. Pure Java EE/Jakarta EE standard compliant.

---

## 4. Default Demonstration Accounts

The PostgreSQL seed database includes pre-configured demo users across all three authorization tiers:

| Role | Email Address | Default Password | Permissions |
|---|---|---|---|
| **Student** | `student@studymate.edu` | `StudyMate@2026` | Browse courses, preview PDFs, bookmark, view profile |
| **Administrator** | `admin@studymate.edu` | `StudyMate@2026` | Upload resources, manage subjects, publish bulletins |
| **Super Administrator** | `superadmin@studymate.edu` | `StudyMate@2026` | Provision admins, audit security logs, system settings |

---

## 5. Repository Structure

```
StudyMate/
├── pom.xml                               # Maven project definition and dependencies
├── README.md                             # Primary project documentation
├── AGENTS.md                             # AI agent instructions and conventions
├── run-mvn.ps1                           # Local Maven execution wrapper
├── data/
│   └── pgdata/                           # PostgreSQL 16 active data cluster
├── database/
│   ├── schema.sql                        # 20 DDL tables, indexes, constraints
│   └── seed.sql                          # Core roles, users, courses, subjects
├── docs/                                 # Comprehensive technical documentation
│   ├── diagrams/                         # Mermaid architecture & ER diagrams
│   ├── PROJECT_OVERVIEW.md
│   ├── REQUIREMENTS.md
│   ├── SYSTEM_ARCHITECTURE.md
│   ├── DATABASE_DESIGN.md
│   ├── ER_DIAGRAM.md
│   ├── SERVLET_ARCHITECTURE.md
│   ├── HIBERNATE_GUIDE.md
│   ├── JDBC_GUIDE.md
│   ├── AUTHENTICATION_FLOW.md
│   ├── API_AND_ROUTES.md
│   ├── SECURITY.md
│   ├── STUDENT_GUIDE.md
│   ├── ADMIN_GUIDE.md
│   ├── UI_UX_GUIDELINES.md
│   ├── DEVELOPMENT_SETUP.md
│   ├── DEPLOYMENT.md
│   ├── TESTING.md
│   ├── TROUBLESHOOTING.md
│   └── CHANGELOG.md
├── storage/
│   └── uploads/                          # Secure upload store outside web root
├── src/
│   ├── main/
│   │   ├── java/com/studymate/
│   │   │   ├── config/                   # Database, Hibernate, App configuration
│   │   │   ├── controller/               # Jakarta Servlets (10 controllers)
│   │   │   ├── dao/                      # Hibernate & JDBC DAOs (11 DAOs)
│   │   │   ├── dto/                      # Data Transfer Objects
│   │   │   ├── exception/                # Domain exception hierarchy
│   │   │   ├── filter/                   # Security, CSRF, Auth, RBAC filters
│   │   │   ├── model/                    # JPA Entities (18 domain models)
│   │   │   ├── service/                  # Business logic services (8 services)
│   │   │   └── util/                     # Security, Password, Validation utilities
│   │   ├── resources/
│   │   │   ├── hibernate.cfg.xml         # Hibernate 6 ORM database mapping
│   │   │   ├── application.properties    # Environment & database properties
│   │   │   └── logback.xml               # SLF4J / Logback logging config
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── web.xml               # Servlet container deployment descriptor
│   │       │   └── views/                # JSP 3.1 views (Auth, Student, Admin, SuperAdmin)
│   │       └── assets/                   # CSS, JS, SVG logos, and favicon
│   └── test/java/com/studymate/          # JUnit 5 & Mockito test suites (25 tests)
└── tools/                                # Portable toolchain (JDK 21, Maven, Postgres, Tomcat)
```

---

## 6. Quick Start & Execution

### Prerequisites
- **Java 21 LTS** installed and configured in `JAVA_HOME`.
- **PostgreSQL 16** running locally on port `5432` with database `studymate`.
- **Apache Tomcat 10.1** configured in `CATALINA_HOME`.

### Building the Project
Execute the Maven package command to compile, test, and assemble the WAR archive:
```bash
mvn clean package
```
*Artifact generated:* `target/studymate.war`

### Executing Automated Tests
Run the 25 unit and integration tests across security, authentication, resource streaming, and JDBC reporting:
```bash
mvn test
```

### Deploying to Apache Tomcat
Copy `target/studymate.war` to `$CATALINA_HOME/webapps/` and start Tomcat:
```bash
# Windows
catalina.bat run

# Linux / macOS
catalina.sh run
```

### Accessing the Live Platform
Open your browser and navigate to:
```
http://localhost:8080/studymate/
```

---

## 7. Security Architecture

StudyMate implements defense-in-depth across every layer:
1. **Password Protection**: BCrypt with 12 rounds of CSPRNG salting.
2. **Anti-CSRF Defense**: Nonce-based cryptographic tokens validated on every mutating `POST`, `PUT`, or `DELETE` request.
3. **Session Fixation Prevention**: User sessions are invalidated and regenerated immediately upon authentication.
4. **Content Security Policy (CSP)**: Strict HTTP headers blocking malicious scripts, clickjacking (`X-Frame-Options: SAMEORIGIN`), and MIME-sniffing (`X-Content-Type-Options: nosniff`).
5. **Path Traversal Shield**: Uploaded and streamed filenames are stripped of `../` and assigned randomized UUID keys on disk.
6. **Isolated Storage**: Binary payloads are stored strictly outside the web application directory.

---

## 8. License

StudyMate is open-source software licensed under the [MIT License](LICENSE).  
Copyright © 2026 StudyMate Development Team. All rights reserved.

