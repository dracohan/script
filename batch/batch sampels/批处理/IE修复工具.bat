���ơ�
@echo off
cls
echo.
echo                 IE ����޸��ű�����
echo.
echo.
echo           �����޸� IE ���ע�ᣬ���Ժ򡭡�
regsvr32 /s actxprxy.dll
regsvr32 /s shdocvw.dll
regsvr32 /s oleaut32.dll
Regsvr32 /s URLMON.DLL
Regsvr32 /s mshtml.dll
Regsvr32 /s msjava.dll
Regsvr32 /s browseui.dll
Regsvr32 /s softpub.dll
Regsvr32 /s wintrust.dll
Regsvr32 /s initpki.dll
Regsvr32 /s dssenh.dll
Regsvr32 /s rsaenh.dl
Regsvr32 /s gpkcsp.dll
Regsvr32 /s sccbase.dll
Regsvr32 /s slbcsp.dll
Regsvr32 /s cryptdlg.dll
echo.
echo           IE ���ע��ɹ������ܴ�ĳЩ���ӵȴ���������
echo           �����Ȼ�������⣬ ����ر� IE ������ִ�б�����
echo           ���������������������ִ�б�����
echo.
echo           �޸�������ϣ�������˳���
pause>nul
