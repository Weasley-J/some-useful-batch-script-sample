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
title 给Windows右键菜单增加新建[bat-sh-java-py]文件

::fileType
set "fileType=bat" & call :function_of_write_reg
::set "fileType=cmd" & call :function_of_write_reg
set "fileType=sh" & call :function_of_write_reg
set "fileType=java" & call :function_of_write_reg
set "fileType=py" & call :function_of_write_reg
set "fileType=js" & call :function_of_write_reg
set "fileType=html" & call :function_of_write_reg
set "fileType=xml" & call :function_of_write_reg

goto countdownLoop

::set "fileType=cmd" & call :function_of_write_reg
:function_of_write_reg
@echo off
set "tmp=%temp%\%fileType%.reg"
set "subStr=%fileType%"
(
	echo Windows Registry Editor Version 5.00
	echo [HKEY_CLASSES_ROOT\.%subStr%\ShellNew]
	echo "NullFile"=""
	echo "FileName"=""
)>%tmp%
REG DELETE "HKEY_CLASSES_ROOT\.%subStr%\ShellNew" /f
regedit /s %tmp%
del "%tmp%" >nul 2>nul & exit /b

:countdownLoop
set "w=5"
echo.
echo. 				  	 Automatic exit in %w% seconds...
echo.
TIMEOUT /T %w% /nobreak >NUL
EXIT