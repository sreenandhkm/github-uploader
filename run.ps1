# PowerShell startup script for GitHub Uploader
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $scriptDir

Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "     Starting GitHub Uploader Web Application      " -ForegroundColor Green
Write-Host "===================================================" -ForegroundColor Cyan

if (-not (Test-Path "bin")) {
    New-Item -ItemType Directory -Path "bin" | Out-Null
}

Write-Host "Compiling Java backend..." -ForegroundColor Yellow
javac -encoding UTF-8 -d bin (Get-ChildItem -Path "src\*.java").FullName

Write-Host "Launching server on http://localhost:8080..." -ForegroundColor Green
Start-Process "http://localhost:8080"
java -cp bin com.githubuploader.GitHubUploaderServer 8080
