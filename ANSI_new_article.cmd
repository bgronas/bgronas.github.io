@echo off
setlocal EnableExtensions EnableDelayedExpansion
title New Hugo Article Creator (DEBUG)

set "DEBUG=1"

echo =====================================================
echo =============== CREATE NEW HUGO ARTICLE ==============
echo ===================== DEBUG =========================
echo =====================================================
echo.

call :DBG "START" "CD=%CD%"
call :DBG "START" "SCRIPT=%~f0"
call :DBG "START" "SCRIPTDIR=%~dp0"

:: 1. Verify Hugo exists
call :DBG "STEP1" "Checking Hugo in PATH..."
where hugo >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Hugo not found in PATH.
  exit /b 1
)
call :DBG "STEP1" "Hugo found OK"

:: 2. Ask for post title
set /p POST_TITLE=Enter the title of your new post: 
call :DBG "STEP2" "POST_TITLE=[%POST_TITLE%]"
if "%POST_TITLE%"=="" (
  echo [ERROR] You must provide a title.
  exit /b 1
)

:: Trim trailing spaces (important!)
:trimtitle
if "%POST_TITLE:~-1%"==" " (
  set "POST_TITLE=%POST_TITLE:~0,-1%"
  goto trimtitle
)
call :DBG "STEP2" "POST_TITLE trimmed=[%POST_TITLE%]"

:: 3. Generate slug-friendly name
set "POST_SLUG=%POST_TITLE: =-%"
call :DBG "STEP3" "POST_SLUG after spaces=[%POST_SLUG%]"

set "POST_SLUG=%POST_SLUG:.=%"
call :DBG "STEP3" "POST_SLUG after dots=[%POST_SLUG%]"

set "POST_SLUG=%POST_SLUG:,=%"
call :DBG "STEP3" "POST_SLUG after commas=[%POST_SLUG%]"

:: Remove trailing '-' if any
:trimdash
if "%POST_SLUG:~-1%"=="-" (
  set "POST_SLUG=%POST_SLUG:~0,-1%"
  goto trimdash
)
call :DBG "STEP3" "POST_SLUG trimmed=[%POST_SLUG%]"

:: 4. Get current date (YYYY-MM-DD)
call :DBG "STEP4" "Reading datetime..."
for /f "tokens=2 delims==." %%a in ('wmic os get localdatetime /value') do set DTS=%%a
call :DBG "STEP4" "DTS=[%DTS%]"

set "YEAR=%DTS:~0,4%"
set "MONTH=%DTS:~4,2%"
set "DAY=%DTS:~6,2%"
set "HUGO_DATE=%YEAR%-%MONTH%-%DAY%"

call :DBG "STEP4" "YEAR=[%YEAR%]"
call :DBG "STEP4" "MONTH=[%MONTH%]"
call :DBG "STEP4" "DAY=[%DAY%]"
call :DBG "STEP4" "HUGO_DATE=[%HUGO_DATE%]"

:: 5. Define paths
set "POST_PATH=post/%HUGO_DATE%-%POST_SLUG%"
set "POST_DIR=content\post\%HUGO_DATE%-%POST_SLUG%"
set "POST_FILE=%POST_DIR%\index.md"

call :DBG "STEP5" "POST_PATH=[%POST_PATH%]"
call :DBG "STEP5" "POST_DIR=[%POST_DIR%]"
call :DBG "STEP5" "POST_FILE=[%POST_FILE%]"

:: 6. Ensure no collision
if exist "%POST_FILE%" (
  echo [WARN] A post already exists: %POST_FILE%
  exit /b 1
)
call :DBG "STEP6" "No collision OK"

:: 7. Create new post using archetype
echo Creating post from archetype...
call :DBG "STEP7" "Running: hugo new ""%POST_PATH%/index.md"""
hugo new "%POST_PATH%/index.md"
set "HUGO_RC=%errorlevel%"
call :DBG "STEP7" "HUGO errorlevel=%HUGO_RC%"
if not "%HUGO_RC%"=="0" (
  echo [ERROR] Hugo failed to create the new post.
  exit /b 1
)

call :DBG "STEP7" "After Hugo, checking file exists..."
if exist "%POST_FILE%" (
  call :DBG "STEP7" "POST_FILE exists OK"
) else (
  call :DBG "STEP7" "POST_FILE DOES NOT EXIST!"
  echo [ERROR] Expected file missing: %POST_FILE%
  exit /b 1
)

call :DBG "STEP7" "Dir listing of POST_DIR:"
dir "%POST_DIR%"

:: 7.5 Sleep 1 second (lock avoidance)
call :DBG "STEP7.5" "Sleeping 1 second..."
timeout /t 1 /nobreak >nul
call :DBG "STEP7.5" "Wake"

:: 8. Copy images (in subroutine)
call :DBG "STEP8" "About to copy images..."
call :COPY_IMAGES
if errorlevel 1 (
  echo [ERROR] Copy images step failed.
  exit /b 1
)
call :DBG "STEP8" "Copy images OK"

:: 9. Title override (optional, kept OFF by default to reduce noise)
set "DO_TITLE_OVERRIDE=0"
call :DBG "STEP9" "DO_TITLE_OVERRIDE=%DO_TITLE_OVERRIDE%"
if "%DO_TITLE_OVERRIDE%"=="1" (
  call :TITLE_OVERRIDE
  if errorlevel 1 (
    echo [ERROR] Title override failed.
    exit /b 1
  )
)

:: 10. Open Typora for editing
echo Launching Typora...
call :DBG "STEP10" "Launching Typora with POST_FILE=[%POST_FILE%]"
start "" "C:\Program Files\Typora\Typora.exe" "%POST_FILE%"

echo.
echo ? Created: %POST_FILE%
echo.
pause
exit /b 0


:: ---------------- SUBROUTINES ----------------

:DBG
if "%DEBUG%"=="1" echo [DEBUG %~1] %~2
exit /b 0

:COPY_IMAGES
call :DBG "COPY" "CD=%CD%"
call :DBG "COPY" "Looking for images\"
if not exist "images\" (
  call :DBG "COPY" "No images\ folder found. Skipping."
  exit /b 0
)

call :DBG "COPY" "Copying FROM=[%CD%\images] TO=[%POST_DIR%]"
call :DBG "COPY" "robocopy images ""%POST_DIR%"" /E /R:1 /W:1 /ZB"
robocopy "images" "%POST_DIR%" /E /R:1 /W:1 /ZB
set "RC=%errorlevel%"
call :DBG "COPY" "robocopy errorlevel=%RC% (>=8 is failure)"
if %RC% GEQ 8 exit /b 1
exit /b 0

:TITLE_OVERRIDE
:: Intentionally blank for now (you said avoid PowerShell)
:: If you want, we can do a safe title override later.
exit /b 0
