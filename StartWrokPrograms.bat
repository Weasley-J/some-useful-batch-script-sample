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
TITLE 启动办公程序        %date%  %time%
ECHO.
ECHO   关闭程序...
ECHO.
taskkill /f /im "notepad++.exe" >nul 2>nul
taskkill /f /im "WeChat.exe" >nul 2>nul
taskkill /f /im "QQScLauncher.exe" >nul 2>nul
taskkill /f /im "TIM.exe" >nul 2>nul
taskkill /f /im "UCBrowser.exe" >nul 2>nul
taskkill /f /im "360chrome.exe" >nul 2>nul
taskkill /f /im "eclipse.exe" >nul 2>nul
taskkill /f /im "idea64.exe" >nul 2>nul
taskkill /f /im "Foxmail.exe" >nul 2>nul
taskkill /f /im "firefox.exe" >nul 2>nul
taskkill /f /im "Studio 3T.exe" >nul 2>nul
taskkill /f /im "p4v.exe" >nul 2>nul
:: taskkill /f /im "explorer.exe" >nul 2>nul
:: @start "" "explorer.exe" >nul 2>nul
ECHO.
ECHO   启动程序...
ECHO.
:: @start "" "C:\Program Files (x86)\TeamViewer\TeamViewer.exe" >nul 2>nul
:: @start "" "C:\Users\liuwe\AppData\Roaming\DesktopCal\desktopcal.exe" >nul 2>nul
@start "" "C:\Program Files\Notepad++\notepad++.exe" >nul 2>nul
@start "" "C:\Program Files (x86)\Tencent\WeChat\WeChat.exe" >nul 2>nul
@start "" "C:\Program Files (x86)\Tencent\TIM\Bin\QQScLauncher.exe" >nul 2>nul
@start "" "C:\Program Files\Mozilla Firefox\firefox.exe" >nul 2>nul
@start "" "D:\MyApplications\360Chrome\Chrome\Application\360chrome.exe" >nul 2>nul
@start "" "C:\Program Files\JetBrains\IntelliJ IDEA 2019.2.4\bin\idea64.exe" >nul 2>nul
@start "" "E:\Foxmail 7.2\Foxmail.exe" >nul 2>nul
@start "" "E:\Eclipse\jee-2019-09\eclipse\eclipse.exe" >nul 2>nul
@start "" "E:\Studio 3T\Studio 3T.exe" >nul 2>nul
@start "" "E:\Perforce\p4v.exe" >nul 2>nul
@start "" "E:\Jingyue_Weasley\MongoDB_start_3.2.bat" >nul 2>nul
ECHO.
ECHO   启动完成，退出...
ECHO.
TIMEOUT /T 3 /nobreak >NUL & EXIT
