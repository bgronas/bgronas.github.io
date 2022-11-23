@echo off
cls
E:
CD "E:\DATA\Dropbox (Personal)\HUGO\Sites\bgronas.github.io"
IF NOT EXIST "..\..\Sites" (
    You're not positioned in a SITE folder
    exit 1
) ELSE (
   echo.
   echo "# SITE=%CD%"
   echo.
)
   echo.

for /F "tokens=6" %%d in ('net time \\%COMPUTERNAME%^|findstr /I /C:"%COMPUTERNAME%"') do set today=%%d
if (%today:~1,1%)==(/) set today=0%today%
if (%today:~4,1%)==(/) set today=%today:~0,3%0%today:~3,6%
set day=%today:~0,2%
set month=%today:~3,2%
set year=%today:~8,2%
set /p input=Title on bgronas.github.io post: 
set Input=%Input% [%today%].md

:: echo Blog: "%Input%"
:: echo running: "hugo new "post\20%year%-%month%-%day%\%input%""

echo # CREATING A NEW POST
hugo new "post\20%year%-%month%-%day%\%input%"

:: echo # COPYING IMAGES
:: xcopy "..\..\IMAGES\*.png" "content\post\20%year%-%month%-%day%" /S /C /D /-Y 
:: xcopy "..\..\IMAGES\*.jpg" "content\post\20%year%-%month%-%day%" /S /C /D /-Y 

echo # EDITING THE NEW BLOG POST
MOVE ".\content\post\20%year%-%month%-%day%\%input%" ".\content\post\20%year%-%month%-%day%\index.md"
REM "C:\Program Files\Notepad++\notepad++.exe" ".\content\post\20%year%-%month%-%day%\index.md"
psexec -d "C:\Program Files\Typora\Typora.exe" ".\content\post\20%year%-%month%-%day%\index.md"