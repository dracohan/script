@echo off
color 2f
Title ϵͳ�����ļ�������
echo.
echo   *****  ϵͳ�����ļ�������  *****
echo.
echo  �������ص㣺
echo      ���ںܶ��˰�IE������ļ���ת�Ƶ���ϵͳ�̣�
echo  ���ԣ����������������ļ�ʱ�����Ƚ����ж�ϵͳ
echo  �����á�
echo.
echo 
echo.
echo 
echo               
echo.
echo  �ŵ㣺����λ�ø���׼ȷ�����Ը��ӿ�ѧ��
echo.
pause
echo  ��ʼִ��������
echo.
echo ���ڼ��cookies����ʷ��¼��Ŀ¼λ��(��ǰ�û�)����
reg query "HKCU\software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Cache>%temp%\cleantmp.txt
reg query "HKCU\software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Cookies>>%temp%\cleantmp.txt
reg query "HKCU\software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v History>>%temp%\cleantmp.txt
reg query "HKCU\software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v NetHood>>%temp%\cleantmp.txt
reg query "HKCU\software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Recent>>%temp%\cleantmp.txt
echo ��������Cookies��IE���桢��ʷ��¼��(��ǰ�û�)����
for /f "tokens=3*" %%a in (%temp%\cleantmp.txt) do (
  for /d %%i in ("%%a %%b\*.*") do rd /s /q "%%i"
  del /a /f /s /q "%%a %%b\*.*"
)
::�����漸��δ�����ظ���(��)��Ҳ�ǶԵ�ǰ�û�Ŀ¼
echo ����������ʱ�ļ� (ϵͳĿ¼)����
del /a /f /s /q "%userprofile%\Locals~1\Tempor~1\*.*" 
del /a /f /s /q "%userprofile%\Locals~1\Temp\*.*" 
del /a /f /s /q "%userprofile%\cookies\*.*" 
del /a /f /s /q "%userprofile%\recent\*.*"
del /a /f /s /q "%Temp%\*.*"
del /a /f /s /q "%Tmp%\*.*"
del /a /f /s /q "%HomePath%\..\IconCache.db"
echo ��������ϵͳĿ¼�е������ļ� (�Ժ���Ҫ��ʱ��)����
del /a /f /s /q "%SystemRoot%\*._mp"
del /a /f /s /q "%SystemRoot%\*.bak"
del /a /f /s /q "%SystemRoot%\*.log"
del /a /f /s /q "%SystemRoot%\*.dmp"
del /a /f /s /q "%SystemRoot%\*.gid"
del /a /f /s /q "%SystemRoot%\*.old"
del /a /f /s /q "%SystemRoot%\*.query"
del /a /f /q "%SystemRoot%\*.tmp"
rd /s /q "%SystemRoot%\Downloaded Program Files"
rd /s /q "%SystemRoot%\Offline Web Pages"
rd /s /q "%systemroot%\Connection Wizard"
rd /s /q "%SystemRoot%\SoftwareDistribution\Download"
rd /s /q "%SystemRoot%\Assembly"
rd /s /q "%SystemRoot%\Help"
rd /s /q "%SystemRoot%\ReinstallBackups"
del /a /s /q "%SystemRoot%\inf\*.pnf"
del /a /f /s /q "%SystemRoot%\inf\InfCache.1"
dir %SystemRoot%\inf\*.* /ad/b >%SystemRoot%\vTmp.txt
for /f %%a in (%SystemRoot%\vTmp.txt) do rd /s /q "%SystemRoot%\inf\%%a"
del /a /f /s /q "%SystemRoot%\driver?\*.pnf"
del /a /f /s /q "%SystemRoot%\driver?\InfCache.1" 
del /a /f /s /q "%SystemDrive%\driver?\*.pnf"
del /a /f /s /q "%SystemDrive%\driver?\InfCache.1"
rd /s /q "%SystemRoot%\temp" & md "%SystemRoot%\temp"
del /a /f /s /q "%SystemRoot%\Prefetch\*.*"
del /a /f /s /q "%SystemRoot%\minidump\*.*"
echo ����������õĴ��̼���ļ� (ϵͳ����)����
del /a /f /q "%SystemDrive%\*.chk"
dir %SystemDrive%\found.??? /ad/b >%SystemRoot%\vTmp.txt
for /f %%a in (%SystemRoot%\vTmp.txt) do rd /s /q "%SystemDrive%\%%a"
echo ��������ϵͳ���������������ķ���װĿ¼ (����������ȷ���)����
dir %SystemRoot%\$*$ /ad/b >%SystemRoot%\vTmp.txt
for /f %%a in (%SystemRoot%\vTmp.txt) do rd /s /q "%SystemRoot%\%%a"
echo ����������������������Ŀ (��Ĭ��Ŀ¼)����
rd /s /q "%ProgramFiles%\InstallShield Installation Information"
Ren "%ProgramFiles%\Common~1\Real\Update_OB\realsched.exe" realsched.ex_
Del "%ProgramFiles%\Common~1\Real\Update_OB\realsched.exe"
Reg Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v TkBellExe /f
rd /s /q "%ProgramFiles%\Tencent\QQGame\Download"
taskkill /f /im "TIMPlatform.exe" /t
del /a /f /s /q "%ProgramFiles%\Tencent\QQ\TIMPlatform.exe"
del /a /f /s /q "%ProgramFiles%\Kaspersky Lab\*.tmp"
echo.
echo   ȫ��������ϣ�������˳� (ע: ����ʾ�ļ�û�ҵ���������)����
pause
del %SystemRoot%\vTmp.txt