@echo off
cd /d "%~dp0"

echo ==========================================================
echo === 💥 HARD ONE-WAY PUBLISH: local (HEAD) -> origin/main ===
echo === WARNING: This forcefully overwrites remote content ===
echo ==========================================================
echo.

echo 1. Cleaning local build output (public and docs)...
if exist public rmdir /S /Q public
if exist docs rmdir /S /Q docs

echo.
echo 2. Wiping Git staging area (index) to ensure full re-add...
git rm -r --cached .
if errorlevel 1 echo [WARN] Could not untrack files (already clean?), continuing.

echo.
echo 3. Building site with Hugo to docs/ (Minifying and cleaning destination dir)...
hugo --minify --cleanDestinationDir
if errorlevel 1 goto BUILD_FAILED

echo.
echo 4. Staging ALL local changes (git add -A) including untracked content...
git add -A
git add .


echo.
echo 5. Creating 'Hard publish' commit...
git commit -m "Publish: %COMPUTERNAME% content is King. %DATE% %TIME%"
if errorlevel 1 echo No changes to commit, continuing anyway. [cite: 13]

echo.
echo 6. Forcing push to origin/main (ONE-WAY OVERWRITE)... [cite: 14]
git push --force origin main

echo.
echo ✅ {Local Build Clean} + {Index Wipe &  Re-add} + {Remote Force Push}
echo ✅ DONE: Remote site now mirrors local HEAD EXACTLY. [cite: 15]
goto :EOF

:BUILD_FAILED
echo ❌ Hugo build failed. Aborting.
goto :EOF