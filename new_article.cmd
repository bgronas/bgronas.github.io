@echo off
setlocal EnableExtensions DisableDelayedExpansion
title New Hugo Article Creator (Flat CMD)

echo =====================================================
echo =============== CREATE NEW HUGO ARTICLE ==============
echo =====================================================
echo.

where hugo >nul 2>&1
if errorlevel 1 goto NOHUGO

where sed >nul 2>&1
if errorlevel 1 goto NOSED

:: Read title safely (preserve !)
setlocal DisableDelayedExpansion
set /p "POST_TITLE=Enter the title of your new post: "
endlocal & set "POST_TITLE=%POST_TITLE%"

if "%POST_TITLE%"=="" goto NOTITLE

:: slug (assume safe input)
set "POST_SLUG=%POST_TITLE: =-%"
set "POST_SLUG=%POST_SLUG:.=%"
set "POST_SLUG=%POST_SLUG:,=%"

:trimSlugDash
if "%POST_SLUG:~-1%"=="-" set "POST_SLUG=%POST_SLUG:~0,-1%" & goto trimSlugDash

for /f "tokens=2 delims==." %%a in ('wmic os get localdatetime /value') do set DTS=%%a
set "HUGO_DATE=%DTS:~0,4%-%DTS:~4,2%-%DTS:~6,2%"

set "POST_PATH=post/%HUGO_DATE%-%POST_SLUG%"
set "POST_DIR=content\post\%HUGO_DATE%-%POST_SLUG%"
set "POST_FILE=%POST_DIR%\index.md"

if exist "%POST_FILE%" goto EXISTS

echo Creating post from archetype...
hugo new "%POST_PATH%/index.md"
if errorlevel 1 goto HUGOFAIL

timeout /t 1 /nobreak >nul

:: Copy images (no parentheses)
if not exist "images\" goto SKIPCOPY
robocopy "images" "%POST_DIR%" /E /R:1 /W:1 /ZB /NFL /NDL /NJH /NJS /NP >nul
if errorlevel 8 goto ROBOFAIL
:SKIPCOPY

:: sed title replacement (escape minimal sed replacement chars)
set "TITLE_ESC=%POST_TITLE%"
set "TITLE_ESC=%TITLE_ESC:"=%"
set "TITLE_ESC=%TITLE_ESC:\=\\%"
set "TITLE_ESC=%TITLE_ESC:&=\&%"
set "TITLE_ESC=%TITLE_ESC:/=\/%"

sed -i "s/^title:.*/title: \"%TITLE_ESC%\"/" "%POST_FILE%"

echo Launching Typora...
start "" "C:\Program Files\Typora\Typora.exe" "%POST_FILE%"

echo.
echo ✅ Created: %POST_FILE%
echo.
pause
exit /b 0

:NOHUGO
echo [ERROR] Hugo not found in PATH.
exit /b 1

:NOSED
echo [ERROR] sed not found in PATH.
exit /b 1

:NOTITLE
echo [ERROR] You must provide a title.
exit /b 1

:EXISTS
echo [WARN] A post already exists: %POST_FILE%
exit /b 1

:HUGOFAIL
echo [ERROR] Hugo failed to create the new post.
exit /b 1

:ROBOFAIL
echo [ERROR] robocopy failed (exit code %errorlevel%).
exit /b 1
