# StudyMate Unified Startup Script
$ErrorActionPreference = "Continue"

$baseDir = "C:\StudyMate"
$javaHome = "$baseDir\tools\jdk-21"
$tomcatHome = "$baseDir\tools\tomcat-10"
$pgDir = "$baseDir\tools\pgsql"
$pgData = "$baseDir\data\pgdata"

$env:JAVA_HOME = $javaHome
$env:CATALINA_HOME = $tomcatHome
$env:PATH = "$javaHome\bin;$pgDir\bin;$env:PATH"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " StudyMate - Your Learning. Your Space. (Starting Engine)  " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Start PostgreSQL if not already running
$pgProcess = Get-Process -Name postgres -ErrorAction SilentlyContinue
if (-not $pgProcess) {
    Write-Host "[1/3] Starting PostgreSQL 16 server..." -ForegroundColor Yellow
    & "$pgDir\bin\pg_ctl.exe" -D $pgData start
    Start-Sleep -Seconds 2
} else {
    Write-Host "[1/3] PostgreSQL is already running." -ForegroundColor Green
}

# 2. Deploy latest WAR if built
if (Test-Path "$baseDir\target\studymate.war") {
    Write-Host "[2/3] Verifying WAR deployment in Tomcat webapps..." -ForegroundColor Yellow
    Copy-Item -Path "$baseDir\target\studymate.war" -Destination "$tomcatHome\webapps\studymate.war" -Force
}

# 3. Start Apache Tomcat 10
Write-Host "[3/3] Starting Apache Tomcat 10.1..." -ForegroundColor Yellow
Start-Process -FilePath "$tomcatHome\bin\catalina.bat" -ArgumentList "start" -WorkingDirectory "$tomcatHome\bin"

Start-Sleep -Seconds 4

Write-Host "`nStudyMate LMS is active and accessible at:" -ForegroundColor Green
Write-Host "   * Main Platform:       http://localhost:8080/studymate/" -ForegroundColor White
Write-Host "   * Authentication:      http://localhost:8080/studymate/auth/login" -ForegroundColor White
Write-Host "   * Admin Console:       http://localhost:8080/studymate/admin/dashboard" -ForegroundColor White
Write-Host "   * Super Admin Panel:   http://localhost:8080/studymate/superadmin/dashboard`n" -ForegroundColor White
Write-Host "Default Demo Accounts (Password: StudyMate@2026):" -ForegroundColor Cyan
Write-Host "   - Student:      student@studymate.edu" -ForegroundColor Gray
Write-Host "   - Admin:        admin@studymate.edu" -ForegroundColor Gray
Write-Host "   - Super Admin:  superadmin@studymate.edu" -ForegroundColor Gray

