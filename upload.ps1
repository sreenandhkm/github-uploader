param(
    [Parameter(Mandatory=$true)]
    [string]$Token,
    [string]$Owner = "sreenandhkm",
    [string]$Repo = "github-uploader",
    [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Uploading Project to github.com/$Owner/$Repo" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Verify User
$headers = @{
    "Authorization" = "Bearer $Token"
    "Accept"        = "application/vnd.github+json"
    "User-Agent"    = "GitHub-Uploader-Script"
    "X-GitHub-Api-Version" = "2022-11-28"
}

Write-Host "1. Verifying GitHub token..." -ForegroundColor Yellow
try {
    $user = Invoke-RestMethod -Uri "https://api.github.com/user" -Headers $headers -Method Get
    Write-Host "   Authenticated as: $($user.login) ($($user.name))" -ForegroundColor Green
    $Owner = $user.login
} catch {
    Write-Host "   ERROR: Token authentication failed! Please check your token." -ForegroundColor Red
    exit 1
}

# 2. Check or Create Repo
Write-Host "2. Checking repository https://github.com/$Owner/$Repo..." -ForegroundColor Yellow
$repoExists = $false
try {
    $r = Invoke-RestMethod -Uri "https://api.github.com/repos/$Owner/$Repo" -Headers $headers -Method Get
    $repoExists = $true
    Write-Host "   Repository already exists." -ForegroundColor Green
} catch {
    Write-Host "   Repository not found. Creating https://github.com/$Owner/$Repo..." -ForegroundColor Yellow
    $createBody = @{
        name        = $Repo
        description = "Web site to upload to GitHub using HTML and Java"
        private     = $false
        auto_init   = $true
    } | ConvertTo-Json

    $newRepo = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Headers $headers -Method Post -Body $createBody -ContentType "application/json"
    Write-Host "   Repository created successfully!" -ForegroundColor Green
    Start-Sleep -Seconds 2
}

# 3. List of files to upload
$files = @(
    "src/GitHubUploaderServer.java",
    "src/SimpleJson.java",
    "web/index.html",
    "web/styles.css",
    "web/app.js",
    "run.bat",
    "run.ps1",
    "README.md"
)

Write-Host "3. Uploading $($files.Count) project files..." -ForegroundColor Yellow

foreach ($relPath in $files) {
    if (-not (Test-Path $relPath)) {
        Write-Host "   Skipping missing file: $relPath" -ForegroundColor DarkGray
        continue
    }

    $bytes = [System.IO.File]::ReadAllBytes((Resolve-Path $relPath))
    $base64 = [Convert]::ToBase64String($bytes)

    # Check if file exists to get SHA
    $sha = $null
    $encodedPath = ($relPath -split '/' | ForEach-Object { [System.Uri]::EscapeDataString($_) }) -join '/'
    $checkUrl = "https://api.github.com/repos/$Owner/$Repo/contents/$encodedPath`?ref=$Branch"
    
    try {
        $existing = Invoke-RestMethod -Uri $checkUrl -Headers $headers -Method Get
        $sha = $existing.sha
    } catch {}

    $putBody = @{
        message = "Upload $relPath"
        content = $base64
        branch  = $Branch
    }
    if ($sha) {
        $putBody["sha"] = $sha
    }

    $putJson = $putBody | ConvertTo-Json
    $putUrl = "https://api.github.com/repos/$Owner/$Repo/contents/$encodedPath"

    try {
        $uploadResp = Invoke-RestMethod -Uri $putUrl -Headers $headers -Method Put -Body $putJson -ContentType "application/json"
        $action = if ($sha) { "Updated" } else { "Created" }
        Write-Host "   [✓] $action : $relPath" -ForegroundColor Green
    } catch {
        Write-Host "   [✗] Failed to upload $relPath : $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host " SUCCESS! Project uploaded to:" -ForegroundColor Green
Write-Host " https://github.com/$Owner/$Repo" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Cyan
Start-Process "https://github.com/$Owner/$Repo"
