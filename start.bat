@echo off
:: 确保在CMD中运行，避免PowerShell兼容性问题
if "%PSModulePath%" neq "" (
    echo 请在命令提示符(CMD)中运行此脚本，而不是PowerShell
    echo 按Win+R，输入cmd，然后运行 start.bat
    pause
    exit /b 1
)

chcp 65001 >nul
echo ========================================
echo 医院管理系统一键启动脚本
echo ========================================
echo.

:: 配置颜色
color 0A

:: 设置变量
set "PROJECT_DIR=%~dp0"
set "BACKEND_DIR=%PROJECT_DIR%backend"
set "FRONTEND_DIR=%PROJECT_DIR%frontend"
set "DB_NAME=hospital_management"
set "DB_USER=root"
set "DB_PASS=123123"

:: 尝试自动检测MySQL路径
echo 检测MySQL安装路径...
set "MYSQL_BIN="

:: 检查常见MySQL安装路径
if exist "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" (
    set "MYSQL_BIN=C:\Program Files\MySQL\MySQL Server 8.0\bin"
) else if exist "C:\Program Files (x86)\MySQL\MySQL Server 8.0\bin\mysql.exe" (
    set "MYSQL_BIN=C:\Program Files (x86)\MySQL\MySQL Server 8.0\bin"
) else if exist "D:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" (
    set "MYSQL_BIN=D:\Program Files\MySQL\MySQL Server 8.0\bin"
) else (
    echo 警告：未找到MySQL安装路径，请手动输入MySQL bin目录路径：
    set /p "MYSQL_BIN=MySQL bin目录路径: "
    if not exist "%MYSQL_BIN%\mysql.exe" (
        echo 错误：指定的路径中未找到mysql.exe
        pause
        exit /b 1
    )
)

echo 已找到MySQL路径：%MYSQL_BIN%
echo.

:: 检查MySQL服务状态
echo 检查MySQL服务状态...
sc query mysql >nul 2>&1
if %errorlevel% neq 0 (
    echo MySQL服务未运行，尝试启动...
    net start mysql >nul 2>&1
    if %errorlevel% neq 0 (
        echo 错误：无法启动MySQL服务，请手动启动后重试
        echo 请按Win+R，输入services.msc，找到MySQL服务并启动
        pause
        exit /b 1
    )
    echo MySQL服务已成功启动
) else (
    echo MySQL服务已在运行
)
echo.

:: 检查数据库是否存在
echo 检查数据库 %DB_NAME% 是否存在...
"%MYSQL_BIN%\mysql" -u%DB_USER% -p%DB_PASS% -e "USE %DB_NAME%" >nul 2>&1
if %errorlevel% neq 0 (
    echo 数据库 %DB_NAME% 不存在，正在创建...
    "%MYSQL_BIN%\mysql" -u%DB_USER% -p%DB_PASS% -e "CREATE DATABASE IF NOT EXISTS %DB_NAME% CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci" >nul 2>&1
    if %errorlevel% neq 0 (
        echo 错误：创建数据库失败，请检查MySQL用户名和密码是否正确
        echo 用户名：%DB_USER%
        echo 密码：%DB_PASS%
        pause
        exit /b 1
    )
    echo 数据库 %DB_NAME% 已成功创建
    
    :: 导入数据库初始化脚本
    echo 导入数据库初始化脚本...
    if exist "%PROJECT_DIR%hospital_db_latest.sql" (
        "%MYSQL_BIN%\mysql" -u%DB_USER% -p%DB_PASS% %DB_NAME% < "%PROJECT_DIR%hospital_db_latest.sql" >nul 2>&1
        if %errorlevel% neq 0 (
            echo 警告：导入数据库脚本失败，但不影响项目启动
        ) else (
            echo 数据库初始化完成
        )
    ) else (
        echo 警告：未找到数据库初始化脚本 hospital_db_latest.sql
    )
) else (
    echo 数据库 %DB_NAME% 已存在
)
echo.

:: 启动后端应用
echo ========================================
echo 启动后端Spring Boot应用...
echo 启动命令：cd /d "%BACKEND_DIR%" && mvn spring-boot:run
echo ========================================
echo 请等待后端启动完成，然后按任意键继续启动前端...
echo 注意：如果后端启动失败，请检查控制台输出的错误信息
echo.
:: 使用start命令打开新窗口启动后端，便于查看日志
start "后端服务 - 医院管理系统" cmd /k "cd /d "%BACKEND_DIR%" && echo 启动后端服务... && mvn spring-boot:run"

:: 等待用户确认后端启动成功
echo 后端服务已在新窗口启动，请检查是否启动成功
echo 后端服务地址：http://localhost:8080/api
echo.
pause

echo.
echo ========================================
echo 启动前端Vue应用...
echo 启动命令：cd /d "%FRONTEND_DIR%" && npm install && npm run dev
echo ========================================
echo 请等待前端依赖安装和启动完成...
echo.

:: 启动前端应用
start "前端服务 - 医院管理系统" cmd /k "cd /d "%FRONTEND_DIR%" && echo 安装前端依赖... && npm install && echo 启动前端服务... && npm run dev"

echo 前端服务已在新窗口启动
echo 前端服务地址：http://localhost:3000
echo.
echo ========================================
echo 项目启动完成！
echo ========================================
echo 后端服务：http://localhost:8080/api （新窗口）
echo 前端服务：http://localhost:3000 （新窗口）
echo.
echo 请在浏览器中访问 http://localhost:3000 开始使用系统
echo.
echo 提示：
echo 1. 如果服务启动失败，请查看对应的命令窗口中的错误信息
echo 2. 关闭命令窗口即可停止对应的服务
echo 3. 下次启动前，请确保关闭所有相关服务窗口
echo.
echo 按任意键退出本窗口...
pause >nul
exit