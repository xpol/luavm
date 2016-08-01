@echo off

:GETTEMPNAME
SET LUAVMTMPFILE=%TEMP%\luavm-update-session-%RANDOM%.bat
IF EXIST "%LUAVMTMPFILE%" GOTO :GETTEMPNAME
echo. > %LUAVMTMPFILE%

setlocal
"%~dp0..\versions\luajit-2.1\luajit.exe" "%~dp0luavm.lua" %*
endlocal

call %LUAVMTMPFILE%
del %LUAVMTMPFILE%
set LUAVMTMPFILE=
