@echo off
setlocal enabledelayedexpansion

:: Execute this file after first cloning the repository.

:: REPO_ROOT is passed as the first argument, or defaults to two levels up from this script
set "REPO_ROOT=%~1"
if "%REPO_ROOT%"=="" set "REPO_ROOT=%~dp0..\.."
cd /d "%REPO_ROOT%"

echo Setting git hooks...
git config --local core.hooksPath ./toolkit/hooks
git config --local commit.template ./toolkit/resources/git-commit-msg-template.txt

:: Ensure we are at the repo root
cd /d "%REPO_ROOT%"

:: Detect existing Gradle build
if exist build.gradle (
    echo ✅ Gradle project already exists - skipping init
    exit /b 0
)
if exist build.gradle.kts (
    echo ✅ Gradle project already exists - skipping init
    exit /b 0
)
if exist settings.gradle (
    echo ✅ Gradle project already exists - skipping init
    exit /b 0
)
if exist settings.gradle.kts (
    echo ✅ Gradle project already exists - skipping init
    exit /b 0
)

:: Ensure Gradle is available
if not exist gradlew.bat (
    echo ❌ gradlew.bat not found. Please ensure you are in a Gradle project.
    exit /b 1
)

echo 🚀 Initializing Gradle project...
:: Get the current directory name as project name
for %%I in ("%CD%") do set "PROJECT_NAME=%%~nxI"

call gradlew.bat init --project-name "%PROJECT_NAME%"

if %ERRORLEVEL% neq 0 (
    echo ❌ Gradle initialization failed.
    exit /b %ERRORLEVEL%
)

echo ✅ Gradle initialized
