@echo off
cd /d "%~dp0"

echo === HARD RESET PUBLISH: local -> origin/main ===

echo Cleaning local public and docs folders...
if exist public rmdir /S /Q public
if exist docs rmdir /S /Q docs

echo.
echo Building site with Hugo to docs/...
hugo --cleanDestinationDir

echo.
echo Staging ALL changes (add -A, including deletions)...
git add -A

echo.
echo Committing...
git commit -m "Hard reset publish"

echo.
echo Forcing push to origin/main...
git push --force origin main

echo.
echo DONE: remote now matches local exactly.