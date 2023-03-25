

@echo off
cls
mode 110,40
color 0a
title BIOS
subst X: /d 2>nul
cls
title BIOS--Check Program Integrity
if not exist choice.exe set erc=A&goto :ltgerror
if not exist unzip.exe set erc=B&goto :ltgerror
if not exist img.exe set erc=C&goto :ltgerror
title BIOS--Checking Language Info
if not exist language.ini goto :lngsetting
for /f "tokens=1,* delims==" %%a in ('findstr "lng=" language.ini') do (set lng=%%b)
if "%lng%" neq "en" (if "%lng%" neq "cn" (goto :lngerror))
if "%lng%"=="en" title BIOS--Check System Compatibility
if "%lng%"=="cn" title BIOS--检查系统兼容性
if "%lng%"=="en" echo Check System Compatibility...
if "%lng%"=="cn" echo 检查系统兼容性...
ping -n 2 127.1>nul
if exist oldcons.tmp del oldcons.tmp&goto load
ver|findstr /r /i " [版本 6.1.*]" > NUL && goto load
ver|findstr /r /i " [版本 10.0.*]" > NUL && goto oldcons
if "%lng%"=="en" echo Your System Is Not Compatible With This Program,Please Use Windows7 Or Windows10.
if "%lng%"=="cn" echo 您的系统与此程序不兼容，请使用Windows7或Windows10。
if "%lng%"=="en" echo If You Want To Force It, Press A, Otherwise Press E To Exit.
if "%lng%"=="cn" echo 如果要强制执行，请按A，否则按E退出。
if "%lng%"=="en" echo Note: If You Are Not Using The Chinese Version Of Windows, The Program May Misjudge.
if "%lng%"=="cn" echo 注意：如果您使用的不是中文版的Windows，程序可能误判。
choice -n -c ae >nul
if errorlevel == 2 exit
if errorlevel == 1 goto :load

:ltgerror
set img=1
set errcode=0x%erc%1 Program Missing ERROR
goto bluescreen

:lngsetting
title BIOS--Set Language
echo Set Language:
echo 设置语言:
echo Enter E To Set English.
echo 输入 C 设置中文。
choice -n -c ec >nul
if errorlevel == 2 goto :zhcn
if errorlevel == 1 goto :enus

:enus
echo Configuring Language...
ping -n 2 127.1>nul
echo [Language Info]>language.ini
echo lng=en>>language.ini
ping -n 1 127.1>nul
echo Done!
echo Press Any Key To Restart The Program...
pause>nul
call BIOS.cmd 2>nul
set img=3
set errcode=0x03 Suffix ERROR
goto bluescreen

:zhcn
echo 正在配置语言...
ping -n 2 127.1>nul
echo [Language Info]>language.ini
echo lng=cn>>language.ini
ping -n 1 127.1>nul
echo 完成!
echo 按任意键重启程序...
pause>nul
call BIOS.cmd 2>nul
set img=3
set errcode=0x03 Suffix ERROR
goto bluescreen

:lngerror
set img=2
set errcode=0x02 Language Setting ERROR
goto bluescreen

:oldcons
if "%lng%"=="en" echo Found Windows 10 Operating System, Modifying Registry To Support This Program...
if "%lng%"=="cn" echo 找到Windows 10操作系统，正在修改注册表以支持此程序...
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
 echo 0>>oldcons.tmp
 call BIOS.cmd 2>nul
 set img=3
 set errcode=0x03 Suffix ERROR
goto bluescreen
)
:olderror
set img=4
set errcode=0x04 Modifying Registry ERROR
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
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                                       ╭══╮╭══╮╭══╮╭══╮
echo                                       ║╭╮║╰╮╭╯║╭╮║║╭═╯
echo                                       ║╰╯╯　║║　║║║║║╰═╮
echo                                       ║╭╮╮　║║　║║║║╰═╮║
echo                                       ║╰╯║╭╯╰╮║╰╯║╭═╯║
echo                                       ╰══╯╰══╯╰══╯╰══╯
echo.
echo.
echo.
echo.
echo.
if "%lng%"=="en" echo                                                  ver 0.3.1
if "%lng%"=="cn" echo                                                 版本  0.3.1
echo.
if "%lng%"=="en" echo                                          Update Time:2020/8/13 20:56
if "%lng%"=="cn" echo                                            更新时间:2020/8/13 20:56
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo  -----------------------------------------------------------------------------------------------------------
if "%lng%"=="en" echo  Press B to enter Boot Menu,S to skip                         Copyright (c) 2020 NaivG. All rights reserved.
if "%lng%"=="cn" echo      按B键进入启动菜单，S键跳过                                            版权所有（c）2020 NaivG。 
echo  -----------------------------------------------------------------------------------------------------------          
choice -n -c bs >nul
if errorlevel == 2 goto :skip
if errorlevel == 1 goto :menu

:skip
set s=%type1%
set m=1
rem boot
:boot
rem check boot option type
if "%lng%"=="en" title BIOS--Boot
if "%lng%"=="cn" title BIOS--启动
cls
if "%s%"=="img" goto img
if "%s%"=="network" goto network
if "%lng%"=="en" echo Invalid Boot Option Type.
if "%lng%"=="cn" echo 无效的启动类型。
if "%lng%"=="en" echo Press Any Key To Exit...
if "%lng%"=="cn" echo 按任意键退出...
pause>nul
exit


:booterror
set img=5
set errcode=0x05 Boot Option Missing ERROR
goto bluescreen

:img
for /f "tokens=1,* delims==" %%a in ('findstr "img%m%b=" boot.ini') do (set BOOT=%%b)
ping -n 2 127.1>nul
if "%lng%"=="en" echo Loading System Image...
if "%lng%"=="cn" echo 正在加载系统镜像...
ping -n 2 127.1>nul
ren %BOOT%.img TEMP.zip
unzip -o TEMP 2>nul
ren TEMP.zip %BOOT%.img
ping -n 1 127.1>nul
if "%lng%"=="en" echo Done!
if "%lng%"=="cn" echo 完成!
ping -n 2 127.1>nul
if "%lng%"=="en" echo Creating Virtual Disk...
if "%lng%"=="cn" echo 正在创建虚拟磁盘...
ping -n 1 127.1>nul
subst X: %~dp0disk >nul 2>nul
md C:\Windows\BIOStemp 2>nul
echo @echo off>C:\Windows\BIOStemp\del.bat
echo subst X: /d>>C:\Windows\BIOStemp\del.bat
echo rd /s /q %cd%\disk>>C:\Windows\BIOStemp\del.bat
echo exit>>C:\Windows\BIOStemp\del.bat
ping -n 1 127.1>nul
if "%lng%"=="en" echo Done!
if "%lng%"=="cn" echo 完成!
ping -n 3 127.1>nul
if "%lng%"=="en" echo Booting system...
if "%lng%"=="cn" echo 正在启动系统...
ping -n 2 127.1>nul
cd /d X:\boot\BIOS
ren *.boot sys.cmd
call sys.cmd 2>nul
set img=6
set errcode=0x06 System Image ERROR
goto bluescreen

:network
for /f "tokens=1,* delims==" %%a in ('findstr "address%m%b=" boot.ini') do (set address=%%b)
if not exist wget.exe ping -n 1 137.1>nul & goto:nterror
:ecnext
ping -n 3 127.1>nul
set errorlevel=0
echo Getting System Image From Server...
echo 正在从服务器获取系统镜像...
wget %address%
if "%lng%"=="en" title BIOS--Boot
if "%lng%"=="cn" title BIOS--启动
if "%lng%"=="en" echo Done!
if "%lng%"=="cn" echo 完成!
ping -n 2 127.1>nul
if "%lng%"=="en" echo Loading System Image...
if "%lng%"=="cn" echo 正在加载系统镜像...
ping -n 2 127.1>nul
ren download.img TEMP.zip
unzip -o TEMP 2>nul
ren TEMP.zip download.img
ping -n 1 127.1>nul
if "%lng%"=="en" echo Done!
if "%lng%"=="cn" echo 完成!
ping -n 2 127.1>nul
if "%lng%"=="en" echo Creating Virtual Disk...
if "%lng%"=="cn" echo 正在创建虚拟磁盘...
ping -n 1 127.1>nul
subst X: %~dp0disk 2>nul
md C:\Windows\BIOStemp 2>nul
echo @echo off>C:\Windows\BIOStemp\del.bat
echo subst X: /d>>C:\Windows\BIOStemp\del.bat
echo rd /s /q %cd%\disk>>C:\Windows\BIOStemp\del.bat
echo exit>>C:\Windows\BIOStemp\del.bat
ping -n 1 127.1>nul
if "%lng%"=="en" echo Done!
if "%lng%"=="cn" echo 完成!
ping -n 3 127.1>nul
if "%lng%"=="en" echo Booting system...
if "%lng%"=="cn" echo 正在启动系统...
ping -n 2 127.1>nul
copy language.ini X:\sys
cd /d X:\boot\BIOS
ren *.boot sys.cmd
call sys.cmd 2>nul
set img=6
set errcode=0x06 System Image ERROR
goto bluescreen

:nterror
set img=1
set errcode=0xD1 Program Missing ERROR
goto bluescreen

:menu
set min=1
set max=3
rem boot menu
if "%lng%"=="en" title BIOS--Boot Menu
if "%lng%"=="cn" title BIOS--启动菜单
:logo2
cls
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
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
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
if "%lng%"=="en" echo                            Press W up, S down, E to select, I to see option info.
if "%lng%"=="cn" echo                                      按W向上，S向下，E选择，I显示选项信息。 
echo.
:mnc
choice -n -c wsei >nul
if errorlevel == 4 goto :info
if errorlevel == 3 goto :select
if errorlevel == 2 goto :down
if errorlevel == 1 goto :up
goto :mnc

:up
if "%choices%"=="%min%" set "%choices%"=="%max%"&goto :logo2
set /a choices=%choices%-1
goto :logo2

:down
if "%choices%"=="%max%" set "%choices%"=="%min%"&goto :logo2
set /a choices=%choices%+1
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
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo  ============================================================================================================
if "%lng%"=="en" echo                        Boot Option Name:%bootname%
if "%lng%"=="cn" echo                        启动项名称:%bootname%  
if "%lng%"=="en" echo                        Boot Option Type:%s%
if "%lng%"=="cn" echo                        启动项类型:%s%
if "%s%"=="img" goto indpimg
if "%s%"=="network" goto indpnet
if "%lng%"=="en" echo                        Invalid Boot Option Type.
if "%lng%"=="cn" echo                        无效的启动类型。
goto indpnext
:indpimg
for /f "tokens=1,* delims==" %%a in ('findstr "img%m%b=" boot.ini') do (set BOOT=%%b)
if "%lng%"=="en" echo                        System Image Name:%BOOT%.img
if "%lng%"=="cn" echo                        系统镜像名称:%BOOT%.img
if not exist %BOOT%.img set dperror=1
goto indpnext
:indpnet
for /f "tokens=1,* delims==" %%a in ('findstr "address%m%b=" boot.ini') do (set address=%%b)
if "%lng%"=="en" echo                        System Image Address:%address%
if "%lng%"=="cn" echo                        系统镜像路径:%address%
goto indpnext
:dperror
if "%lng%"=="en" echo                        System Status:Not Ready
if "%lng%"=="cn" echo                        系统状态:Not Ready
goto infoend
:indpnext
if "%dperror%"=="1" goto dperror
if "%lng%"=="en" echo                        System Status:Ready
if "%lng%"=="cn" echo                        系统状态:Ready
:infoend
if "%lng%"=="en" echo                        Press Any Key To Return To The Boot Menu.
if "%lng%"=="cn" echo                        按任意键返回启动菜单。 
echo  ============================================================================================================
pause>nul
goto :logo2

:bluescreen
title BIOS--ERROR
subst X: /d 2>nul
cls
color 97
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo  ============================================================================================================
echo        一个未知的错误导致程序将终止运行。
echo        An Unknown Error Caused The Program To Stop Running. 
echo        错误代码:%errcode%
echo        Error Code:%errcode%
echo        你可以尝试重新运行，或将本目录下的错误日志(ERROR.log)发送给作者。
echo        You Can Try Running It Again Or Send The Error Log (ERROR.log) In This Directory To The Author.
echo        扫描二维码可查看参考解决方法。
echo        Scan The QR Code To See The Reference Solutions.
echo        按任意键退出...   
echo        Press Any Key To Exit...
echo  ============================================================================================================
if not exist img.exe echo 丢失 img.exe ,因此无法加载二维码。 & echo Missing img.exe ,So Cannot Load QR Code. & goto end
if not exist QR\%img%.jpg echo 找不到二维码。 & echo QR Code Not Found. & goto end
img.exe QR\%img%.jpg:328,465
:end
echo %date% %time% Error Code:%errcode%>>ERROR.log
pause>nul
exit