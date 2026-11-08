@echo off
chcp 936 >nul
title Git 日常一键推送工具 (模块化结构)
setlocal enabledelayedexpansion

:: ==============================================================
:: 1. 配置区 (Configuration)
:: ==============================================================
set "LOCAL_DIR=C:\Users\20503\Desktop\Excel插件模版_需不断更新"
set "BRANCH=main"

:: 切换工作目录
cd /d "%LOCAL_DIR%"
if errorlevel 1 (
    echo [ERROR] 找不到目录: %LOCAL_DIR%
    pause
    exit /b
)

:: ==============================================================
:: 2. 主函数 (Main)
:: ==============================================================
echo ===================================================
echo 开始执行日常推送流程...
echo ===================================================

:: 自动确保有 .gitignore，防止 bin/obj 把仓库撑爆
call :EnsureGitIgnore

:: 检查是否有变动
call :CheckChanges
if !errorlevel! equ 1 (
    echo [INFO] 未检测到任何文件变动，无需备份。
    goto :End
)

:: 获取当前时间
call :GetCurrentTime

:: 执行提交和推送
call :CommitAndPush

echo.
echo ===================================================
echo [SUCCESS] 日常备份推送完成！
echo ===================================================
goto :End

:: ==============================================================
:: 3. 函数区 (Functions)
:: ==============================================================

:EnsureGitIgnore
    if not exist ".gitignore" (
        echo [INFO] 未发现 .gitignore，正在自动生成...
        echo bin/ > .gitignore
        echo obj/ >> .gitignore
        echo .vs/ >> .gitignore
        echo *.user >> .gitignore
        echo *.pfx >> .gitignore
    )
    exit /b 0

:CheckChanges
    :: 使用 git status 才能检测出“新建的未追踪文件”
    :: 只要输出结果不为空，说明有变动
    for /f %%i in ('git status --porcelain') do exit /b 0
    :: 如果没有任何输出，说明无变动
    exit /b 1

:GetCurrentTime
    set "dt=%date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2%"
    set "dt=!dt: =0!"
    exit /b 0

:CommitAndPush
    echo [INFO] 检测到变动，正在添加文件...
    git add .
    
    echo [INFO] 正在提交代码 (时间: !dt!)...
    git commit -m "日常备份: !dt!"
    
    echo [INFO] 正在推送到 GitHub...
    git push origin %BRANCH%
    
    if !errorlevel! neq 0 (
        echo.
        echo [WARNING] 推送失败！可能原因：
        echo 1. 网络连不上 GitHub，请开启加速器或 VPN。
        echo 2. 本地仓库与远程冲突，建议手动执行 git pull 后再试。
    )
    exit /b 0

:End
    pause