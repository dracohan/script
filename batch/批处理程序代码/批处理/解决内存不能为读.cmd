@echo off  
color F2 
echo �������������Զ�ע��DLL�ļ� 
echo. 

echo �Խ�����ֳ�����ʾ���ڴ治��ΪRead�Ĵ��� 

echo. 
echo ��������ʱ��ϳ��������ĵȺ� 
echo.  

echo ���������ʼ����رհ�ť�˳� 
pause>nul 
for %%1 in (%systemroot%\system32\*.dll) do regsvr32 /s %%1 
for %%1 in (%systemroot%\system32\*.ocx) do regsvr32 /s %%1  