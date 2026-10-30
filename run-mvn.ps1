param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$MavenArgs
)

$toolsDir = "C:\StudyMate\tools"
$repoDir = "C:\StudyMate\.m2\repository"

if (-not (Test-Path $repoDir)) {
    New-Item -ItemType Directory -Path $repoDir -Force | Out-Null
}

$env:JAVA_HOME = "$toolsDir\jdk-21"
$env:M2_HOME = "$toolsDir\maven"
$env:PATH = "$toolsDir\jdk-21\bin;$toolsDir\maven\bin;$env:PATH"

& "$toolsDir\maven\bin\mvn.cmd" "-Dmaven.repo.local=$repoDir" @MavenArgs
