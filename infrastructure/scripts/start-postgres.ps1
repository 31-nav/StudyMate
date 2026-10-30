$pgBin = "C:\StudyMate\tools\pgsql\bin"
$pgData = "C:\StudyMate\data\pgdata"
$logFile = "C:\StudyMate\data\postgres.log"

Write-Host "Checking if PostgreSQL is already running..."
& "$pgBin\pg_isready.exe" -h localhost -p 5432 -U postgres 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Starting PostgreSQL Server..."
    & "$pgBin\pg_ctl.exe" -D $pgData -l $logFile start
    Start-Sleep -Seconds 3
    & "$pgBin\pg_isready.exe" -h localhost -p 5432 -U postgres
} else {
    Write-Host "PostgreSQL is already running."
}
