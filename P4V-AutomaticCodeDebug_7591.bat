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
title P4V Automatic CodeDebug Testing (By Weasley)                              %date%   %time%
call :Set_Variables & goto sync_home
::call :Set_Variables & goto currentTime
:sync_home
if "%time:~0,1%" equ " " (
	set logDate=%date:~0,4%%date:~5,2%%date:~8,2%0%time:~1,1%%time:~3,2%%time:~6,2%
) else (
	set logDate=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
)
set p4_log=%p4LogStore%\p4_sync_%logDate%.txt
:: p4 -C utf8 -p IP:port -u user -p password -c workspace_name sync //serverpath/...
:: p4 -p perforce.9yuntu.com:1666 -u wenjing -P 9yuntu -C wenjing_iZ2ymu4uzl3u9jZ_9376 sync
:: %p4% -p %IP%:%port% -u %user% -P %password% -c %client% sync //depot/yuntu/com.yuntu.statistics/...
echo. sync-ing %serverpath1% to %local_dir%... & echo. sync-ing %serverpath1% to %local_dir%...>%p4_log%
%p4% -p %IP%:%port% -u %user% -P %password% -c %client% sync %serverpath1%>>%p4_log%
echo.
echo. sync-ing %serverpath2% to %local_dir%... & echo. sync-ing %serverpath2% to %local_dir%...>>%p4_log%
%p4% -p %IP%:%port% -u %user% -P %password% -c %client% sync %serverpath2%>>%p4_log%
echo. >nul 2>nul & echo. Press ENTER will copy files to yuntu_ds! & pause >nul 2>nul
::goto debug_test
:: ------------
echo.
echo. %counter% files moded, copy folder and files to %ds_dir%...
set exeName="node.exe" & call :taskkillExeWithPid
if "%time:~0,1%" equ " " (
	set dateStr=%date:~0,4%%date:~5,2%%date:~8,2%0%time:~1,1%%time:~3,2%%time:~6,2%
) else (
	set dateStr=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
)
echo making backup...
cd /d "D:\"
if exist "%ds_dir%" (
	md "yuntu_ds_%dateStr%" >nul 2>nul & move /y "%ds_dir%" "yuntu_ds_%dateStr%" >nul 2>nul
)
pause
ren %ds_dir% yuntu_ds_%dateStr% >nul 2>nul
if not exist "%ds_dir%" (
	md "%ds_dir%" >nul 2>nul & md "%node_dir%\empty" >nul 2>nul & md "%node_dir%" >nul 2>nul & echo start cmd.exe ^& exit>%node_dir%\cmd.cmd
	xcopy "%node_dir%" "%ds_dir%\" /s/y/e/h
)
:: mod RunMode.js automatically
cd /d "%ds_dir%\"
call :mod_RunMode_js
call :weasley1

:attrib_files
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
exit /b

:weasley1
@echo off
set "grunt=%temp%\StartGrunt.cmd"
del "%grunt%" >nul 2>nul
(
	::echo ::Minimizing the window
	::echo @if "%%~1"=="y" goto begin
	::echo start /min cmd /c "%%~f0" y ^& exit
	::echo :begin
	echo @echo off
	echo setlocal enabledelayedexpansion ^& color 0F
	echo title grunt Services Startup          %%date%% %%time%%
	echo if "%%time:~0,1%%" ^equ " " (
	echo  	set logDate=%%date:~0,4%%%%date:~5,2%%%%date:~8,2%%0%%time:~1,1%%%%time:~3,2%%%%time:~6,2%%
	echo ^) else (
	echo  	set logDate=%%date:~0,4%%%%date:~5,2%%%%date:~8,2%%%%time:~0,2%%%%time:~3,2%%%%time:~6,2%%
	echo ^)
	echo set "grunt_log=%p4LogStore%\grunt_log_%%logDate%%.txt"
	echo cd /d "%ds_dir%\"
	echo call grunt clean
	echo call grunt server:dist^>%%grunt_log%%
	echo exit
)>%grunt%
pause
start %grunt%
goto currentTime
:: for debug
::debug_test

:currentTime
cls & set "loopSeconds=1"
:: M1
set "year=%date:~0,4%"
set "month=%date:~5,2%"
set "day=%date:~8,2%"
set "hour_ten=%time:~0,1%"
set "hour_one=%time:~1,1%"
set "minute=%time:~3,2%"
set "second=%time:~6,2%"
if "%hour_ten%" == " " (
    set DateTime=%year%_%month%_%day%_0%hour_one%_%minute%_%second%
) else (
    set DateTime=%year%_%month%_%day%_%hour_ten%%hour_one%_%minute%_%second%
)
echo.    %DateTime%_%time:~9,2%
:: M2
echo.
echo.
echo.
echo.    Current time:
echo.    %date% %time%    即: %date:~0,4%年%date:~5,2%月%time:~0,2%日%date:~10,6% %date:~8,2%时%time:~3,2%分%time:~6,2%秒%time:~9,2%毫秒
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
echo.
echo.    Automatic refresh in %loopSeconds% seconds.
timeout /t %loopSeconds% /nobreak>nul
::if "040000"=="%TempTime%" (goto sync_home)
::if "040000" equ "%TempTime%" (goto sync_home)
if "094000" equ "%TempTime%" (goto sync_home)
goto currentTime

:mod_RunMode_js
@echo off & setlocal enabledelayedexpansion
:: Variables
set "srcFileName=RunMode.js"
set "srcDir=app\yuntu\utils"
set "srcPathName=%srcDir%\%srcFileName%"
set "destFile=%temp%\temp"
set "destStr=qaMode : false"
set "replaceStr=qaMode : true"
:: Single file
findstr /r %destStr% "%srcPathName%" >NUL 2>NUL
IF ERRORLEVEL 0 (
	(
		for /f "tokens=*" %%i in (%srcPathName%) do (
			set s=%%i
			set s=!s:%destStr%=%replaceStr%!
			echo !s!
		)
	)>%destFile%
	ren "%destFile%" "%srcFileName%" >nul 2>nul
	del "%srcPathName%" >nul 2>nul
	move "%temp%\%srcFileName%" "%srcDir%\" >nul 2>nul
) ELSE ECHO No such string!
timeout /t 3 /nobreak>nul
exit /b

::All the "js" files in an directory(String replace): "source String" replaced with "destination String"
:replace_special_string_in_directory
:: bat file itself directory
::cd /d %~dp0
set counter=0
set "src=9yuntu"
set "dest=8yuntu"
set "destDir=%cd%"
::set "src=source String"
::set "dest=destination String"
set "tmp=%temp%\tmp"
for /r "%destDir%" %%f in ("*.*") do (
	findstr /r %src% "%%f"
	IF ERRORLEVEL 0 (
		set /a counter+=1
		echo Found %%f
		(
			for /f "tokens=*" %%i in ( %%f ) do (
				set s=%%i
				set s=!s:%src%=%dest%!
				echo !s!
			)
		)>%tmp%
		move /y "%tmp%" "%%f" >nul 2>nul
	)
)
echo. Processes %counter% files.
timeout /t 3 /nobreak>nul
exit /b

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
set client=wenjing_Inspiron-7591_947
set workspace_name=wenjing_Inspiron-7591_947
:: serverpath/...
set serverpath1=//depot/yuntu/com.yuntu.node/...
set serverpath2=//depot/yuntu/com.yuntu.statistics/...
set log=%userprofile%\Desktop\p4_log.txt
set client_name=%userprofile%\Desktop\client_name.txt
set local_dir=E:\PerforceWorkspace\
set p4LogStore=D:\P4LogStore
if not exist "%p4LogStore%" (md "%p4LogStore%")
set node_dir=%local_dir%yuntu\com.yuntu.node
set stat_dir=%local_dir%yuntu\com.yuntu.statistics
set ds_dir=D:\yuntu_ds
exit /b
