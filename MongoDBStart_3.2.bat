@echo off
setlocal enabledelayedexpansion
cd %cd%
set "File=Server\4.2\bin\mongod.exe"
if not exist ".\DatabaseStorage" (
	md ".\DatabaseStorage" >nul 2>nul & goto make_file
) else goto make_file
:make_file
%File% --dbpath ./DatabaseStorage
pause && exit
