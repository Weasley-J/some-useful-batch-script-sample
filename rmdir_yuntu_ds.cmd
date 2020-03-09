@echo off
setlocal enabledelayedexpansion & color 0A
FOR /d %%p IN ("D:\yuntu_ds*") DO (
::FOR /d %%p IN ("D:\yuntu_ds_*") DO (
	echo. sudo rm -rf %%p
	rmdir "%%p" /s /q >nul 2>nul
)
echo. D:\yuntu_ds* not exist.
echo. exiting... & timeout /T 5 /nobreak >NUL & exit
::pause & exit