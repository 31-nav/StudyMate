# StudyMate Unified Shutdown Script
$baseDir = "C:\StudyMate"
$tomcatHome = "$baseDir\tools\tomcat-10"
$pgDir = "$baseDir\tools\pgsql"
$pgData = "$baseDir\data\pgdata"

Write-Host "Stopping StudyMate services..." -ForegroundColor Yellow

# Stop Tomcat
if (Test-Path "$tomcatHome\bin\catalina.bat") {
    & "$tomcatHome\bin\catalina.bat" stop
}

# Stop PostgreSQL
if (Test-Path "$pgDir\bin\pg_ctl.exe") {
    & "$pgDir\bin\pg_ctl.exe" -D $pgData stop
}

Write-Host "StudyMate services stopped." -ForegroundColor Green

