@echo off
setlocal ENABLEDELAYEDEXPANSION

rem Gå til mappen der scriptet ligger (repo-root)
cd /d "%~dp0"

echo === Cleaning old Hugo output (docs and public) ===
if exist public (
rmdir /S /Q public
)
if exist docs (
rmdir /S /Q docs
)

echo === Building site with Hugo ===
hugo --cleanDestinationDir
if errorlevel 1 (
echo Hugo build failed. Aborting.
exit /b 1
)

echo === Git status before publishing ===
git status

echo.
echo === Staging changes ===
git add .

rem Lag en enkel commit-melding med dato og tid
for /f "tokens=1-3 delims=." %%a in ("%date%") do set CDATE=%%a-%%b-%%c
set CTIME=%time: =0%
set CTIME=%CTIME::=-%
set MSG=Publish %CDATE% %CTIME%

echo.
echo === Committing with message: %MSG% ===
git commit -m "%MSG%"
if errorlevel 1 (
echo No changes to commit or commit failed. Continuing...
) else (
echo Commit created.
)

echo.
echo === Pushing local main to origin/main (force-with-lease) ===
git push --force-with-lease origin main

echo.
echo === Done. Local state is now published to GitHub ===
endlocal