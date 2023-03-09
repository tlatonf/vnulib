:: https://ir.vnulib.edu.vn/flowpaper/simple_document.php?subfolder=23/91/22/&doc=23912253043895351368360641452395615385&bitsid=f96fb9d3-833e-4798-819f-1fe46243be67&uid=f5c8452e-f096-4ed8-bf5c-2a92357b9db7

:run

:: BEGIN CONFIG_BATCH
mode con:cols=80 lines=30
@echo off
color 0A
title VNULIB DOWNLOADER BY TLATONF
:: END CONFIG_BATCH

:: BEGIN DECLARE_GLOBAL_VARIABLE
set subfolder=
set doc=
set state=
set from_page=
set to_page=
:: END DECLARE_GLOBAL_VARIABLE

        :: BEGIN MAIN
        setlocal EnableDelayedExpansion

        :::: BEGIN INPUT_LINK_EBOOK
        call :HEADER_PRINTER
        set /p link=LINK: 
        set link=%link:&=*%
        call :FIND "%link%"
        :::: END INPUT_LINK_EBOOK

        set adr=VNULIB_Downloader
        mkdir "%~dp0%adr%"
        rem call :CREATE_LOG %~dp0%adr% %link%

        call :MENU
        :start_program
        set adr=VNULIB_Downloader\image
        mkdir "%~dp0%adr%"
        rem explorer %adr%
        rem start_program /min "" "%SystemRoot%\explorer.exe" /n, /e, "%cd%\%adr%"    

        :::: BEGIN DOWNLOAD_LOOP
        set i=%from_page%
        :do_while
            call :HEADER_PRINTER
            echo DOWNLOADING PAGE %i%...

            set url=https://ir.vnulib.edu.vn/flowpaper/services/view.php?doc=%doc%^&format=jpg^&page=!i!^&subfolder=%subfolder%
            set adr=VNULIB_Downloader\image\page_!i!.jpg
            curl -o !adr! "!url!"

            call :CHECK_FILE_AVAILABEL !adr!
            if !state! EQU FILE_FAIL goto done
            
            if !i! EQU %to_page% goto done
            set /a i+=1
        goto do_while
        :::: END DOWNLOAD_LOOP

        :done

        rem debuger
        pause
        goto run
        
        pause
        exit

        rem endlocal
        :: END MAIN


:: BEGIN FUNCTION

:CREATE_LOG
    :: STATEMANT_HERE
    rem echo [InternetShortcut] >> "%1\LINK.url"
    rem echo URL=%2 >> "%1\LINK.url"
goto :eof

:FIND
    for /f "tokens=1,2 delims=*" %%a in (%1) do (
        for /f "tokens=2 delims==" %%c in ("%%a") do (
            set "subfolder=%%c"
        )
        for /f "tokens=2 delims==" %%d in ("%%b") do (
            set "doc=%%d"
        )
    )
goto :eof

:CHECK_FILE_AVAILABEL
    for /f "tokens=3" %%a in ('dir /-c %1 ^| FINDstr /i "file(s)"') do set size=%%a
    if %size% LEQ 1000 (
        del %1
        set state=FILE_FAIL
    )
goto :eof

:MENU
    rem call :HEADER_PRINTER
    call :MENU_PRINTER
    :input_choice
    
    set /p choice=--^>      ENTER YOUR CHOICE: 
    if %choice%==A goto option1
    if %choice%==a goto option1
    if %choice%==S goto option2
    if %choice%==s goto option2
    if %choice%==B goto option3
    if %choice%==b goto option3
    if %choice%==E goto done
    if %choice%==e goto done
    echo INVALID CHOICE. PLEASE TRY AGAIN....
    goto input_choice

        :option1
        set from_page=1
        set to_page=0
        goto start_program
        
        :option2
        call :MENU_PRINTER
        echo --^>      ENTER SELECT RANGE PAGE
        :re_input_range_page
        set /p from_page=--^>      FROM PAGE: 
        set /p to_page=--^>      TO PAGE: 
        
        :: BEGIN CHECK_INPUT_RANGE
        if 0 GEQ %from_page% (
            echo CONDITION: 0 ^< FROM PAGE ^<= TO PAGE
            goto re_input_range_page
        )
        if %from_page% GTR %to_page% (
            echo CONDITION: 0 ^< FROM PAGE ^<= TO PAGE
            goto re_input_range_page
        )
        :: END CHECK_INPUT_RANGE

        goto start_program

        :option3
        goto run

goto :eof

:MENU_PRINTER
    cls
    echo.
    echo             ____    ____     ________     ____  _____     _____  _____  
    echo           ^|_   \  /   _^|   ^|_   __  ^|   ^|_   \^|_   _^|   ^|_   _^|^|_   _^| 
    echo             ^|   \/   ^|       ^| ^|_ \_^|     ^|   \ ^| ^|       ^| ^|    ^| ^|   
    echo             ^| ^|\  /^| ^|       ^|  _^| _      ^| ^|\ \^| ^|       ^| ^|    ^| ^| 
    echo            _^| ^|_\/_^| ^|_     _^| ^|__/ ^|    _^| ^|_\   ^|_      ^| ^|____^| ^|
    echo           ^|_____^|^|_____^|   ^|________^|   ^|_____^|\____^|     ^|________^|                                                             
    echo.
    echo                            CHOICE DOWNLOAD RANGE PAGE                           
    echo.
    echo          [A]. ALL RANGE PAGE                                                    
    echo          [S]. SELECT RANGE PAGE                                                 
    echo          [B]. BACK TO ENTER LINK                                                
    echo          [E]. EXIT                                                              
    echo.                                                                                
goto :eof

:HEADER_PRINTER
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

:: BEGIN FUNCTION