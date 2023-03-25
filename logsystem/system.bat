@echo off
cd /d %~dp0
title Log System
set log=1
echo [34m[Prompt] [37m Loading...
:main
if exist log%log%.bat (
set /a log=%log%+1
call log%log%.bat
)
if '%end%' == '1' (
    echo [34m[Prompt] [37mStop running.
    pause>nul
    del log*.bat
    exit
)
ping -n 1 127.1>nul
goto main