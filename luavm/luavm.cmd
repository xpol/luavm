@echo off

:GETTEMPNAME
SET SESSION_UPDATE_BATCH=%TEMP%\luavm-update-session-%RANDOM%.bat
IF EXIST "%SESSION_UPDATE_BATCH%" GOTO :GETTEMPNAME
echo. > %SESSION_UPDATE_BATCH%

setlocal
"%~dp0versions\luajit-2.1\luajit.exe" "%~dp0luavm.lua" %*
endlocal

call %SESSION_UPDATE_BATCH%
del %SESSION_UPDATE_BATCH%
set SESSION_UPDATE_BATCH=
