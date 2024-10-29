@echo off
:: Repository URL: https://github.com/bgronas/bgronas.github.io
:: Repository Code: https://github.com/bgronas/bgronas.github.io.git

K:



:: Set the path to your main directory and specify the repository details
set "main_directory=K:\DATA\DOCUMENTS\GitHub\bgronas.github.io"
set "repository_url=https://github.com/bgronas/bgronas.github.io.git"
set "repository_name=bgronas.github.io"

:: Change the current directory to the location of the repository
cd /d "%main_directory%\%repository_name%"

:: Check if the repository is already cloned (i.e., downloaded) to your local machine
if not exist "%main_directory%\%repository_name%" (
    echo Cloning repository...        :: If not cloned, clone the repository from GitHub
    git clone %repository_url% "%main_directory%\%repository_name%"
) else (
    echo Repository already cloned. Pulling latest changes...
    git pull                          :: If already cloned, update it with the latest changes from GitHub
)

:: Stage all changes (add them to the next commit)
echo Adding changes...
git add --all                        :: Add all changes in the repository to be committed
git add *                            :: Extra addition command to ensure everything is added

:: Collect a commit message from the user or generate a default one if left blank
set "commit_message=Commit: %DATE% %TIME% by @%USERNAME% [Bengt, Oslo, Norway]" :: Default commit message

:: Commit the changes with the provided or default message
echo Committing changes...
git commit -m "%commit_message%"

:: Pull the latest changes from GitHub before pushing, to ensure your changes are up-to-date
echo Pulling latest changes before pushing...
git pull

:: Push your changes to the remote repository on GitHub
echo Pushing changes...
:: git push -u origin main
git push

:: Indicate that the script has finished running
echo All done. Exiting...
