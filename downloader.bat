@echo off
title VNULIB DOWNLOADER ! (PREMIUM VERSION)
mode con:cols=80 lines=30
color 0A
setlocal EnableDelayedExpansion

call :print
set /p link=LINK: 
mkdir "%~dp0VNULIB_Downloader"
echo [InternetShortcut] >> "%~dp0%VNULIB_Downloader\LINK.url"
echo URL=!link! >> "%~dp0%VNULIB_Downloader\LINK.url"
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

call :print
mkdir "%~dp0VNULIB_Downloader\image"
explorer VNULIB_Downloader\image
start /min "" "%SystemRoot%\explorer.exe" /n, /e, "%cd%\VNULIB_Downloader\image"

set i=%from_page%
:download
echo DOWNLOADING PAGE !i!...
set url=https://ir.vnulib.edu.vn/flowpaper/services/view.php?doc=!doc!^&format=jpg^&page=!i!^&subfolder=!subfolder!
curl -o VNULIB_Downloader\image\page_!i!.jpg "!url!"
set /a i+=1
call :print
if !i! LEQ %to_page% goto download

echo OK...
del "%~f0"
exit


:print
cls
echo ********************************************************************************
echo ******************** DOWNLOADER EBOOK FROM IR.VNULIB.EDU.VN ********************
echo ******************************* CODE BY @TLATONF *******************************
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
echo.
goto :eof
