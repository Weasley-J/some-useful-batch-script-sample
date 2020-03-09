@echo off
setlocal enabledelayedexpansion & color 0A
:currentTime
cls & set "loopSeconds=1"
echo.
echo.
echo.    Current time:
echo.    %date% %time%  即: %date:~0,4%年%date:~5,2%月%date:~8,2%日%date:~10,6%%time:~0,2%时%time:~3,2%分%time:~6,2%秒%time:~9,2%毫秒
echo.
echo.    Date number(String):
echo.    %date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%%time:~9,2%
set "TempTime=%time:~0,2%%time:~3,2%%time:~6,2%"
echo.    %TempTime%
echo.
echo.
echo.    Automatic refresh in %loopSeconds% seconds.
timeout /t %loopSeconds% /nobreak>nul
::if "040000"=="%TempTime%" (
::if "040000" equ "%TempTime%" (
if "00000" geq "%TempTime%" (
	:: 现在快要下班了，等到18:50的时候，我回到家里，我希望我的笔记本自己动播放 “宝石gem-野狼disco(Live)” 这首歌，然后关闭这个冒绿光的窗口！
	set exeName="kwmusic.exe" & call :taskkillExeWithPid
	:: start "" "C:\Program Files (x86)\kuwo\kuwomusic\9.0.6.0_W1\bin\kwmusic.exe" "D:\KwDownload\song\宝石gem&陈伟霆-野狼Disco（feat.陈伟霆）.flac"
	Shutdown -s -t 0
	goto countdownLoop
) else goto currentTime

:taskkillExeWithPid
del "D:\pidTmp.txt" >nul 2>nul
tasklist|find /i %exeName%>D:\pidTmp.txt
for /f "tokens=2 delims= " %%i in (D:\pidTmp.txt) do (
	set /a count+=1
	echo.     %exeName%'s pidID: %%i;
	taskkill /pid %%i /t /f
	taskkill /t /f /im %exeName% >nul 2>nul
)
echo %exeName% has enabled %count% .exe;
echo.
set count=0
del "D:\pidTmp.txt" >nul 2>nul & exit /b

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