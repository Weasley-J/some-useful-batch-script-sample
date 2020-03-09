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
TITLE This is an example     Date: %date%   Time: %time%
set exeName="java.exe" & call :taskkillExeWithPid
set exeName="wps.exe" & call :taskkillExeWithPid
set exeName="iexplore.exe" & call :taskkillExeWithPid
cd /d "E:\apache-tomcat-9.0.27\bin\"
call startup.bat
EXIT
::pause

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