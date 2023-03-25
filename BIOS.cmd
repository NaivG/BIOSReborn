

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
if "%lng%"=="cn" title BIOS--���ϵͳ������
if "%lng%"=="en" echo Check System Compatibility...
if "%lng%"=="cn" echo ���ϵͳ������...
ping -n 2 127.1>nul
if exist oldcons.tmp del oldcons.tmp&goto load
ver|findstr /r /i " [�汾 6.1.*]" > NUL && goto load
ver|findstr /r /i " [�汾 10.0.*]" > NUL && goto oldcons
if "%lng%"=="en" echo Your System Is Not Compatible With This Program,Please Use Windows7 Or Windows10.
if "%lng%"=="cn" echo ����ϵͳ��˳��򲻼��ݣ���ʹ��Windows7��Windows10��
if "%lng%"=="en" echo If You Want To Force It, Press A, Otherwise Press E To Exit.
if "%lng%"=="cn" echo ���Ҫǿ��ִ�У��밴A������E�˳���
if "%lng%"=="en" echo Note: If You Are Not Using The Chinese Version Of Windows, The Program May Misjudge.
if "%lng%"=="cn" echo ע�⣺�����ʹ�õĲ������İ��Windows������������С�
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
echo ��������:
echo Enter E To Set English.
echo ���� C �������ġ�
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
echo ������������...
ping -n 2 127.1>nul
echo [Language Info]>language.ini
echo lng=cn>>language.ini
ping -n 1 127.1>nul
echo ���!
echo ���������������...
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
if "%lng%"=="cn" echo �ҵ�Windows 10����ϵͳ�������޸�ע�����֧�ִ˳���...
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
echo                                       �q�T�T�r�q�T�T�r�q�T�T�r�q�T�T�r
echo                                       �U�q�r�U�t�r�q�s�U�q�r�U�U�q�T�s
echo                                       �U�t�s�s���U�U���U�U�U�U�U�t�T�r
echo                                       �U�q�r�r���U�U���U�U�U�U�t�T�r�U
echo                                       �U�t�s�U�q�s�t�r�U�t�s�U�q�T�s�U
echo                                       �t�T�T�s�t�T�T�s�t�T�T�s�t�T�T�s
echo.
echo.
echo.
echo.
echo.
if "%lng%"=="en" echo                                                  ver 0.3.1
if "%lng%"=="cn" echo                                                 �汾  0.3.1
echo.
if "%lng%"=="en" echo                                          Update Time:2020/8/13 20:56
if "%lng%"=="cn" echo                                            ����ʱ��:2020/8/13 20:56
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
if "%lng%"=="cn" echo      ��B�����������˵���S������                                            ��Ȩ���У�c��2020 NaivG�� 
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
if "%lng%"=="cn" title BIOS--����
cls
if "%s%"=="img" goto img
if "%s%"=="network" goto network
if "%lng%"=="en" echo Invalid Boot Option Type.
if "%lng%"=="cn" echo ��Ч���������͡�
if "%lng%"=="en" echo Press Any Key To Exit...
if "%lng%"=="cn" echo ��������˳�...
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
if "%lng%"=="cn" echo ���ڼ���ϵͳ����...
ping -n 2 127.1>nul
ren %BOOT%.img TEMP.zip
unzip -o TEMP 2>nul
ren TEMP.zip %BOOT%.img
ping -n 1 127.1>nul
if "%lng%"=="en" echo Done!
if "%lng%"=="cn" echo ���!
ping -n 2 127.1>nul
if "%lng%"=="en" echo Creating Virtual Disk...
if "%lng%"=="cn" echo ���ڴ����������...
ping -n 1 127.1>nul
subst X: %~dp0disk >nul 2>nul
md C:\Windows\BIOStemp 2>nul
echo @echo off>C:\Windows\BIOStemp\del.bat
echo subst X: /d>>C:\Windows\BIOStemp\del.bat
echo rd /s /q %cd%\disk>>C:\Windows\BIOStemp\del.bat
echo exit>>C:\Windows\BIOStemp\del.bat
ping -n 1 127.1>nul
if "%lng%"=="en" echo Done!
if "%lng%"=="cn" echo ���!
ping -n 3 127.1>nul
if "%lng%"=="en" echo Booting system...
if "%lng%"=="cn" echo ��������ϵͳ...
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
echo ���ڴӷ�������ȡϵͳ����...
wget %address%
if "%lng%"=="en" title BIOS--Boot
if "%lng%"=="cn" title BIOS--����
if "%lng%"=="en" echo Done!
if "%lng%"=="cn" echo ���!
ping -n 2 127.1>nul
if "%lng%"=="en" echo Loading System Image...
if "%lng%"=="cn" echo ���ڼ���ϵͳ����...
ping -n 2 127.1>nul
ren download.img TEMP.zip
unzip -o TEMP 2>nul
ren TEMP.zip download.img
ping -n 1 127.1>nul
if "%lng%"=="en" echo Done!
if "%lng%"=="cn" echo ���!
ping -n 2 127.1>nul
if "%lng%"=="en" echo Creating Virtual Disk...
if "%lng%"=="cn" echo ���ڴ����������...
ping -n 1 127.1>nul
subst X: %~dp0disk 2>nul
md C:\Windows\BIOStemp 2>nul
echo @echo off>C:\Windows\BIOStemp\del.bat
echo subst X: /d>>C:\Windows\BIOStemp\del.bat
echo rd /s /q %cd%\disk>>C:\Windows\BIOStemp\del.bat
echo exit>>C:\Windows\BIOStemp\del.bat
ping -n 1 127.1>nul
if "%lng%"=="en" echo Done!
if "%lng%"=="cn" echo ���!
ping -n 3 127.1>nul
if "%lng%"=="en" echo Booting system...
if "%lng%"=="cn" echo ��������ϵͳ...
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
if "%lng%"=="cn" title BIOS--�����˵�
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
echo                                   �q�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�r
echo                                  �U                                          �U
:dpname
if "%choices%" equ "1" (
echo                                  �U   �� %boot1%  �U
) else (
echo                                  �U      %boot1%  �U
)
)
if "%choices%" equ "2" (
echo                                  �U   �� %boot2%                           �U
) else (
echo                                  �U      %boot2%                           �U
)
)
if "%choices%" equ "3" (
echo                                  �U   �� %boot3%                   �U
) else (
echo                                  �U      %boot3%                   �U
)
)                
echo                                  �U                                          �U
echo                                  �t�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�s
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
if "%lng%"=="cn" echo                                      ��W���ϣ�S���£�Eѡ��I��ʾѡ����Ϣ�� 
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
if "%lng%"=="cn" echo                        ����������:%bootname%  
if "%lng%"=="en" echo                        Boot Option Type:%s%
if "%lng%"=="cn" echo                        ����������:%s%
if "%s%"=="img" goto indpimg
if "%s%"=="network" goto indpnet
if "%lng%"=="en" echo                        Invalid Boot Option Type.
if "%lng%"=="cn" echo                        ��Ч���������͡�
goto indpnext
:indpimg
for /f "tokens=1,* delims==" %%a in ('findstr "img%m%b=" boot.ini') do (set BOOT=%%b)
if "%lng%"=="en" echo                        System Image Name:%BOOT%.img
if "%lng%"=="cn" echo                        ϵͳ��������:%BOOT%.img
if not exist %BOOT%.img set dperror=1
goto indpnext
:indpnet
for /f "tokens=1,* delims==" %%a in ('findstr "address%m%b=" boot.ini') do (set address=%%b)
if "%lng%"=="en" echo                        System Image Address:%address%
if "%lng%"=="cn" echo                        ϵͳ����·��:%address%
goto indpnext
:dperror
if "%lng%"=="en" echo                        System Status:Not Ready
if "%lng%"=="cn" echo                        ϵͳ״̬:Not Ready
goto infoend
:indpnext
if "%dperror%"=="1" goto dperror
if "%lng%"=="en" echo                        System Status:Ready
if "%lng%"=="cn" echo                        ϵͳ״̬:Ready
:infoend
if "%lng%"=="en" echo                        Press Any Key To Return To The Boot Menu.
if "%lng%"=="cn" echo                        ����������������˵��� 
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
echo        һ��δ֪�Ĵ����³�����ֹ���С�
echo        An Unknown Error Caused The Program To Stop Running. 
echo        �������:%errcode%
echo        Error Code:%errcode%
echo        ����Գ����������У��򽫱�Ŀ¼�µĴ�����־(ERROR.log)���͸����ߡ�
echo        You Can Try Running It Again Or Send The Error Log (ERROR.log) In This Directory To The Author.
echo        ɨ���ά��ɲ鿴�ο����������
echo        Scan The QR Code To See The Reference Solutions.
echo        ��������˳�...   
echo        Press Any Key To Exit...
echo  ============================================================================================================
if not exist img.exe echo ��ʧ img.exe ,����޷����ض�ά�롣 & echo Missing img.exe ,So Cannot Load QR Code. & goto end
if not exist QR\%img%.jpg echo �Ҳ�����ά�롣 & echo QR Code Not Found. & goto end
img.exe QR\%img%.jpg:328,465
:end
echo %date% %time% Error Code:%errcode%>>ERROR.log
pause>nul
exit