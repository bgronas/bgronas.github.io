@echo off
setlocal enabledelayedexpansion
title New Hugo Article Creator (Archetype Aware)

echo =====================================================
echo =============== CREATE NEW HUGO ARTICLE ==============
echo =====================================================
echo.

:: 1. Verify Hugo exists
where hugo >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Hugo not found in PATH.
  exit /b 1
)

:: 2. Ask for post title
set /p POST_TITLE=Enter the title of your new post: 
if "%POST_TITLE%"=="" (
  echo [ERROR] You must provide a title.
  exit /b 1
)

:: 3. Generate slug-friendly name
set "POST_SLUG=%POST_TITLE: =-%"
set "POST_SLUG=%POST_SLUG:.=%"
set "POST_SLUG=%POST_SLUG:,=%"

:: 4. Get current date (YYYY-MM-DD)
for /f "tokens=2 delims==." %%a in ('wmic os get localdatetime /value') do set DTS=%%a
set YEAR=%DTS:~0,4%
set MONTH=%DTS:~4,2%
set DAY=%DTS:~6,2%
set HUGO_DATE=%YEAR%-%MONTH%-%DAY%

:: 5. Define path for the new post bundle
set "POST_PATH=post/%HUGO_DATE%-%POST_SLUG%"
set "POST_DIR=content\%POST_PATH%"
set "POST_FILE=%POST_DIR%\index.md"

:: 6. Ensure no collision
if exist "%POST_FILE%" (
  echo [WARN] A post already exists: %POST_FILE%
  exit /b 1
)

:: 7. Create new post using archetype
echo Creating post from archetype...
hugo new "%POST_PATH%/index.md"
if errorlevel 1 (
  echo [ERROR] Hugo failed to create the new post.
  exit /b 1
)

:: 8. Add title override (in case archetype uses .Name)
powershell -Command "(Get-Content '%POST_FILE%') -replace 'title:.*', 'title: \"%POST_TITLE%\"' | Set-Content '%POST_FILE%'"

:: 9. Open Typora for editing
echo Launching Typora...
start "" "C:\Program Files\Typora\Typora.exe" "%POST_FILE%"

echo.
echo ✅ Created: %POST_FILE%
echo.
pause
