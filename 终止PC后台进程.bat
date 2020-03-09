@echo off
setlocal enabledelayedexpansion & color 0A
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (goto UACPrompt) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"
mode con: lines=35 cols=120
title PC Process Killer(终止PC后台应用进程  Powered Weasley)           日期: %date%   时间: %time%
REM -----------------------------------------------------------
set exeName="TeamViewer.exe" & call :taskkillExeWithPid
set exeName="TeamViewer_Service.exe" & call :taskkillExeWithPid
set exeName="tv_w32.exe" & call :taskkillExeWithPid
set exeName="tv_x64.exe" & call :taskkillExeWithPid
set exeName="IDMan.exe" & call :taskkillExeWithPid
set exeName="GoogleCrashHandler.exe" & call :taskkillExeWithPid
set exeName="SunloginClient.exe" & call :taskkillExeWithPid
set exeName="node.exe" & call :taskkillExeWithPid
set exeName="java.exe" & call :taskkillExeWithPid
set exeName="wps.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="WinStore.App.exe" & call :taskkillExeWithPid
set exeName="LocalBridge.exe" & call :taskkillExeWithPid
set exeName="GoogleCrashHandler64.exe" & call :taskkillExeWithPid
set exeName="MicrosoftEdge.exe" & call :taskkillExeWithPid
set exeName="SearchUI.exe" & call :taskkillExeWithPid
set exeName="TeamViewer_Service.exe" & call :taskkillExeWithPid
set exeName="wwbizsrv.exe" & call :taskkillExeWithPid
set exeName="YourPhone.exe" & call :taskkillExeWithPid
set exeName="AlibabaProtect.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid

for /l %%W in (5,-1,0) do (
cls
echo.
echo.
echo.
echo.
echo.
echo.
ECHO 			 恭喜，你笔记本的后台不用的进程已成功被终止了.
echo.
ECHO 			 此操不会对你的电脑造成伤害，相反能提升计算机的运行速度.
echo.
ECHO 			 请放心使用，程序将会在 %%W 秒后自动退出.
echo.
echo.
echo.
echo.
echo.
echo.
ping 127.1 -n 2 >nul
)
EXIT
REM -----------------------------------------------------------
:taskkillExeWithPid
@echo off
setlocal enabledelayedexpansion
REM set exeName="SunloginClient.exe"
del "D:\pidTmp.txt" >nul 2>nul
tasklist|find /i %exeName%>D:\pidTmp.txt
for /f "tokens=2 delims= " %%i in (D:\pidTmp.txt) do (
	set /a count+=1
	echo.     %exeName%的pidID为: %%i;
	taskkill /pid %%i /t /f
	taskkill /t /f /im %exeName%
)
echo.
echo %exeName%共启动了 %count% 个应用程序。
echo.
set count=0;
del "D:\pidTmp.txt" >nul 2>nul & exit /b
