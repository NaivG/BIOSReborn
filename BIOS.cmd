

@echo off
cls
mode 110,40
color 0a
set firstrun=0
set Version=0.5.2
set uptime=2022/7/14 20:18
cd /d %~dp0
set batpath=%cd%
set log=1
set ESC=
set RD=%ESC%[31m
set GN=%ESC%[32m
set YW=%ESC%[33m
set BL=%ESC%[34m
set WT=%ESC%[37m
set RN=%ESC%[0m
title BIOS
subst X: /d 2>nul
md %temp%\BIOStemp 2>nul
cls
if "%1"=="cmpfin" goto :cmpfin
if exist err.tmp goto :rec
if not exist settings.ini goto :firstrun
if not exist BIOS.cmd (
set img=3
set errcode=0x03 Suffix ERROR
goto bluescreen
)
for /f "tokens=1,* delims==" %%a in ('findstr "DEBUGLOG=" settings.ini') do (set dep=%%b)
if "%dep%"=="on" (
    pushd .
    cd logsystem
    del /s /q log*.bat
    popd
    cls
    start %batpath%\logsystem\system.bat
    echo echo %GN%[%time:~0,8% INFO] %WT%Initialized Complete.>>%batpath%\logsystem\log%log%.bat 
    set /a log=%log%+1
)

echo Checking Language Info...
for /f "tokens=1,* delims==" %%a in ('findstr "language=" settings.ini') do (set lng=%%b)
if not exist languages\%lng%.bat goto :lngerror
if "%dep%"=="on" (
    echo echo %GN%[%time:~0,8% INFO] %WT%Loaded Language.>>%batpath%\logsystem\log%log%.bat
    set /a log=%log%+1
)

::::::::::::::::::::::::::::::::::::::::::::::::::
for /f "tokens=1,* delims==" %%a in ('findstr "UAC=" settings.ini') do (set UAC=%%b)
if "%UAC%" neq "on" goto :skipUAC
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' (
    if "%dep%"=="on" (
        echo echo %GN%[%time:~0,8% INFO] %WT%Get UAC successfully.>>%batpath%\logsystem\log%log%.bat
        set /a log=%log%+1  
        )
    ) else (
    call languages\%lng%.bat check 1
    if "%dep%"=="on" (
        echo echo %GN%[%time:~0,8% INFO] %WT%Getting UAC...>>%batpath%\logsystem\log%log%.bat
        set /a log=%log%+1 
        )
    UAC %~f0
    exit
    )
 
::::::::::::::::::::::::::::::::::::::::::::::::::
:skipUAC

call languages\%lng%.bat check 2
if not exist choice.exe (if not exist %windir%\System32\choice.exe set erc=A&goto :ltgerror)
if "%dep%"=="on" (
    echo echo %GN%[%time:~0,8% INFO] %WT%Detected choice.exe.>>%batpath%\logsystem\log%log%.bat
    set /a log=%log%+1 
)

if not exist unzip.exe set erc=B&goto :ltgerror
if "%dep%"=="on" (
    echo echo %GN%[%time:~0,8% INFO] %WT%Detected unzip.exe.>>%batpath%\logsystem\log%log%.bat
    set /a log=%log%+1 
)

call languages\%lng%.bat check 3
ping -n 1 127.1>nul
if exist oldcons.tmp del oldcons.tmp&goto :load
ver|findstr /r /i " [°æ±¾ 6.*.*]" > NUL && goto :load
ver|findstr /r /i " [Version 6.*.*]" > NUL && goto :load
ver|findstr /r /i " [°æ±¾ 10.0.*]" > NUL && goto :oldcons
ver|findstr /r /i " [Version 10.0.*]" > NUL && goto :oldcons

if "%dep%"=="on" (
    echo echo %YW%[%time:~0,8% WARN] %WT%Found That The System Is Not Compatible.>>%batpath%\logsystem\log%log%.bat
    set /a log=%log%+1 
)

for /f "tokens=1,* delims==" %%a in ('findstr "force=" settings.ini') do (set force=%%b)
if "%force%"=="on" goto :load
call languages\%lng%.bat compatible 1
call languages\%lng%.bat compatible 2
choice -n -c yn >nul
if errorlevel == 2 exit
if errorlevel == 1 (
    echo force=on>>settings.ini
    goto :load
)

:ltgerror
set img=1
set errcode=0x%erc%1 Program Missing ERROR
if "%erc%"=="A" set misprog=choice.exe
if "%erc%"=="B" set misprog=unzip.exe
if "%erc%"=="D" set misprog=wget.exe
if "%dep%"=="on" (
    echo echo %RD%[%time:~0,8% ERROR] %WT%Missing Program %misprog%.>>%batpath%\logsystem\log%log%.bat
    echo echo   ERROR Code:%errcode%>>%batpath%\logsystem\log%log%.bat
    echo echo       Cannot Find Program %misprog%.>>%batpath%\logsystem\log%log%.bat
    echo echo     End>>%batpath%\logsystem\log%log%.bat
    echo set end=^1>>%batpath%\logsystem\log%log%.bat
)
goto bluescreen

:firstrun
set firstrun=1
set n=10
:wait
SleepX -p "Wait for %n% seconds to automatic progress, or press a key..." -k 1
cls
if errorlevel 1 goto :KEYPRESSED
set /a n=n-1
if "%n%"=="0" goto :automatic
goto :wait

:KEYPRESSED
cls
echo Set Language:
echo ÉèÖÃÓïÑÔ:
echo Enter E To Set English.
echo ÊäÈë C ÉèÖÃÖÐÎÄ¡£
choice -n -c ec >nul
if errorlevel == 2 set lng=zh_cn
if errorlevel == 1 set lng=en_us

ping -n 2 127.1>nul
if not exist languages\%lng%.bat goto :lngerror
call languages\%lng%.bat firstrun 1
ping -n 1 127.1>nul
call languages\%lng%.bat firstrun 2

ver|findstr /r /i " [°æ±¾ 10.0.*]" > NUL && goto oldcons
ver|findstr /r /i " [Version 10.0.*]" > NUL && goto oldcons

:checkpgm
call languages\%lng%.bat firstrun 3
if not exist choice.exe (if not exist %windir%\System32\choice.exe set firstrunerr=1&set lostitem=choice.exe)
if not exist unzip.exe set firstrunerr=1&set lostitem=%lostitem% unzip.exe
if not exist wget.exe set firstrunerr=1&set lostitem=%lostitem% wget.exe
if "%firstrunerr%" neq "1" (
    call languages\%lng%.bat firstrun 4
)
if "%firstrunerr%"=="1" (
    call languages\%lng%.bat firstrun 5
    call languages\%lng%.bat firstrun 6
    choice -n -c yn >nul
        if errorlevel == 2 exit
        if errorlevel == 1 goto :uacstg
)
:uacstg
call languages\%lng%.bat firstrun 7
call languages\%lng%.bat firstrun 8
    choice -n -c yn >nul
        if errorlevel == 2 set UAC=off
        if errorlevel == 1 set UAC=on
:continuestg
call languages\%lng%.bat firstrun 9
echo [BIOS Settings]>settings.ini
echo Version=%Version%>>settings.ini
echo number=051-%random%-%random%-%random%>>settings.ini
echo language=%lng%>>settings.ini
if "%modyreg%"=="0" echo modyreg=off>>settings.ini
if "%modyreg%"=="1" echo modyreg=on>>settings.ini
echo DEBUGLOG=on>>settings.ini
echo UAC=%UAC%>>settings.ini
if not exist boot.ini (
    call languages\%lng%.bat firstrun 10
   (
    echo [BIOS Boot Options Info]
    echo n=^2
    echo 1=Batch System 0.0.1alpha
    echo type1a=img
    echo img1b=sys
    echo 2=DOS 1.5.4
    echo type2a=img
    echo img2b=dos
    echo 3=Boot from Network
    echo type3a=network
    echo address3b=www.baidu.com
   )>boot.ini
)
call languages\%lng%.bat firstrun 11
call languages\%lng%.bat firstrun 12
pause>nul
call BIOS.cmd 2>nul
set img=3
set errcode=0x03 Suffix ERROR
goto bluescreen

:automatic
set lng=en_us
ver|findstr /r /i "°æ±¾" > NUL && set lng=zh_cn
set modyreg=0
ver|findstr /r /i " [°æ±¾ 10.0.*]" > NUL && set modyreg=1
ver|findstr /r /i " [Version 10.0.*]" > NUL && set modyreg=1
set UAC=off
goto :continuestg

:lngerror
set img=2
set errcode=0x02 Language Setting ERROR
if "%dep%"=="on" (
echo echo %RD%[%time:~0,8% ERROR] %WT%Failed To Load Language.>>%batpath%\logsystem\log%log%.bat
echo echo   ERROR Code:%errcode%>>%batpath%\logsystem\log%log%.bat
echo echo       The Pointing Language Is %lng%.>>%batpath%\logsystem\log%log%.bat
echo echo       The Language Can Only Be Chinese Or English.>>%batpath%\logsystem\log%log%.bat
echo echo     End>>%batpath%\logsystem\log%log%.bat
echo set end=^1>>%batpath%\logsystem\log%log%.bat
)
goto bluescreen

:oldcons
if "%firstrun%"=="1" goto :checkmody
for /f "tokens=1,* delims==" %%a in ('findstr "modyreg=" settings.ini') do (set modyreg=%%b)
if "%modyreg%"=="on" goto :Modify
goto :load

:checkmody
call languages\%lng%.bat firstrun 13
call languages\%lng%.bat firstrun 14
call languages\%lng%.bat firstrun 15
choice -n -c yn >nul
if errorlevel == 2 (
    set modyreg=0
    ping -n 1 127.1>nul
    goto :checkpgm
)
if errorlevel == 1 (
    set modyreg=1
    ping -n 1 127.1>nul
    goto :checkpgm
)

:Modify
call languages\%lng%.bat compatible 3
ping -n 2 127.1>nul
set V=
for /f "tokens=3" %%V in ('reg query HKCU\Console /v ForceV2 2^>nul') do set V=%%V
if "%V%"=="0x1" (
 reg add HKCU\Console /v ForceV2 /t REG_DWORD /d 0x0 /f || goto olderror
 start "" "%~f0" regOK 
 goto :eof
) else (
 if "%1"=="regOK" reg add HKCU\Console /v ForceV2 /t REG_DWORD /d 0x1 /f
 cls
 echo 0>oldcons.tmp
 call BIOS.cmd 2>nul
 set img=3
 set errcode=0x03 Suffix ERROR
 goto bluescreen
)

:olderror
set img=4
set errcode=0x04 Modifying Registry ERROR
if "%dep%"=="on" (
echo echo %RD%[%time:~0,8% ERROR] %WT%Failed To Modify Registry.>>%batpath%\logsystem\log%log%.bat
echo echo   ERROR Code:%errcode%>>%batpath%\logsystem\log%log%.bat
echo echo       Add DWORD Failed.>>%batpath%\logsystem\log%log%.bat
echo echo     End>>%batpath%\logsystem\log%log%.bat
echo set end=^1>>%batpath%\logsystem\log%log%.bat
)
goto bluescreen

:load
set choices=1
if not exist boot.ini goto :booterror
for /f "tokens=1,* delims==" %%a in ('findstr "1=" boot.ini') do (set boot1=%%b)
for /f "tokens=1,* delims==" %%a in ('findstr "2=" boot.ini') do (set boot2=%%b)
for /f "tokens=1,* delims==" %%a in ('findstr "3=" boot.ini') do (set boot3=%%b)
for /f "tokens=1,* delims==" %%a in ('findstr "type1a=" boot.ini') do (set type1=%%b)
for /f "tokens=1,* delims==" %%a in ('findstr "type2a=" boot.ini') do (set type2=%%b)
for /f "tokens=1,* delims==" %%a in ('findstr "type3a=" boot.ini') do (set type3=%%b)

title BIOS
cls
echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.
echo.
echo                                       ¨q¨T¨T¨r¨q¨T¨T¨r¨q¨T¨T¨r¨q¨T¨T¨r
echo                                       ¨U¨q¨r¨U¨t¨r¨q¨s¨U¨q¨r¨U¨U¨q¨T¨s
echo                                       ¨U¨t¨s¨s¡¡¨U¨U¡¡¨U¨U¨U¨U¨U¨t¨T¨r
echo                                       ¨U¨q¨r¨r¡¡¨U¨U¡¡¨U¨U¨U¨U¨t¨T¨r¨U
echo                                       ¨U¨t¨s¨U¨q¨s¨t¨r¨U¨t¨s¨U¨q¨T¨s¨U
echo                                       ¨t¨T¨T¨s¨t¨T¨T¨s¨t¨T¨T¨s¨t¨T¨T¨s
echo.
echo.
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' (
echo                                                 ADMIN  MODE
) else (
echo. 
)
echo.
echo.
call languages\%lng%.bat main 1
echo.
call languages\%lng%.bat main 2
echo.
echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.
echo.
echo  -----------------------------------------------------------------------------------------------------------
call languages\%lng%.bat main 3
echo  -----------------------------------------------------------------------------------------------------------          
choice -n -c bsrm >nul
if errorlevel == 4 goto :blmenu
if errorlevel == 3 goto :resetstg
if errorlevel == 2 goto :skip
if errorlevel == 1 goto :menu

:blmenu
cls
echo Loading Settings...
set min=1
set max=2
ping -n 5 127.1>nul
:blmenue
cls
echo.
echo  ============================================================================================================
echo.
:dpname2
if "%choices%" equ "1" (
echo                                  ¡ú Boot Option
) else (
echo                                     Boot Option
)
if "%choices%" equ "2" (
echo                                  ¡ú Language Option
) else (
echo                                     Language Option
)
echo.
echo  ============================================================================================================
echo.
:mnblm
choice -n -c wse >nul
if errorlevel == 3 goto :selecte
if errorlevel == 2 (
    if "%choices%"=="%max%" set "%choices%"=="%min%"&goto :blmenue
    set /a choices=%choices%+1
    goto :blmenue
)
if errorlevel == 1 (
    if "%choices%"=="%min%" set "%choices%"=="%max%"&goto :blmenue
    set /a choices=%choices%-1
    goto :blmenue
)
goto :mnblm

:selecte
set m=%choices%
if "%m%"=="1" goto :bootopt
if "%m%"=="2" if "%dep%"=="on" (
    echo echo %YW%[%time:~0,8% WARN] %WT%ºÃÏñÕâÀï»¹Ã»Íê³É°É>>%batpath%\logsystem\log%log%.bat
    set /a log=%log%+1 
)
goto :blmenue

:bootopt
cls
if "%dep%"=="on" (
    echo echo %YW%[%time:~0,8% WARN] %WT%ºÃÏñÕâÀï»¹Ã»Íê³É°É>>%batpath%\logsystem\log%log%.bat
    set /a log=%log%+1 
)
echo  ============================================================================================================
echo.
echo                                      Boot Option1:%boot1%
echo                                      Boot Option2:%boot2%
echo                                      Boot Option3:%boot3%
echo.
echo  ============================================================================================================
pause
goto :blmenue

:resetstg
cls
echo The Program Will Reset The Settings.
del /q settings.ini
rd /s /q %temp%\BIOStemp
ping -n 5 127.1>nul
exit

:booterror
set img=5
set errcode=0x05 Boot Option Missing ERROR
if "%dep%"=="on" (echo echo %RD%[%time:~0,8% ERROR] %WT%Failed To Read Boot Opinion.>>%batpath%\logsystem\log%log%.bat
echo echo   ERROR Code:%errcode%>>%batpath%\logsystem\log%log%.bat
echo echo       Read Boot Opinion Failed.>>%batpath%\logsystem\log%log%.bat
echo echo     End>>%batpath%\logsystem\log%log%.bat
echo set end=^1>>%batpath%\logsystem\log%log%.bat
)
goto bluescreen

:skip
set s=%type1%
set m=1
:boot
if "%lng%"=="en" title BIOS--Boot
if "%lng%"=="cn" title BIOS--Æô¶¯
cls
if "%s%"=="img" goto img
if "%s%"=="network" goto network
call languages\%lng%.bat boot 1
call languages\%lng%.bat boot 2
pause>nul
exit

:img
for /f "tokens=1,* delims==" %%a in ('findstr "img%m%b=" boot.ini') do (set BOOT=%%b)
ping -n 2 127.1>nul
call languages\%lng%.bat boot 3
ping -n 2 127.1>nul
if not exist %BOOT%.img (
  set img=6
  set errcode=0x06 System Image ERROR
  if "%dep%"=="on" (
    echo echo %RD%[%time:~0,8% ERROR] %WT%Failed To Boot System.>>%batpath%\logsystem\log%log%.bat
    echo echo   ERROR Code:%errcode%>>%batpath%\logsystem\log%log%.bat
    echo echo       Boot Failed.>>%batpath%\logsystem\log%log%.bat
    echo echo       The Pointed IMG File Doesn't Exist.>>%batpath%\logsystem\log%log%.bat
    echo echo     End>>%batpath%\logsystem\log%log%.bat
    echo set end=^1>>%batpath%\logsystem\log%log%.bat
    )
  goto bluescreen  
)
ren %BOOT%.img TEMP.zip
unzip -o TEMP 2>nul
ren TEMP.zip %BOOT%.img
ping -n 1 127.1>nul
call languages\%lng%.bat boot 4
ping -n 2 127.1>nul
call languages\%lng%.bat boot 5
ping -n 1 127.1>nul
subst X: %~dp0disk >nul 2>nul
md %temp%\BIOStemp 2>nul
(
echo @echo off
echo subst X: /d
echo rd /s /q %cd%\disk
echo exit
)>%temp%\BIOStemp\del.bat
ping -n 1 127.1>nul
call languages\%lng%.bat boot 6
ping -n 3 127.1>nul
call languages\%lng%.bat boot 7
ping -n 2 127.1>nul
if not exist X:\boot\BIOS\*.boot (
  set img=6
  set errcode=0x06 System Image ERROR
  if "%dep%"=="on" (
    echo echo %RD%[%time:~0,8% ERROR] %WT%Failed To Boot System.>>%batpath%\logsystem\log%log%.bat
    echo echo   ERROR Code:%errcode%>>%batpath%\logsystem\log%log%.bat
    echo echo       Boot Failed.>>%batpath%\logsystem\log%log%.bat
    echo echo       The Pointed IMG File Doesn't Exist BOOT FILE.>>%batpath%\logsystem\log%log%.bat
    echo echo     End>>%batpath%\logsystem\log%log%.bat
    echo set end=^1>>%batpath%\logsystem\log%log%.bat
    )
  goto bluescreen  
)
cd /d X:\boot\BIOS
ren *.boot sys.cmd
call sys.cmd 2>nul
set img=6
set errcode=0x06 System Image ERROR
if "%dep%"=="on" (
    echo echo %RD%[%time:~0,8% ERROR] %WT%Failed To Boot System.>>%batpath%\logsystem\log%log%.bat
    echo echo   ERROR Code:%errcode%>>%batpath%\logsystem\log%log%.bat
    echo echo       Boot Failed.>>%batpath%\logsystem\log%log%.bat
    echo echo       The Pointed IMG File Has ERRORS.>>%batpath%\logsystem\log%log%.bat
    echo echo     End>>%batpath%\logsystem\log%log%.bat
    echo set end=^1>>%batpath%\logsystem\log%log%.bat
    )
goto bluescreen

:network
for /f "tokens=1,* delims==" %%a in ('findstr "address%m%b=" boot.ini') do (set address=%%b)
if not exist wget.exe ping -n 1 137.1>nul & goto:nterror
:ecnext
ping -n 3 127.1>nul
set errorlevel=0
call languages\%lng%.bat boot 8
del /s /q download.img
wget %address%
if "%lng%"=="en" title BIOS--Boot
if "%lng%"=="cn" title BIOS--Æô¶¯
call languages\%lng%.bat boot 9
ping -n 2 127.1>nul
call languages\%lng%.bat boot 10
ping -n 2 127.1>nul
if not exist download.img (
  set img=6
  set errcode=0x06 System Image ERROR
  if "%dep%"=="on" (
    echo echo %RD%[%time:~0,8% ERROR] %WT%Failed To Boot System.>>%batpath%\logsystem\log%log%.bat
    echo echo   ERROR Code:%errcode%>>%batpath%\logsystem\log%log%.bat
    echo echo       Boot Failed.>>%batpath%\logsystem\log%log%.bat 
    echo echo       The Pointed IMG File Doesn't Exist.>>%batpath%\logsystem\log%log%.bat
    echo echo     End>>%batpath%\logsystem\log%log%.bat
    echo set end=^1>>%batpath%\logsystem\log%log%.bat
    )
  goto bluescreen  
)
ren download.img TEMP.zip
unzip -o TEMP 2>nul
ren TEMP.zip download.img
ping -n 1 127.1>nul
call languages\%lng%.bat boot 11
ping -n 2 127.1>nul
call languages\%lng%.bat boot 12
ping -n 1 127.1>nul
subst X: %~dp0disk 2>nul
md %temp%\BIOStemp 2>nul
(
echo @echo off
echo subst X: /d
echo rd /s /q %cd%\disk
echo exit
)>%temp%\BIOStemp\del.bat
ping -n 1 127.1>nul
call languages\%lng%.bat boot 13
ping -n 3 127.1>nul
call languages\%lng%.bat boot 14
ping -n 2 127.1>nul
if not exist X:\boot\BIOS\*.boot (
  set img=6
  set errcode=0x06 System Image ERROR
  if "%dep%"=="on" (
    echo echo %RD%[%time:~0,8% ERROR] %WT%Failed To Boot System.>>%batpath%\logsystem\log%log%.bat
    echo echo   ERROR Code:%errcode%>>%batpath%\logsystem\log%log%.bat
    echo echo       Boot Failed.>>%batpath%\logsystem\log%log%.bat
    echo echo       The Pointed IMG File Doesn't Exist BOOT FILE.>>%batpath%\logsystem\log%log%.bat
    echo echo     End>>%batpath%\logsystem\log%log%.bat
    echo set end=^1>>%batpath%\logsystem\log%log%.bat
    )
  goto bluescreen  
)
cd /d X:\boot\BIOS
ren *.boot sys.cmd
call sys.cmd 2>nul
set img=6
set errcode=0x06 System Image ERROR
if "%dep%"=="on" (
    echo echo %RD%[%time:~0,8% ERROR] %WT%Failed To Boot System.>>%batpath%\logsystem\log%log%.bat
    echo echo   ERROR Code:%errcode%>>%batpath%\logsystem\log%log%.bat
    echo echo       Boot Failed.>>%batpath%\logsystem\log%log%.bat
    echo echo       The Pointed IMG File Has ERRORS.>>%batpath%\logsystem\log%log%.bat
    echo echo     End>>%batpath%\logsystem\log%log%.bat
    echo set end=^1>>%batpath%\logsystem\log%log%.bat
    )
goto bluescreen

:nterror
set erc=D
goto :ltgerror

:menu
rem boot menu
if "%lng%"=="en" title BIOS--Boot Menu
if "%lng%"=="cn" title BIOS--Æô¶¯²Ëµ¥
:logo2
cls
echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.
echo.
echo                                   ¨q¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨r
echo                                  ¨U                                          ¨U
:dpname
if "%choices%" equ "1" (
echo                                  ¨U   ¡ú %boot1%  ¨U
) else (
echo                                  ¨U      %boot1%  ¨U
)
if "%choices%" equ "2" (
echo                                  ¨U   ¡ú %boot2%                           ¨U
) else (
echo                                  ¨U      %boot2%                           ¨U
)
if "%choices%" equ "3" (
echo                                  ¨U   ¡ú %boot3%                   ¨U
) else (
echo                                  ¨U      %boot3%                   ¨U
)             
echo                                  ¨U                                          ¨U
echo                                  ¨t¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨s
echo.
echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.
echo.
call languages\%lng%.bat main 4
echo.
choice -n -c wsei >nul
if errorlevel == 4 goto :info
if errorlevel == 3 goto :select
if errorlevel == 2 (
    if "%choices%"=="3" set choices=1& goto :logo2
    set /a choices=%choices%+1
    goto :logo2
)
if errorlevel == 1 (
    if "%choices%"=="1" set choices=3& goto :logo2
    set /a choices=%choices%-1
    goto :logo2
)
goto :logo2

:select
set m=%choices%
if "%m%"=="1" goto t1
if "%m%"=="2" goto t2
if "%m%"=="3" goto t3
goto :boot

:t1
set s=%type1%
goto :boot

:t2
set s=%type2%
goto :boot

:t3
set s=%type3%
goto :boot

:info
set m=%choices%
if "%choices%"=="1" (
    set bootname=%boot1%
    set s=%type1%
    goto :infonext
)
if "%choices%"=="2" (
    set bootname=%boot2%
    set s=%type2%
    goto :infonext
)
if "%choices%"=="3" (
    set bootname=%boot3%
    set s=%type3%
    goto :infonext
)
:infonext
cls
echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.
echo.
echo  ============================================================================================================
call languages\%lng%.bat info 1
call languages\%lng%.bat info 2
if "%s%"=="img" (
for /f "tokens=1,* delims==" %%a in ('findstr "img%m%b=" boot.ini') do (set BOOT=%%b)
call languages\%lng%.bat info 3
if not exist %BOOT%.img (
    call languages\%lng%.bat info 4
   ) else (
    call languages\%lng%.bat info 5
   )
) else if "%s%"=="network" (
for /f "tokens=1,* delims==" %%a in ('findstr "address%m%b=" boot.ini') do (set address=%%b)
call languages\%lng%.bat info 6
call languages\%lng%.bat info 5
) else (
call languages\%lng%.bat info 7
)
call languages\%lng%.bat info 8
echo  ============================================================================================================
pause>nul
goto :logo2

:rec
for /f "tokens=1,* delims==" %%a in ('findstr "code=" err.tmp') do (set errcode=%%b)
set choices=1
:rec2
cls
echo.
echo We detected an error in the last run.
echo The error code is %errcode%.
echo What you wish to do?
echo Press W up, S down, E to select.
echo.
if "%choices%" equ "1" (
echo   ¡ú Try to fix
) else (
echo      Try to fix
)
if "%choices%" equ "2" (
echo   ¡ú Reset settings
) else (
echo      Reset settings
)
if "%choices%" equ "3" (
echo   ¡ú Normal start-up
) else (
echo      Normal start-up
)
if "%choices%" equ "4" (
echo   ¡ú Exit
) else (
echo      Exit
)
echo.
choice -n -c wse >nul
if errorlevel == 3 goto :eselect
if errorlevel == 2 (
    if "%choices%"=="4" set choices=1&goto :rec2
    set /a choices=%choices%+1
    goto :rec2
)
if errorlevel == 1 (
    if "%choices%"=="1" set choices=4&goto :rec2
    set /a choices=%choices%-1
    goto :rec2
)
goto :rec2

:eselect
if "%choices%"=="2" (
    cls
    echo The Program Will Reset The Settings.
    del /s /q err.tmp
    del /q settings.ini
    rd /s /q %temp%\BIOStemp
    ping -n 5 127.1>nul
    exit
)
if "%choices%"=="3" (
    del /s /q err.tmp
    call BIOS.cmd 2>nul
    set img=3
    set errcode=0x03 Suffix ERROR
    goto bluescreen
)
if "%choices%"=="4" exit
if "%choices%" neq "1" (
    cls
    echo ERROR!
    echo Press any key to exit...
    pause>nul
    exit
)
cls
echo Trying to fix...
ping -n 2 127.1>nul
echo Check settings...
for /f "tokens=1,* delims==" %%a in ('findstr "Version=" settings.ini') do (set tmpver=%%b)
if "%tmpver%" neq "%Version%" (
    echo   Find Version Setting ERROR.Fixing...
    ping -n 2 127.1>nul
    echo   The Version has been set to %Version%.
)
for /f "tokens=1,* delims==" %%a in ('findstr "number=" settings.ini') do (set number=%%b)
if "%number:~0,3%" neq "051" (
    echo   Find Number Setting ERROR.Fixing...
    set tmpnum=051-%random%-%random%-%random%
    ping -n 2 127.1>nul
    echo   The Number has been set to %tmpnum%.
) else (
    set tmpnum=%number%
)
for /f "tokens=1,* delims==" %%a in ('findstr "language=" settings.ini') do (set lng=%%b)
if not exist languages\%lng%.bat (
    echo   Find Language Setting ERROR.Fixing...
    set lng=zh_cn
    ping -n 2 127.1>nul
    if not exist languages\zh_cn.bat (
        echo   Missing zh_cn lanugage file detected.
        echo   Redownloading may solve the problem.
    )
    ping -n 1 127.1>nul
    echo   The language has been set to zh_cn.
)
for /f "tokens=1,* delims==" %%a in ('findstr "modyreg=" settings.ini') do (set modyreg=%%b)
if "%modyreg%" neq "off" (
    if "%modyreg%" neq "on" (
    echo   Find Modyreg Setting ERROR.Fixing...
    set modyreg=off
    ping -n 2 127.1>nul
    echo   The Modyreg has been set to OFF.
    )
)
for /f "tokens=1,* delims==" %%a in ('findstr "DEBUGLOG=" settings.ini') do (set dep=%%b)
if "%dep%" neq "off" (
    if "%dep%" neq "on" (
    echo   Find DEBUGLOG Setting ERROR.Fixing...
    set dep=on
    ping -n 2 127.1>nul
    echo   The DEBUGLOG has been set to ON.
    )
)
ping -n 2 127.1>nul
(
    echo [BIOS Settings]
    echo Version=%Version%
    echo number=%tmpnum%
    echo language=%lng%
    echo modyreg=%modyreg%
    echo DEBUGLOG=%dep%
)>settings.ini
echo The settings check is complete.
ping -n 2 127.1>nul
echo Check program integrity...
set missfile=0
if not exist choice.exe (
    if not exist %windir%\System32\choice.exe (
        set missfile=1
        echo   Missing choice.exe detected.
    )
)
if not exist unzip.exe (
    set missfile=1
    echo   Missing unzip.exe detected.
)
if not exist wget.exe (
    set missfile=1
    echo   Missing wget.exe detected.
)
ping -n 1 127.1>nul
if "%missfile%"=="1" (
echo   Missing program file detected.
echo   Redownloading may solve the problem.
)
ping -n 1 127.1>nul
echo The program integrity check is complete.
ping -n 2 127.1>nul
echo Check BOOT file...
if not exist boot.ini (
    echo   Find Boot Option Missing ERROR.Generate default boot file...
   (
    echo [BIOS Boot Options Info]
    echo n=^2
    echo 1=Batch System 0.0.1alpha
    echo type1a=img
    echo img1b=sys
    echo 2=DOS 1.5.4
    echo type2a=img
    echo img2b=dos
    echo 3=Boot from Network
    echo type3a=network
    echo address3b=www.baidu.com
   )>boot.ini
)
echo The BOOT file check is complete.
ping -n 2 127.1>nul
echo Check main program...
if not exist BIOS.cmd (
    echo   Find Suffix ERROR.
    echo   When we try to fix it, the program may crash.
    echo   Select the method you want to use [W,S]
    echo     W.Method 1 ^(Recommended^)
    echo     S.Method 2
    choice -n -c ws >nul
    if errorlevel == 2 (
        ren "%~f0" BIOS.cmd
        echo   Fixed!
    )
    if errorlevel == 1 (
        (
            echo @echo off
            echo ren "%~f0" BIOS.cmd
            echo echo Fixed!
            echo call BIOS.cmd cmpfin
        )>tmp.bat
        call tmp.bat
    )
)
:cmpfin
if exist tmp.bat del /s /q tmp.bat
del /s /q err.tmp
echo The check is complete.
echo Press any key to restart the program...
pause>nul
call BIOS.cmd 2>nul
set img=3
set errcode=0x03 Suffix ERROR
goto bluescreen

:bluescreen
title BIOS--ERROR
subst X: /d 2>nul
del /s /q %batpath%\err.tmp
cls
color 97
echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.
echo.
echo  ============================================================================================================
echo        Ò»¸öÎ´ÖªµÄ´íÎóµ¼ÖÂ³ÌÐò½«ÖÕÖ¹ÔËÐÐ¡£
echo        An Unknown Error Caused The Program To Stop Running. 
echo        ´íÎó´úÂë:%errcode%
echo        Error Code:%errcode%
echo        Äã¿ÉÒÔ³¢ÊÔÖØÐÂÔËÐÐ£¬»ò½«±¾Ä¿Â¼ÏÂµÄ´íÎóÈÕÖ¾(ERROR.log)·¢ËÍ¸ø×÷Õß¡£
echo        You Can Try Running It Again Or Send The Error Log (ERROR.log) In This Directory To The Author.
echo        °´ÈÎÒâ¼üÍË³ö...   
echo        Press Any Key To Exit...
echo  ============================================================================================================
echo %date% %time% Error Code:%errcode%>>%batpath%\ERROR.log
echo code=%errcode%>%batpath%\err.tmp
pause>nul
exit