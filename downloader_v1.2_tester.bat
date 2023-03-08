REM CONFIG SYSTEM
@echo off
title VNULIB DOWNLOADER BY TLATONF
mode con:cols=80 lines=30
color 0A
setlocal EnableDelayedExpansion

REM INPUT LINK
:input_link
call :header
set /p link=LINK: 
set address=VNULIB_Downloader
mkdir "%~dp0%address%"
call :create_log address link
for /f "tokens=1,2 delims=&" %%a in ("%link%") do (
    for /f "tokens=2 delims==" %%c in ("%%a") do (
        set "subfolder=%%c"
    )
    for /f "tokens=2 delims==" %%d in ("%%b") do (
        set "doc=%%d"
    )
)

REM CHOICE
:menu
call :header
call :menu_printer
set /p choice=Enter your choice:
if %choice%==A goto option1
if %choice%==S goto option2
if %choice%==B goto option3
if %choice%==E goto exit
if %choice%==R goto reopen
echo Invalid choice. Please try again....
goto menu

    :option1
    echo DOWNLOAD ALL RANGE PAGE
    set from_page=1
    set to_page=
    goto start

    :option2
    echo DOWNLOAD SELECT RANGE PAGE
    set /p from_page=FROM PAGE: 
    set /p to_page=TO PAGE: 
    goto start

    :option3
    goto input_link


REM START DOWNLOADER
:start
set address=VNULIB_Downloader\image
mkdir "%~dp0%address%"
rem explorer %address%
rem input_link /min "" "%SystemRoot%\explorer.exe" /n, /e, "%cd%\%address%"

REM DOWNLOAD IMAGE
set i=%from_page%
:download
call :header
echo DOWNLOADING PAGE !i!...
set url=https://ir.vnulib.edu.vn/flowpaper/services/view.php?doc=!doc!^&format=jpg^&page=!i!^&subfolder=!subfolder!
set address=VNULIB_Downloader\image\page_!i!.jpg
curl -o !address! "!url!"
	REM CHECK SIZE OF IMAGE
	call :check_image address
set /a i+=1
if !i! LEQ %to_page% goto download
:done
goto menu

:exit
exit


REM FUNCTION

:check_image
for /f "tokens=3" %%a in ('dir /-c %1 ^| findstr /i "file(s)"') do set size=%%a
	if %size% LEQ 1000 (
        del %1
        goto done
    )
goto :eof

:create_log
echo [InternetShortcut] >> "%~dp0%1\LINK.url"
echo URL=%2 >> "%~dp0%1\LINK.url"
goto eof

:menu_printer
echo ########################## CHOICE DOWNLOAD RANGE PAGE ##########################
echo #####    [A]. ALL RANGE PAGE                                               #####
echo #####    [S]. SELECT RANGE PAGE                                            #####
echo #####    [B]. BACK TO ENTER LINK                                           #####
echo #####    [E]. EXIT                                                         #####
echo ################################################################################
echo.
goto :eof

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

:reopen
call %0
exit /b