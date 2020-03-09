@echo off
setlocal enabledelayedexpansion
:: 直接 goto gotAdmin
goto gotAdmin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (goto UACPrompt) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:: 上面的注释掉了
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"
@start "" "mstsc.exe" >nul 2>nul
ECHO.
ECHO   启动完成，退出...
ECHO.
TIMEOUT /T 3 /nobreak >NUL & EXIT
