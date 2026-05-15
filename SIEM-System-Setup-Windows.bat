@echo off
setlocal enabledelayedexpansion

cls
echo ==================================================
echo          SIEM System v1.0.0 - Windows Setup
echo ==================================================
echo.

echo [Step 1/6] Checking system requirements...
echo.

echo Checking for Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker not found!
    echo.
    echo Please install Docker Desktop first:
    echo https://www.docker.com/products/docker-desktop
    echo.
    echo For help, contact: vrajgavade17@gmail.com
    echo.
    pause
    exit /b 1
)
echo OK: Docker is installed
echo.

echo Checking if Docker is running...
docker info >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not running!
    echo.
    echo Please start Docker Desktop and try again.
    echo.
    echo For help, contact: vrajgavade17@gmail.com
    echo.
    pause
    exit /b 1
)
echo OK: Docker is running
echo.

echo Checking internet connection...
ping -n 2 github.com >nul 2>&1
if errorlevel 1 (
    echo ERROR: No internet connection!
    echo.
    echo Please check your internet connection and try again.
    echo.
    echo For help, contact: vrajgavade17@gmail.com
    echo.
    pause
    exit /b 1
)
echo OK: Internet connection available
echo.

echo ==================================================
echo All system checks passed!
echo ==================================================
echo.

echo [Step 2/6] Downloading docker-compose.yml...
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/viraj-gavade/SIEM_SYSTEM/main/docker-compose.yml' -OutFile 'docker-compose.yml'"

if not exist docker-compose.yml (
    echo.
    echo ERROR: Failed to download docker-compose.yml!
    echo.
    echo Please check your internet connection and try again.
    echo.
    echo For help, contact: vrajgavade17@gmail.com
    echo.
    pause
    exit /b 1
)
echo OK: Downloaded docker-compose.yml successfully!
echo.

echo [Step 3/6] Checking for existing containers...
docker-compose ps -q >nul 2>&1
if not errorlevel 1 (
    echo Found existing containers - stopping them first...
    docker-compose down >nul 2>&1
    echo OK: Existing containers stopped
)
echo.

echo [Step 4/6] Pulling Docker images (this may take a few minutes)...
echo.
docker-compose pull

if errorlevel 1 (
    echo.
    echo ERROR: Failed to pull Docker images!
    echo.
    echo Please check your internet connection and try again.
    echo.
    echo For help, contact: vrajgavade17@gmail.com
    echo.
    pause
    exit /b 1
)
echo.
echo OK: All images pulled successfully!
echo.

echo [Step 5/6] Starting SIEM System...
echo.
docker-compose up -d

if errorlevel 1 (
    echo.
    echo ERROR: Failed to start SIEM System!
    echo.
    echo Please check the logs with: docker-compose logs
    echo.
    echo For help, contact: vrajgavade17@gmail.com
    echo.
    pause
    exit /b 1
)
echo.
echo OK: SIEM System started successfully!
echo.

echo [Step 6/6] Waiting for services to be ready...
echo This will take about 30-60 seconds...
timeout /t 45 /nobreak >nul
echo.

echo ==================================================
echo ✅ SIEM SYSTEM SETUP COMPLETE!
echo ==================================================
echo.
echo Dashboard: http://localhost:3000
echo.
echo Useful Commands:
echo   - Stop system: docker-compose down
echo   - View logs:    docker-compose logs -f
echo   - Check status: docker-compose ps
echo.
echo Need help? Contact: vrajgavade17@gmail.com
echo.
echo Opening dashboard in your browser...
timeout /t 3 /nobreak >nul
start http://localhost:3000
echo.
pause
