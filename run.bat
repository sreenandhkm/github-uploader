@echo off
setlocal
cd /d "%~dp0"

echo ===================================================
echo     Starting GitHub Uploader Web Application
echo ===================================================

if not exist "bin" mkdir "bin"

echo Compiling Java source files...
javac -encoding UTF-8 -d bin src\*.java

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Compilation failed. Please make sure Java JDK is installed.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo Starting Java HTTP Server on http://localhost:8080 ...
start http://localhost:8080
java -cp bin com.githubuploader.GitHubUploaderServer 8080

pause
