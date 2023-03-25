
@echo off
set command=%1
::firstrun

::check
if "%command%"=="check1" echo 检查程序完整性... & goto :end
if "%command%"=="check2" echo 检查系统兼容性... & goto :end
if "%command%"=="compatible1" echo 您的系统与此程序不兼容，请使用Windows7或Windows10。 & goto :end
if "%command%"=="compatible2" echo 如果要强制执行，请按Y，否则按N退出。 & goto :end
if "%command%"=="compatible3" echo 正在修改注册表以支持此程序... & goto :end
::main
if "%command%"=="main1" echo                                                 版本  %Version% & goto :end
if "%command%"=="main2" echo                                            更新时间:%uptime% & goto :end
if "%command%"=="main3" echo      按B键进入启动菜单，M键进入BL菜单，S键跳过，R键重置                           版权所有（c）2022 NaivG。  & goto :end
if "%command%"=="main4" echo 程序将会重置设置。 & goto :end
if "%command%"=="main5" echo                                      按W向上，S向下，E选择，I显示选项信息。  & goto :end
::boot
if "%command%"=="boot1" echo 无效的启动类型。 & goto :end
if "%command%"=="boot2" echo 按任意键退出... & goto :end
if "%command%"=="boot3" echo 正在加载系统镜像... & goto :end
if "%command%"=="boot4" echo 完成! & goto :end
if "%command%"=="boot5" echo 正在创建虚拟磁盘... & goto :end
if "%command%"=="boot6" echo 完成! & goto :end
if "%command%"=="boot7" echo 正在启动系统... & goto :end
if "%command%"=="boot8" echo 正在从服务器获取系统镜像... & goto :end
if "%command%"=="boot9" echo 完成! & goto :end
if "%command%"=="boot10" echo 正在加载系统镜像... & goto :end
if "%command%"=="boot11" echo 完成! & goto :end
if "%command%"=="boot12" echo 正在创建虚拟磁盘... & goto :end
if "%command%"=="boot13" echo 完成! & goto :end
if "%command%"=="boot14" echo 正在启动系统... & goto :end

:end