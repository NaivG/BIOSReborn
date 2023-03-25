

@echo off
cls
mode 110,40
color 0a
set firstrun=0
set Version=0.5.1
set uptime=2022/5/18 21:46
set batpath=%cd%
title BIOS
subst X: /d 2>nul
md %temp%\BIOStemp 2>nul
cls
if "%1"=="cmpfin" goto :cmpfin
if exist err.tmp goto :rec
if not exist settings.ini goto :firstrun
for /f "tokens=1,* delims==" %%a in ('findstr "DEBUGLOG=" settings.ini') do (set dep=%%b)
if "%dep%"=="on" echo [INFO]%date%%time%:Initialized Complete.>>%batpath%\DEBUG.LOG

echo Checking Language Info...
for /f "tokens=1,* delims==" %%a in ('findstr "language=" settings.ini') do (set lng=%%b)
if not exist languages\%lng%.bat goto :lngerror

::if "%lng%" neq "en" (if "%lng%" neq "cn" (goto :lngerror))
if "%dep%"=="on" echo [INFO]%date%%time%:Loaded Language.>>%batpath%\DEBUG.LOG

    if "%lng%"=="en" echo echo Check Program Integrity...
call languages\%lng%.bat check1

if not exist choice.exe (if not exist %windir%\System32\choice.exe set erc=A&goto :ltgerror)
if "%dep%"=="on" echo [INFO]%date%%time%:Detected choice.exe.>>%batpath%\DEBUG.LOG
if not exist unzip.exe set erc=B&goto :ltgerror
if "%dep%"=="on" echo [INFO]%date%%time%:Detected unzip.exe.>>%batpath%\DEBUG.LOG

    if "%lng%"=="en" echo Check System Compatibility...
    if "%lng%"=="cn" echo 检查系统兼容性...
call languages\%lng%.bat check2

ping -n 2 127.1>nul
if exist oldcons.tmp del oldcons.tmp&goto load
ver|findstr /r /i " [版本 6.1.*]" > NUL && goto load
ver|findstr /r /i " [版本 10.0.*]" > NUL && goto oldcons
ver|findstr /r /i " [Version 6.1.*]" > NUL && goto load
ver|findstr /r /i " [Version 10.0.*]" > NUL && goto oldcons

if "%dep%"=="on" echo [WARN]%date%%time%:Found That The System Is Not Compatible.>>%batpath%\DEBUG.LOG

    if "%lng%"=="en" echo Your System Is Not Compatible With This Program,Please Use Windows7 Or Windows10.
    if "%lng%"=="cn" echo 您的系统与此程序不兼容，请使用Windows7或Windows10。
call languages\%lng%.bat compatible1
    if "%lng%"=="en" echo If You Want To Force It, Press Y, Otherwise Press N To Exit.
    if "%lng%"=="cn" echo 如果要强制执行，请按Y，否则按N退出。
call languages\%lng%.bat compatible2
choice -n -c yn >nul
if errorlevel == 2 exit
if errorlevel == 1 goto :load

:firstrun
set firstrun=1
echo Set Language:
echo 设置语言:
echo Enter E To Set English.
echo 输入 C 设置中文。
choice -n -c ec >nul
if errorlevel == 2 goto :zhcn
if errorlevel == 1 goto :enus

:ltgerror
set img=1
set errcode=0x%erc%1 Program Missing ERROR
if "%erc%"=="A" set misprog=choice.exe
if "%erc%"=="B" set misprog=unzip.exe
if "%erc%"=="D" set misprog=wget.exe
if "%dep%"=="on" echo [ERROR]%date%%time%:Missing Program %misprog%.>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo   ERROR Code:%errcode%>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo       Cannot Find Program %misprog%.>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo     End>>%batpath%\DEBUG.LOG
goto bluescreen

:enus
echo Configuring Language...
ping -n 2 127.1>nul
set lng=en
ping -n 1 127.1>nul
echo Done!
goto :checksys

:zhcn
echo 正在配置语言...
ping -n 2 127.1>nul
set lng=cn
ping -n 1 127.1>nul
echo 完成!
goto :checksys

:checksys
ver|findstr /r /i " [版本 10.0.*]" > NUL && goto oldcons
ver|findstr /r /i " [Version 10.0.*]" > NUL && goto oldcons
:checkpgm
    if "%lng%"=="en" echo Check Program Integrity...
    if "%lng%"=="cn" echo 检测程序完整性...
if not exist choice.exe (if not exist %windir%\System32\choice.exe set firstrunerr=1&set lostitem=choice.exe)
if not exist unzip.exe set firstrunerr=1&set lostitem=%lostitem% unzip.exe
if not exist wget.exe set firstrunerr=1&set lostitem=%lostitem% wget.exe
if "%firstrunerr%" neq "1" (
   if "%lng%"=="en" echo Done!
   if "%lng%"=="cn" echo 完成!
)
if "%firstrunerr%"=="1" (
   if "%lng%"=="en" echo Missing file: %lostitem%, this may cause an error.
   if "%lng%"=="cn" echo 检测到缺失文件：%lostitem%，这可能会引起错误。
   if "%lng%"=="en" echo Does the configuration continue? [Y,N]
   if "%lng%"=="cn" echo 是否继续配置？[Y,N]
   choice -n -c yn >nul
    if errorlevel == 2 exit
    if errorlevel == 1 goto :continuestg
)
:continuestg
if "%lng%"=="en" echo Automatic configuration in progress, please wait...
if "%lng%"=="cn" echo 自动配置中，请稍后...
echo [BIOS Settings]>settings.ini
echo Version=%Version%>>settings.ini
echo number=050-%random%-%random%-%random%>>settings.ini
if "%lng%"=="en" echo language=en>>settings.ini
if "%lng%"=="cn" echo language=zh_cn>>settings.ini
if "%modyreg%"=="0" echo modyreg=off>>settings.ini
if "%modyreg%"=="1" echo modyreg=on>>settings.ini
echo DEBUGLOG=on>>settings.ini
if not exist boot.ini (
    if "%lng%"=="en" echo Generate default boot file...
    if "%lng%"=="cn" echo 生成默认启动配置文件中...
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
    if "%lng%"=="en" echo Done!
    if "%lng%"=="cn" echo 完成!
    if "%lng%"=="en" echo Press Any Key To Restart The Program...
    if "%lng%"=="cn" echo 按任意键重启程序...
pause>nul
call BIOS.cmd 2>nul
set img=3
set errcode=0x03 Suffix ERROR
goto bluescreen

:lngerror
set img=2
set errcode=0x02 Language Setting ERROR
if "%dep%"=="on" echo [ERROR]%date%%time%:Failed To Load Language.>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo   ERROR Code:%errcode%>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo       The Pointing Language Is %lng%.>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo       The Language Can Only Be Chinese Or English.>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo     End>>%batpath%\DEBUG.LOG
goto bluescreen

:oldcons
if "%firstrun%"=="1" goto :checkmody
for /f "tokens=1,* delims==" %%a in ('findstr "modyreg=" settings.ini') do (set modyreg=%%b)
if "%modyreg%"=="on" goto :Modify
goto :load

:checkmody
    if "%lng%"=="en" echo It Has Been Detected That You Are Using The Windows 10 Operating System, Which May Cause Display Errors.
    if "%lng%"=="cn" echo 检测到你正在使用Windows 10操作系统，这可能导致显示错误。
    if "%lng%"=="en" echo Do You Want To Modify The Registry To Support This Program? [Y,N]
    if "%lng%"=="cn" echo 是否修改注册表以支持此程序？[Y,N]
    if "%lng%"=="en" echo Note: Some Systems Cannot Be Restored After Modifying The Registry, Please Choose Carefully!
    if "%lng%"=="cn" echo 注意：某些系统修改注册表后将无法复原，请谨慎选择！
choice -n -c yn >nul
if errorlevel == 2 goto :Modifyno
if errorlevel == 1 goto :Modifyyes

:Modifyno
set modyreg=0
ping -n 1 127.1>nul
goto :checkpgm

:Modifyyes
set modyreg=1
ping -n 1 127.1>nul
goto :checkpgm

:Modify
    if "%lng%"=="en" echo Modifying Registry To Support This Program...
    if "%lng%"=="cn" echo 正在修改注册表以支持此程序...
call languages\%lng%.bat compatible3
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
if "%dep%"=="on" echo [ERROR]%date%%time%:Failed To Modify Registry.>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo   ERROR Code:%errcode%>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo       Add DWORD Failed.>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo     End>>%batpath%\DEBUG.LOG
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
echo                                       ╭══╮╭══╮╭══╮╭══╮
echo                                       ║╭╮║╰╮╭╯║╭╮║║╭═╯
echo                                       ║╰╯╯　║║　║║║║║╰═╮
echo                                       ║╭╮╮　║║　║║║║╰═╮║
echo                                       ║╰╯║╭╯╰╮║╰╯║╭═╯║
echo                                       ╰══╯╰══╯╰══╯╰══╯
echo.
echo. & echo. & echo.
echo.
    if "%lng%"=="en" echo                                                  ver 0.5.0beta
    if "%lng%"=="cn" echo                                                 版本  0.5.0beta
call languages\%lng%.bat main1
echo.
    if "%lng%"=="en" echo                                          Update Time:2021/5/29 15:04
    if "%lng%"=="cn" echo                                            更新时间:2021/5/29 15:04
call languages\%lng%.bat main2
echo.
echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.
echo.
echo  -----------------------------------------------------------------------------------------------------------
    if "%lng%"=="en" echo  Press B to enter Boot Menu,M to BootLoader MenuS to skip,R to reset settings     Copyright (c) 2020 NaivG.
    if "%lng%"=="cn" echo      按B键进入启动菜单，M键进入BL菜单，S键跳过，R键重置                           版权所有（c）2020 NaivG。 
call languages\%lng%.bat main3
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
echo                                  → Boot Option
) else (
echo                                     Boot Option
)
)
if "%choices%" equ "2" (
echo                                  → Language Option
) else (
echo                                     Language Option
)
)
echo.
echo  ============================================================================================================
echo.
:mnblm
choice -n -c wse >nul
if errorlevel == 3 goto :selecte
if errorlevel == 2 goto :downm
if errorlevel == 1 goto :upm
goto :mnblm

:upm
if "%choices%"=="%min%" set "%choices%"=="%max%"&goto :blmenue
set /a choices=%choices%-1
goto :blmenue

:downm
if "%choices%"=="%max%" set "%choices%"=="%min%"&goto :blmenue
set /a choices=%choices%+1
goto :blmenue

:selecte
set m=%choices%
if "%m%"=="1" goto :bootopt
if "%m%"=="2" if "%dep%"=="on" echo [WARN]%date%%time%:好像这里还没完成吧>>%batpath%\DEBUG.LOG
goto :blmenue

:bootopt
cls
if "%dep%"=="on" echo [WARN]%date%%time%:好像这里还没完成吧>>%batpath%\DEBUG.LOG
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
    if "%lng%"=="en" echo The Program Will Reset The Settings.
    if "%lng%"=="cn" echo 程序将会重置设置。
call languages\%lng%.bat main4
del /q settings.ini
rd /s /q %temp%\BIOStemp
ping -n 5 127.1>nul
exit

:booterror
set img=5
set errcode=0x05 Boot Option Missing ERROR
if "%dep%"=="on" echo [ERROR]%date%%time%:Failed To Read Boot Opinion.>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo   ERROR Code:%errcode%>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo       Read Boot Opinion Failed.>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo     End>>%batpath%\DEBUG.LOG
goto bluescreen

:skip
set s=%type1%
set m=1
:boot
if "%lng%"=="en" title BIOS--Boot
if "%lng%"=="cn" title BIOS--启动
cls
if "%s%"=="img" goto img
if "%s%"=="network" goto network
    if "%lng%"=="en" echo Invalid Boot Option Type.
    if "%lng%"=="cn" echo 无效的启动类型。
call languages\%lng%.bat boot1
    if "%lng%"=="en" echo Press Any Key To Exit...
    if "%lng%"=="cn" echo 按任意键退出...
call languages\%lng%.bat boot2
pause>nul
exit

:img
for /f "tokens=1,* delims==" %%a in ('findstr "img%m%b=" boot.ini') do (set BOOT=%%b)
ping -n 2 127.1>nul
    if "%lng%"=="en" echo Loading System Image...
    if "%lng%"=="cn" echo 正在加载系统镜像...
call languages\%lng%.bat boot3
ping -n 2 127.1>nul
ren %BOOT%.img TEMP.zip
unzip -o TEMP 2>nul
ren TEMP.zip %BOOT%.img
ping -n 1 127.1>nul
    if "%lng%"=="en" echo Done!
    if "%lng%"=="cn" echo 完成!
call languages\%lng%.bat boot4
ping -n 2 127.1>nul
    if "%lng%"=="en" echo Creating Virtual Disk...
    if "%lng%"=="cn" echo 正在创建虚拟磁盘...
call languages\%lng%.bat boot5
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
    if "%lng%"=="en" echo Done!
    if "%lng%"=="cn" echo 完成!
call languages\%lng%.bat boot6
ping -n 3 127.1>nul
    if "%lng%"=="en" echo Booting system...
    if "%lng%"=="cn" echo 正在启动系统...
call languages\%lng%.bat boot7
ping -n 2 127.1>nul
cd /d X:\boot\BIOS
ren *.boot sys.cmd
call sys.cmd 2>nul
set img=6
set errcode=0x06 System Image ERROR
if "%dep%"=="on" echo [ERROR]%date%%time%:Failed To Boot System.>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo   ERROR Code:%errcode%>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo       Boot Failed.>>%batpath%\DEBUG.LOG
if not exist %BOOT%.img if "%dep%"=="on" echo       The Pointed IMG File Doesn't Exist.>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo     End>>%batpath%\DEBUG.LOG
goto bluescreen

:network
for /f "tokens=1,* delims==" %%a in ('findstr "address%m%b=" boot.ini') do (set address=%%b)
if not exist wget.exe ping -n 1 137.1>nul & goto:nterror
:ecnext
ping -n 3 127.1>nul
set errorlevel=0
    if "%lng%"=="en" echo Getting System Image From Server...
    if "%lng%"=="cn" echo 正在从服务器获取系统镜像...
call languages\%lng%.bat boot8
wget %address%
if "%lng%"=="en" title BIOS--Boot
if "%lng%"=="cn" title BIOS--启动
    if "%lng%"=="en" echo Done!
    if "%lng%"=="cn" echo 完成!
call languages\%lng%.bat boot9
ping -n 2 127.1>nul
    if "%lng%"=="en" echo Loading System Image...
    if "%lng%"=="cn" echo 正在加载系统镜像...
call languages\%lng%.bat boot10
ping -n 2 127.1>nul
ren download.img TEMP.zip
unzip -o TEMP 2>nul
ren TEMP.zip download.img
ping -n 1 127.1>nul
    if "%lng%"=="en" echo Done!
    if "%lng%"=="cn" echo 完成!
call languages\%lng%.bat boot11
ping -n 2 127.1>nul
    if "%lng%"=="en" echo Creating Virtual Disk...
    if "%lng%"=="cn" echo 正在创建虚拟磁盘...
call languages\%lng%.bat boot12
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
    if "%lng%"=="en" echo Done!
    if "%lng%"=="cn" echo 完成!
call languages\%lng%.bat boot13
ping -n 3 127.1>nul
    if "%lng%"=="en" echo Booting system...
    if "%lng%"=="cn" echo 正在启动系统...
call languages\%lng%.bat boot14
ping -n 2 127.1>nul
cd /d X:\boot\BIOS
ren *.boot sys.cmd
call sys.cmd 2>nul
set img=6
set errcode=0x06 System Image ERROR
if "%dep%"=="on" echo [ERROR]%date%%time%:Failed To Boot System.>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo   ERROR Code:%errcode%>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo       Boot Failed.>>%batpath%\DEBUG.LOG
if not exist download.img if "%dep%"=="on" echo       The Pointed IMG File Doesn't Exist.>>%batpath%\DEBUG.LOG
if "%dep%"=="on" echo     End>>%batpath%\DEBUG.LOG
goto bluescreen

:nterror
set erc=D
goto :ltgerror

:menu
set min=1
set max=3
rem boot menu
if "%lng%"=="en" title BIOS--Boot Menu
if "%lng%"=="cn" title BIOS--启动菜单
:logo2
cls
echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.
echo.
echo                                   ╭════════════════════╮
echo                                  ║                                          ║
:dpname
if "%choices%" equ "1" (
echo                                  ║   → %boot1%  ║
) else (
echo                                  ║      %boot1%  ║
)
)
if "%choices%" equ "2" (
echo                                  ║   → %boot2%                           ║
) else (
echo                                  ║      %boot2%                           ║
)
)
if "%choices%" equ "3" (
echo                                  ║   → %boot3%                   ║
) else (
echo                                  ║      %boot3%                   ║
)
)                
echo                                  ║                                          ║
echo                                  ╰═════════════════════╯
echo.
echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.
echo.
if "%lng%"=="en" echo                            Press W up, S down, E to select, I to see option info.
if "%lng%"=="cn" echo                                      按W向上，S向下，E选择，I显示选项信息。 
call languages\%lng%.bat main5
echo.
choice -n -c wsei >nul
if errorlevel == 4 goto :info
if errorlevel == 3 goto :select
if errorlevel == 2 (
    if "%choices%"=="%max%" set "%choices%"=="%min%"&goto :logo2
    set /a choices=%choices%+1
    goto :logo2
)
if errorlevel == 1 (
    if "%choices%"=="%min%" set "%choices%"=="%max%"&goto :logo2
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
set dperror=0
set m=%choices%
if "%m%"=="1" goto a1
if "%m%"=="2" goto a2
if "%m%"=="3" goto a3

:a1
set bootname=%boot1%
set s=%type1%
goto:infonext

:a2
set bootname=%boot2%
set s=%type2%
goto:infonext

:a3
set bootname=%boot3%
set s=%type3%
goto:infonext

:infonext
cls
echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.
echo.
echo  ============================================================================================================
if "%lng%"=="en" echo                        Boot Option Name:%bootname%
if "%lng%"=="cn" echo                        启动项名称:%bootname%  
call languages\%lng%.bat main6
if "%lng%"=="en" echo                        Boot Option Type:%s%
if "%lng%"=="cn" echo                        启动项类型:%s%
call languages\%lng%.bat main7
if "%s%"=="img" (
for /f "tokens=1,* delims==" %%a in ('findstr "img%m%b=" boot.ini') do (set BOOT=%%b)
if "%lng%"=="en" echo                        System Image Name:%BOOT%.img
if "%lng%"=="cn" echo                        系统镜像名称:%BOOT%.img
if not exist %BOOT%.img (
   set dperror=1
    if "%lng%"=="en" echo                        System Status:Not Ready
    if "%lng%"=="cn" echo                        系统状态:Not Ready
   )
) else if "%s%"=="network" (
for /f "tokens=1,* delims==" %%a in ('findstr "address%m%b=" boot.ini') do (set address=%%b)
if "%lng%"=="en" echo                        System Image Address:%address%
if "%lng%"=="cn" echo                        系统镜像路径:%address%
) else (
if "%lng%"=="en" echo                        Invalid Boot Option Type.
if "%lng%"=="cn" echo                        无效的启动类型。
)
if "%dperror%" neq "1" (
if "%lng%"=="en" echo                        System Status:Ready
if "%lng%"=="cn" echo                        系统状态:Ready
)
if "%lng%"=="en" echo                        Press Any Key To Return To The Boot Menu.
if "%lng%"=="cn" echo                        按任意键返回启动菜单。 
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
echo   → Try to fix
) else (
echo      Try to fix
)
if "%choices%" equ "2" (
echo   → Reset settings
) else (
echo      Reset settings
)
if "%choices%" equ "3" (
echo   → Normal start-up
) else (
echo      Normal start-up
)
if "%choices%" equ "4" (
echo   → Exit
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
if "%number:~0,3%" neq "050" (
    echo   Find Number Setting ERROR.Fixing...
    set tmpnum=050-%random%-%random%-%random%
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
del /s /q err.tmp
cls
color 97
echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.
echo.
echo  ============================================================================================================
echo        一个未知的错误导致程序将终止运行。
echo        An Unknown Error Caused The Program To Stop Running. 
echo        错误代码:%errcode%
echo        Error Code:%errcode%
echo        你可以尝试重新运行，或将本目录下的错误日志(ERROR.log)发送给作者。
echo        You Can Try Running It Again Or Send The Error Log (ERROR.log) In This Directory To The Author.
echo        按任意键退出...   
echo        Press Any Key To Exit...
echo  ============================================================================================================
echo %date% %time% Error Code:%errcode%>>%batpath%\ERROR.log
echo code=%errcode%>err.tmp
pause>nul
exit