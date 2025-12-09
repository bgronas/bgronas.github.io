@echo off
cd /d "%~dp0"

echo Cleaning local public and docs...
if exist public rmdir /S /Q public
if exist docs rmdir /S /Q docs

echo Building with Hugo...
hugo --cleanDestinationDir

echo Staging...
git add -A

echo Committing...
git commit -m "Regular publish"

echo Pushing (no force)...
git push origin main

echo Done.
