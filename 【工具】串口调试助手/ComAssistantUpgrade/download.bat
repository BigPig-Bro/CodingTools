::usage: the first param is the download url
@echo off

set TEMP_FILE=ComAssistant.temp.1
set FINAL_FILE=ComAssistant.temp.2
set FINAL_MD5=ComAssistant.md5
set REMOTE_URL=%1
set REMOTE_MD5_URL=%2

if [%REMOTE_URL%] == [] set REMOTE_URL=http://www.comassistant.cn/upgrade/ComAssistant_x64.exe
if [%REMOTE_MD5_URL%] == [] set REMOTE_MD5_URL=http://www.comassistant.cn/upgrade/ComAssistant_x64.md5

echo arg1_file_url: %REMOTE_URL%
echo arg2_md5_url: %REMOTE_MD5_URL%


if exist %TEMP_FILE% (
    echo clear temp file...
    del %TEMP_FILE%
)

if exist %FINAL_FILE% (
    ::del %FINAL_FILE%
    echo there is downloaded file, skip download!
    goto :end
)

echo start downloading executable file...
type nul>%TEMP_FILE%
.\wget.exe -q --show-progress --tries=3 -c -O %TEMP_FILE% %REMOTE_URL%
echo.
echo start downloading md5 file...
.\wget.exe -q --show-progress --tries=3 -c -O %FINAL_MD5% %REMOTE_MD5_URL%
echo.

if %errorlevel%==0 (
    echo preparing file...
    ren %TEMP_FILE% %FINAL_FILE%
    echo success! wait for trigger...
) else (
    del %TEMP_FILE%
    echo failed!
)

:end
