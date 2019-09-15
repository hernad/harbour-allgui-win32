@echo off
@setlocal
SET HMGPATH=\minigui
SET PATH=%HMGPATH%\harbour\bin;\borland\bcc55\bin;%PATH%

if exist %HMGPATH%\lib\minigui.bak del %HMGPATH%\lib\minigui.bak

hbmk2 hmg.hbp 2>&1 | mtee /d /t build.log

@endlocal
