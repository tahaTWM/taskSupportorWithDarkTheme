@echo off 
git init 
git add -A

set /p repo="Enter Repo Name : "
git remote add %repo% https://github.com/tahaTWM/%repo%.git

rem set /p id="Enter Commit Message : "
set /p time=%date% - %time%
git commit -m %time%

set /p branch="main or master ? "
if %branch% == main (git branch -M %branch%) 


git push -u %repo% %branch% 
set /p id="it is Done Press any key to close.."
