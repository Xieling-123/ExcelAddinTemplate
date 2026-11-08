@echo off
chcp 936 >nul
title Git 首次推送工具 (模块化结构)
setlocal enabledelayedexpansion

:: ==============================================================
:: 1. 配置区 (Configuration) - 请按需修改这里的变量
:: ==============================================================
set "LOCAL_DIR=C:\Users\20503\Desktop\Excel插件模版_需不断更新"
set "GIT_URL=https://github.com/Xieling-123/ExcelAddinTemplate.git"
set "BRANCH=main"
set "COMMIT_MSG=首次提交：Excel插件母版模板"

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
echo 开始执行首次推送流程...
echo ===================================================

:: 调用函数检查环境
call :CheckGit
if !errorlevel! neq 0 goto :End

:: 调用函数生成忽略文件
call :CreateGitIgnore

:: 调用函数初始化仓库
call :InitRepo

:: 调用函数配置远程地址
call :ConfigRemote

:: 调用函数执行推送
call :PushCode

echo.
echo ===================================================
echo [SUCCESS] 首次推送完成！请去 GitHub 刷新页面查看。
echo ===================================================
goto :End

:: ==============================================================
:: 3. 函数区 (Functions)
:: ==============================================================

:CheckGit
    git --version >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] 未检测到 Git 环境，请先安装 Git！
        exit /b 1
    )
    echo [OK] Git 环境检测通过。
    exit /b 0

:CreateGitIgnore
    :: 如果本地没有 .gitignore，自动生成一个，防止把证书和编译垃圾传上去
    if not exist ".gitignore" (
        echo [INFO] 正在生成 .gitignore 文件...
        echo bin/ > .gitignore
        echo obj/ >> .gitignore
        echo .vs/ >> .gitignore
        echo *.pfx >> .gitignore
        echo *.user >> .gitignore
    )
    exit /b 0

:InitRepo
    if not exist ".git" (
        echo [INFO] 正在初始化本地 Git 仓库...
        git init
        :: 强制将主分支重命名为 main
        git branch -M %BRANCH%
    ) else (
        echo [INFO] 本地已是 Git 仓库，跳过初始化。
    )
    exit /b 0

:ConfigRemote
    git remote get-url origin >nul 2>&1
    if errorlevel 1 (
        echo [INFO] 正在关联远程仓库...
        git remote add origin %GIT_URL%
    ) else (
        echo [INFO] 远程仓库已存在，正在更新地址...
        git remote set-url origin %GIT_URL%
    )
    exit /b 0

:PushCode
    echo [INFO] 正在添加文件到暂存区...
    git add .
    echo [INFO] 正在提交代码...
    git commit -m "%COMMIT_MSG%"
    echo [INFO] 正在推送到远程仓库 (首次推送可能会弹窗要求登录 GitHub)...
    git push -u origin %BRANCH%
    exit /b 0

:End
    pause