$pgBin = "C:\StudyMate\tools\pgsql\bin"
$schemaSql = "C:\StudyMate\database\schema.sql"
$seedSql = "C:\StudyMate\database\seed.sql"

# Ensure server is running
powershell -ExecutionPolicy Bypass -File "C:\StudyMate\infrastructure\scripts\start-postgres.ps1"

Write-Host "Ensuring 'niksa' superuser role exists for current Windows login..."
& "$pgBin\psql.exe" -U postgres -h localhost -p 5432 -c "CREATE ROLE niksa WITH SUPERUSER LOGIN;" 2>$null

Write-Host "Creating 'studymate' database if it doesn't exist..."
& "$pgBin\psql.exe" -U postgres -h localhost -p 5432 -c "CREATE DATABASE studymate;" 2>$null

Write-Host "Applying schema.sql..."
& "$pgBin\psql.exe" -U postgres -h localhost -p 5432 -d studymate -f $schemaSql

Write-Host "Applying seed.sql..."
& "$pgBin\psql.exe" -U postgres -h localhost -p 5432 -d studymate -f $seedSql

Write-Host "Verifying table counts..."
& "$pgBin\psql.exe" -U postgres -h localhost -p 5432 -d studymate -c "SELECT 'users' as tbl, count(*) from users union all SELECT 'subjects', count(*) from subjects union all SELECT 'resources', count(*) from resources;"

Write-Host "Database initialization completed successfully!"
