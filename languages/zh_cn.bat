
@echo off
set command=%1
::firstrun

::check
if "%command%"=="check1" echo ������������... & goto :end
if "%command%"=="check2" echo ���ϵͳ������... & goto :end
if "%command%"=="compatible1" echo ����ϵͳ��˳��򲻼��ݣ���ʹ��Windows7��Windows10�� & goto :end
if "%command%"=="compatible2" echo ���Ҫǿ��ִ�У��밴Y������N�˳��� & goto :end
if "%command%"=="compatible3" echo �����޸�ע�����֧�ִ˳���... & goto :end
::main
if "%command%"=="main1" echo                                                 �汾  %Version% & goto :end
if "%command%"=="main2" echo                                            ����ʱ��:%uptime% & goto :end
if "%command%"=="main3" echo      ��B�����������˵���M������BL�˵���S��������R������                           ��Ȩ���У�c��2022 NaivG��  & goto :end
if "%command%"=="main4" echo ���򽫻��������á� & goto :end
if "%command%"=="main5" echo                                      ��W���ϣ�S���£�Eѡ��I��ʾѡ����Ϣ��  & goto :end
::boot
if "%command%"=="boot1" echo ��Ч���������͡� & goto :end
if "%command%"=="boot2" echo ��������˳�... & goto :end
if "%command%"=="boot3" echo ���ڼ���ϵͳ����... & goto :end
if "%command%"=="boot4" echo ���! & goto :end
if "%command%"=="boot5" echo ���ڴ����������... & goto :end
if "%command%"=="boot6" echo ���! & goto :end
if "%command%"=="boot7" echo ��������ϵͳ... & goto :end
if "%command%"=="boot8" echo ���ڴӷ�������ȡϵͳ����... & goto :end
if "%command%"=="boot9" echo ���! & goto :end
if "%command%"=="boot10" echo ���ڼ���ϵͳ����... & goto :end
if "%command%"=="boot11" echo ���! & goto :end
if "%command%"=="boot12" echo ���ڴ����������... & goto :end
if "%command%"=="boot13" echo ���! & goto :end
if "%command%"=="boot14" echo ��������ϵͳ... & goto :end

:end