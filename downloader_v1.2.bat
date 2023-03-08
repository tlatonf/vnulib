@echo off

REM CONFIG SYSTEM
title VNULIB DOWNLOADER BY TLATONF
mode con:cols=80 lines=30
color 0A
setlocal EnableDelayedExpansion

REM INPUT AND CHOICE
:start
call :header
set /p link=LINK: 
set address=VNULIB_Downloader
mkdir "%~dp0%address%"
echo [InternetShortcut] >> "%~dp0%address%\LINK.url"
echo URL=!link! >> "%~dp0%address%\LINK.url"
for /f "tokens=1,2 delims=&" %%a in ("%link%") do (
    for /f "tokens=2 delims==" %%c in ("%%a") do (
        set "subfolder=%%c"
    )
    for /f "tokens=2 delims==" %%d in ("%%b") do (
        set "doc=%%d"
    )
)
echo.
set /p from_page=FROM PAGE: 
echo.
set /p to_page=TO PAGE: 

set address=VNULIB_Downloader\image
mkdir "%~dp0%address%"
rem explorer %address%
rem start /min "" "%SystemRoot%\explorer.exe" /n, /e, "%cd%\%address%"

REM DOWNLOAD IMAGE
set i=%from_page%
:download
call :header
echo DOWNLOADING PAGE !i!...
set url=https://ir.vnulib.edu.vn/flowpaper/services/view.php?doc=!doc!^&format=jpg^&page=!i!^&subfolder=!subfolder!
set address=VNULIB_Downloader\image\page_!i!.jpg
curl -o !address! "!url!"
	REM CHECK SIZE OF IMAGE
	for /f "tokens=3" %%a in ('dir /-c !address! ^| findstr /i "file(s)"') do set size=%%a
	if !size! LEQ 1000 (
		del !address!
		goto done
	)
set /a i+=1
if !i! LEQ %to_page% goto download

:done
rem goto start
pause


:header
cls
echo ********************************************************************************
echo ****************** SCRIPT DOWNLOAD EBOOK FROM VNUHCM LIBRARY *******************
echo *********************** VERSION 1.2 - PUBLISH 2023-03-08 ***********************
echo ********************************************************************************
echo *****                                                                      *****
echo *****      SS\     SS\            SS\                          SSSSSS\     *****
echo *****      SS \    SS \           SS \                        SS  __SS\    *****
echo *****    SSSSSS\   SS \ SSSSSS\ SSSSSS\    SSSSSS\  SSSSSSS\  SS /  \__\   *****
echo *****    \_SS  _\  SS \ \____SS\\_SS  _\  SS  __SS\ SS  __SS\ SSSS\        *****
echo *****      SS \    SS \ SSSSSSS \ SS \    SS /  SS \SS \  SS \SS  _\       *****
echo *****      SS \SS\ SS \SS  __SS \ SS \SS\ SS \  SS \SS \  SS \SS \         *****
echo *****      \SSSS  \SS \\SSSSSSS \ \SSSS  \\SSSSSS  \SS \  SS \SS \         *****
echo *****       \____/ \__\ \_______\  \____/  \______/ \__\  \__\\__\         *****
echo *****                                                                      *****
echo ********************************************************************************
echo ********************************************************************************
echo ********************************************************************************
echo ********************************************************************************
echo.
goto :eof
