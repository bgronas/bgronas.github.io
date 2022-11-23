@echo off
E:
CD "E:\DATA\Dropbox (Personal)\HUGO\Sites\bgronas.github.io"
git add *
git status -s | find /i "??" > NUL 2>&1
IF %errorlevel%==0 (
            echo "The working directory is dirty. Please commit any pending changes."
			exit 1
    ) ELSE (
        echo cool
    )
echo "Deleting old publication"
del /F /S /Q public
RMDIR /S /Q public
MKDIR public
hugo 
del /F /S /Q ".git\worktrees\public"
echo %DATE% %TIME% > date-time_last_updated.txt
cd public
git add --all 
git add *
git commit -m "Update: %DATE% %TIME%" 
git push --all
cd ..
