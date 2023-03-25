

@echo off
if "%1"=="firstrun" goto :firstrun
if "%1"=="check" goto :check
if "%1"=="compatible" goto :compatible
if "%1"=="main" goto :main
if "%1"=="info" goto :info
if "%1"=="boot" goto :boot
echo 语言配置错误！ & goto :EOF

:firstrun
if "%2"=="1" echo 正在配置语言... & goto :EOF
if "%2"=="2" echo 完成! & goto :EOF
if "%2"=="3" echo 检查程序完整性... & goto :EOF
if "%2"=="4" echo 完成! & goto :EOF
if "%2"=="5" echo 检测到缺失文件：%lostitem%，这可能会引起错误。 & goto :EOF
if "%2"=="6" echo 是否继续配置？[Y,N] & goto :EOF
if "%2"=="7" echo 是否启用获取UAC？[Y,N] & goto :EOF
if "%2"=="8" echo 注意：获取UAC后稳定性可能增加也可能降低。 & goto :EOF
if "%2"=="9" echo 自动配置中，请稍后... & goto :EOF
if "%2"=="10" echo 生成默认启动配置文件中... & goto :EOF
if "%2"=="11" echo 完成! & goto :EOF
if "%2"=="12" echo 按任意键重启程序... & goto :EOF
if "%2"=="13" echo 检测到你正在使用Windows 10操作系统，这可能导致显示错误。 & goto :EOF
if "%2"=="14" echo 是否修改注册表以支持此程序？[Y,N] & goto :EOF
if "%2"=="15" echo 注意：某些系统修改注册表后将无法复原，请谨慎选择！ & goto :EOF
echo 语言配置错误！ & goto :EOF

:check
if "%2"=="1" echo 正在获取UAC... & goto :EOF
if "%2"=="2" echo 检查程序完整性... & goto :EOF
if "%2"=="3" echo 检查系统兼容性... & goto :EOF
echo 语言配置错误！ & goto :EOF

:compatible
if "%2"=="1" echo 您的系统可能与此程序不兼容，请使用Windows7或Windows10。 & goto :EOF
if "%2"=="2" echo 如果要强制执行，请按Y，否则按N退出。 & goto :EOF
if "%2"=="3" echo 正在修改注册表以支持此程序... & goto :EOF
echo 语言配置错误！ & goto :EOF

:main
if "%2"=="1" echo                                                 版本  %Version% & goto :EOF
if "%2"=="2" echo                                            更新时间:%uptime% & goto :EOF
if "%2"=="3" echo      按B键进入启动菜单，M键进入BL菜单，S键跳过，R键重置                           版权所有（c）%date:~0,4% NaivG。  & goto :EOF
if "%2"=="4" echo                                      按W向上，S向下，E选择，I显示选项信息。  & goto :EOF
echo 语言配置错误！ & goto :EOF

:info
if "%2"=="1" echo                        启动项名称:%bootname%   & goto :EOF
if "%2"=="2" echo                        启动项类型:%s% & goto :EOF
if "%2"=="3" echo                        系统镜像名称:%BOOT%.img & goto :EOF
if "%2"=="4" echo                        系统状态:Not Ready & goto :EOF
if "%2"=="5" echo                        系统状态:Ready & goto :EOF
if "%2"=="6" echo                        系统镜像路径:%address% & goto :EOF
if "%2"=="7" echo                        无效的启动类型。 & goto :EOF
if "%2"=="8" echo                        按任意键返回启动菜单。 & goto :EOF
echo 语言配置错误！ & goto :EOF

:boot
if "%2"=="1" echo 无效的启动类型。 & goto :EOF
if "%2"=="2" echo 按任意键退出... & goto :EOF
if "%2"=="3" echo 正在加载系统镜像... & goto :EOF
if "%2"=="4" echo 完成! & goto :EOF
if "%2"=="5" echo 正在创建虚拟磁盘... & goto :EOF
if "%2"=="6" echo 完成! & goto :EOF
if "%2"=="7" echo 正在启动系统... & goto :EOF
if "%2"=="8" echo 正在从服务器获取系统镜像... & goto :EOF
if "%2"=="9" echo 完成! & goto :EOF
if "%2"=="10" echo 正在加载系统镜像... & goto :EOF
if "%2"=="11" echo 完成! & goto :EOF
if "%2"=="12" echo 正在创建虚拟磁盘... & goto :EOF
if "%2"=="13" echo 完成! & goto :EOF
if "%2"=="14" echo 正在启动系统... & goto :EOF
echo 语言配置错误！ & goto :EOF
