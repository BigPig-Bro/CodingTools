::usage: the first param is the target file
@echo off

echo start upgrade script, target file: %1

set TEMP_FILE=ComAssistant.temp.2
set FINAL_FILE=%1

if [%FINAL_FILE%] == [] set FINAL_FILE=ComAssistant.exe

if exist %FINAL_FILE%.old (
    echo delete %FINAL_FILE%.old file
    del %FINAL_FILE%.old
)

if exist %TEMP_FILE% (
    echo exist exist exist
:wait_exe_quit
    tasklist /FI "IMAGENAME eq %FINAL_FILE%" > findexe
    find /i "%FINAL_FILE%" findexe
    if %ERRORLEVEL% EQU 0 (
        echo "%FINAL_FILE% are running, wait to exit!"
        timeout /t 1 /NOBREAK
        GOTO :wait_exe_quit
    )
    echo %FINAL_FILE% exited, start upgrade process
    move ..\%FINAL_FILE% %FINAL_FILE%.old
    move %TEMP_FILE% ..\%FINAL_FILE%
    move %FINAL_FILE%.old %FINAL_FILE%.temp.3
    if %errorlevel% EQU 0 (
        echo %FINAL_FILE% upgrade successfully! You can close this window by manual!
        start cmd /k echo Congratulations! %FINAL_FILE% upgrade successfully! You can close this window by manual!
    ) else (
        echo %FINAL_FILE% upgrade failed!
        start cmd /k echo Sorry, %FINAL_FILE% upgrade failed! You can visit 'https://www.comassistant.cn/' to upgrade manually.
    )
    exit 0
) else (
    echo %FINAL_FILE% upgrade failed!
    start cmd /k echo Sorry, %FINAL_FILE% upgrade failed! You can visit 'https://www.comassistant.cn/' to upgrade manually.
    exit 0
)

