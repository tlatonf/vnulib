:: https://ir.vnulib.edu.vn/flowpaper/simple_document.php?subfolder=23/91/22/&doc=23912253043895351368360641452395615385&bitsid=f96fb9d3-833e-4798-819f-1fe46243be67&uid=f5c8452e-f096-4ed8-bf5c-2a92357b9db7

rem config batch
@echo off
title VNULIB DOWNLOADER BY TLATONF
mode con:cols=80 lines=30
color 0A

rem global var
set subfolder=NONE
set doc=NONE
set state=NONE


:: begin script
setlocal EnableDelayedExpansion

rem input link ebook
call :header
set /p link=LINK: 
set link=%link:&=*%

set adr=VNULIB_Downloader
mkdir "%~dp0%adr%"
call :create_log %~dp0%adr% %link%
call :find "%link%"

echo.
set /p from_page=FROM PAGE: 
echo.
set /p to_page=TO PAGE: 

set adr=VNULIB_Downloader\image
mkdir "%~dp0%adr%"
rem explorer %adr%
rem start /min "" "%SystemRoot%\explorer.exe" /n, /e, "%cd%\%adr%"

rem download image from vnulib
set i=%from_page%
:download
call :header
echo DOWNLOADING PAGE %i%...
set url=https://ir.vnulib.edu.vn/flowpaper/services/view.php?doc=%doc%^&format=jpg^&page=!i!^&subfolder=%subfolder%
set adr=VNULIB_Downloader\image\page_!i!.jpg
curl -o !adr! "!url!"
call :check_file_available !adr!
if %state%==FILE_FAIL goto done
set /a i+=1
if !i! LEQ %to_page% goto download

:done
pause

endlocal
:: end script


rem this is space for functions

:create_log
    echo [InternetShortcut] >> "%1\LINK.url"
    echo URL=%2 >> "%1\LINK.url"
goto :eof

:find
    for /f "tokens=1,2 delims=*" %%a in (%1) do (
        for /f "tokens=2 delims==" %%c in ("%%a") do (
            set "subfolder=%%c"
        )
        for /f "tokens=2 delims==" %%d in ("%%b") do (
            set "doc=%%d"
        )
    )
goto :eof

:check_file_available
    for /f "tokens=3" %%a in ('dir /-c %1 ^| findstr /i "file(s)"') do set size=%%a
    if %size% LEQ 1000 (
        del %1
        set state=FILE_FAIL
    )
goto :eof

:header
    cls
    echo ********************************************************************************
    echo ****************** SCRIPT DOWNLOAD EBOOK FROM VNUHCM LIBRARY *******************
    echo *********************** VERSION 1.2 - PUBLISH 2023-03-09 ***********************
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