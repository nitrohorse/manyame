@echo off
setlocal EnableExtensions
if exist "manyame.sh" goto :check
curl -sLO https://raw.githubusercontent.com/whew/manyame/master/manyame.sh
:check
for /f "tokens=* USEBACKQ" %%a in (
`for %%I in ^(manyame.sh^) do @echo %%~zI`
) do (
set local=%%a
)
FOR /F "tokens=* USEBACKQ" %%F IN (
`curl -sI https://raw.githubusercontent.com/whew/manyame/master/manyame.sh  ^| busybox awk "/Content-Length/ { print $2 }"`) DO (
SET remote=%%F
)
IF %remote% EQU %local% (GOTO uniqLoop) ELSE (GOTO dl)
:dl
curl -sLO https://raw.githubusercontent.com/whew/manyame/master/manyame.sh
GOTO uniqLoop
:uniqLoop
set "uniqueFileName=%tmp%\rand%RANDOM%.tmp"
if exist "%uniqueFileName%" goto :uniqLoop
:uniqBat
set "uniqueBatName=%tmp%\bat%RANDOM%.bat"
if exist "%uniqueBatName%" goto :uniqBat
echo cd /d %cd% > %uniqueBatName%
busybox bash manyame.sh "%uniqueFileName%" "%uniqueBatName%" %*
call %uniqueBatName%
echo Success! Press enter to exit...
pause >nul
