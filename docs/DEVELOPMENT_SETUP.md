# Local Development Environment Setup: StudyMate

This guide provides step-by-step instructions for provisioning a local development workstation to build, test, and run StudyMate.

---

## 1. Prerequisites & Toolchain

Ensure the following tools are installed on your machine:
- **Java Development Kit (JDK)**: OpenJDK 21 LTS or Oracle JDK 21.
- **Build Tool**: Apache Maven 3.9+
- **Relational Database**: PostgreSQL 16+
- **Servlet Container**: Apache Tomcat 10.1+
- **Version Control**: Git

---

## 2. Database Initialization (PostgreSQL 16)

### 2.1 Starting PostgreSQL Service
Ensure PostgreSQL is active on port `5432`:
```powershell
# Windows Portable (Included in StudyMate toolchain)
C:\StudyMate\tools\pgsql\bin\postgres.exe -D C:\StudyMate\data\pgdata

# Linux (systemd)
sudo systemctl start postgresql

# macOS (Homebrew)
brew services start postgresql@16
```

### 2.2 Creating the Database & Executing Scripts
Connect using `psql` and execute the schema and seed scripts:
```bash
# Connect as superuser
psql -U postgres -h localhost -p 5432

# Create database
CREATE DATABASE studymate;
\c studymate;

# Execute DDL schema (20 tables)
\i C:/StudyMate/database/schema.sql

# Execute Seed Data (roles, default accounts, courses, subjects)
\i C:/StudyMate/database/seed.sql
```

---

## 3. Configuration Properties

Review and adjust database credentials in `src/main/resources/application.properties` and `src/main/resources/hibernate.cfg.xml`:

```properties
db.driver=org.postgresql.Driver
db.url=jdbc:postgresql://localhost:5432/studymate
db.user=postgres
db.password=postgres
storage.upload.dir=C:/StudyMate/storage/uploads
```

Ensure the physical upload directory exists:
```powershell
New-Item -ItemType Directory -Force -Path "C:\StudyMate\storage\uploads"
```

---

## 4. Compiling & Running Automated Tests

Run the full test suite using Maven:
```powershell
# Using the local Maven wrapper (Windows)
powershell -ExecutionPolicy Bypass -File C:\StudyMate\run-mvn.ps1 clean test

# Standard Maven command
mvn clean test
```
*Expected Output:*
```
[INFO] Tests run: 25, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```

---

## 5. Building & Packaging the WAR Archive

Assemble the web application archive (`WAR`):
```bash
mvn clean package -DskipTests
```
The deployable archive will be generated at `target/studymate.war`.

---

## 6. Running with Apache Tomcat 10.1

1. Copy the packaged WAR to Tomcat's `webapps` directory:
   ```powershell
   Copy-Item target\studymate.war C:\StudyMate\tools\tomcat-10\webapps\studymate.war -Force
   ```
2. Start Apache Tomcat:
   ```powershell
   cmd.exe /c "set CATALINA_HOME=C:\StudyMate\tools\tomcat-10&& set JAVA_HOME=C:\StudyMate\tools\jdk-21&& cd /d C:\StudyMate\tools\tomcat-10\bin&& catalina.bat run"
   ```
3. Open your browser and navigate to:
   ```
   http://localhost:8080/studymate/
   ```

---

## 7. Default Credentials for Development Testing

| Role | Email Address | Password |
|---|---|---|
| **Student** | `student@studymate.edu` | `StudyMate@2026` |
| **Administrator** | `admin@studymate.edu` | `StudyMate@2026` |
| **Super Administrator** | `superadmin@studymate.edu` | `StudyMate@2026` |

