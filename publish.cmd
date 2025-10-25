@echo off
setlocal enabledelayedexpansion
title Publish Hugo Site to GitHub Pages

echo =====================================================
echo =========== HUGO STATIC SITE DEPLOY SCRIPT ===========
echo =====================================================
echo.

:: 1. Verify Hugo is available
where hugo >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Hugo not found in PATH.
  exit /b 1
)

:: 2. Verify Git is available
where git >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Git not found in PATH.
  exit /b 1
)

:: 3. Clean Hugo cache and rebuild
echo Cleaning and building site with Hugo...
hugo --minify
if errorlevel 1 (
  echo [ERROR] Hugo build failed.
  exit /b 1
)

:: 4. Show repo status
echo Checking repository status...
git status --short

echo.
set /p choice="Continue with git sync, commit, and push? (Y/N): "
if /I "%choice%" NEQ "Y" exit /b 0

:: 5. Sync with origin/main (force local as truth)
echo Syncing with origin/main...
git fetch origin
git reset --hard origin/main
if errorlevel 1 (
  echo [WARN] Could not reset to origin/main, assuming local source of truth.
)

:: 6. Stage all changes
echo Staging all changes...
git add -A

:: 7. Commit
set /p COMMIT_MSG=Commit message: 
if "%COMMIT_MSG%"=="" set COMMIT_MSG=update site

echo Committing changes...
git commit -m "%COMMIT_MSG%"
if errorlevel 1 (
  echo [INFO] Nothing to commit, skipping.
) else (
  echo Commit successful.
)

:: 8. Push (force)
echo Pushing to origin/main...
git push origin main --force
if errorlevel 1 (
  echo [ERROR] Push failed.
  exit /b 1
)

echo.
echo ✅ Deployment complete!
echo If GitHub Pages is enabled, your site will rebuild automatically.
echo.
git status

pause
