@echo off
cd /d "%~dp0"

echo === HARD ONE-WAY PUBLISH: local -> origin/main ===

echo Cleaning local public and docs...
if exist public rmdir /S /Q public
if exist docs rmdir /S /Q docs

echo.
echo Building site with Hugo to docs/...
hugo --cleanDestinationDir
if errorlevel 1 goto BUILD_FAILED

echo.
echo Staging ALL changes (git add -A)...
git add -A

echo.
echo Committing...
git commit -m "Hard publish"
if errorlevel 1 echo No changes to commit, continuing anyway.

echo.
echo Forcing push to origin/main (ONE-WAY)...
git push --force origin main

echo.
echo DONE: remote now mirrors local HEAD exactly.
goto :EOF

:BUILD_FAILED
echo Hugo build failed. Aborting.
goto :EOF