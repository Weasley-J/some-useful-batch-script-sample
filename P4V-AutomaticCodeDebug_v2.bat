@echo off
setlocal enabledelayedexpansion
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
set hight=30
mode con: cols=%with% lines=%hight%
title P4V Automatic CodeDebug Testing (By Weasley)                              %date%   %time%
call :Set_Variables & goto sync_home
:sync_home
echo. sync-ing %serverpath1% to %local_dir%...
call :getTimeString
if %time_str% geq 040000 if %time_str% leq 042000 (
	%p4% -p %IP%:%port% -u %user% -P %password% -c %client% sync -f %serverpath1%
) else %p4% -p %IP%:%port% -u %user% -P %password% -c %client% sync %serverpath1%
echo. %counter% files moded, copy folder and files to %ds_dir%...
call :getDirectoryDateString
set exeName="node.exe" & call :taskkillExeWithPid
echo making backup...
if exist "%ds_dir%" (
	ren "%ds_dir%" "yuntu_ds_%dir_date_str%"
)
echo copying %node_dir% to %ds_dir%\
if not exist "%ds_dir%" (
	md "%ds_dir%" >nul 2>nul & md "%node_dir%\empty" >nul 2>nul & md "%node_dir%" >nul 2>nul & echo start cmd.exe ^& exit>%node_dir%\cmd.cmd
	xcopy "%node_dir%" "%ds_dir%\" /s/y/e/h >nul 2>nul & cd /d "%ds_dir%\" & call :rj
) else (
	xcopy "%node_dir%" "%ds_dir%\" /s/y/e/h >nul 2>nul & cd /d "%ds_dir%\" & call :rj
)
::Start Grunt
@echo off
set "grunt=%temp%\StartGrunt.cmd"
del "%grunt%" >nul 2>nul
(
	echo @echo off
	echo setlocal enabledelayedexpansion ^& color 0F
	echo title grunt Services Startup          %%date%% %%time%%
	echo cd /d "%ds_dir%\"
	echo call grunt clean
	echo call grunt server:dist
	echo exit
)>%grunt%
start %grunt%
goto currentTime

:currentTime
set "loopSeconds=1200"
call :getTimeString
timeout /t %loopSeconds% /nobreak>nul
if %time_str% geq 040000 if %time_str% leq 042000 goto sync_home
goto currentTime

:getTimeString
@echo off
if "%time:~0,1%" equ " " (
	set "time_str=0%time:~1,1%%time:~3,2%%time:~6,2%"
) else (
	set "time_str=%time:~0,2%%time:~3,2%%time:~6,2%"
)
exit /b

:getDirectoryDateString
@echo off
if "%time:~0,1%" equ " " (
	set dir_date_str=%date:~0,4%%date:~5,2%%date:~8,2%0%time:~1,1%%time:~3,2%%time:~6,2%
) else (
	set dir_date_str=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
)
exit /b

:rj
@echo off & setlocal enabledelayedexpansion
:: Variables
set "srcFileName=RunMode.js"
set "srcDir=%ds_dir%\app\yuntu\utils"
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
set client=wenjing_xxxxxx-ds_7326
set workspace_name=wenjing_xxxxxx-ds_7326
set serverpath1=//depot/yuntu/com.yuntu.node/...
set client_name=%userprofile%\Desktop\client_name.txt
set local_dir=D:\P4\
set p4LogStore=D:\P4LogStore
if not exist "%p4LogStore%" (md "%p4LogStore%")
set node_dir=%local_dir%yuntu\com.yuntu.node
set stat_dir=%local_dir%yuntu\com.yuntu.statistics
set ds_dir=D:\yuntu_ds
exit /b
