

@echo off
if "%1"=="firstrun" goto :firstrun
if "%1"=="check" goto :check
if "%1"=="compatible" goto :compatible
if "%1"=="main" goto :main
if "%1"=="info" goto :info
if "%1"=="boot" goto :boot
echo Language configuration error! & goto :EOF

:firstrun
if "%2"=="1" echo Configuring Language... & goto :EOF
if "%2"=="2" echo Done! & goto :EOF
if "%2"=="3" echo Check Program Integrity... & goto :EOF
if "%2"=="4" echo Done! & goto :EOF
if "%2"=="5" echo Missing file: %lostitem%, this may cause an error. & goto :EOF
if "%2"=="6" echo Does the configuration continue? [Y,N] & goto :EOF
if "%2"=="7" echo Is Get UAC enabled?[Y,N] & goto :EOF
if "%2"=="8" echo Note: Stability may increase or decrease after acquiring the UAC. & goto :EOF
if "%2"=="9" echo Automatic configuration in progress, please wait... & goto :EOF
if "%2"=="10" echo Generate default boot file... & goto :EOF
if "%2"=="11" echo Done! & goto :EOF
if "%2"=="12" echo Press Any Key To Restart The Program... & goto :EOF
if "%2"=="13" echo It Has Been Detected That You Are Using The Windows 10 Operating System, Which May Cause Display Errors. & goto :EOF
if "%2"=="14" echo Do You Want To Modify The Registry To Support This Program? [Y,N] & goto :EOF
if "%2"=="15" echo Note: Some Systems Cannot Be Restored After Modifying The Registry, Please Choose Carefully! & goto :EOF
echo Language configuration error! & goto :EOF

:check
if "%2"=="1" echo Getting UAC... & goto :EOF
if "%2"=="2" echo Check Program Integrity... & goto :EOF
if "%2"=="3" echo Check System Compatibility... & goto :EOF
echo Language configuration error! & goto :EOF

:compatible
if "%2"=="1" echo Your system may not be compatible with this program, please use Windows 7 or Windows 10. & goto :EOF
if "%2"=="2" echo To force it, press Y, otherwise press N to exit. & goto :EOF
if "%2"=="3" echo Modifying Registry To Support This Program... & goto :EOF
echo Language configuration error! & goto :EOF

:main
if "%2"=="1" echo                                                  ver %Version% & goto :EOF
if "%2"=="2" echo                                          Update Time:%uptime% & goto :EOF
if "%2"=="3" echo  Press B to enter Boot Menu,M to BootLoader Menu,S to skip,R to reset settings     Copyright (c) %date:~0,4% NaivG.  & goto :EOF
if "%2"=="4" echo                            Press W up, S down, E to select, I to see option info. & goto :EOF
echo Language configuration error! & goto :EOF

:info
if "%2"=="1" echo                        Boot Option Name:%bootname%   & goto :EOF
if "%2"=="2" echo                        Boot Option Type:%s% & goto :EOF
if "%2"=="3" echo                        System Image Name:%BOOT%.img & goto :EOF
if "%2"=="4" echo                        System Status:Not Ready & goto :EOF
if "%2"=="5" echo                        System Status:Ready & goto :EOF
if "%2"=="6" echo                        System Image Address:%address% & goto :EOF
if "%2"=="7" echo                        Invalid Boot Option Type. & goto :EOF
if "%2"=="8" echo                        Press Any Key To Return To The Boot Menu. & goto :EOF
echo Language configuration error! & goto :EOF

:boot
if "%2"=="1" echo Invalid Boot Option Type. & goto :EOF
if "%2"=="2" echo Press Any Key To Exit... & goto :EOF
if "%2"=="3" echo Loading System Image... & goto :EOF
if "%2"=="4" echo Done! & goto :EOF
if "%2"=="5" echo Creating Virtual Disk... & goto :EOF
if "%2"=="6" echo Done! & goto :EOF
if "%2"=="7" echo Booting system... & goto :EOF
if "%2"=="8" echo Downloading System Image... & goto :EOF
if "%2"=="9" echo Done! & goto :EOF
if "%2"=="10" echo Loading System Image... & goto :EOF
if "%2"=="11" echo Done! & goto :EOF
if "%2"=="12" echo Creating Virtual Disk... & goto :EOF
if "%2"=="13" echo Done! & goto :EOF
if "%2"=="14" echo Booting system... & goto :EOF
echo Language configuration error! & goto :EOF
