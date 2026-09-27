@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem ==========================================================================
rem  publish.cmd - build Hugo (hugo-clarity) to docs\ and push to GitHub Pages
rem
rem  Usage:  publish.cmd              interactive, safe push
rem          publish.cmd /y           no prompts
rem          publish.cmd /force       overwrite origin/main (force-with-lease)
rem          publish.cmd /lintall     img lint on ALL posts, not just changed ones
rem ==========================================================================

set "SELF=%~nx0"
cd /d "%~dp0" || goto :FAIL_NOREPO

set "BRANCH=main"
set "REMOTE=origin"
set "SITE_URL=https://bgronas.github.io/"
set "HUGO_FLAGS=--gc --minify --cleanDestinationDir --printPathWarnings --logLevel warn -e production"

set "AUTO=0"
set "FORCE=0"
set "LINTALL=0"
:ARGS
if "%~1"=="" goto :ARGS_DONE
if /i "%~1"=="/y"       set "AUTO=1"
if /i "%~1"=="/force"   set "FORCE=1"
if /i "%~1"=="/lintall" set "LINTALL=1"
shift
goto :ARGS
:ARGS_DONE

set "OLDCP="
for /f "tokens=2 delims=:." %%c in ('chcp') do set /a "OLDCP=%%c" 2>nul
chcp 65001 >nul

set "TMPDIR_P=%TEMP%\hugo_publish_%RANDOM%%RANDOM%"
mkdir "%TMPDIR_P%" >nul 2>&1

echo.
echo === 1/8 Tools and repository ===
where hugo >nul 2>&1 || goto :FAIL_NOHUGO
where git  >nul 2>&1 || goto :FAIL_NOGIT
for /f "delims=" %%v in ('hugo version') do echo     %%v
git rev-parse --is-inside-work-tree >nul 2>&1 || goto :FAIL_NOREPO
set "CUR_BRANCH="
for /f "delims=" %%b in ('git rev-parse --abbrev-ref HEAD') do set "CUR_BRANCH=%%b"
if /i not "%CUR_BRANCH%"=="%BRANCH%" goto :FAIL_BRANCH
echo     Branch: %CUR_BRANCH%
dir /s /b /a ".git\*conflicted copy*" >nul 2>&1
if not errorlevel 1 goto :FAIL_DROPBOX

echo.
echo === 2/8 Environment ===
tasklist /fi "imagename eq hugo.exe" /nh 2>nul | find /i "hugo.exe" >nul
if errorlevel 1 goto :HUGO_IDLE
echo     WARNING: hugo.exe is already running - probably "hugo server".
echo              A running server can write dev/draft pages into docs\ during the build.
echo              Stop it with Ctrl+C in its window before publishing.
if "%AUTO%"=="1" goto :HUGO_IDLE
choice /c YN /n /m "    Continue anyway? [Y/N] "
if errorlevel 2 goto :ABORTED
:HUGO_IDLE
if not exist "static\" mkdir "static"
if not exist "static\.nojekyll" (
  type nul > "static\.nojekyll"
  echo     Created static\.nojekyll - Jekyll will no longer post-process docs\
) else (
  echo     static\.nojekyll present
)

echo.
echo === 3/8 Sync check against %REMOTE%/%BRANCH% ===
git fetch -q %REMOTE% %BRANCH% || goto :FAIL_FETCH
set "BEHIND=0"
for /f %%n in ('git rev-list --count HEAD..%REMOTE%/%BRANCH% 2^>nul') do set "BEHIND=%%n"
if "%BEHIND%"=="0" (
  echo     Up to date
  goto :SYNC_DONE
)
echo     %REMOTE%/%BRANCH% has %BEHIND% commit^(s^) you do not have locally.
if "%FORCE%"=="1" (
  echo     /force given: those commits will be overwritten.
  goto :SYNC_DONE
)
goto :FAIL_BEHIND
:SYNC_DONE

echo.
echo === 4/8 Content lint: raw img tags ===
rem hugo-clarity JS turns the alt text of every raw img tag into a caption
rem and DELETES the element that follows the image: a link, bold text etc.
rem Permanent fix: assets\js\index.js from patch_clarity_rawimg.py.
rem Per-image fix: title=" " on the img tag.
findstr /c:"raw-img-guard" "assets\js\index.js" >nul 2>&1
if errorlevel 1 goto :LINT_RUN
echo     Raw-img guard active in assets\js\index.js - no lint needed
goto :LINT_DONE
:LINT_RUN
set "LINT=%TMPDIR_P%\lint.txt"
type nul > "%LINT%"
if "%LINTALL%"=="1" (
  findstr /s /i /n /c:"<img " "content\*.md" 2>nul | findstr /v /i /c:"title=" > "%LINT%"
  goto :LINT_EVAL
)
set "LIST=%TMPDIR_P%\changed.txt"
git -c core.quotepath=false diff --name-only --diff-filter=d %REMOTE%/%BRANCH% -- content > "%LIST%" 2>nul
git -c core.quotepath=false ls-files --others --exclude-standard -- content >> "%LIST%" 2>nul
for /f "usebackq delims=" %%F in ("%LIST%") do call :LINTFILE "%%F"
:LINT_EVAL
set "LINTSIZE=0"
for %%A in ("%LINT%") do set "LINTSIZE=%%~zA"
if "%LINTSIZE%"=="0" (
  echo     OK - no unguarded img tags in changed posts
  goto :LINT_DONE
)
echo     WARNING: these img tags will be mangled by the theme:
for /f "usebackq delims=" %%L in ("%LINT%") do echo       %%L
echo     Fix once for all posts:  uv run patch_clarity_rawimg.py
echo     Or per image:            add title=" " to the img tag
if "%AUTO%"=="1" goto :LINT_DONE
choice /c YN /n /m "    Publish anyway? [Y/N] "
if errorlevel 2 goto :ABORTED
:LINT_DONE

echo.
echo === 5/8 Build: hugo %HUGO_FLAGS% ===
if exist "public\" rmdir /s /q "public"
rem Dropbox/AV/hugo-server can transiently lock a file docs\ is about to
rem delete. Retry a few times before giving up - most locks clear in 1-2s.
set "BUILD_TRY=0"
:BUILD_RETRY
set /a "BUILD_TRY+=1"
hugo %HUGO_FLAGS%
if not errorlevel 1 goto :BUILD_OK
if %BUILD_TRY% GEQ 5 goto :FAIL_BUILD
echo     Build failed ^(attempt %BUILD_TRY%/5^) - probably a locked file. Retrying in 2s...
timeout /t 2 /nobreak >nul
goto :BUILD_RETRY
:BUILD_OK

echo.
echo === 6/8 Verify build output ===
if not exist "docs\index.html" goto :FAIL_NOINDEX
if not exist "docs\.nojekyll"  goto :FAIL_NOJEKYLL
findstr /s /m /i /c:"localhost" "docs\sitemap.xml" >nul 2>&1
if not errorlevel 1 goto :FAIL_LOCALHOST
echo     docs\index.html, docs\.nojekyll present; no localhost URLs

echo.
echo === 7/8 Stage and commit ===
rem Re-index docs\ from disk so file-name case matches exactly. Windows is
rem case-insensitive, GitHub Pages is not: Image.PNG vs image.png = 404.
git rm -r -q --cached --ignore-unmatch docs >nul
git add -A
if errorlevel 1 goto :FAIL_GIT
git diff --cached --quiet
if not errorlevel 1 (
  echo     Nothing changed since last publish.
  goto :PUSH
)
git diff --cached --shortstat
set "MSG=%TMPDIR_P%\msg.txt"
> "%MSG%" echo Publish site from %COMPUTERNAME%
>>"%MSG%" echo.
git -c core.quotepath=false diff --cached --name-only --diff-filter=AMR -- content assets layouts >> "%MSG%"
git commit -q -F "%MSG%"
if errorlevel 1 goto :FAIL_GIT
for /f "delims=" %%c in ('git log -1 --format^=%%h') do echo     Commit %%c created

:PUSH
echo.
echo === 8/8 Push to %REMOTE%/%BRANCH% ===
if "%FORCE%"=="1" (
  git push --force-with-lease %REMOTE% %BRANCH%
) else (
  git push %REMOTE% %BRANCH%
)
if errorlevel 1 goto :FAIL_PUSH

echo.
echo DONE. GitHub Pages redeploys in about 1 minute: %SITE_URL%
echo Hard-refresh the browser [Ctrl+F5] if you still see the old version.
where gh >nul 2>&1 && gh run list --limit 1 --workflow "pages-build-deployment" 2>nul
set "RC=0"
goto :END

rem ------------------------------------------------------------- subroutines
:LINTFILE
set "LF=%~1"
set "LF=%LF:/=\%"
for %%X in ("%LF%") do if /i not "%%~xX"==".md" exit /b 0
if not exist "%LF%" exit /b 0
for /f "tokens=1* delims=:" %%a in ('findstr /i /n /c:"<img " "%LF%" ^| findstr /v /i /c:"title="') do >>"%LINT%" echo %LF%:%%a: %%b
exit /b 0

rem ---------------------------------------------------------------- failures
:FAIL_NOREPO
echo [ERROR] Not a git repository: %CD%
goto :FAILED
:FAIL_NOHUGO
echo [ERROR] hugo not found in PATH.
goto :FAILED
:FAIL_NOGIT
echo [ERROR] git not found in PATH.
goto :FAILED
:FAIL_BRANCH
echo [ERROR] On branch "%CUR_BRANCH%", expected "%BRANCH%". Run: git switch %BRANCH%
goto :FAILED
:FAIL_FETCH
echo [ERROR] git fetch failed - see the git message above.
goto :FAILED
:FAIL_DROPBOX
echo [ERROR] Dropbox conflicted copies inside .git - they corrupt refs:
dir /s /b /a ".git\*conflicted copy*"
echo         Move them out of .git, then run: git fsck --no-dangling
goto :FAILED
:FAIL_BEHIND
echo [ERROR] Remote is ahead. Either:
echo           git pull --rebase %REMOTE% %BRANCH%    then run publish again, or
echo           %SELF% /force                     to overwrite the remote
goto :FAILED
:FAIL_BUILD
echo [ERROR] Hugo build failed - nothing committed or pushed.
goto :FAILED
:FAIL_NOINDEX
echo [ERROR] docs\index.html missing after build. Check publishDir in config.toml.
goto :FAILED
:FAIL_NOJEKYLL
echo [ERROR] docs\.nojekyll missing after build.
goto :FAILED
:FAIL_LOCALHOST
echo [ERROR] docs\sitemap.xml contains localhost URLs - a hugo server build leaked in.
echo         Stop hugo server and run publish again.
goto :FAILED
:FAIL_GIT
echo [ERROR] git staging/commit failed.
goto :FAILED
:FAIL_PUSH
echo [ERROR] git push failed. The commit is local; fix the cause and re-run.
goto :FAILED
:ABORTED
echo Aborted. Nothing committed or pushed.
goto :FAILED

:FAILED
set "RC=1"

:END
if defined TMPDIR_P if exist "%TMPDIR_P%\" rmdir /s /q "%TMPDIR_P%"
if defined OLDCP chcp %OLDCP% >nul
echo %CMDCMDLINE% | findstr /i /c:"%SELF%" >nul && pause
endlocal & exit /b %RC%