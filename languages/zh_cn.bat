

@echo off
if "%1"=="firstrun" goto :firstrun
if "%1"=="check" goto :check
if "%1"=="compatible" goto :compatible
if "%1"=="main" goto :main
if "%1"=="info" goto :info
if "%1"=="boot" goto :boot
echo �������ô��� & goto :EOF

:firstrun
if "%2"=="1" echo ������������... & goto :EOF
if "%2"=="2" echo ���! & goto :EOF
if "%2"=="3" echo ������������... & goto :EOF
if "%2"=="4" echo ���! & goto :EOF
if "%2"=="5" echo ��⵽ȱʧ�ļ���%lostitem%������ܻ�������� & goto :EOF
if "%2"=="6" echo �Ƿ�������ã�[Y,N] & goto :EOF
if "%2"=="7" echo �Ƿ����û�ȡUAC��[Y,N] & goto :EOF
if "%2"=="8" echo ע�⣺��ȡUAC���ȶ��Կ�������Ҳ���ܽ��͡� & goto :EOF
if "%2"=="9" echo �Զ������У����Ժ�... & goto :EOF
if "%2"=="10" echo ����Ĭ�����������ļ���... & goto :EOF
if "%2"=="11" echo ���! & goto :EOF
if "%2"=="12" echo ���������������... & goto :EOF
if "%2"=="13" echo ��⵽������ʹ��Windows 10����ϵͳ������ܵ�����ʾ���� & goto :EOF
if "%2"=="14" echo �Ƿ��޸�ע�����֧�ִ˳���[Y,N] & goto :EOF
if "%2"=="15" echo ע�⣺ĳЩϵͳ�޸�ע�����޷���ԭ�������ѡ�� & goto :EOF
echo �������ô��� & goto :EOF

:check
if "%2"=="1" echo ���ڻ�ȡUAC... & goto :EOF
if "%2"=="2" echo ������������... & goto :EOF
if "%2"=="3" echo ���ϵͳ������... & goto :EOF
echo �������ô��� & goto :EOF

:compatible
if "%2"=="1" echo ����ϵͳ������˳��򲻼��ݣ���ʹ��Windows7��Windows10�� & goto :EOF
if "%2"=="2" echo ���Ҫǿ��ִ�У��밴Y������N�˳��� & goto :EOF
if "%2"=="3" echo �����޸�ע�����֧�ִ˳���... & goto :EOF
echo �������ô��� & goto :EOF

:main
if "%2"=="1" echo                                                 �汾  %Version% & goto :EOF
if "%2"=="2" echo                                            ����ʱ��:%uptime% & goto :EOF
if "%2"=="3" echo      ��B�����������˵���M������BL�˵���S��������R������                           ��Ȩ���У�c��%date:~0,4% NaivG��  & goto :EOF
if "%2"=="4" echo                                      ��W���ϣ�S���£�Eѡ��I��ʾѡ����Ϣ��  & goto :EOF
echo �������ô��� & goto :EOF

:info
if "%2"=="1" echo                        ����������:%bootname%   & goto :EOF
if "%2"=="2" echo                        ����������:%s% & goto :EOF
if "%2"=="3" echo                        ϵͳ��������:%BOOT%.img & goto :EOF
if "%2"=="4" echo                        ϵͳ״̬:Not Ready & goto :EOF
if "%2"=="5" echo                        ϵͳ״̬:Ready & goto :EOF
if "%2"=="6" echo                        ϵͳ����·��:%address% & goto :EOF
if "%2"=="7" echo                        ��Ч���������͡� & goto :EOF
if "%2"=="8" echo                        ����������������˵��� & goto :EOF
echo �������ô��� & goto :EOF

:boot
if "%2"=="1" echo ��Ч���������͡� & goto :EOF
if "%2"=="2" echo ��������˳�... & goto :EOF
if "%2"=="3" echo ���ڼ���ϵͳ����... & goto :EOF
if "%2"=="4" echo ���! & goto :EOF
if "%2"=="5" echo ���ڴ����������... & goto :EOF
if "%2"=="6" echo ���! & goto :EOF
if "%2"=="7" echo ��������ϵͳ... & goto :EOF
if "%2"=="8" echo ���ڴӷ�������ȡϵͳ����... & goto :EOF
if "%2"=="9" echo ���! & goto :EOF
if "%2"=="10" echo ���ڼ���ϵͳ����... & goto :EOF
if "%2"=="11" echo ���! & goto :EOF
if "%2"=="12" echo ���ڴ����������... & goto :EOF
if "%2"=="13" echo ���! & goto :EOF
if "%2"=="14" echo ��������ϵͳ... & goto :EOF
echo �������ô��� & goto :EOF
