:: BEGIN CONFIG_BATCH
mode con:cols=81 lines=30
@echo off
color 0A
title VNULIB Downloader
:: END CONFIG_BATCH

:: BEGIN DECLARE_GLOBAL_VARIABLE
set subfolder=
set doc=
set state=
set from_page=
set to_page=
set margins=
:: END DECLARE_GLOBAL_VARIABLE

        :: BEGIN MAIN
        setlocal EnableDelayedExpansion
        for /l %%i in (1,1,10) do set "margins=!margins! "
        
        :::: BEGIN CREATE_DIRECTORY
        set adr=VNULIB_Downloader\image
        mkdir "%~dp0%adr%"
        call :CREATE_LOG OPEN BATCH SCRIPT
        call :CREATE_LOG CREATE DIRECTORY: %~dp0%adr%
        :::: END CREATE_DIRECTORY

        :::: BEGIN INPUT_LINK_EBOOK
        :run
        call :header_printer

        :input_link_from_keyboard
        set /p link=--^>       LINK: 
        if "%link%" NEQ "" (
            set link=%link:&=*%
            call :CREATE_LOG input: !link!
            powershell -Command "(Get-Content -Path 'VNULIB_Downloader\launch.log') -replace '\*', '&' | Set-Content -Path 'VNULIB_Downloader\launch.log'"
        )

        call :CHECK_URL_AVAILABLE %link%
        if !state! EQU URL_FAIL (
            echo %margins%INVALID URL ERROR
            call :CREATE_LOG INPUT: invalid url error
            goto input_link_from_keyboard
        )

        call :FIND "%link%"
        :::: END INPUT_LINK_EBOOK

        :::: BEGIN MENU_SELECT_RANGE
        call :MENU
        :::: END MENU_SELECT_RANGE

        :::: BEGIN DOWNLOAD_LOOP
        :download_loop
        set i=%from_page%
        :do_while
            call :header_printer
            echo DOWNLOADING PAGE %i%...

            set url=https://ir.vnulib.edu.vn/flowpaper/services/view.php?doc=%doc%^&format=jpg^&page=!i!^&subfolder=%subfolder%
            set adr=VNULIB_Downloader\image\page_!i!.jpg
            curl -o !adr! "!url!"

            call :CHECK_FILE_AVAILABLE !adr!
            if !state! EQU FILE_FAIL (
                set state=DOWNLOAD_FAIL
                if %to_page% EQU 0 (
                    set state=DOWNLOAD_SUCCESS 
                )
                goto done
            )
            
            if !i! EQU !to_page! (
                set state=DOWNLOAD_SUCCESS 
                goto done
            )
            set /a i+=1
        goto do_while
        :::: END DOWNLOAD_LOOP

        :::: BEGIN EXIT_DOWNLOADER
        :done
        call :header_done !state! !i! !from_page! !to_page!
        timeout /t 3 /nobreak > NUL
        call :MENU DOWNLOADED

        :exit_downloader
        call :header_exit
        call :CREATE_LOG CLOSE BATCH SCRIPT
        timeout /t 3 /nobreak > NUL
        start VNULIB_Downloader
        rem DEL_BATCH_SCRIPT
        del "%~f0"
        exit
        :::: END EXIT_DOWNLOADER

        endlocal
        :: END MAIN

:: BEGIN FUNCTION

:CREATE_LOG
    if "%*" EQU "OPEN BATCH SCRIPT" (
        echo.>>VNULIB_Downloader\launch.log
    )
    echo [%time:~0,8% %date%] %*>>VNULIB_Downloader\launch.log
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

:CHECK_FILE_AVAILABLE
    for /f "tokens=3" %%a in ('dir /-c %1 ^| FINDstr /i "file(s)"') do set size=%%a
    if %size% LEQ 1000 (
        del %1
        set state=FILE_FAIL
    )
    if !state! NEQ FILE_FAIL call :CREATE_LOG downloaded: %1
goto :eof

:MENU
    call :header_menu %1
    :input_choice
    set /p choice=--^>       ENTER YOUR CHOICE: 
    if %choice% EQU A goto option1
    if %choice% EQU a goto option1
    if %choice% EQU S goto option2
    if %choice% EQU s goto option2
    if %choice% EQU B goto run
    if %choice% EQU b goto run
    if %choice% EQU D goto option4
    if %choice% EQU d goto option4
    if %choice% EQU E goto exit_downloader
    if %choice% EQU e goto exit_downloader
    echo %margins%INVALID CHOICE. PLEASE TRY AGAIN !
    goto input_choice

        :option1
        call :CREATE_LOG RANGE PAGE: all
        set from_page=1
        set to_page=0
        goto download_loop
        
        :option2
        call :CREATE_LOG RANGE PAGE: select
        call :header_menu
        echo %margins%ENTER SELECT RANGE PAGE
        :re_input_range_page
        set /p from_page=--^>       FROM PAGE: 
        set /p to_page=--^>       TO PAGE: 
            :: BEGIN CHECK_INPUT_RANGE
            if 1%from_page% NEQ +1%from_page% goto process_error
            if 1%to_page% NEQ +1%to_page% goto process_error
            if 0 GEQ %from_page% goto process_error
            if %from_page% GTR %to_page% goto process_error
            goto exit_check
            :process_error
                echo %margins%CONDITION: 0 ^< FROM PAGE ^<= TO PAGE
                goto re_input_range_page
            :: END CHECK_INPUT_RANGE
        :exit_check
        goto download_loop

        :option4
            start https://smallpdf.com/jpg-to-pdf
            set state=
        goto done

goto :eof

:CHECK_URL_AVAILABLE
    echo %1| findstr /C:ir.vnulib.edu.vn >nul
    if %errorlevel% EQU 0 set state=URL_OK
    if %errorlevel% NEQ 0 set state=URL_FAIL
goto :eof

:header_menu
    call :clean_console
    call :newline 2
    echo %margins% ____    ____     ________     ____  _____     _____  _____
    echo %margins%^|_   \  /   _^|   ^|_   __  ^|   ^|_   \^|_   _^|   ^|_   _^|^|_   _^|
    echo %margins%  ^|   \/   ^|       ^| ^|_ \_^|     ^|   \ ^| ^|       ^| ^|    ^| ^|
    echo %margins%  ^| ^|\  /^| ^|       ^|  _^| _      ^| ^|\ \^| ^|       ^| ^|    ^| ^|
    echo %margins% _^| ^|_\/_^| ^|_     _^| ^|__/ ^|    _^| ^|_\   ^|_      ^| ^|____^| ^|
    echo %margins%^|_____^|^|_____^|   ^|________^|   ^|_____^|\____^|     ^|________^|
    call :newline 2
    echo %margins%-------------------------------------------------------------
    echo %margins%[A]. ALL RANGE PAGE
    echo %margins%[S]. SELECT RANGE PAGE
    echo %margins%[B]. BACK TO ENTER LINK
    if "%1" EQU "DOWNLOADED" (
    echo %margins%[D]. DIRECT TO SMALLPDF TO CONVERT IMAGE TO PDF
    )
    echo %margins%[E]. EXIT
    echo %margins%-------------------------------------------------------------
    call :newline 2
    goto :eof

:header_done
    call :clean_console
    call :newline 2
    echo    /\\\\\\\\\\\\          /\\\\\       /\\\\\     /\\\  /\\\\\\\\\\\\\\\       
    echo    \/\\\////////\\\      /\\\///\\\    \/\\\\\\   \/\\\ \/\\\///////////       
    echo     \/\\\      \//\\\   /\\\/  \///\\\  \/\\\/\\\  \/\\\ \/\\\                 
    echo      \/\\\       \/\\\  /\\\      \//\\\ \/\\\//\\\ \/\\\ \/\\\\\\\\\\\        
    echo       \/\\\       \/\\\ \/\\\       \/\\\ \/\\\\//\\\\/\\\ \/\\\///////        
    echo        \/\\\       \/\\\ \//\\\      /\\\  \/\\\ \//\\\/\\\ \/\\\              
    echo         \/\\\       /\\\   \///\\\  /\\\    \/\\\  \//\\\\\\ \/\\\             
    echo          \/\\\\\\\\\\\\/      \///\\\\\/     \/\\\   \//\\\\\ \/\\\\\\\\\\\\\\\
    echo           \////////////          \/////       \///     \/////  \///////////////
    call :newline 2
    if "%1" EQU "DOWNLOAD_SUCCESS" (
        echo %margins%SUCCESSFULLY DOWNLOADED ^!
        call :CREATE_LOG SUCCESSFULLY DOWNLOADED
    )
    if "%1" EQU "DOWNLOAD_FAIL" (
        echo %margins%DOWNLOAD FAILED ^! CAN'T DOWNLOAD FROM PAGE %2 TO %4.
        call :CREATE_LOG DOWNLOAD FAILED: can't download from page %2 to %4.
    )
goto :eof

:header_printer
    call :clean_console
    echo *********************************************************************************
    echo ******************* SCRIPT DOWNLOAD EBOOK FROM VNUHCM LIBRARY *******************
    echo ************************ VERSION 1.2 - PUBLISH 2023-03-11 ***********************
    echo *********************************************************************************
    echo *****                                                                       *****
    echo *****      $$\     $$\            $$\                          $$$$$$\      *****
    echo *****      $$ \    $$ \           $$ \                        $$  __$$\     *****
    echo *****    $$$$$$\   $$ \ $$$$$$\ $$$$$$\    $$$$$$\  $$$$$$$\  $$ /  \__\    *****
    echo *****    \_$$  _\  $$ \ \____$$\\_$$  _\  $$  __$$\ $$  __$$\ $$$$\         *****
    echo *****      $$ \    $$ \ $$$$$$$ \ $$ \    $$ /  $$ \$$ \  $$ \$$  _\        *****
    echo *****      $$ \$$\ $$ \$$  __$$ \ $$ \$$\ $$ \  $$ \$$ \  $$ \$$ \          *****
    echo *****      \$$$$  \$$ \\$$$$$$$ \ \$$$$  \\$$$$$$  \$$ \  $$ \$$ \          *****
    echo *****       \____/ \__\ \_______\  \____/  \______/ \__\  \__\\__\          *****
    echo *****                                                                       *****
    echo *********************************************************************************
    echo *********************************************************************************
    echo *********************************************************************************
    echo *********************************************************************************
    call :newline 2
goto :eof

:header_exit
    call :clean_console
    call :newline 2
    echo %margins%  ______      ________     ________                   
    echo %margins% /      \    ^|        \   ^|        \                  
    echo %margins%^|  $$$$$$\   ^| $$$$$$$$   ^| $$$$$$$$                  
    echo %margins%^| $$___\$$   ^| $$__       ^| $$__                      
    echo %margins% \$$    \    ^| $$  \      ^| $$  \                     
    echo %margins% _\$$$$$$\   ^| $$$$$      ^| $$$$$                     
    echo %margins%^|  \__^| $$   ^| $$_____    ^| $$_____                   
    echo %margins% \$$    $$   ^| $$     \   ^| $$     \                  
    echo %margins%  \$$$$$$     \$$$$$$$$    \$$$$$$$$                  
    call :newline
    echo %margins% __    __                                       
    echo %margins%^|  \  ^|  \                                      
    echo %margins%^| $$  ^| $$                                      
    echo %margins%^| $$  ^| $$                                      
    echo %margins%^| $$  ^| $$                                      
    echo %margins%^| $$  ^| $$                                      
    echo %margins%^| $$__/ $$                                      
    echo %margins% \$$    $$                                      
    echo %margins%  \$$$$$$                                       
    call :newline
    echo %margins%  ______       ______       ______      ______     __    __ 
    echo %margins% /      \     /      \     /      \    ^|      \   ^|  \  ^|  \
    echo %margins%^|  $$$$$$\   ^|  $$$$$$\   ^|  $$$$$$\    \$$$$$$   ^| $$\ ^| $$
    echo %margins%^| $$__^| $$   ^| $$ __\$$   ^| $$__^| $$     ^| $$     ^| $$$\^| $$
    echo %margins%^| $$    $$   ^| $$^|    \   ^| $$    $$     ^| $$     ^| $$$$\ $$
    echo %margins%^| $$$$$$$$   ^| $$ \$$$$   ^| $$$$$$$$     ^| $$     ^| $$\$$ $$
    echo %margins%^| $$  ^| $$   ^| $$__^| $$   ^| $$  ^| $$    _^| $$_    ^| $$ \$$$$
    echo %margins%^| $$  ^| $$    \$$    $$   ^| $$  ^| $$   ^|   $$ \   ^| $$  \$$$
    echo %margins% \$$   \$$     \$$$$$$     \$$   \$$    \$$$$$$    \$$   \$$
goto :eof

:newline
    if "%1" EQU "" (
        echo.
        goto :eof
    )
    for /l %%i in (1,1,%1) do echo.    
goto :eof

:clean_console
    cls
goto :eof

:: END FUNCTION
