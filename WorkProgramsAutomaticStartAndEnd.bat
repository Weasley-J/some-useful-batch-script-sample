::Minimizing the window
@if "%~1"=="y" goto begin
start /min cmd /c "%~f0" y & exit
:begin
:: StartUp Programs
:: cd /d "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" && echo %cd%
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
set with=120
set hight=35
mode con: cols=%with% lines=%hight%
title Automatic Startup And Endup Work Programs  (By Weasley)                            %date% %time%
::call :Set_Variables & goto sync_home
call :Set_Variables & call :startWorkExe & goto currentTime
:: --------------------------------------------------------------------------
:sync_home
set logDate=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
set p4_log=%p4LogStore%\p4_sync_%logDate%.txt
:: p4 -C utf8 -p IP:port -u user -p password -c workspace_name sync //serverpath/...
:: p4 -p perforce.9yuntu.com:1666 -u wenjing -P 9yuntu -C wenjing_iZ2ymu4uzl3u9jZ_9376 sync
:: %p4% -p %IP%:%port% -u %user% -P %password% -c %client% sync //depot/yuntu/com.yuntu.statistics/...
echo. sync-ing %serverpath1% to %local_dir%...
%p4% -p %IP%:%port% -u %user% -P %password% -c %client% sync %serverpath1%>%p4_log%
echo.
echo. sync-ing %serverpath2% to %local_dir%... & echo. sync-ing %serverpath2% to %local_dir%...>>%p4_log%
%p4% -p %IP%:%port% -u %user% -P %password% -c %client% sync %serverpath2%>>%p4_log%
::goto debug_test
:: ------------
echo.
echo. %counter% files moded, copy folder and files to %ds_dir%...
set exeName="node.exe" & call :taskkillExeWithPid
set dateStr1=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
set dateStr2=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%%time:~9,2%
echo. dateStr1=%dateStr1%
echo. dateStr2=%dateStr2%
ren %ds_dir% yuntu_ds_%dateStr1% >nul 2>nul
if not exist "%ds_dir%" (
	md "%ds_dir%" >nul 2>nul & md "%node_dir%\empty" >nul 2>nul & md "%node_dir%" >nul 2>nul & echo start cmd.exe ^& exit>%node_dir%\cmd.cmd
	xcopy "%node_dir%" "%ds_dir%\" /s/y/e/h
)
echo.
echo. Setting folder and files in folder attributes...
cd /d %ds_dir%
set DIR="%cd%"
set counter=0
for /R %DIR% %%f in (*.*) do (
	set /a counter+=1
	echo.    Processing: %%f & echo.    Processing: %%f>>%p4_log%
	attrib -h -r -a -s %%f /s /d
)
echo. >>%p4_log% & echo. Processes ( %counter% ) files.>>%p4_log% & set counter=0
::attrib %cd%\* -s -r -a -h /d /s
::debug_test
cd /d "%ds_dir%\"
call grunt clean
call grunt server:dist
goto currentTime
:: for debug
:: pause & exit

:currentTime
cls & set "loopSeconds=1"
echo.
echo.
echo.    Current time:
echo.    %date% %time%
echo.
echo.    Date number(String):
if "%time:~0,1%" equ " " (
	echo.    %date:~0,4%%date:~5,2%%date:~8,2%0%time:~1,1%%time:~3,2%%time:~6,2%%time:~9,2%
) else (
	echo.    %date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%%time:~9,2%
)
if "%time:~0,1%" equ " " (
	set "TempTime=0%time:~1,1%%time:~3,2%%time:~6,2%"
) else (
	set "TempTime=%time:~0,2%%time:~3,2%%time:~6,2%"
)
echo.    %TempTime%
echo.
echo.
echo.    Automatic refresh in %loopSeconds% seconds.
timeout /t %loopSeconds% /nobreak>nul
::if "40000"=="%TempTime%" (goto sync_home)
if "100000"=="%TempTime%" (goto sync_home)
if "173000"=="%TempTime%" (call :killTaskEex & Shutdown -f -s -t 0)
::if "153600"=="%TempTime%" (call :killTaskEex & Shutdown -f -r -t 0)
goto currentTime

:countdownLoop
for /l %%W in (5,-1,0) do (
cls
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo. 				  	 Automatic refresh in %%W seconds...
echo.
echo.
echo.
echo.
echo.
echo.
echo.
ping 127.1 -n 2 >nul
)
exit /b

:killTaskEex
cls
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
set exeName="notepad++.exe" & call :taskkillExeWithPid
set exeName="Foxmail.exe" & call :taskkillExeWithPid
set exeName="WeChat.exe" & call :taskkillExeWithPid
set exeName="TIM.exe" & call :taskkillExeWithPid
set exeName="QQScLauncher.exe" & call :taskkillExeWithPid
set exeName="p4v.exe" & call :taskkillExeWithPid
set exeName="firefox.exe" & call :taskkillExeWithPid
set exeName="UCBrowser.exe" & call :taskkillExeWithPid
set exeName="eclipse.exe" & call :taskkillExeWithPid
set exeName="idea64.exe" & call :taskkillExeWithPid
set exeName="Studio 3T.exe" & call :taskkillExeWithPid
set exeName="pycharm64.exe" & call :taskkillExeWithPid
exit /b

:startWorkExe
@echo off
cls & cd /d "E:\MongoDB\"
set "MongoDB=StartMongoDB.cmd"
del "%MongoDB%" >nul 2>nul
(
	echo ::Minimizing the window
	echo @if "%%~1"=="y" goto begin
	echo start /min cmd /c "%%~f0" y ^& exit
	echo :begin
	echo @echo off
	echo setlocal enabledelayedexpansion ^& color 0F
	echo title MongoDB Services Startup          %%date%% %%time%%
	echo cd /d "E:\MongoDB\Server\4.2\bin\"
	echo set "mongo=mongod.exe"
	echo if not exist "MongoDatabase" (
	echo 	^md "MongoDatabase" ^>nul 2^>nul ^& goto StartMongo
	echo ^) else goto StartMongo
	echo :StartMongo
	echo %%mongo%% --dbpath ./MongoDatabase
	echo pause ^& exit
)>>%MongoDB%
start %MongoDB%
set exeName="notepad++.exe" & call :taskkillExeWithPid
set exeName="WeChat.exe" & call :taskkillExeWithPid
set exeName="TIM.exe" & call :taskkillExeWithPid
set exeName="QQScLauncher.exe" & call :taskkillExeWithPid
set exeName="UCBrowser.exe" & call :taskkillExeWithPid
set exeName="eclipse.exe" & call :taskkillExeWithPid
set exeName="idea64.exe" & call :taskkillExeWithPid
set exeName="firefox.exe" & call :taskkillExeWithPid
set exeName="Studio 3T.exe" & call :taskkillExeWithPid
set exeName="p4v.exe" & call :taskkillExeWithPid
echo.
echo.   StartUp Programs...
echo.
@start "" "C:\Program Files\Notepad++\notepad++.exe" >nul 2>nul
@start "" "D:\Program Files\Foxmail 7.2\Foxmail.exe" >nul 2>nul
@start "" "C:\Program Files (x86)\Tencent\WeChat\WeChat.exe" >nul 2>nul
@start "" "C:\Program Files (x86)\Tencent\TIM\Bin\QQScLauncher.exe" >nul 2>nul
@start "" "C:\Program Files\Perforce\p4v.exe" >nul 2>nul
@start "" "C:\Program Files\Mozilla Firefox\firefox.exe" >nul 2>nul
@start "" "C:\Program Files (x86)\UCBrowser\Application\UCBrowser.exe" >nul 2>nul
@start "" "C:\Program Files\eclipse\jee-2019-06\eclipse\eclipse.exe" >nul 2>nul
@start "" "C:\Program Files\JetBrains\IntelliJ IDEA 2019.2.1\bin\idea64.exe" >nul 2>nul
@start "" "C:\Program Files\3T Software Labs\Studio 3T\Studio 3T.exe" >nul 2>nul
exit /b

:taskkillExeWithPid
del "D:\pidTmp.txt" >nul 2>nul
tasklist|find /i %exeName%>D:\pidTmp.txt
for /f "tokens=2 delims= " %%i in (D:\pidTmp.txt) do (
	set /a count+=1
	echo.     %exeName%'s pidID: %%i;
	taskkill /pid %%i /t /f
	taskkill /t /f /im %exeName% >nul 2>nul
)
echo. %exeName% has enabled %count% .exe;
echo.
set count=0
del "D:\pidTmp.txt" >nul 2>nul & exit /b

:utcTime
@echo off
set "$=%temp%\Spring"
>%$% Echo WScript.Echo((new Date()).getTime())
for /f %%a in ('cscript -nologo -e:jscript %$%') do set timestamp=%%a
del /f /q %$%
set utcTime=%timestamp%
echo. utcTime=%utcTime%
exit /b

:Set_Variables
set p4=p4.exe
::your p4 Account Info.
:: --------------------------------
set P4PORT=perforce.yourdomain.com:1666
set P4USER=your_username
set P4PASSWD=your_password
:: --------------------------------
set IP=perforce.yourdomain.com:1666
set port=1666
set user=your_username
set password=your_password
:: workspace_name=client_name
set client=wenjing_XXXX-PC_8421
set workspace_name=wenjing_XXXX-PC_8421
:: serverpath/...
set serverpath1=//depot/yuntu/com.yuntu.node/...
set serverpath2=//depot/yuntu/com.yuntu.statistics/...
set log=%userprofile%\Desktop\p4_log.txt
set client_name=%userprofile%\Desktop\client_name.txt
set local_dir=D:\P4_Workspace\
set p4LogStore=D:\P4LogStore
if not exist "%p4LogStore%" (md "%p4LogStore%")
set node_dir=%local_dir%yuntu\com.yuntu.node
set stat_dir=%local_dir%yuntu\com.yuntu.statistics
set ds_dir=D:\yuntu_ds
exit /b
