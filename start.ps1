# Hospital Management System Startup Script
# PowerShell version for better compatibility

# 1. Check MySQL Status
Clear-Host
Write-Host "Hospital Management System Startup" -ForegroundColor Green
Write-Host "========================================="
Write-Host ""

Write-Host "1. Checking MySQL Status..."
$mysqlProcess = Get-Process -Name "mysqld" -ErrorAction SilentlyContinue
if ($mysqlProcess) {
    Write-Host "   MySQL is running" -ForegroundColor Green
} else {
    Write-Host "   WARNING: MySQL is not running!" -ForegroundColor Yellow
    Write-Host "   Please start MySQL80 service in services.msc manually"
    Read-Host "   Press Enter to continue..."
}
Write-Host ""

# 2. Start Backend Service
Write-Host "2. Starting Backend Service..."
$backendPath = Join-Path -Path $PSScriptRoot -ChildPath "backend"
Start-Process cmd.exe -ArgumentList "/k cd /d `"$backendPath`" && mvn spring-boot:run" -WindowStyle Normal -WorkingDirectory $PSScriptRoot
Write-Host "   Backend started in new window"
Write-Host ""

# 3. Start Frontend Service
Write-Host "   Waiting 10 seconds before starting frontend..." -ForegroundColor Yellow
Start-Sleep -Seconds 10
Write-Host "3. Starting Frontend Service..."
$frontendPath = Join-Path -Path $PSScriptRoot -ChildPath "frontend"
Start-Process cmd.exe -ArgumentList "/k cd /d `"$frontendPath`" && npm install && npm run dev" -WindowStyle Normal -WorkingDirectory $PSScriptRoot
Write-Host "   Frontend started in new window"
Write-Host ""

# Instructions
Write-Host "Startup Instructions:"
Write-Host "===================="
Write-Host "- Backend: http://localhost:8080/api"
Write-Host "- Frontend: http://localhost:3000"
Write-Host ""
Write-Host "Please ensure MySQL is running before using the system"
Write-Host "Visit http://localhost:3000 in your browser when ready"
Read-Host "Press Enter to exit..."
