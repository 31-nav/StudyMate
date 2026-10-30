$pgBin = "C:\StudyMate\tools\pgsql\bin"
$pgData = "C:\StudyMate\data\pgdata"

Write-Host "Stopping PostgreSQL Server..."
& "$pgBin\pg_ctl.exe" -D $pgData stop

