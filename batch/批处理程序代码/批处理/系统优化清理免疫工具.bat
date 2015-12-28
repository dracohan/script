@echo off

:menu
cls
color 0A
echo 
echo                                                                        
ECHO                                            
ECHO                                               
ECHO           欢迎访问第九兵团论坛：www.9thclub.cn                                       
ECHO                                                                      
echo                                                           
echo                                
echo                                                 
echo                                               
echo                                                
echo                                                
echo 
echo 
echo .
echo.
echo                             
echo.
echo                         
echo.
echo                 
echo.         欢迎访问第九兵团论坛：www.9thclub.cn  
echo          ****************************************************       
echo                  请选择要进行的操作，然后按回车
echo          ****************************************************       
echo.
echo              1.网络修复及上网相关设置，修复IE
echo.
echo              2.病毒专杀工具，端口关闭工具
echo.
echo              3.清除所有多余的自启动项目，修复系统错误
echo.
echo              4.清理系统垃圾,提高启动速度
echo.
echo              5.测试并自动优化系统
echo.
echo              6.注册表锁定/解锁
echo.             
echo              7.访问论坛
echo.
echo              q.退出
echo.
echo                                            
echo.
echo                                           
echo.
:cho
set choice=
set /p choice=    请选择:        
IF NOT "%choice%"=="" SET choice=%choice:~0,1%
if /i "%choice%"=="1" goto ip
if /i "%choice%"=="2" goto setsave
if /i "%choice%"=="3" goto kaiji
if /i "%choice%"=="4" goto clean
if /i "%choice%"=="5" goto NB
if /i "%choice%"=="6" goto regg
if /i "%choice%"=="7" goto url
if /i "%choice%"=="Q" goto endd
if /i "%choice%"=="@" goto lmj1
echo 选择无效，请重新输入
echo.
goto cho

:kaiji
cls
echo                         
echo.
echo                             
echo.
echo         ********* 终极系统修复***********
echo.
echo                1.开机速度优化
echo.
echo                2.注册WIN32下所有DLL文件(解决内存不能为READ)
echo.
echo                3.返回主菜单
echo.               
echo                Q.退出
              
:chokaiji
set choice=
set /p choice=        请选择:
IF NOT "%Choice%"=="" SET Choice=%Choice:~0,1%
if /i "%choice%"=="1" goto delstart
if /i "%choice%"=="2" goto reg32all
if /i "%choice%"=="3" goto menu
if /i "%choice%"=="q" goto endd
echo 选择无效，请重新输入
echo.
goto chokaiji

:reg32all
echo 此项整理将会花一分钟左右时间，请您耐心等等...
for %%i in (%systemroot%\system32\*.dll) do regsvr32.exe /s %%i
pause >nul
goto kaiji

:ip
cls
echo 本机网络属性......
@echo off
:: 

::调用格式：
call :select "ip address" "ip"
call :select "Physical Address" "mac"
call :select "Default Gateway" "gateway"
call :select "DNS Servers" "dns"
call :select "Description" "netcard"

:: 演示效果
echo 您的IP为:       %ip%
echo 您的网关为:     %gateway%
echo DNS服务器地址:  %dns%
echo 网卡物理地址:   %mac%
echo 网卡类型:       %netcard%
echo.
echo                确认您的网络IP网关及DNS等设置都正确吗？
echo.
echo                          请按任意键继续
pause>nul
goto :ip2

::
::              解析ipconfig命令输出通用函数
::
:select
    for /f "tokens=2 delims=:" %%i in ('ipconfig /all ^| findstr /i /c:%1') do if not "!%~2!" == "" set "%~2=%%i"
goto :eof
pause

:ip2
cls
echo                         
echo.
echo                             
echo.
echo            ********** 终极上网修复************
echo.
echo                1.测试上网状态
echo.
echo                2.修复登陆无响应问题
echo.
echo                3.解决上网端口被其他程序占用问题
echo.
echo                  (同时也是解决上得了QQ却打不开网页功能）
echo.
echo                4.重新加载上网功能要调用的所有DLL文件
echo.
echo                5.手动重新定义IP，网关，子网掩码及DNS地址
echo.
echo                6.全面修复IE
echo.
echo                7.返回主目录
echo.
echo                Q. 退出
echo.

:cho2
set choice=
set /p choice=            请选择：
IF NOT "%choice%"=="" SET choice=%choice:~0,1%
if /i "%choice%"=="1" goto state
if /i "%choice%"=="2" goto reply
if /i "%choice%"=="3" goto qq
if /i "%choice%"=="4" goto final
if /i "%choice%"=="5" goto reset
if /i "%choice%"=="6" goto rie
if /i "%choice%"=="7" goto menu
if /i "%choice%"=="q" goto endd
echo.
echo 选择无效，请重新输入
echo.
goto cho2

:regg
echo.
echo                   1.注册表解锁
echo.
echo                   2.注册表锁定
echo.

:regcho
set choice=
set /p choice=            请选择：
IF NOT "%choice%"=="" SET choice=%choice:~0,1%
if /i "%choice%"=="1" goto unlockreg
if /i "%choice%"=="2" goto lockreg
echo.
echo 选择无效，请重新输入
echo.
goto regcho

:lockreg
@reg  add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t reg_dword /d 00000001 /f
echo 注册表成功锁定!!!
start regedit
pause >nul
goto menu

:unlockreg
@reg  add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t reg_dword /d 00000000 /f 
echo 注册表解锁成功!!!
start regedit
pause >nul
goto menu


:rie
cls
echo          
echo.
echo         
echo.
echo  IE修复开始...
@echo off
　　regsvr32 /s actxprxy.dll 
　　regsvr32 /s shdocvw.dll 
　　Regsvr32 /s URLMON.DLL 
　　Regsvr32 /s actxprxy.dll 
　　Regsvr32 /s shdocvw.dll 
　　regsvr32 /s oleaut32.dll 
　　rundll32.exe /s advpack.dll /DelNodeRunDLL32 C:\WINNT\System32\dacui.dll 
　　rundll32.exe /s advpack.dll /DelNodeRunDLL32 C:\WINNT\Catroot\icatalog.mdb 
　　regsvr32 /s setupwbv.dll 
    echo 完成百分之 10
　　regsvr32 /s wininet.dll 
　　regsvr32 /s comcat.dll 
　　regsvr32 /s shdoc401.dll 
　　regsvr32 /s shdoc401.dll /i 
　　regsvr32 /s asctrls.ocx 
　　regsvr32 /s oleaut32.dll 
　　regsvr32 /s shdocvw.dll /I 
　　regsvr32 /s shdocvw.dll 
echo 完成百分之 15
　　regsvr32 /s browseui.dll 
　　regsvr32 /s browseui.dll /I 
　　regsvr32 /s msrating.dll 
　　regsvr32 /s mlang.dll 
　　regsvr32 /s hlink.dll 
　　regsvr32 /s mshtml.dll 
　　regsvr32 /s mshtmled.dll 
　　regsvr32 /s urlmon.dll 
　　regsvr32 /s plugin.ocx 
echo 完成百分之 20
　　regsvr32 /s sendmail.dll 
　　regsvr32 /s comctl32.dll /i 
　　regsvr32 /s inetcpl.cpl /i 
　　regsvr32 /s mshtml.dll /i 
　　regsvr32 /s scrobj.dll 
　　regsvr32 /s mmefxe.ocx 
　　regsvr32 /s proctexe.ocx mshta.exe /register 
　　regsvr32 /s corpol.dll 
　　regsvr32 /s jscript.dll 
　　regsvr32 /s msxml.dll 
echo 完成百分之 25
　　regsvr32 /s imgutil.dll 
　　regsvr32 /s thumbvw.dll 
　　regsvr32 /s cryptext.dll 
　　regsvr32 /s rsabase.dll 
　　regsvr32 /s triedit.dll 
　　regsvr32 /s dhtmled.ocx 
　　regsvr32 /s inseng.dll 
echo 完成百分之 30
　　regsvr32 /s iesetup.dll /i 
　　regsvr32 /s hmmapi.dll 
　　regsvr32 /s cryptdlg.dll 
　　regsvr32 /s actxprxy.dll 
　　regsvr32 /s dispex.dll 
　　regsvr32 /s occache.dll 
　　regsvr32 /s occache.dll /i 
　　regsvr32 /s iepeers.dll 
echo 完成百分之 40
　　regsvr32 /s wininet.dll /i 
　　regsvr32 /s urlmon.dll /i 
　　regsvr32 /s digest.dll /i 
　　regsvr32 /s cdfview.dll 
　　regsvr32 /s webcheck.dll 
echo 完成百分之 50
　　regsvr32 /s mobsync.dll 
　　regsvr32 /s pngfilt.dll 
　　regsvr32 /s licmgr10.dll 
　　regsvr32 /s icmfilter.dll 
　　regsvr32 /s hhctrl.ocx 
　　regsvr32 /s inetcfg.dll 
　　regsvr32 /s trialoc.dll 
　　regsvr32 /s tdc.ocx 
　　regsvr32 /s MSR2C.DLL 
　　regsvr32 /s msident.dll 
　　regsvr32 /s msieftp.dll 
echo 完成百分之 60
　　regsvr32 /s xmsconf.ocx 
　　regsvr32 /s ils.dll 
　　regsvr32 /s msoeacct.dll 
　　regsvr32 /s wab32.dll 
　　regsvr32 /s wabimp.dll 
echo 完成百分之 70
　　regsvr32 /s wabfind.dll 
　　regsvr32 /s oemiglib.dll 
　　regsvr32 /s directdb.dll 
　　regsvr32 /s inetcomm.dll 
　　regsvr32 /s msoe.dll 
　　regsvr32 /s oeimport.dll 
　　regsvr32 /s msdxm.ocx 
echo 完成百分之 80
　　regsvr32 /s dxmasf.dll 
　　regsvr32 /s laprxy.dll 
　　regsvr32 /s l3codecx.ax 
　　regsvr32 /s acelpdec.ax 
　　regsvr32 /s mpg4ds32.ax 
　　regsvr32 /s voxmsdec.ax 
　　regsvr32 /s danim.dll 
　　regsvr32 /s Daxctle.ocx 
　　regsvr32 /s lmrt.dll 
　　regsvr32 /s datime.dll 
　　regsvr32 /s dxtrans.dll 
　　regsvr32 /s dxtmsft.dll 
　　regsvr32 /s vgx.dll 
echo 完成百分之 90
　　regsvr32 /s WEBPOST.DLL 
　　regsvr32 /s WPWIZDLL.DLL 
　　regsvr32 /s POSTWPP.DLL 
　　regsvr32 /s CRSWPP.DLL 
　　regsvr32 /s FTPWPP.DLL 
　　regsvr32 /s FPWPP.DLL 
　　regsvr32 /s FLUPL.OCX 
　　regsvr32 /s wshom.ocx 
　　regsvr32 /s wshext.dll 
　　regsvr32 /s vbscript.dll 
　　regsvr32 /s scrrun.dll mstinit.exe /setup 
　　regsvr32 /s msnsspc.dll /SspcCreateSspiReg 
　　regsvr32 /s msapsspc.dll /SspcCreateSspiReg 
echo 完成百分之 100
　　 
echo    IE修复结束,按任意键返回
echo.
pause >nul
goto menu

:state
cls
echo                            
echo                 终极上网修复
echo.
echo                 *******************************
echo                 请选择要进行的操作，然后按回车
echo                 *******************************
echo.
echo               1.使用系统默认的PING（218.65.129.46）
echo.
echo               2.自己手动输入要PING的IP或网址
echo.
echo               3.返回主目录
echo.

:choIP
set choice=
set /p choice=            请选择：
IF NOT "%choice%"=="" SET choice=%choice:~0,1%
if /i "%choice%"=="1" goto default
if /i "%choice%"=="2" goto self
if /i "%choice%"=="3" goto menu
echo.
echo 选择无效，请重新输入
echo.
goto cho2

:default
echo.
echo 开始测试上网状态（REPLY后有数字返回值则表明网络已正常连接）
ping 218.65.129.46 -n 8
echo 测试结束，请按任意键返回
pause >nul
goto menu

:self
echo.
set for=于
set of=的
set with=用
set in=(以
set data:=数据
set milli-seconds:=毫秒为单位)
set Approximate=大约
set times=时间:
set round=来回
set trip=行程
set Reply=应答
set from=来自
set bytes=字节
set time=时间:
set timed=时间
set out=超过
set statistics=统计
set Packets:=包:
set Sent=已发送=
set Received=已收到=
set Lost=已丢失=
set loss)=丢失)
set Minimum=最小值=
set Maximum=最大值=
set Average=平均值=
set TTL=TTL=
setlocal enabledelayedexpansion
set a=
set/p a=请输入要ping的网址或IP   
for /f "delims=" %%i in ('ping %a%') do (
    set ret=
    for %%a in (%%i) do if defined %%a (set ret=!ret!!%%a!) else set ret=!ret! %%a 
    if not "!ret!"=="" (set ret=!ret:time=时间! && echo !ret!) else echo.
)
pause >nul
goto menu

:reply
echo 修复网络无响应
ipconfig /release
arp -d *
nbtstat -r
ipconfig /flushdns
nbtstat -rr
ipconfig /registerdns
net start
echo 操作结束，请按任意键返回
pause >nul
goto menu

:qq
cls
echo 解决开得了ＱＱ但打不开网页功能
netsh winsock reset
echo 操作结束，请按任意键返回
pause >nul
goto menu

:final
echo 重新加载上网调用所有动链接库（终级解决）
regsvr32 /s Shdocvw.dll 
echo 重新加载WIN32目录下Shdocvw.dll成功!!!
regsvr32 /s Oleaut32.dll 
echo 重新加载WIN32目录下Oleaut32.dll成功!!!
regsvr32 /s Actxprxy.dll 
echo 重新加载WIN32目录下Actxprxy.dll成功!!!
regsvr32 /s Mshtml.dll 
echo 重新加载WIN32目录下Mshtml.dll成功!!!
regsvr32 /s Urlmon.dll 
echo 重新加载WIN32目录下Urlmon.dll成功!!!
regsvr32 /s Msjava.dll 
echo 重新加载WIN32目录下Msjava.dll成功!!!
regsvr32 /s Browseui.dll 
echo 重新加载WIN32目录下Browseui.dll成功!!!
regsvr32 /s Shell32.dll
echo 重新加载WIN32目录下Shell32.dll成功!!!
echo.
echo 操作结束，请按任意键继续返回
pause >nul
goto menu

:url
start http://www.9thclub.cn
goto menu

:clean
del /f /s /q %systemdrive%\*.tmp
del /f /s /q %systemdrive%\*._mp
del /f /s /q %systemdrive%\*.log
del /f /s /q %systemdrive%\*.gid
del /f /s /q %systemdrive%\*.chk
del /f /s /q %systemdrive%\*.old
del /f /s /q %systemdrive%\recycled\*.*
del /f /s /q %windir%\*.bak
del /f /s /q %windir%\prefetch\*.*
rd /s /q %windir%\temp & md %windir%\temp
del /f /q %userprofile%\cookies\*.*
del /f /q %userprofile%\recent\*.*
del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*"
del /f /s /q "%userprofile%\Local Settings\Temp\*.*"
del /f /s /q "%userprofile%\recent\*.*"
echo 系统垃圾清理完毕！

taskkill  /im realsched.exe /f
del /f /s /q C:\Progra~1\Common~1\Real\Update_OB\realsched.exe

regsvr32 /u /s zipfldr.dll

reg add "HKCU\Control Panel\Desktop" /v AutoEndTasks /t REG_DWORD /d 1 /f 
reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /d 50 /f 
reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /d 200 /f 

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 1 /f 

reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer /v AlwaysUnloadDLL /t REG_DWORD /d 1 /f 

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug" /v Auto /d 0 /f 

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v SFCDisable /t REG_DWORD /d 4294967197 /f 

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v MaxConnectionsPer1_0Server /t REG_DWORD /d 8 /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v MaxConnectionsPerServer /t REG_DWORD /d 8 /f 

reg add HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer /v Link /t REG_BINARY /d 00000000 /f 
echo 垃圾清理结束，按任意键返回
pause >nul
goto menu


:delstart
cls
echo.
echo LMJ243友情提醒您：
echo.
echo    此项将把所有开机自启动项目全部禁止，包括流氓软件甚至杀毒软件
echo    的自启动项目，选择的时候请注意!!!
echo.
echo.
echo       是否选择清除所有多余的启动项目
echo.
echo       (如无太多流氓软件，建议不选择)       
echo.
echo.
echo.
echo                      是（Y）否（N）

:notice
set choice=
set /p choice=          请选择:
IF NOT "%Choice%"=="" SET Choice=%Choice:~0,1%
if /i "%choice%"=="Y" goto del
if /i "%choice%"=="N" goto menu
echo  选择无效，请重新输入！
echo.
pause >nul
goto delstart

:del
@ ECHO OFF
@ ECHO.
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /va /f
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /va /f
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v ctfmon.exe /d C:\WINDOWS\system32\ctfmon.exe
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg" /f

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\IMJPMIG8.1"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\IMJPMIG8.1" /v command /d ""C:\WINDOWS\IME\imjp8_1\IMJPMIG.EXE" /Spoil /RemAdvDef /Migration32"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\IMJPMIG8.1" /v hkey /d HKLM
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\IMJPMIG8.1" /v inimapping /d 0
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\IMJPMIG8.1" /v item /d IMJPMIG
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\IMJPMIG8.1" /v key /d SOFTWARE\Microsoft\Windows\CurrentVersion\Run

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\PHIME2002A"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\PHIME2002A" /v command /d "C:\WINDOWS\system32\IME\TINTLGNT\TINTSETP.EXE /IMEName"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\PHIME2002A" /v hkey /d HKLM
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\PHIME2002A" /v inimapping /d 0
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\PHIME2002A" /v item /d TINTSETP
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\PHIME2002A" /v key /d SOFTWARE\Microsoft\Windows\CurrentVersion\Run

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\PHIME2002ASync"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\PHIME2002ASync" /v command /d ""C:\WINDOWS\IME\imjp8_1\IMJPMIG.EXE" /Spoil /RemAdvDef /Migration32"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\PHIME2002ASync" /v hkey /d HKLM
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\PHIME2002ASync" /v inimapping /d 0
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\PHIME2002ASync" /v item /d TINTSETP
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Shared Tools\MSConfig\startupreg\PHIME2002ASync" /v key /d SOFTWARE\Microsoft\Windows\CurrentVersion\Run

del "C:\Documents and Settings\All Users\「开始」菜单\程序\启动\*.*" /q /f
del "C:\Documents and Settings\Default User\「开始」菜单\程序\启动\*.*" /q /f
del "%userprofile%\「开始」菜单\程序\启动\*.*" /q /f
cls
echo       删除所有多余自启动项目成功!!!
pause >nul
goto menu


:reset
set slection1=
set/p slection1=请输入IP地址：
netsh interface ip set address name="本地连接" source=static addr=%slection1% mask=255.255.255.0
set slection2=
set/p slection2=请输入网关地址：
netsh interface ip set address name="本地连接" gateway=%slection2% gwmetric=0

set slection3=
set/p slection3=请输入主dns地址
netsh interface ip set dns name="本地连接" source=static addr=%slection3% register=PRIMARY

set slection4=
set/p slection4=请输入备份dns地址
netsh interface ip add dns name="本地连接" addr=%slection4%
netsh interface ip set wins name="本地连接" source=static addr=none
pause >nul
goto menu

:nb
@echo off
cls
rem Copyright (C) 2003-05 Ansgar Wiechers & Torsten Mann
rem Contact: admin@ntsvcfg.de
rem 
rem This program is free software; you can redistribute it and/or modify it under
rem the terms of the GNU General Public License as published by the Free Software Foundation;
rem either version 2 of the License, or (at your option) any later version.
rem This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
rem without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
rem See the GNU General Public License for more details.
rem
rem You should have received a copy of the GNU General Public License along with this program;
rem if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, 
rem MA 02111-1307, USA. 
echo.
REM Tested on ... Windows XP Pro SP2
REM NEW ... basic XP64 Support - Warning - Experimental!!
REM Showing XP64-Message generated by script on XP32 systems fixed

setlocal

REM *** INIT_VARS ***
set CHK_SVC=YES
set XPSP2=FALSE
set SERVER=FALSE
set NT_SERVER_CHK=TRUE


:START
echo  "智能化测试优化系统"
echo  ================================================================
set find=%SystemRoot%\System32\find.exe
set regedit=%SystemRoot%\regedit.exe
if not exist "%find%" goto :NOFIND
if not exist "%regedit%" goto :NOREGEDIT
if not "%1" == "%*" goto :SYNTAX
if /I "%1"=="/?" goto :HELP
if /I "%1"=="/help" goto :HELP
if /I "%1"=="-h" goto :HELP
if /I "%1"=="--help" goto :HELP
if /I "%1"=="-?" goto :HELP
if /I "%1"=="--?" goto :HELP
if /I "%1"=="/fix" goto :FIX
if /I "%1"=="/default" goto :RESTORE_DEFAULTS
goto :VERSION

:SYNTAX
echo.
echo.
echo  !!Syntax error!!
echo  ________________
echo  Es kann nur ein oder kein Parameter angegeben werden.
echo.
echo  Only one or no parameter allowed.
goto :QUIT

:HELP
echo.
echo                                 -= Hilfe =-                           
echo  Parameter:
echo  /lan.......einige Dienste (fuer LAN-Betrieb) bleiben unveraendert.
echo  /std.......Schliesst alle Ports, laesst aber einige Dienste unveraendert
echo  /all.......Setzt ALLE Aenderungen nach www.kssysteme.de um (hardening)
echo  /restore...Nimmt die letzten Aenderungen zurueck.
echo  /reLAN.....Reaktiviert Dienste, dir fuer LAN-Betrieb benoetigt werden.
echo.
echo  Parameters:
echo  /lan.......Some services needed for LAN-usage stay unchanged!
echo  /std.......Closes all Ports, but some services stay unchanged
echo  /all.......Changes all issues recommended by www.ntsvcfg.de ("hardening")
echo  /restore...Undo last changes.
echo  /reLAN.....Reactivates services required for LAN.
echo  /default...Restoring factory service settings (before first time usage)
echo.
echo  example: svc2kxp.cmd /all
echo.
set /P CHS= [Press "G" for GNU GPL informations or "Q" for quit]?
if /I "%CHS%"=="G" goto :GNU_GPL
if /I "%CHS%"=="Q" goto :QUIT_EXT
CLS
goto :HELP

:GNU_GPL
CLS
echo  Informations about GNU-General Public License for "svc2kxp.cmd"
echo  ===============================================================
echo.
echo  Copyright (C) 2003-05 Ansgar Wiechers, Torsten Mann
echo  Contact: admin@ntsvcfg.de
echo. 
echo  This program is free software; you can redistribute it and/or modify it under
echo  the terms of the GNU General Public License as published by the Free Software
echo  Foundation; either version 2 of the License, or (at your option) any later 
echo  version. This program is distributed in the hope that it will be useful, but
echo  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
echo  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
echo  details.
echo.
echo  You should have received a copy of the GNU General Public License along with 
echo  this program; if not, write to the:
echo.
echo  Free Software Foundation, Inc.
echo  59 Temple Place, Suite 330 
echo  Boston, MA 02111-1307, USA.
echo.
set /P CHS= [Press "H" for help or "Q" for quit]?
CLS
if /I "%CHS%"=="H" goto :HELP
if /I "%CHS%"=="Q" goto :QUIT_EXT
goto GNU_GPL

:VERSION
echo  检查系统版本...


if /I "%NT_SERVER_CHK%"=="FALSE" goto :SKIP_NT_SERVER_CHK
REM Checking for running server version
	"%regedit%" /e "%TEMP%\~svr.txt" "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ProductOptions"
 		type "%TEMP%\~svr.txt"|"%find%" /i "Server" >NUL
		if not errorlevel 1 set SERVER=TRUE
 		type "%TEMP%\~svr.txt"|"%find%" /i "LanMan" >NUL
		if not errorlevel 1 set SERVER=TRUE
		if exist "%TEMP%\~svr.txt" del /F /Q "%TEMP%\~svr.txt"
		if /I "%SERVER%"=="TRUE" goto :NTSERVER


:SKIP_NT_SERVER_CHK

ver | "%find%"  /i "Windows 2000" > nul
if not errorlevel 1 goto :OS2K

ver | "%find%"  /i "Windows XP" > nul
if not errorlevel 1 goto :OSXP

ver | "%find%"  /i "Microsoft Windows [Version 5.2.3790]" > nul
if not errorlevel 1 goto :OSXP64

echo  !!Failed!!
echo  __________
echo.
echo  Dieses Script ist nur unter Windows 2000 oder XP lauffaehig!
echo.
echo  This script works only on Windows 2000/XP machines!
echo.
goto :QUIT

:NOFIND
echo.
echo  !!Failed!!
echo  __________
echo.
echo  Leider konnte folgende Datei nicht gefunden werden:
echo. 
echo  Sorry, but following file is missing:
echo.
echo.
echo  # %SystemRoot%\System32\FIND.EXE
echo.
echo. 
goto :QUIT

:NOREGEDIT
echo.
echo  !!Failed!!
echo  __________
echo.
echo  Leider konnte folgende Datei nicht gefunden werden:
echo. 
echo  Sorry, but following file is missing:
echo.
echo.
echo  # %SystemRoot%\REGEDIT.EXE
echo.
echo. 
goto :QUIT

:NTSERVER
echo.
echo  !!Failed!!
echo  __________
echo.
echo  Dieses Script unterstuetzt keine NT Server Versionen!
echo.
echo  This script doesn't support NT server versions!
echo.
goto :QUIT


:OS2K
rem Specific OS Detection I
set SYSTEM=2k

rem Testing for XP ServicePacks
	
	"%regedit%" /e "%TEMP%\~svclist.txt" "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
	type "%TEMP%\~svclist.txt"|"%find%" /i "Service Pack 4" >NUL
	if errorlevel==1 (
		
	  	type "%TEMP%\~svclist.txt"|"%find%" /i "Service Pack 3" >NUL
	  	if errorlevel==1 (

			type "%TEMP%\~svclist.txt"|"%find%" /i "Service Pack 2" >NUL
	  		if errorlevel==1 (
		
				type "%TEMP%\~svclist.txt"|"%find%" /i "Service Pack 1" >NUL
				if errorlevel==1 (
			
					echo  !Windows 2000 [no or unknown Service Pack] detected!
					goto NO_2KSP
					)

				echo  !Windows 2000 [Service Pack 1] detected!
	  			goto :NO_2KSP
				)


			echo  !Windows 2000 [Service Pack 2] detected!
  			goto :NO_2KSP
			)


		echo  !Windows 2000 [Service Pack 3] detected!
		goto :NO_2KSP
		)


	echo  !Windows 2000 [Service Pack 4] detected!
	goto :NO_2KSP

:NO_2kSP
if exist "%TEMP%\~svclist.txt" del /F /Q "%TEMP%\~svclist.txt"
goto :CONTINUE


:OSXP
rem Specific OS detection II
set SYSTEM=xp
rem Testing for XP ServicePack 2

	"%regedit%" /e "%TEMP%\~svclist.txt" "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
	type "%TEMP%\~svclist.txt"|"%find%" /i "Service Pack 2" >NUL
	if errorlevel==1 (
		
	  	type "%TEMP%\~svclist.txt"|"%find%" /i "Service Pack 1" >NUL
	  	if errorlevel==1 (
			
			SET XPSP2=FALSE
			echo  !Windows XP [no or unknown Service Pack] detected!
			goto NO_XPSP
			)
		
		SET XPSP2=FALSE
	  	echo  !Windows XP [Service Pack 1] detected!
	  	goto :NO_XPSP
		)

	SET XPSP2=TRUE
	echo  !Windows XP [ServicePack 2] detected!
	goto :NO_XPSP

:OSXP64
rem Specific OS detection II
set SYSTEM=xp
rem Testing for XP ServicePack 2

	"%regedit%" /e "%TEMP%\~svclist.txt" "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
	type "%TEMP%\~svclist.txt"|"%find%" /i "Service Pack 2" >NUL
	if errorlevel==1 (
		
	  	type "%TEMP%\~svclist.txt"|"%find%" /i "Service Pack 1" >NUL
	  	if errorlevel==1 (
			
			SET XPSP2=FALSE
			echo  !EXPERIMENTAL! Windows XP64 [no or unknown Service Pack] detected!
			goto NO_XPSP
			)
		
		SET XPSP2=FALSE
	  	echo  !EXPERIMENTAL! Windows XP64 [Service Pack 1] detected!
	  	goto :NO_XPSP
		)

	SET XPSP2=TRUE
	echo  !EXPERIMENTAL! Windows XP64 [ServicePack 2] detected!
	goto :NO_XPSP


:NO_XPSP
if exist "%TEMP%\~svclist.txt" del /F /Q "%TEMP%\~svclist.txt"
goto :CONTINUE


:CONTINUE

REM Creating subdirectory "ntsvcfg" in userprofile if necessary
if not exist "%USERPROFILE%\ntsvcfg\*.*" mkdir "%USERPROFILE%\ntsvcfg"

REM Moving old script backup files to ...\%USERNAME%\ntsvcfg :
	if exist "%USERPROFILE%\dcom.reg" move /Y "%USERPROFILE%\dcom.reg" "%USERPROFILE%\ntsvcfg\dcom.reg"
	if exist "%USERPROFILE%\dcomp.reg" move /Y "%USERPROFILE%\dcomp.reg" "%USERPROFILE%\ntsvcfg\dcomp.reg"
	if exist "%USERPROFILE%\services.reg" move /Y "%USERPROFILE%\services.reg" "%USERPROFILE%\ntsvcfg\services.reg"
	if exist "%USERPROFILE%\current_services_config.reg" move /Y "%USERPROFILE%\current_services_config.reg" "%USERPROFILE%\ntsvcfg\current_services_config.reg"
	if exist "%USERPROFILE%\smb.reg" move /Y "%USERPROFILE%\smb.reg" "%USERPROFILE%\ntsvcfg\smb.reg"
	if exist "%USERPROFILE%\FPRINT.REF" move /Y "%USERPROFILE%\FPRINT.REF" "%USERPROFILE%\ntsvcfg\FPRINT.REF"
	if exist "%USERPROFILE%\handler_aim.reg" move /Y "%USERPROFILE%\handler_aim.reg" "%USERPROFILE%\ntsvcfg\handler_aim.reg"
	if exist "%USERPROFILE%\handler_gopher.reg" move /Y "%USERPROFILE%\handler_gopher.reg" "%USERPROFILE%\ntsvcfg\handler_gopher.reg"
	if exist "%USERPROFILE%\handler_telnet.reg" move /Y "%USERPROFILE%\handler_telnet.reg" "%USERPROFILE%\ntsvcfg\handler_telnet.reg"
	if exist "%USERPROFILE%\services.reg.default" move /Y "%USERPROFILE%\services.reg.default" "%USERPROFILE%\ntsvcfg\services.reg.default"
	if exist "%USERPROFILE%\dcom.reg.default" move /Y "%USERPROFILE%\dcom.reg.default" "%USERPROFILE%\ntsvcfg\dcom.reg.default"
	if exist "%USERPROFILE%\dcomp.reg.default" move /Y "%USERPROFILE%\dcomp.reg.default" "%USERPROFILE%\ntsvcfg\dcomp.reg.default"
	if exist "%USERPROFILE%\smb.reg.default" move /Y "%USERPROFILE%\smb.reg.default" "%USERPROFILE%\ntsvcfg\smb.reg.default"
	if exist "%USERPROFILE%\handler_aim.reg.default" move /Y "%USERPROFILE%\handler_aim.reg.default" "%USERPROFILE%\ntsvcfg\handler_aim.reg.default"
	if exist "%USERPROFILE%\handler_gopher.reg.default" move /Y "%USERPROFILE%\handler_gopher.reg.default" "%USERPROFILE%\ntsvcfg\handler_gopher.reg.default"
	if exist "%USERPROFILE%\handler_telnet.reg.default" move /Y "%USERPROFILE%\handler_telnet.reg.default" "%USERPROFILE%\ntsvcfg\handler_telnet.reg.default"


REM *****Declarations*****
set SELECT="no"
set SVC_BAK=%USERPROFILE%\ntsvcfg\services.reg
set SVC_SAV=%USERPROFILE%\ntsvcfg\current_services_config.reg
set DCOM_BAK=%USERPROFILE%\ntsvcfg\dcom.reg
set DCOMP_BAK=%USERPROFILE%\ntsvcfg\dcomp.reg
set SMB_BAK=%USERPROFILE%\ntsvcfg\smb.reg
set DCOM_TMP=%TEMP%\dcomoff.reg
set DCOMP_TMP=%TEMP%\dcompoff.reg
set SMB_TMP=%TEMP%\smboff.reg
set FPRINT=%USERPROFILE%\ntsvcfg\FPRINT.REF
set HANDLER1=%USERPROFILE%\ntsvcfg\handler_aim.reg
set HANDLER2=%USERPROFILE%\ntsvcfg\handler_gopher.reg
set HANDLER3=%USERPROFILE%\ntsvcfg\handler_telnet.reg
set NB_TMP=%TEMP%\nb_off.vbs
set srctmp=%USERPROFILE%\~srcreate.vbs

REM *****Options*****
set SCHEDULER_ENABLED=NO
set UseXPSysRestore=YES
set RESTORE=NO
set SVC_MOD=NO
set USE_FPRINT=YES
set Deactivate_NetBIOS=YES
set RESTORE_MODE=2

REM *****APP_PATHs******
set NET=%SystemRoot%\system32\net.exe
set SC=%SystemRoot%\system32\sc.exe
set FC=%SystemRoot%\system32\fc.exe
set IPCONFIG=%SystemRoot%\system32\ipconfig.exe


echo  检查本机配置: [本地], 请等待 ...
"%net%" user "%USERNAME%" 2> nul | "%find%"  /i "admin" | "%find%"  /i /v "name" > nul
if errorlevel 1 (
	echo     "         "          "     : [domain], please wait ...
	"%net%" user "%USERNAME%" /domain 2> nul | "%find%"  /i "admin" | "%find%"  /i /v "name" > nul
	if errorlevel 1 (
		echo.
		echo  失败
		echo  __________
		echo  此项任务需要管理员权限
		echo.
		echo  对不起,您没有足够的权限进行此项改动...
		echo  请重新以管理员身份进行登陆
		echo.
		goto :END
		)
	)

set IMPORT_OLD_FILES=FALSE
rem searching for sc.exe
if not exist "%FPRINT%" echo  Checking for presence of SC.EXE ...
"%sc%" qc > nul 2>&1
if errorlevel 1 (
	echo  !!Failed!!
	echo  __________
	echo  [%SystemRoot%\SYSTEM32\] gefunden werden.
	echo.
	echo  找不到文件SC.EXE[%SystemRoot%\SYSTEM32\]. 
	echo  请到下面的位置下载
	echo.
	echo.
	echo            -= ftp://ftp.microsoft.com/reskit/win2000/sc.zip =-
	echo. 
	echo				请重新安装该文件
	echo				****************
	echo  svx2kxp.cmd kann versuchen, die notwendige Datei selbst zu installieren.
	echo  
	echo.
	echo  本软件正在进行尝试,请稍等 
	echo  网络连接中.... 
	goto :SC_DOWNLOAD
	)


if /I "%1"=="/all" (
	set SELECT="/all"
	goto :SKIP_MENUE
	)

if /I "%1"=="/relan" (
	set SELECT="/relan"
	goto :SKIP_MENUE
	)

if /I "%1"=="/std" (
	set SELECT="/std"
	goto :SKIP_MENUE
	)


rem checking for modified services
if /I %CHK_SVC%==YES (
	if /I %USE_FPRINT%==YES (
		if exist "%FPRINT%" (
			rem Creating fingerprint of current service settings...        
			if exist "%USERPROFILE%\svc2cmp.sav" del /F /Q "%USERPROFILE%\svc2cmp.sav"
			"%sc%" query type= service state= all bufsize= 8192 | %FIND% "SERVICE_NAME" >%TEMP%\~svclist.txt
			for /F "tokens=1*" %%a in (%TEMP%\~svclist.txt) do (
				echo %%b >>"%USERPROFILE%\svc2cmp.sav"
				"%sc%" query "%%b" | %FIND% "STATE" >>"%USERPROFILE%\svc2cmp.sav"
				"%sc%" qc "%%b" | %FIND% "DISPLAY_NAME" >>"%USERPROFILE%\svc2cmp.sav"
				"%SC%" qc "%%b" | %FIND% "START_TYPE" >>"%USERPROFILE%\svc2cmp.sav"
				echo. >> "%USERPROFILE%\svc2cmp.sav" 
				)
			del "%TEMP%\~svclist.txt"	


			"%FC%" "%FPRINT%" "%USERPROFILE%\svc2cmp.sav" >NUL
			if errorlevel 1 goto :DIFF
			goto OK

			:DIFF
			echo  检查经过改动的本机服务选项 ... 本机服务已经经过改动，分析中.... 
			set SVC_MOD=YES
			goto :MOD_END

			:OK
			echo  检查原来的服务..... ... OK
			set SVC_MOD=NO
			if exist "%USERPROFILE%\svc2cmp.sav" del /F /Q "%USERPROFILE%\svc2cmp.sav"
			goto :MOD_END
        
			:MOD_END
			REM
        		)
		)
	)
set CHK_SVC=NO


if /I "%1"=="/restore" goto :RESTORE


:MENUE
if /I "%1"=="/lan" goto :SKIP_MENUE
echo.
echo                          * 请您耐心等待*
echo.
echo.
echo  (1) 局域网:  您使用的是局域网，程序将以此为基础进行优化
echo  (2) 标  准:  进行标准的系统，网络优化
echo  (3) 所  有:  对所有选项进行优化，保障您有一个更完美的系统及网络
echo  (4) 恢  复:  恢复之前进行的改动。
echo  ______________________________________________________________________________
echo.
echo  请选择您要进行的优化:
echo.
echo  (1) 局域网:  局域网上网方式所需要的服务不变动
echo  (2) 标  准:  关闭无用的端口，但保留系统服务
echo  (3) 所  有:  就已知的可优化项目进行优化
echo  (4) 恢  复:  恢复之前进行的一切改动
echo.
set /P CHS= LMJ243提醒您选择要进行的操作: [1],[2],[3],[4], 按[M]更多选项 或者[Q]退出 选择：

if /I "%CHS%"=="1" (
	set SELECT="/lan"
	goto :SKIP_MENUE
	)

if /I "%CHS%"=="2" (
	set SELECT="/std"
	goto :SKIP_MENUE
	)

if /I "%CHS%"=="3" (
	set SELECT="/all"
	goto :SKIP_MENUE
	)

if /I "%CHS%"=="4" goto :RESTORE
if /I "%CHS%"=="R" goto :RESTORE
if /I "%CHS%"=="M" goto :MORE_OPTIONS
if /I "%SVC_MOD%"=="YES" if /I "%CHS%"=="E" goto :EVALUATE_SERVICES
if /I "%CHS%"=="G" goto :CREATING_NEW_FINGERPRINT
if /I "%CHS%"=="Q" goto :QUIT
cls
goto :START


:SKIP_MENUE



rem Checking if old restorefiles exists.
rem if it is so old files will be restored before new changes
if not exist "%SVC_BAK%" goto :NO_RESTORE
if /I %RESTORE_MODE%==3 goto :NO_RESTORE
if /I %RESTORE_MODE%==4 goto :NO_RESTORE
set RESTORE=YES
echo.
echo  _______________________________________________________________________
echo.
echo  [选择恢复选项: %RESTORE_MODE%]
echo.
echo  # Achtung: Alte Sicherungsdateien gefunden!
echo.
echo.
echo    注意: 找到可以恢复的旧配置
echo.
echo     这不是您第一次运行本程序,请仔细检查之前进行的改动
echo     确认无问题后,方可继续....
echo.
echo.
echo  # Starting restore ...
goto RESTORE_EXT



:NO_RESTORE
rem query if taskplaner should run
if /I "%SYSTEM%"=="2k" goto :SKIP_SQUERY
if /I "%SYSTEM%"=="xp" (
	if /I %SELECT%=="" goto :SKIP_SQUERY
	if /I %SELECT%=="/all" goto :SKIP_SQUERY
	if /I %XPSP2%==True (
		set SCHEDULER_ENABLED=YES
		goto :SKIP_SQUERY
		)

	)


echo.
echo.
echo  Rueckfrage / Query
echo  ==================
echo.
echo  Soll der Dienst "Taskplaner" beendet werden?
echo. 
echo  Wenn sie zeitgesteuerten Aufgaben [z.B. Antiviren-Updates] oder die automati-
echo  sche Erstellung von Systemwiederherstellungspunkten nicht benoetigen, druecken
echo  Sie eine BELIEBIGE TASTE, um auch Port 135 [RPC] sowie Port 1025 [Taskplaner]
echo  zu schliessen [empfohlen!]. Andernfalls druecken Sie "N"!
echo.
echo.
echo  Should the "scheduler service" be disabled?
echo.
echo  If you have time-controlled tasks [i.e. AV-Updates] or you will not set
echo  automatic system restore points press ANY KEY TO CONTINUE to close port 135
echo  [RPC] and port 1025 [scheduler] instantly. Otherwise press "N"
echo  ___________________________________________
echo.
set /P UNDO= Taskplaner beenden - Close scheduler [y/n]?
if /I "%UNDO%"=="n" set SCHEDULER_ENABLED=YES



:SKIP_SQUERY

if not exist "%SVC_BAK%.default" (
	echo.
	echo  Creating backup of defaults ...
	"%regedit%" /e "%SVC_BAK%.default" HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services
	"%regedit%" /e "%DCOM_BAK%.default" HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Ole
	"%regedit%" /e "%DCOMP_BAK%.default" HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Rpc
	"%regedit%" /e "%SMB_BAK%.default" HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters
	"%regedit%" /e "%HANDLER1%.default" HKEY_CLASSES_ROOT\AIM
	"%regedit%" /e "%HANDLER2%.default" HKEY_CLASSES_ROOT\gopher
	"%regedit%" /e "%HANDLER3%.default" HKEY_CLASSES_ROOT\telnet
	echo                             ... done.
	)

if exist "%SVC_BAK%" (
	if /I %RESTORE_MODE%==2 goto :SKIP_SAVING
	if /I %RESTORE_MODE%==4 goto :SKIP_SAVING
	)

rem saving registry settings
echo  _________________________________________________________________________
echo.
echo  [Selected Restore Mode: %RESTORE_MODE%]
echo.
echo     Saving services settings to 
echo       %SVC_BAK% ...
"%regedit%" /e "%SVC_BAK%" HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services
echo     Saving DCOM settings to 
echo       %DCOM_BAK% ...
"%regedit%" /e "%DCOM_BAK%" HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Ole
echo     Saving DCOM standard protocols settings to 
echo       %DCOMP_BAK% ...
"%regedit%" /e "%DCOMP_BAK%" HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Rpc
echo     Saving SMB settings to
echo       %SMB_BAK%
"%regedit%" /e "%SMB_BAK%" HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters
echo     Saving URL-Handler [AIM, GOPHER, TELNET] to
echo       %HANDLER1%
"%regedit%" /e "%HANDLER1%" HKEY_CLASSES_ROOT\AIM
echo       %HANDLER2%
"%regedit%" /e "%HANDLER2%" HKEY_CLASSES_ROOT\gopher
echo       %HANDLER3%
"%regedit%" /e "%HANDLER3%" HKEY_CLASSES_ROOT\telnet
echo.

echo  All done.
echo  ___________________________________________
echo.


:SKIP_SAVING

if /I "%SYSTEM%"=="xp" ( 
	if /I %UseXPSysRestore%==YES (
		goto :XPSYSRESTORE
		)
	)
:XPSYSRESTORE_DONE

rem reconfigure services
rem startup: demand
echo.
echo  Setting services to "demand" ...

echo.
echo  Checking DHCP ...
"%ipconfig%" -all | "%find%"  /i "Lease" > nul
if errorlevel 1 (
	rem trying other method for DHCP
	"%ipconfig%" -all | "%find%"  /i "DHCP-Server" > nul
	if errorlevel 1 (
	echo                ... no active DHCP found.
	echo.
  	"%sc%" config DHCP start= demand
  	goto :SKIP_DHCP
	)
)
echo  ... DHCP active, status of service will NOT be changed!
echo.

:SKIP_DHCP
"%sc%" config dmadmin start= demand
"%sc%" config DNSCache start= demand
"%sc%" config mnmsrvc start= demand
"%sc%" config MSIServer start= demand
"%sc%" config NetDDE start= demand
"%sc%" config NetDDEdsdm start= demand
"%sc%" config Netman start= demand
"%sc%" config NTLMSsp start= demand
"%sc%" config NtmsSvc start= demand
"%sc%" config PolicyAgent start= demand
"%sc%" config RASAuto start= demand
"%sc%" config RASMan start= demand
"%sc%" config RSVP start= demand
"%sc%" config Scardsvr start= demand

"%sc%" query ScardDrv | "%find%"  /i "OpenService FAILED" >NUL
if errorlevel 1 "%sc%" config ScardDrv start= demand  

if /I %XPSP2%==True (
	rem If XP SP2 is installed there are less changes to XP-ICF
	if /I %SELECT%=="/std" goto :SKIP_FIREWALL 
	)
"%sc%" config SharedAccess start= demand

:SKIP_FIREWALL
"%sc%" config Sysmonlog start= demand
"%sc%" config TAPISrv start= demand
"%sc%" config TrkWks start= demand
"%sc%" config UPS start= demand
"%sc%" config W32Time start= demand
"%sc%" config WMI start= demand

if /I %SELECT%=="/all" (
	"%sc%" config SamSs start= demand
	"%sc%" config LmHosts start= demand
	"%sc%" config Winmgmt start= demand
	)

if /I "%SYSTEM%"=="2k" (
	"%sc%" config AppMgmt start= demand
	"%sc%" config Browser start= demand
	"%sc%" config clipsrv start= demand
	"%sc%" config EventSystem start= demand
	"%sc%" config Fax start= demand
	"%sc%" config netlogon start= demand
	"%sc%" config RPCLocator start= demand
	"%sc%" config Utilman start= demand
	if /I %SELECT%=="/all" (
		"%sc%" config seclogon start= demand
		"%sc%" config RPCSs start= demand
		"%sc%" config lanmanServer start= demand
		)
	)


if /I "%SYSTEM%"=="xp" (
	"%sc%" config ALG start= demand
	"%sc%" config FastUserSwitchingCompatibility start= demand
	"%sc%" config helpsvc start= demand
	"%sc%" config ImapiService start= demand
	"%sc%" config Nla start= demand
	"%sc%" config RdSessMgr start= demand
	"%sc%" config seclogon start= demand
	"%sc%" config stisvc start= demand
	"%sc%" config SwPrv start= demand
	"%sc%" config TermService start= demand
	"%sc%" config upnphost start= demand
	"%sc%" config VSS start= demand

	"%sc%" query WmdmPmSp | "%find%"  /i "OpenService FAILED" >NUL
	if errorlevel 1 "%sc%" config WmdmPmSp start= demand  

	"%sc%" config WmiApSrv start= demand
	rem Wireless Zero Configuration - fuer WLAN-Verbindungen notwendig.
	rem Falls erforderlich auf AUTO stellen.
	rem "%sc%" config WZCSVC start= demand
	)
echo.




rem startup: auto
echo  Setting services to "auto" ...
"%sc%" config dmserver start= auto
"%sc%" config eventlog start= auto
"%sc%" config PlugPlay start= auto
"%sc%" config ProtectedStorage start= auto
"%sc%" config sens start= auto
"%sc%" config spooler start= auto

if /I "%SYSTEM%"=="2k" (
	"%sc%" config lanmanworkstation start= auto
	"%sc%" config alerter start= auto
	)

if /I "%SYSTEM%"=="xp" (
	"%sc%" query InteractiveLogon | "%find%"  /i "OpenService FAILED" >NUL
	if errorlevel 1 "%sc%" config InteractiveLogon start= auto
	"%sc%" config Audiosrv start= auto
	"%sc%" config CryptSvc start= auto
	"%sc%" config RPCSs start= auto
	"%sc%" config ShellHWDetection start= auto
	"%sc%" config srservice start= auto
	"%sc%" query uploadmgr | "%find%"  /i "OpenService FAILED" >NUL
	if errorlevel 1 "%sc%" config uploadmgr start= auto
	"%sc%" config WebClient start= auto
	)
echo.





rem startup: disabled
echo  Setting services to "disabled" ...
"%sc%" config cisvc start= disabled
"%sc%" config MSDTC start= disabled
"%sc%" config RemoteAccess start= disabled
"%sc%" config TlntSvr start= disabled
"%sc%" config messenger start= disabled


if /I %SELECT%=="/all" (
	"%sc%" query BITS | "%find%"  /i "SERVICE_NAME" >NUL
	if not errorlevel 1 "%sc%" config BITS start= disabled
	"%sc%" query wuauserv | "%find%"  /i "SERVICE_NAME" >NUL
	if not errorlevel 1 "%sc%" config wuauserv start= disabled
	"%sc%" config schedule start= disabled
	"%sc%" config RemoteRegistry start= disabled
	)

if /I "%SYSTEM%"=="xp" (
	"%sc%" config ERSvc start= disabled
	"%sc%" config HidServ start= disabled
	"%sc%" config SSDPSRV start= disabled
	
	if /I %SELECT%=="/lan" (
		if /I %SCHEDULER_ENABLED%==NO "%sc%" config schedule start= disabled
		)

	if /I %SELECT%=="/std" (
		if /I %SCHEDULER_ENABLED%==NO "%sc%" config schedule start= disabled
		)

	if /I %XPSP2%==True (
		echo.
		echo  XPSP2: Disabling Security Center ...
		"%sc%" config wscsvc start= disabled
		)
	)


echo.
echo  ------------------
echo  Checking and stopping unnecessary services ...
echo.
"%sc%" query cisvc | "%find%"  /i "4  RUNNING" >NUL
	if not errorlevel 1 "%net%" stop cisvc
"%sc%" query RemoteAccess | "%find%"  /i "4  RUNNING" >NUL
	if not errorlevel 1 "%net%" stop RemoteAccess
"%sc%" query TlntSvr | "%find%"  /i "4  RUNNING" >NUL
	if not errorlevel 1 "%net%" stop TlntSvr
"%sc%" query MSDTC | "%find%"  /i "4  RUNNING" >NUL
	if not errorlevel 1 "%net%" stop MSDTC
"%sc%" query messenger | "%find%"  /i "4  RUNNING" >NUL
	if not errorlevel 1 "%net%" stop messenger

if /I %SELECT%=="/all" (
	"%sc%" query BITS | "%find%"  /i "SERVICE_NAME" >NUL
	if not errorlevel 1 (
		"%sc%" query BITS | "%find%"  /i "4  RUNNING" >NUL
		if not errorlevel 1 "%net%" stop BITS
		)
	"%sc%" query wuauserv | "%find%"  /i "SERVICE_NAME" >NUL
	if not errorlevel 1 (
		"%sc%" query wuauserv | "%find%"  /i "4  RUNNING" >NUL
		if not errorlevel 1 "%net%" stop wuauserv
		)
	"%sc%" query schedule | "%find%"  /i "4  RUNNING" >NUL
	if not errorlevel 1 "%net%" stop schedule
	)

if /I "%SYSTEM%"=="xp" (
	if /I %SELECT%=="/lan" (
		if /I %SCHEDULER_ENABLED%==NO "%net%" (
			"%sc%" query schedule | "%find%"  /i "4  RUNNING" >NUL
			if not errorlevel 1 "%net%" stop schedule
			)
		)

	if /I %SELECT%=="/std" (
		if /I %SCHEDULER_ENABLED%==NO "%net%" (
			"%sc%" query schedule | "%find%"  /i "4  RUNNING" >NUL
			if not errorlevel 1 "%net%" stop schedule
		)

	if /I %XPSP2%==True (
		"%sc%" query wscsvc | "%find%"  /i "4  RUNNING" >NUL
		if not errorlevel 1 "%net%" stop wscsvc
		)

	)

echo  ------------------
echo  Disabling DCOM ...
echo REGEDIT4 > "%DCOM_TMP%"
echo. >> "%DCOM_TMP%"
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Ole] >> "%DCOM_TMP%"
echo "EnableDCOM"="N" >> "%DCOM_TMP%"
echo "EnableDCOMHTTP"="N" >> "%DCOM_TMP%"
echo. >> "%DCOM_TMP%"
echo. >> "%DCOM_TMP%"
"%regedit%" /s "%DCOM_TMP%"
del /F /Q "%DCOM_TMP%"

echo  Disabling DCOM standard protocols ...
echo REGEDIT4 > "%DCOMP_TMP%"
echo. >> "%DCOMP_TMP%"
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Rpc] >> "%DCOMP_TMP%"
echo "DCOM Protocols"=hex(7):00,00,00,00 >> "%DCOMP_TMP%"
echo. >> "%DCOMP_TMP%"
echo. >> "%DCOMP_TMP%"
"%regedit%" /s "%DCOMP_TMP%"
del /F /Q "%DCOMP_TMP%"

   echo  Disabling port 135 (maybe 1025 too) ...
   echo    - Removing RPC Client Protocols
   echo REGEDIT4 > "%SMB_TMP%"
   echo [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Rpc\ClientProtocols] >> "%SMB_TMP%"
   echo. >> "%SMB_TMP%"
   
   if /I %SCHEDULER_ENABLED%==NO (
    echo    - Advanced RPC Configuration 
    echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Rpc\Internet] >> "%SMB_TMP%"
    echo "PortsInternetAvailable"="N" >> "%SMB_TMP%"
    echo "UseInternetPorts"="N" >> "%SMB_TMP%"
    echo. >> "%SMB_TMP%"
    )

   if /I %XPSP2%==TRUE (
    echo    - Advanced RPC Configuration 
    echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Rpc\Internet] >> "%SMB_TMP%"
    echo "PortsInternetAvailable"="N" >> "%SMB_TMP%"
    echo "UseInternetPorts"="N" >> "%SMB_TMP%"
    echo. >> "%SMB_TMP%"
    )
   
   echo    - Removing needless URL Handler [AIM,gopher,telnet]
   echo [-HKEY_CLASSES_ROOT\AIM] >> "%SMB_TMP%"
   echo [-HKEY_CLASSES_ROOT\gopher] >> "%SMB_TMP%"
   echo [-HKEY_CLASSES_ROOT\telnet] >> "%SMB_TMP%"
   echo. >> "%SMB_TMP%"
   echo. >> "%SMB_TMP%"
  "%regedit%" /s "%SMB_TMP%"
  del /F /Q "%SMB_TMP%"

if /I %SELECT%=="/all" (
	echo.
	echo  Disabling SMB port 445 ...
	echo REGEDIT4 > "%SMB_TMP%"
	echo. >> "%SMB_TMP%"
	echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters] >> "%SMB_TMP%"
	echo "SMBDeviceEnabled"=dword:00000000 >> "%SMB_TMP%"
	echo. >> "%SMB_TMP%"
	echo. >> "%SMB_TMP%"
	"%regedit%" /s "%SMB_TMP%"
	del /F /Q "%SMB_TMP%"
	set REBOOT_REQUIRED=yes
	)

if /I %SELECT%=="/std" (
	echo.
	echo  Disabling SMB port 445 ...
	echo REGEDIT4 > "%SMB_TMP%"
	echo. >> "%SMB_TMP%"
	echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters] >> "%SMB_TMP%"
	echo "SMBDeviceEnabled"=dword:00000000 >> "%SMB_TMP%"
	echo. >> "%SMB_TMP%"
	echo. >> "%SMB_TMP%"
	"%regedit%" /s "%SMB_TMP%"
	del /F /Q "%SMB_TMP%"
	set REBOOT_REQUIRED=yes
	)

if /I %SELECT%=="/std" goto :NB_DISABLE
if /I %SELECT%=="/all" goto :NB_DISABLE
goto :SKIP_NB_DISABLE

:NB_DISABLE
  if /I %DEACTIVATE_NETBIOS%==NO (
		echo.
		echo.  Due problems with SP2 and deactivating NetBIOS this option
		echo   will be skipped.
		echo.
		goto :SKIP_NB_DISABLE
		)
  
  rem Because of problems with SP2 Netbios:
  if /I %XPSP2%==True (
		echo.
		echo  Note:
		echo  -----
		echo  If you experiencing problems after updating Windows XP with 
		echo  Service Pack 2 please do following:
		echo.
		echo  			set Deactivate_NetBIOS=NO
		echo.
		)
  rem *** Thx2 Johannes Lichtenberger for the following lines using VBScript***
  echo  Disable NetBios on all local interfaces ...
  echo.
  echo On Error Resume Next>> "%nb_tmp%"
  echo.>> "%nb_tmp%"
  echo TcpipoverNetbios = 2 '0=NetbiosfromDHCP 1=EnableNetbios 2=DisableNetbios>> "%nb_tmp%"
  echo.>> "%nb_tmp%"
  echo strComputer = ".">> "%nb_tmp%"
  echo Set objWMIService = GetObject("winmgmts:\\" ^& strComputer ^& "\root\cimv2")>> "%nb_tmp%"
  echo Set objNICs = objWMIService.ExecQuery _>> "%nb_tmp%"
  echo    ("Select * From Win32_NetworkAdapterConfiguration Where IPEnabled = True")>> "%nb_tmp%"
  echo For Each objNic In objNICs>> "%nb_tmp%"
  echo    errTcpipNetbios = objNic.SetTCPIPNetBIOS(TcpipoverNetbios)>> "%nb_tmp%"
  echo Next>> "%nb_tmp%"
  "%SYSTEMROOT%\SYSTEM32\CSCRIPT.EXE" "%nb_tmp%"
  del /F /Q "%nb_tmp%"
  set REBOOT_REQUIRED=yes

:SKIP_NB_DISABLE
rem Skip Billboard because /all is used
if /I %SELECT%=="/all" goto :SW_ALL
if /I %SELECT%=="/std" goto :SW_ALL
if /I %SELECT%=="/relan" goto :SW_ALL
echo.
echo  ___________________________________________________________________
echo.
echo                   *** Zusammenfassung / Result ***
echo.
echo  Es wurden NICHT alle Aenderungen umgesetzt!
echo  Um alle Vorschlaege von kssysteme.de umzusetzen, verwenden Sie
echo  bitte den Parameter '/all' oder waehlen Sie im Menue den Punkt "3".
echo.
echo  Not all changes could be performed. To change all issues listed 
echo  on www.9thclub.cn.de please use parameter '/all' or select item "3"!
echo  ___________________________________________________________________

:SW_ALL

if /I %SELECT%=="/relan" (
	rem startup: auto
	echo.
	echo  ------------------
	echo  Re-enabling services ...
	"%sc%" config LmHosts  start= auto
	"%sc%" config RemoteRegistry start= auto
	"%sc%" config SamSs start= auto
	"%sc%" config Winmgmt start= auto
	if /I "%SYSTEM%"=="2k" (
		"%sc%" config RPCSs start= auto
		"%sc%" config lanmanServer start= auto
		"%sc%" config seclogon start= auto
		)
	if /I "%SYSTEM%"=="XP" (
		rem "%sc%" config SharedAccess start= auto
		)


	rem start re-enabled services
	echo.
	echo  ------------------
	echo  [Re]starting services ...
	echo.
	
	"%sc%" query RemoteRegistry | "%find%"  /i "1  STOPPED" >NUL
	if not errorlevel 1 "%net%" start RemoteRegistry
	"%sc%" query SamSs | "%find%"  /i "1  STOPPED" >NUL
	if not errorlevel 1 "%net%" start SamSs
	"%sc%" query LmHosts | "%find%"  /i "1  STOPPED" >NUL
	if not errorlevel 1 "%net%" start LmHosts
	"%sc%" query Winmgmt | "%find%"  /i "1  STOPPED" >NUL
	if not errorlevel 1 "%net%" start Winmgmt
	if /I "%SYSTEM%"=="2k" (
		"%sc%" query LanmanServer | "%find%"  /i "1  STOPPED" >NUL
		if not errorlevel 1 "%net%" start lanmanServer
		"%sc%" query RPCSs | "%find%"  /i "1  STOPPED" >NUL
		if not errorlevel 1 "%net%" start RPCSs
		"%sc%" query Seclogon | "%find%"  /i "1  STOPPED" >NUL
		if not errorlevel 1 "%net%" start seclogon
		)

	if /I "%SYSTEM%"=="XP" (
		rem "%net%" start SharedAccess
		)

	rem enable SMB port 445
	echo.
	echo  ------------------
	echo  Enabling SMB port 445 ...
	echo REGEDIT4 > "%SMB_TMP%"
	echo. >> "%SMB_TMP%"
	echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters] >> "%SMB_TMP%"
	echo "SMBDeviceEnabled"=dword:00000001 >> "%SMB_TMP%"
	echo. >> "%SMB_TMP%"
	echo. >> "%SMB_TMP%"
	"%regedit%" /s "%SMB_TMP%"
	del /F /Q "%SMB_TMP%"
	set REBOOT_REQUIRED=yes
	)


rem Creating fingerprint of current service settings...
if exist "%FPRINT%" del /F /Q "%FPRINT%"
if /I %USE_FPRINT%==YES (
	echo.
	echo  Creating fingerprint which will take a few seconds ...
	"%sc%" query type= service state= all bufsize= 8192 | %FIND% "SERVICE_NAME" > %TEMP%\~svclist.txt
	for /F "tokens=1*" %%a in (%TEMP%\~svclist.txt) do (
		echo %%b >>"%FPRINT%"
		"%sc%" query "%%b" | %FIND% "STATE" >>"%FPRINT%"
		"%sc%" qc "%%b" | %FIND% "DISPLAY_NAME" >>"%FPRINT%"
		"%SC%" qc "%%b" | %FIND% "START_TYPE" >>"%FPRINT%"
		echo. >> "%FPRINT%" 
		)
	del "%TEMP%\~svclist.txt"
	echo                                                      ... done.
	)
goto :END


:RESTORE
echo  ____________________________________________________
echo.
echo  Letzte Aenderungen zuruecknehmen [y/n]?
set /P UNDO= Undo last changes [y/n]?
if /I "%UNDO%"=="y" (
	echo  _______________________________________________________________
	echo.
	echo  Hinweis:
	echo  ========
	echo  Moeglicherweise meldet Windows Fehler beim Importieren.
	echo  Ignorieren Sie diese mit Klick auf "OK".
	echo.
	echo  Windows might probably report an error during importing the
	echo  backups. Just ignore this by clicking the "OK" button!
	echo  _______________________________________________________________
	echo  Status:
	echo  -------
	:RESTORE_EXT
	if exist "%SVC_BAK%" (
		echo     Importing services ...
		echo        ["%SVC_BAK%"]
		"%regedit%" /s "%SVC_BAK%"
		set action=""
		)

	if exist "%DCOM_BAK%" (
		echo     Importing DCOM ...
		echo        ["%DCOM_BAK%"]
		"%regedit%" /s "%DCOM_BAK%"
		)

	if exist "%DCOMP_BAK%" (
		echo     Importing DCOM-standard protocols ...
		echo        ["%DCOMP_BAK%"]
		"%regedit%" /s "%DCOMP_BAK%"
		)

	if exist "%SMB_BAK%" (
		echo     Importing SMB-settings ...
		echo        ["%SMB_BAK%"]
		"%regedit%" /s "%SMB_BAK%"
		)

	if exist "%HANDLER1%" (
		echo     Importing URL_HANDLER AIM ...
		echo        ["%HANDLER1%"]
		"%regedit%" /s "%HANDLER1%"
		)

	if exist "%HANDLER2%" (
		echo     Importing URL_HANDLER GOPHER ...
		echo        ["%HANDLER2%"]
		"%regedit%" /s "%HANDLER2%"
		)

	if exist "%HANDLER3%" (
		echo     Importing URL_HANDLER TELNET ...
		echo        ["%HANDLER3%"]
		"%regedit%" /s "%HANDLER3%"
		)
  
	rem Skipping back to next state
	if /I "%RESTORE%"=="YES" goto :NO_RESTORE

	echo     Removing RPC Internet key ....
	echo REGEDIT4 >"%USERPROFILE%\svc_fix.reg"
	echo. >>"%USERPROFILE%\svc_fix.reg"
	echo [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Rpc\Internet] >>"%USERPROFILE%\svc_fix.reg"
	echo. >>"%USERPROFILE%\svc_fix.reg"
	echo. >>"%USERPROFILE%\svc_fix.reg"
	"%regedit%" /s "%USERPROFILE%\svc_fix.reg"
	del /F /Q "%USERPROFILE%\svc_fix.reg"
  
	rem Creating fingerprint of current service settings...
	if exist "%FPRINT%" del /F /Q "%FPRINT%"
	if /I %USE_FPRINT%==YES (
		echo.
		echo  Creating fingerprint which will take a few seconds ...
		"%sc%" query type= service state= all bufsize= 8192 | %FIND% "SERVICE_NAME" > %TEMP%\~svclist.txt
		for /F "tokens=1*" %%a in (%TEMP%\~svclist.txt) do (
			echo %%b >>"%FPRINT%"
			"%sc%" query "%%b" | %FIND% "STATE" >>"%FPRINT%"
			"%sc%" qc "%%b" | %FIND% "DISPLAY_NAME" >>"%FPRINT%"
			"%SC%" qc "%%b" | %FIND% "START_TYPE" >>"%FPRINT%"
			echo. >> "%FPRINT%" 
			)
		del "%TEMP%\~svclist.txt"
		echo                                                      ... done.
		)

	echo.
	echo  _______________________________________________________________
	echo.
	echo               *** Zusammenfassung / Result ***
	echo.
	echo  Die Ruecksicherung wurde ausgefuehrt. Wenn in der oberen Zeile 
	echo  keine Statusmeldungen zu sehen sind, existierten keine rueckzu-
	echo  sichernden Dateien. Aktivieren Sie gegebenenfalls NetBios in 
	echo  den Eigenschaften der jeweiligen Netzwerkkarte.
	echo  Bitte starten Sie abschliessend Ihren Rechner neu.
	echo.
	echo  Restore finished. If you don't see any messages in the status
	echo  box above, there were no files to restore. Please reactivate
	echo  NetBios for each NIC you want use with it and reboot afterwards.
	echo  ________________________________________________________________  
	)

goto :END

:RESTORE_DEFAULTS
echo.
echo                     *** Restore Factory Settings ***
echo.
echo  ______________________________________________________________________________
echo.
echo  Einstellungen vor Erstanwendung des Scripts wiederherstellen (ausser NetBIOS)?
set /P UNDO= Restore defaults (before using script, except NetBIOS) [y/n]?
if /I "%UNDO%"=="y" (
	echo.
	echo   - Restoring original service settings [if exists] ...
	if exist "%SVC_BAK%.default" %regedit%" /s "%SVC_BAK%.default"
	if exist "%DCOM_BAK%.default" "%regedit%" /s "%DCOM_BAK%.default"
	if exist "%DCOMP_BAK%.default" "%regedit%" /s "%DCOMP_BAK%.default"
	if exist "%SMB_BAK%.default" "%regedit%" /s "%SMB_BAK%.default"
	if exist "%HANDLER1%.default" "%regedit%" /s "%HANDLER1%.default"
	if exist "%HANDLER2%.default" "%regedit%" /s "%HANDLER2%.default"
	if exist "%HANDLER3%.default" "%regedit%" /s "%HANDLER3%.default"
	echo                                                 ... done.
  
	echo   - Removing RPC Internet key ...
	echo REGEDIT4 >"%USERPROFILE%\svc_fix.reg"
	echo. >>"%USERPROFILE%\svc_fix.reg"
	echo [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Rpc\Internet] >>"%USERPROFILE%\svc_fix.reg"
	echo. >>"%USERPROFILE%\svc_fix.reg"
	echo. >>"%USERPROFILE%\svc_fix.reg"
	"%regedit%" /s "%USERPROFILE%\svc_fix.reg"
	del /F /Q "%USERPROFILE%\svc_fix.reg"
	echo                                                 ... done.

	)
goto :QUIT


:SC_DOWNLOAD
echo  ______________________________________________________________
echo.
echo  有一优化所需要的重要文件丢失。。。
echo  找不到文件sc.exe，您想从网上下载吗？
echo.
set /P UNDO= 选择下载请按Y，不下载请按N: [y/n]?
  if /I "%UNDO%"=="y" goto :SC_DOWNLOAD_OK
goto :END

:SC_DOWNLOAD_OK
if exist "%SYSTEMROOT%\sc.zip" goto :SCE
echo  Generating FTP-script ...
if exist "%USERPROFILE%"\script_sc.ls del /F "%USERPROFILE%\script_sc.ls"
echo open 207.46.133.140 >"%USERPROFILE%\script_sc.ls"
echo user anonymous anonymous@aol.com >>"%USERPROFILE%\script_sc.ls"
echo type binary >>"%USERPROFILE%\script_sc.ls"
echo user anonymous anonymous@aol.com >>"%USERPROFILE%\script_sc.ls"
echo type binary >>"%USERPROFILE%\script_sc.ls"
echo get /reskit/win2000/sc.zip "%SYSTEMROOT%\System32\SC.ZIP" >>"%USERPROFILE%\script_sc.ls"
echo quit >>"%USERPROFILE%\script_sc.ls"

echo  Downloading SC.EXE ...
ftp -s:"%USERPROFILE%\script_sc.ls"
del /F "%USERPROFILE%\script_sc.ls"

:SCE
if exist "%SYSTEMROOT%\System32\pkunzip.exe" goto :PKE
echo  Generating FTP-script ...
if exist "%USERPROFILE%"\script_pk.ls del /F "%USERPROFILE%\script_pk.ls"
echo open ftp.uni-duesseldorf.de >"%USERPROFILE%\script_pk.ls"
echo user anonymous anonymous@aol.com >>"%USERPROFILE%\script_pk.ls"
echo type binary >>"%USERPROFILE%\script_pk.ls"
echo user anonymous anonymous@aol.com >>"%USERPROFILE%\script_pk.ls"
echo type binary >>"%USERPROFILE%\script_pk.ls"
echo get /pub/ie/pkunzip.exe "%SYSTEMROOT%\System32\pkunzip.exe" >>"%USERPROFILE%\script_pk.ls"
echo quit >>"%USERPROFILE%\script_pk.ls"

echo  Downloading PKUNZIP.EXE ...
ftp -s:"%USERPROFILE%\script_pk.ls"
del /F "%USERPROFILE%\script_pk.ls"

:PKE
if not exist "%SYSTEMROOT%\System32\sc.zip" (
	echo.
	echo   Download fehlgeschlagen. Bitte laden sie sich die Datei SC.ZIP manuell
	echo   herunter und kopieren diese nach %SYSTEMROOT%\.
	echo.
	echo   Downloading SC.ZIP failed. Please download it manually an copy it to
	echo   %SYSTEMROOT%\.
	)

if not exist "%SYSTEMROOT%\System32\pkunzip.exe" (
	echo.
	echo   Die Datei PKUNZIP.EXE konnte nicht gefunden werden. Diese wird zum 
	echo   Entpacken des Archivs SC.ZIP benoetigt!
	echo.
	echo   File PKUNZIP.EXE not found. It is needed to decompress the archive SC.EXE.
	)

if exist "%SYSTEMROOT%\System32\SC.ZIP" (
	if exist "%SYSTEMROOT%\System32\pkunzip.exe" (
		"%SYSTEMROOT%\System32\pkunzip.exe" -e "%SYSTEMROOT%\System32\sc.zip" sc.exe
		)
	)

move /Y sc.exe "%SYSTEMROOT%\System32\"
echo.
echo  Skript wird neu gestartet ...
echo  Restarting script ...
goto :START

:FIX
echo.
echo                     -= svc2kxp.cmd taskplaner fix =-
echo.
echo.
echo  Druecken Sie "Y", um das Problem mit dem Taskplaner ("falscher Parameter") 
echo  unter Windows XP zu beheben.
echo.
echo  Press "Y", if you want fix issue "scheduler doesn't start under Windows XP 
echo  after running script v2.0 - v2.1build0".
echo.
set /P UNDO= Fix problem [y/n]?
if /I "%UNDO%"=="y" (
	echo REGEDIT4 >"%USERPROFILE%\svc_fix.reg"
	echo. >>"%USERPROFILE%\svc_fix.reg"
	echo [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Rpc\Internet] >>"%USERPROFILE%\svc_fix.reg"
	echo. >>"%USERPROFILE%\svc_fix.reg"
	echo. >>"%USERPROFILE%\svc_fix.reg"
	"%regedit%" /s "%USERPROFILE%\svc_fix.reg"
	del /F /Q "%USERPROFILE%\svc_fix.reg"
	echo  ______________________________________
	echo  OK. Bitte starten Sie den Rechner neu und kontrollieren Sie erneut,
	echo  ob hierdurch Ports geoeffnet wurden.
	echo.
	echo  Done. Please reboot and check again for open ports ...!
	)


rem Creating fingerprint of current service settings...
if exist "%FPRINT%" del /F /Q "%FPRINT%"
goto quit
if /I %USE_FPRINT%==YES (
	echo.
  	echo  Creating fingerprint which will take a few seconds ...
  	"%sc%" query type= service state= all bufsize= 8192 | %FIND% "SERVICE_NAME" > %TEMP%\~svclist.txt
  	for /F "tokens=1*" %%a in (%TEMP%\~svclist.txt) do (
		echo %%b >>"%FPRINT%"
		"%sc%" query "%%b" | %FIND% "STATE" >>"%FPRINT%"
		"%sc%" qc "%%b" | %FIND% "DISPLAY_NAME" >>"%FPRINT%"
		"%SC%" qc "%%b" | %FIND% "START_TYPE" >>"%FPRINT%"
		echo. >> "%FPRINT%" 
		)
	del "%TEMP%\~svclist.txt"
	echo                                                      ... done.
	)

goto :QUIT

rem **** Additional Feature List ****

:MORE_OPTIONS
cls
echo  ______________________________________________________________________________
echo.
echo                 *** Weitere Optionen / More Options Menue ***
echo                    
echo.
if /I "%SVC_MOD%"=="YES" (
	echo  [E]...Zeigt eine Liste an, welche Dienste seit der letzten Anwendung
	echo        von svc2kxp.cmd veraendert wurden.
	echo.
	echo        Shows a list with modified services since last use of scv2kxp.cmd
	echo.
	)

echo  [G]...Generiert einen neuen Fingerprint, um Veraenderungen bei 
echo        Diensten zu erfassen
echo.
echo        Generates a new fingerprint to correctly detect changes of 
echo        services
echo.
echo  [S]...Sichern der aktuellen Dienstekonfiguration.
echo        Saving current NT service configuration (auto/demand/disabled).
echo.
echo  ______________________________________________________________________________
echo.
if /I "%SVC_MOD%"=="NO" set /P CHS=       Bitte waehlen Sie/Please choose: [G], [S], [B]ack or [Q]uit?
if /I "%SVC_MOD%"=="YES" set /P CHS=       Bitte waehlen Sie/Please choose: [E], [G], [S], [B]ack or [Q]uit?
if /I "%SVC_MOD%"=="YES" if /I "%CHS%"=="E" GOTO :EVALUATE_SERVICES
if /I "%CHS%"=="G" GOTO :CREATING_NEW_FINGERPRINT
if /I "%CHS%"=="B" (
                    CLS
		    GOTO :START
		   )
if /I "%CHS%"=="S" GOTO :SAVE_SVC_SETTINGS
if /I "%CHS%"=="Q" GOTO :QUIT
GOTO :MORE_OPTIONS



:EVALUATE_SERVICES
cls
echo  ______________________________________________________________________________
echo.
echo                        *** Evaluate Services Menue ***
echo.
"%FC%" /N "%FPRINT%" "%USERPROFILE%\svc2cmp.sav"
echo  ______________________________________________________________________________
echo.
set /P CHS=       Bitte waehlen Sie/Please choose: [B]ack, [U]pdate or [Q]uit?
if /I "%CHS%"=="B" GOTO :MORE_OPTIONS
if /I "%CHS%"=="U" GOTO :CREATING_NEW_FINGERPRINT
if /I "%CHS%"=="Q" GOTO :QUIT
GOTO :MORE_OPTIONS


:SAVE_SVC_SETTINGS
cls
echo  ______________________________________________________________________________
echo.
echo               *** Manage current services configurations menue ***
echo                   --------------------------------------------
echo.
echo   Soll die aktuelle Dienstekonfiguration gesichert werden?
echo.
set /P CHS=  Should the current service configuration saved (y/n)?
if /I "%CHS%"=="N" GOTO :MORE_OPTIONS
if /I "%CHS%"=="Y" (
	echo   Saving current services settings to:
	echo. 
	echo    - %SVC_SAV%
	"%regedit%" /e "%SVC_SAV%" HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services
	echo.
	echo   ... Done!
	echo  ______________________________________________________________________________
	echo.
	echo        Beliebige Taste druecken, um fortzufahren. Hit any key to return.
	pause>NUL
	)
if /I "%CHS%"=="Q" GOTO :QUIT
goto :MORE_OPTIONS




pause >NUL
goto :MORE_OPTIONS


:CREATING_NEW_FINGERPRINT
cls
echo  ______________________________________________________________________________
echo.
echo                     *** Creating new fingerprint menue ***
echo                         ------------------------------
echo.
set /P CHS=  Create new fingerprint [Y/N]?
if /I "%CHS%"=="Y" (
	if exist "%FPRINT%" del /F /Q "%FPRINT%"
	echo   Creating new fingerprint which will take a few seconds ...
	"%sc%" query type= service state= all bufsize= 8192 | %FIND% "SERVICE_NAME" > %TEMP%\~svclist.txt
	for /F "tokens=1*" %%a in (%TEMP%\~svclist.txt) do (
		echo %%b >>"%FPRINT%"
		"%sc%" query "%%b" | %FIND% "STATE" >>"%FPRINT%"
		"%sc%" qc "%%b" | %FIND% "DISPLAY_NAME" >>"%FPRINT%"
		"%SC%" qc "%%b" | %FIND% "START_TYPE" >>"%FPRINT%"
		echo. >> "%FPRINT%" 
		)
	del "%TEMP%\~svclist.txt"
	echo                                                           ... done. 
	echo  ______________________________________________________________________________
	echo.
	echo                          [Press any key to continue]
	set CHK_SVC=YES
	PAUSE >NUL
	)
cls
GOTO :MORE_OPTIONS


:XPSYSRESTORE
REM Creating A System Restore Point // Source Code: MS Technet Scriptcenter
	echo.
	echo  # Creating System Restore Point [if XP SysRestore is enabled] ...
	if exist "%srctmp%" del /F /Q "%srctmp%"
	echo CONST DEVICE_DRIVER_INSTALL = 10 >"%srctmp%"
	echo CONST BEGIN_SYSTEM_CHANGE = 100 >>"%srctmp%"
	echo.>>"%srctmp%"
	echo strComputer = ".">>"%srctmp%"
	echo Set objWMIService = GetObject("winmgmts:" _ >>"%srctmp%"
	echo 	^& "{impersonationLevel=impersonate}!\\" ^& strComputer ^& "\root\default")>>"%srctmp%"
	echo.>>"%srctmp%"
	echo Set objItem = objWMIService.Get("SystemRestore")>>"%srctmp%"
	echo errResults = objItem.CreateRestorePoint _ >>"%srctmp%"
	echo 	("svc2kxp.cmd created restore point", DEVICE_DRIVER_INSTALL, BEGIN_SYSTEM_CHANGE)>>"%srctmp%"
	"%srctmp%"
	del /F /Q "%srctmp%"
	echo.
goto :XPSYSRESTORE_DONE


:END
if "%REBOOT_REQUIRED%"=="yes" (
	echo.
	echo  ______________________________________________________
	echo.
	echo           *** Zusammenfassung / Result ***
	echo.
	if /I %SELECT%=="/all" echo  Es wurden alle gewuenschten Aenderungen durchgefuehrt.
	if /I %SELECT%=="/std" echo  Einige Dienste blieben unveraendert.
	if /I %SELECT%=="/relan" echo  Notwendige LAN-Einstellungen wurden aktiviert.
	echo  Bitte starten Sie abschliessend Ihren Rechner neu.
	echo.
	if /I %SELECT%=="/all" echo  All changes applied successfully.
	if /I %SELECT%=="/std" echo  Some services stay unchanged.
	if /I %SELECT%=="/relan" echo  LAN settings reactivated.
	echo  Please reboot.
	echo  ______________________________________________________  
	)


:QUIT
echo		________________________________________________________
echo.
echo		     Weitere Informationen: http://9thclub.cn
echo		For more informations: http://9thclub.cn
echo		________________________________________________________
echo		 [Taste zum Beenden druecken]   [Press any key to quit] 
echo		 ------------------------------------------------------
echo.
if /I "%1"=="" pause>NUL

:QUIT_EXT
endlocal
if exist "%USERPROFILE%\svc2cmp.sav" del /F /Q "%USERPROFILE%\svc2cmp.sav"
echo.

:setsave
@echo off
color 0a
cls
echo.
echo                             
echo.
echo                         
echo.
echo                         安全设置
echo.
echo                 ******************************
echo                 请选择要进行的操作，然后按回车
echo                 ******************************
echo.
echo.
echo               1.自动关闭有害端口
echo.
echo               2.病毒专杀+免疫(U盘病毒，威金病毒，能猫烧香
echo                 蓝波...(包括了目前流行的病毒，一次性杀光并免疫)
echo.
echo               3.其它常见病毒免疫
echo.
echo               4.返回主菜单
echo.
echo               Q.退出
echo.

:chovsafe
set choice=
set /p choice=            请选择：
IF NOT "%choice%"=="" SET choice=%choice:~0,1%
if /i "%choice%"=="1" goto killport
if /i "%choice%"=="2" goto virus
if /i "%choice%"=="3" goto imvirus
if /i "%choice%"=="4" goto menu
if /i "%choice%"=="q" goto endd
echo.
echo 选择无效，请重新输入
echo.
goto chosafe

:imvirus
echo 处理此项目需要花十几秒时间，请您稍等...
@echo off
echo Windows Registry Editor Version 5.00>>Fix.reg

echo [HKEY_CURRENT_USER\Control Panel\Desktop]>>Fix.reg
echo "AutoEndTasks"="1">>Fix.reg
echo "HungAppTimeout"="200">>Fix.reg
echo "WaitToKillAppTimeout"="200">>Fix.reg
echo "WaitTOKillService"="200">>Fix.reg
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control]>>Fix.reg
echo "WaitToKillServiceTimeout"="200">>Fix.reg
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters]>>Fix.reg
echo "EnablePrefetcher"=dword:00000001>>Fix.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon]>>Fix.reg
echo "SFCDisable"=dword:00000001>>Fix.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AlwaysUnloadDLL]>>Fix.reg
echo @="0">>Fix.reg
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters]>>Fix.reg
echo "AutoShareServer"=dword:00000000>>Fix.reg
echo "AutoSharewks"=dword:00000000>>Fix.reg
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Windows]>>Fix.reg
echo "NoPopUpsOnBoot"=dword:00000001>>Fix.reg
echo [HKEY_CLASSES_ROOT\lnkfile]>>Fix.reg
echo @="快捷方式">>Fix.reg
echo "EditFlags"=dword:00000001>>Fix.reg
echo "NeverShowExt"="">>Fix.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RemoteComputer\NameSpace]>>Fix.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RemoteComputer\NameSpace\{2227A280-3AEA-1069-A2DE-08002B30309D}]>>Fix.reg
echo @="Printers">>Fix.reg
echo [HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer]>>Fix.reg
echo "Link"=hex:00,00,00,00>>Fix.reg
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters]>>Fix.reg
echo "EnablePrefetcher"=dword:00000003>>Fix.reg
echo [HKEY_USERS\.DEFAULT\Control Panel\Desktop]>>Fix.reg
echo "FontSmoothing"="2">>Fix.reg
echo "FontSmoothingType"=dword:00000002>>Fix.reg
echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings]>>Fix.reg
echo "MaxConnectionsPer1_0Server"=dword:00000008>>Fix.reg
echo "MaxConnectionsPerServer"=dword:00000008>>Fix.reg
echo [HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control]>>Fix.reg
echo "WaitToKillServiceTimeout"="1000">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Shareaza.exe]>>Fix.reg
echo "Debugger"="c:\\中国超级BT.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\4047.exe]>>Fix.reg
echo "Debugger"="c:\\中国超级BT捆绑的病毒.exe">>Fix.reg


echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\qqfo1.0_dl.exe]>>Fix.reg
echo "Debugger"="c:\\P2P类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SuperLANadmin.exe]>>Fix.reg
echo "Debugger"="c:\\破坏类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Robocop.exe]>>Fix.reg
echo "Debugger"="c:\\破坏类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\diaoxian.exe]>>Fix.reg
echo "Debugger"="c:\\破坏类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\network.exe]>>Fix.reg
echo "Debugger"="c:\\破坏类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\冰点还原终结者.exe]>>Fix.reg
echo "Debugger"="c:\\破坏类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\3389.exe]>>Fix.reg
echo "Debugger"="c:\\破坏类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\3389.rar]>>Fix.reg
echo "Debugger"="c:\\破坏类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sc.exe]>>Fix.reg
echo "Debugger"="c:\\破坏类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\mstsc.exe]>>Fix.reg
echo "Debugger"="c:\\破坏类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\3389dl.exe]>>Fix.reg
echo "Debugger"="c:\\破坏类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\3389dl.rar]>>Fix.reg
echo "Debugger"="c:\\破坏类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\黑社会.exe]>>Fix.reg
echo "Debugger"="c:\\破坏类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\还原精灵密码察看器.exe]>>Fix.reg
echo "Debugger"="bcvb">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\cmcc.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\bczp.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\3721.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\PodcastBarMiniStarter.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\cdnns.dll]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\cdnns.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\setupcnnic.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ieup.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SurfingPlus.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ok.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\123.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ieup.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\IESearch.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WinSC32.dll]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ZComService.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\skin.dll]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\msiexec.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\DrvIst.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MSIF1.tmp]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\NetMon.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\LanecatTrial.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\LEC_Client.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\BTBaby.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WebThunder1.0.4.28deluxbeta.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WebThunder.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Thunder5.1.6.198.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ThunderMini2.0.0.29.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\is-TEQG7.tmp]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TingTing1.1.0.8Beta.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\is-C6R99.tmp]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\is-00KC0.tmp]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\BitComet_0.68_setup.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\BitComet.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\BitComet0.62.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\100baoSetup120.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\GLBD.tmp]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\DDD4_DXT168.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ppstreamsetup.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\PPStream.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TV100.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\is-S5LOA.tmp]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\is-S5L0A.tmp]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\teng.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TENG.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\is-RP216.tmp]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\rongtv.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\hjsetup.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\HJSETUP.EXE]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\msiexec.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\rep.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dudupros.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\DuDuAcc.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Dmad-install.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\D-mad.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\004-PPGou-Dmad.EXE]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\PPGou.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TDUpdate.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\PodcastBarMini.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MyShares.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vfp02.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\is-5SKT1.tmp]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\bgoomain.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\setup_L0029.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ns40.tmp]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\1032.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\yAssistSe.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ddos.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\BitTorrent.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\drwtsn32.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Win98局域网攻击工具.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\NetThief.exe]>>Fix.reg
echo "Debugger"="c:\\网络神偷.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RemoteComputer.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\QQTailer.exe]>>Fix.reg
echo "Debugger"="c:\\制造出来的QQ病毒.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\傀儡僵尸DDOS攻击集合.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Alchem.exe]>>Fix.reg
echo "Debugger"="c:\\以下是存在风险病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\actalert.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\adaware.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\alevir.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\aqadcup.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\archive.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\arr.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ARUpdate.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\asm.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\av.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\avserve.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\avserve2.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\backWeb.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\bargains.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\basfipm.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\belt.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Biprep.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\blss.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\bokja.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\bootconf.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\bpc.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\brasil.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\BRIDGE.DLL]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Buddy.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\BUGSFIX.EXE]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\bundle.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\bvt.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\cashback.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\cdaEngine.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\cmd32.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\cmesys.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\conime.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\conscorr.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\crss.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\cxtpls.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\datemanager.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dcomx.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Desktop.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\directs.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\divx.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dllreg.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dmserver.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dpi.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dssagent.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dvdkeyauth.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\emsw.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\exdl.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\exec.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\EXP.EXE]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\explore.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\explored.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Fash.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\logo_1.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\logo_2.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\worm.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\worm.htm]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\1_.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\2_.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\3_.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\pif.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FuckJacks.exe]>>Fix.reg
echo "Debugger"="c:\\病毒类.exe">>Fix.reg
echo.
echo 常见病毒注册表免疫中。。。。。。
echo.
echo off
start /w regedit /s Fix.reg
del Fix.reg
echo.
echo 免疫成功! 请按任意键返回!
echo.
pause >nul
goto setsave

:killport
cls
@echo off
gpupdate >nul
rem For Client only
ipseccmd  -w REG -p "HFUT_SECU" -o -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -x >nul
rem ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/80" -f *+0:80:TCP -n BLOCK -x >nul
rem ipseccmd  -w REG -p "HFUT_SECU" -r "Block UDP/1434" -f *+0:1434:UDP -n BLOCK -x >nul
rem ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/139" -f *+0:139:TCP -n BLOCK -x >nul 
rem echo 禁止NetBIOS/SMB服务和文件和打印机共享和SAMBA（去掉REM生效）
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/135" -f *+0:135:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block UDP/135" -f *+0:135:UDP -n BLOCK -x >nul
echo 禁止本地服务和防止 Dos 攻击…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/445" -f *+0:445:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block UDP/445" -f *+0:445:UDP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/1025" -f *+0:1025:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block UDP/139" -f *+0:139:UDP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/1068" -f *+0:1068:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/5554" -f *+0:5554:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/9995" -f *+0:9995:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/9996" -f *+0:9996:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/6129" -f *+0:6129:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block ICMP/255" -f *+0:255:ICMP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/43958" -f *+0:43958:TCP -n BLOCK -x >nul
echo 关闭流行危险端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/20034" -f *+0:20034:TCP -n BLOCK -x >nul
echo 关闭木马NetBus Pro开放的端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/1092" -f *+0:1092:TCP -n BLOCK -x >nul
echo 关闭蠕虫LoveGate开放的端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/3996" -f *+0:3996:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/4060" -f *+0:4060:TCP -n BLOCK -x >nul
echo 关闭木马RemoteAnything开放的端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/4590" -f *+0:4590:TCP -n BLOCK -x >nul
echo 关闭木马ICQTrojan开放的端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/1080" -f *+0:1080:TCP -n BLOCK -x >nul
echo 禁止代理服务器扫描…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/113" -f *+0:113:TCP -n BLOCK -x >nul
echo 禁止Authentication Service服务…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/79" -f *+0:79:TCP -n BLOCK -x >nul
echo 禁止Finger扫描…………OK！
ipseccmd  -w REG -p "HFUT_SECU" -r "Block UDP/53" -f *+0:53:UDP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/53" -f *+0:53:TCP -n BLOCK -x >nul
echo 禁止区域传递（TCP），欺骗DNS（UDP）或隐藏其他的通信…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/707" -f *+0:707:TCP -n BLOCK -x >nul
echo 关闭nachi蠕虫病毒监听端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/808" -f *+0:808:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/23" -f *+0:23:TCP -n BLOCK -x >nul
echo 关闭Telnet 和木马Tiny Telnet Server监听端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/520" -f *+0:520:TCP -n BLOCK -x >nul
echo 关闭Rip 端口…………OK！
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/1999" -f *+0:1999:TCP -n BLOCK -x >nul
echo 关闭木马程序BackDoor的默认服务端口…………OK！
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/2001" -f *+0:2001:TCP -n BLOCK -x >nul
echo 关闭马程序黑洞2001的默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/2023" -f *+0:2023:TCP -n BLOCK -x >nul
echo 关闭木马程序Ripper的默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/2583" -f *+0:2583:TCP -n BLOCK -x >nul
echo 关闭木马程序Wincrash v2的默认服务端口…………OK！
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/3389" -f *+0:3389:TCP -n BLOCK -x >nul
echo 关闭Windows 的远程管理终端（远程桌面）监听端口…………OK！
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/4444" -f *+0:4444:TCP -n BLOCK -x >nul
echo 关闭msblast冲击波蠕虫监听端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/4899" -f *+0:4899:TCP -n BLOCK -x >nul
echo 关闭远程控制软件（remote administrator)服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/5800" -f *+0:5800:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/5900" -f *+0:5900:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/8888" -f *+0:8888:TCP -n BLOCK -x >nul
echo 关闭远程控制软件VNC的两个默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/6129" -f *+0:6129:TCP -n BLOCK -x >nul
echo 关闭Dameware服务端默认监听端口（可变！）…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/6267" -f *+0:6267:TCP -n BLOCK -x >nul
echo 关闭木马广外女生的默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/660" -f *+0:660:TCP -n BLOCK -x >nul
echo 关闭木马DeepThroat v1.0 - 3.1默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/6671" -f *+0:6671:TCP -n BLOCK -x >nul
echo 关闭木马Indoctrination默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/6939" -f *+0:6939:TCP -n BLOCK -x >nul
echo 关闭木马PRIORITY默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/7306" -f *+0:7306:TCP -n BLOCK -x >nul
echo 关闭木马网络精灵默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/7511" -f *+0:7511:TCP -n BLOCK -x >nul
echo 关闭木马聪明基因的默认连接端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/7626" -f *+0:7626:TCP -n BLOCK -x >nul
echo 关闭木马冰河默认端口(注意可变！)…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/8011" -f *+0:8011:TCP -n BLOCK -x >nul
echo 关闭木马WAY2.4默认服务端口…………OK！
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/9989" -f *+0:9989:TCP -n BLOCK -x >nul
echo 关闭木马InIkiller默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/19191" -f *+0:19191:TCP -n BLOCK -x >nul
echo 关闭木马兰色火焰默认开放的telnet端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/1029" -f *+0:1029:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/20168" -f *+0:20168:TCP -n BLOCK -x >nul
echo 关闭lovegate 蠕虫所开放的两个后门端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/23444" -f *+0:23444:TCP -n BLOCK -x >nul
echo 关闭木马网络公牛默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/27374" -f *+0:27374:TCP -n BLOCK -x >nul
echo 关闭木马SUB7默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/30100" -f *+0:30100:TCP -n BLOCK -x >nul
echo 关闭木马NetSphere默认的服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/31337" -f *+0:31337:TCP -n BLOCK -x >nul
echo 关闭木马BO2000默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/45576" -f *+0:45576:TCP -n BLOCK -x >nul
echo 关闭代理软件的控制端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/50766" -f *+0:50766:TCP -n BLOCK -x >nul
echo 关闭木马Schwindler默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/61466" -f *+0:61466:TCP -n BLOCK -x >nul
echo 关闭木马Telecommando默认服务端口…………OK!

ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/31338" -f *+0:31338:TCP -n BLOCK -x >nul
echo 关闭木马Back Orifice默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/8102" -f *+0:8102:TCP -n BLOCK -x >nul
echo 关闭木马网络神偷默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2000" -f *+0:2000:TCP -n BLOCK -x >nul
echo 关闭木马黑洞2000默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/31339" -f *+0:31339:TCP -n BLOCK -x >nul
echo 关闭木马NetSpy DK默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2001" -f *+0:2001:TCP -n BLOCK -x >nul
echo 关闭木马黑洞2001默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/31666" -f *+0:31666:TCP -n BLOCK -x >nul
echo 关闭木马BOWhack默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/34324" -f *+0:34324:TCP -n BLOCK -x >nul
echo 关闭木马BigGluck默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7306" -f *+0:7306:TCP -n BLOCK -x >nul
echo 关闭木马网络精灵3.0，netspy3.0默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/40412" -f *+0:40412:TCP -n BLOCK -x >nul
echo 关闭木马The Spy默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/40421" -f *+0:40421:TCP -n BLOCK -x >nul
echo 关闭木马Masters Paradise默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/8011" -f *+0:8011:TCP -n BLOCK -x >nul
echo 关闭木马wry，赖小子，火凤凰默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/40422" -f *+0:40422:TCP -n BLOCK -x >nul
echo 关闭木马Masters Paradise 1.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/23444" -f *+0:23444:TCP -n BLOCK -x >nul
echo 关闭木马网络公牛，netbull默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/40423" -f *+0:40423:TCP -n BLOCK -x >nul
echo 关闭木马Masters Paradise 2.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/23445" -f *+0:23445:TCP -n BLOCK -x >nul
echo 关闭木马网络公牛，netbull默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/40426" -f *+0:40426:TCP -n BLOCK -x >nul
echo 关闭木马Masters Paradise 3.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/50505" -f *+0:50505:TCP -n BLOCK -x >nul
echo 关闭木马Sockets de Troie默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/27374" -f *+0:27374:TCP -n BLOCK -x >nul
echo 关闭木马Sub Seven 2.0+，77，东方魔眼默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/50766" -f *+0:50766:TCP -n BLOCK -x >nul
echo 关闭木马Fore默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/53001" -f *+0:53001:TCP -n BLOCK -x >nul
echo 关闭木马Remote Windows Shutdown默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/61466" -f *+0:61466:TCP -n BLOCK -x >nul
echo 关闭木马Telecommando默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/121" -f *+0:121:TCP -n BLOCK -x >nul
echo 关闭木马BO jammerkillahV默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/666" -f *+0:666:TCP -n BLOCK -x >nul
echo 关闭木马Satanz Backdoor默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/65000" -f *+0:65000:TCP -n BLOCK -x >nul
echo 关闭木马Devil默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1001" -f *+0:1001:TCP -n BLOCK -x >nul
echo 关闭木马Silencer默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/6400" -f *+0:6400:TCP -n BLOCK -x >nul
echo 关闭木马The tHing默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1600" -f *+0:1600:TCP -n BLOCK -x >nul
echo 关闭木马Shivka-Burka默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/12346" -f *+0:12346:TCP -n BLOCK -x >nul
echo 关闭木马NetBus 1.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1807" -f *+0:1807:TCP -n BLOCK -x >nul
echo 关闭木马SpySender默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/20034" -f *+0:20034:TCP -n BLOCK -x >nul
echo 关闭木马NetBus Pro默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1981" -f *+0:1981:TCP -n BLOCK -x >nul
echo 关闭木马Shockrave默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1243" -f *+0:1243:TCP -n BLOCK -x >nul
echo 关闭木马SubSeven默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1001" -f *+0:1001:TCP -n BLOCK -x >nul
echo 关闭木马WebEx默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/30100" -f *+0:30100:TCP -n BLOCK -x >nul
echo 关闭木马NetSphere默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1011" -f *+0:1011:TCP -n BLOCK -x >nul
echo 关闭木马Doly Trojan默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1001" -f *+0:1001:TCP -n BLOCK -x >nul
echo 关闭木马Silencer默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1170" -f *+0:1170:TCP -n BLOCK -x >nul
echo 关闭木马Psyber Stream Server默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/20000" -f *+0:20000:TCP -n BLOCK -x >nul
echo 关闭木马Millenium默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1234" -f *+0:1234:TCP -n BLOCK -x >nul
echo 关闭木马Ultors Trojan默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/65000" -f *+0:65000:TCP -n BLOCK -x >nul
echo 关闭木马Devil 1.03默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1245" -f *+0:1245:TCP -n BLOCK -x >nul
echo 关闭木马VooDoo Doll默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7306" -f *+0:7306:TCP -n BLOCK -x >nul
echo 关闭木马NetMonitor默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1492" -f *+0:1492:TCP -n BLOCK -x >nul
echo 关闭木马FTP99CMP默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1170" -f *+0:1170:TCP -n BLOCK -x >nul
echo 关闭木马Streaming Audio Trojan默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1999" -f *+0:1999:TCP -n BLOCK -x >nul
echo 关闭木马BackDoor默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/30303" -f *+0:30303:TCP -n BLOCK -x >nul
echo 关闭木马Socket23默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2001" -f *+0:2001:TCP -n BLOCK -x >nul
echo 关闭木马Trojan Cow默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/6969" -f *+0:6969:TCP -n BLOCK -x >nul
echo 关闭木马Gatecrasher默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2023" -f *+0:2023:TCP -n BLOCK -x >nul
echo 关闭木马Ripper默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/61466" -f *+0:61466:TCP -n BLOCK -x >nul
echo 关闭木马Telecommando默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2115" -f *+0:2115:TCP -n BLOCK -x >nul
echo 关闭木马Bugs默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/12076" -f *+0:12076:TCP -n BLOCK -x >nul
echo 关闭木马Gjamer默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2140" -f *+0:2140:TCP -n BLOCK -x >nul
echo 关闭木马Deep Throat默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/4950" -f *+0:4950:TCP -n BLOCK -x >nul
echo 关闭木马IcqTrojen默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2140" -f *+0:2140:TCP -n BLOCK -x >nul
echo 关闭木马The Invasor默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/16969" -f *+0:16969:TCP -n BLOCK -x >nul
echo 关闭木马Priotrity默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2801" -f *+0:2801:TCP -n BLOCK -x >nul
echo 关闭木马Phineas Phucker默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1245" -f *+0:1245:TCP -n BLOCK -x >nul
echo 关闭木马Vodoo默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/30129" -f *+0:30129:TCP -n BLOCK -x >nul
echo 关闭木马Masters Paradise默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5742" -f *+0:5742:TCP -n BLOCK -x >nul
echo 关闭木马Wincrash默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/3700" -f *+0:3700:TCP -n BLOCK -x >nul
echo 关闭木马Portal of Doom默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2583" -f *+0:2583:TCP -n BLOCK -x >nul
echo 关闭木马Wincrash2默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/4092" -f *+0:4092:TCP -n BLOCK -x >nul
echo 关闭木马WinCrash默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1033" -f *+0:1033:TCP -n BLOCK -x >nul
echo 关闭木马Netspy默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/4590" -f *+0:4590:TCP -n BLOCK -x >nul
echo 关闭木马ICQTrojan默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1981" -f *+0:1981:TCP -n BLOCK -x >nul
echo 关闭木马ShockRave默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5000" -f *+0:5000:TCP -n BLOCK -x >nul
echo 关闭木马Sockets de Troie默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/555" -f *+0:555:TCP -n BLOCK -x >nul
echo 关闭木马Stealth Spy默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5001" -f *+0:5001:TCP -n BLOCK -x >nul
echo 关闭木马Sockets de Troie 1.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2023" -f *+0:2023:TCP -n BLOCK -x >nul
echo 关闭木马Pass Ripper默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5321" -f *+0:5321:TCP -n BLOCK -x >nul
echo 关闭木马Firehotcker默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/666" -f *+0:666:TCP -n BLOCK -x >nul
echo 关闭木马Attack FTP默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5400" -f *+0:5400:TCP -n BLOCK -x >nul
echo 关闭木马Blade Runner默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/21554" -f *+0:21554:TCP -n BLOCK -x >nul
echo 关闭木马GirlFriend默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5401" -f *+0:5401:TCP -n BLOCK -x >nul
echo 关闭木马Blade Runner 1.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/50766" -f *+0:50766:TCP -n BLOCK -x >nul
echo 关闭木马Fore Schwindler默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5402" -f *+0:5402:TCP -n BLOCK -x >nul
echo 关闭木马Blade Runner 2.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/34324" -f *+0:34324:TCP -n BLOCK -x >nul
echo 关闭木马Tiny Telnet Server默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5569" -f *+0:5569:TCP -n BLOCK -x >nul
echo 关闭木马Robo-Hack默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/30999" -f *+0:30999:TCP -n BLOCK -x >nul
echo 关闭木马Kuang默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/6670" -f *+0:6670:TCP -n BLOCK -x >nul
echo 关闭木马DeepThroat默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/11000" -f *+0:11000:TCP -n BLOCK -x >nul
echo 关闭木马Senna Spy Trojans默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/6771" -f *+0:6771:TCP -n BLOCK -x >nul
echo 关闭木马DeepThroat默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/23456" -f *+0:23456:TCP -n BLOCK -x >nul
echo 关闭木马WhackJob默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/6969" -f *+0:6969:TCP -n BLOCK -x >nul
echo 关闭木马GateCrasher默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/555" -f *+0:555:TCP -n BLOCK -x >nul
echo 关闭木马Phase0默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/6969" -f *+0:6969:TCP -n BLOCK -x >nul
echo 关闭木马Priority默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5400" -f *+0:5400:TCP -n BLOCK -x >nul
echo 关闭木马Blade Runner默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7000" -f *+0:7000:TCP -n BLOCK -x >nul
echo 关闭木马Remote Grab默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/4950" -f *+0:4950:TCP -n BLOCK -x >nul
echo 关闭木马IcqTrojan默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7300" -f *+0:7300:TCP -n BLOCK -x >nul
echo 关闭木马NetMonitor默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/9989" -f *+0:9989:TCP -n BLOCK -x >nul
echo 关闭木马InIkiller默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7301" -f *+0:7301:TCP -n BLOCK -x >nul
echo 关闭木马NetMonitor 1.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/9872" -f *+0:9872:TCP -n BLOCK -x >nul
echo 关闭木马Portal Of Doom默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7306" -f *+0:7306:TCP -n BLOCK -x >nul
echo 关闭木马NetMonitor 2.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/11223" -f *+0:11223:TCP -n BLOCK -x >nul
echo 关闭木马Progenic Trojan默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7307" -f *+0:7307:TCP -n BLOCK -x >nul
echo 关闭木马NetMonitor 3.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/22222" -f *+0:22222:TCP -n BLOCK -x >nul
echo 关闭木马Prosiak 0.47默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7308" -f *+0:7308:TCP -n BLOCK -x >nul
echo 关闭木马NetMonitor 4.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/53001" -f *+0:53001:TCP -n BLOCK -x >nul
echo 关闭木马Remote Windows Shutdown默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7789" -f *+0:7789:TCP -n BLOCK -x >nul
echo 关闭木马ICKiller默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5569" -f *+0:5569:TCP -n BLOCK -x >nul
echo 关闭木马RoboHack默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/9872" -f *+0:9872:TCP -n BLOCK -x >nul
echo 关闭木马Portal of Doom默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -x >nul

gpupdate >nul

echo 正在设置 IP 筛选器……
rem if exist %temp%\ipfilter.reg del %temp%\ipfilter.reg
echo Windows Registry Editor Version 5.00>%temp%\ipfilter.reg
echo.>>%temp%\ipfilter.reg
echo [HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Tcpip\Parameters]>>%temp%\ipfilter.reg
echo "EnableSecurityFilters"=dword:00000001>>%temp%\ipfilter.reg
echo.>>%temp%\ipfilter.reg>>%temp%\ipfilter.reg
echo [HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Tcpip\Parameters\Interfaces\{F3BBAABC-03A5-4584-A7A0-0251FA38B8B1}]>>%temp%\ipfilter.reg
echo "TCPAllowedPorts"=hex(07):32,00,31,00,00,00,38,00,30,00,00,00,34,00,30,00,30,\>>%temp%\ipfilter.reg
echo   00,30,00,00,00,00,00>>%temp%\ipfilter.reg
echo.>>%temp%\ipfilter.reg
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters]>>%temp%\ipfilter.reg
echo "EnableSecurityFilters"=dword:00000001>>%temp%\ipfilter.reg
echo.>>%temp%\ipfilter.reg
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\{F3BBAABC-03A5-4584-A7A0-0251FA38B8B1}]>>%temp%\ipfilter.reg
echo "TCPAllowedPorts"=hex(07):32,00,31,00,00,00,38,00,30,00,00,00,34,00,30,00,30,\>>%temp%\ipfilter.reg
echo   00,30,00,00,00,00,00>>%temp%\ipfilter.reg
echo.>>%temp%\ipfilter.reg
regedit /s %temp%\ipfilter.reg
del %temp%\ipfilter.reg
echo.
echo IP 筛选器设置成功！
rem For PC Server
ipseccmd -w REG -p "HFUT_SECU" -o -x
ipseccmd -w REG -p "HFUT_SECU" -x
rem ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/80" -f *+0:80:TCP -n BLOCK -x
rem ipseccmd -w REG -p "HFUT_SECU" -r "Block UDP/1434" -f *+0:1434:UDP -n BLOCK -x
rem ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/3389" -f *+0:3389:TCP -n BLOCK -x
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/445" -f *+0:445:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block UDP/445" -f *+0:445:UDP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/1025" -f *+0:1025:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block UDP/139" -f *+0:139:UDP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/1068" -f *+0:1068:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/5554" -f *+0:5554:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/9995" -f *+0:9995:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/9996" -f *+0:9996:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/6129" -f *+0:6129:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block ICMP/255" -f *+0:255:ICMP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/43958" -f *+0:43958:TCP -n BLOCK -x >nul
echo 关闭流行危险端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/20034" -f *+0:20034:TCP -n BLOCK -x >nul
echo 关闭木马NetBus Pro开放的端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/1092" -f *+0:1092:TCP -n BLOCK -x >nul
echo 关闭蠕虫LoveGate开放的端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/3996" -f *+0:3996:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/4060" -f *+0:4060:TCP -n BLOCK -x >nul
echo 关闭木马RemoteAnything开放的端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/4590" -f *+0:4590:TCP -n BLOCK -x >nul
echo 关闭木马ICQTrojan开放的端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/1080" -f *+0:1080:TCP -n BLOCK -x >nul
echo 禁止代理服务器扫描…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/113" -f *+0:113:TCP -n BLOCK -x >nul
echo 禁止Authentication Service服务…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/79" -f *+0:79:TCP -n BLOCK -x >nul
echo 禁止Finger扫描…………OK！
ipseccmd  -w REG -p "HFUT_SECU" -r "Block UDP/53" -f *+0:53:UDP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/53" -f *+0:53:TCP -n BLOCK -x >nul
echo 禁止区域传递（TCP），欺骗DNS（UDP）或隐藏其他的通信…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/707" -f *+0:707:TCP -n BLOCK -x >nul
echo 关闭nachi蠕虫病毒监听端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/808" -f *+0:808:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/23" -f *+0:23:TCP -n BLOCK -x >nul
echo 关闭Telnet 和木马Tiny Telnet Server监听端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/520" -f *+0:520:TCP -n BLOCK -x >nul
echo 关闭Rip 端口…………OK！
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/1999" -f *+0:1999:TCP -n BLOCK -x >nul
echo 关闭木马程序BackDoor的默认服务端口…………OK！
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/2001" -f *+0:2001:TCP -n BLOCK -x >nul
echo 关闭马程序黑洞2001的默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/2023" -f *+0:2023:TCP -n BLOCK -x >nul
echo 关闭木马程序Ripper的默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/2583" -f *+0:2583:TCP -n BLOCK -x >nul
echo 关闭木马程序Wincrash v2的默认服务端口…………OK！
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/3389" -f *+0:3389:TCP -n BLOCK -x >nul
echo 关闭Windows 的远程管理终端（远程桌面）监听端口…………OK！
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/4444" -f *+0:4444:TCP -n BLOCK -x >nul
echo 关闭msblast冲击波蠕虫监听端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/4899" -f *+0:4899:TCP -n BLOCK -x >nul
echo 关闭远程控制软件（remote administrator)服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/5800" -f *+0:5800:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/5900" -f *+0:5900:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/8888" -f *+0:8888:TCP -n BLOCK -x >nul
echo 关闭远程控制软件VNC的两个默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/6129" -f *+0:6129:TCP -n BLOCK -x >nul
echo 关闭Dameware服务端默认监听端口（可变！）…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/6267" -f *+0:6267:TCP -n BLOCK -x >nul
echo 关闭木马广外女生的默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/660" -f *+0:660:TCP -n BLOCK -x >nul
echo 关闭木马DeepThroat v1.0 - 3.1默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/6671" -f *+0:6671:TCP -n BLOCK -x >nul
echo 关闭木马Indoctrination默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/6939" -f *+0:6939:TCP -n BLOCK -x >nul
echo 关闭木马PRIORITY默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/7306" -f *+0:7306:TCP -n BLOCK -x >nul
echo 关闭木马网络精灵默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/7511" -f *+0:7511:TCP -n BLOCK -x >nul
echo 关闭木马聪明基因的默认连接端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/7626" -f *+0:7626:TCP -n BLOCK -x >nul
echo 关闭木马冰河默认端口(注意可变！)…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/8011" -f *+0:8011:TCP -n BLOCK -x >nul
echo 关闭木马WAY2.4默认服务端口…………OK！
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/9989" -f *+0:9989:TCP -n BLOCK -x >nul
echo 关闭木马InIkiller默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/19191" -f *+0:19191:TCP -n BLOCK -x >nul
echo 关闭木马兰色火焰默认开放的telnet端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/1029" -f *+0:1029:TCP -n BLOCK -x >nul
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/20168" -f *+0:20168:TCP -n BLOCK -x >nul
echo 关闭lovegate 蠕虫所开放的两个后门端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/23444" -f *+0:23444:TCP -n BLOCK -x >nul
echo 关闭木马网络公牛默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/27374" -f *+0:27374:TCP -n BLOCK -x >nul
echo 关闭木马SUB7默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/30100" -f *+0:30100:TCP -n BLOCK -x >nul
echo 关闭木马NetSphere默认的服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/31337" -f *+0:31337:TCP -n BLOCK -x >nul
echo 关闭木马BO2000默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/45576" -f *+0:45576:TCP -n BLOCK -x >nul
echo 关闭代理软件的控制端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/50766" -f *+0:50766:TCP -n BLOCK -x >nul
echo 关闭木马Schwindler默认服务端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/61466" -f *+0:61466:TCP -n BLOCK -x >nul
echo 关闭木马Telecommando默认服务端口…………OK!

ipseccmd  -w REG -p "HFUT_SECU" -r "Block TCP/31338" -f *+0:31338:TCP -n BLOCK -x >nul
echo 关闭木马Back Orifice默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/8102" -f *+0:8102:TCP -n BLOCK -x >nul
echo 关闭木马网络神偷默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2000" -f *+0:2000:TCP -n BLOCK -x >nul
echo 关闭木马黑洞2000默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/31339" -f *+0:31339:TCP -n BLOCK -x >nul
echo 关闭木马NetSpy DK默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2001" -f *+0:2001:TCP -n BLOCK -x >nul
echo 关闭木马黑洞2001默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/31666" -f *+0:31666:TCP -n BLOCK -x >nul
echo 关闭木马BOWhack默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/34324" -f *+0:34324:TCP -n BLOCK -x >nul
echo 关闭木马BigGluck默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7306" -f *+0:7306:TCP -n BLOCK -x >nul
echo 关闭木马网络精灵3.0，netspy3.0默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/40412" -f *+0:40412:TCP -n BLOCK -x >nul
echo 关闭木马The Spy默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/40421" -f *+0:40421:TCP -n BLOCK -x >nul
echo 关闭木马Masters Paradise默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/8011" -f *+0:8011:TCP -n BLOCK -x >nul
echo 关闭木马wry，赖小子，火凤凰默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/40422" -f *+0:40422:TCP -n BLOCK -x >nul
echo 关闭木马Masters Paradise 1.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/23444" -f *+0:23444:TCP -n BLOCK -x >nul
echo 关闭木马网络公牛，netbull默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/40423" -f *+0:40423:TCP -n BLOCK -x >nul
echo 关闭木马Masters Paradise 2.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/23445" -f *+0:23445:TCP -n BLOCK -x >nul
echo 关闭木马网络公牛，netbull默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/40426" -f *+0:40426:TCP -n BLOCK -x >nul
echo 关闭木马Masters Paradise 3.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/50505" -f *+0:50505:TCP -n BLOCK -x >nul
echo 关闭木马Sockets de Troie默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/27374" -f *+0:27374:TCP -n BLOCK -x >nul
echo 关闭木马Sub Seven 2.0+，77，东方魔眼默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/50766" -f *+0:50766:TCP -n BLOCK -x >nul
echo 关闭木马Fore默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/53001" -f *+0:53001:TCP -n BLOCK -x >nul
echo 关闭木马Remote Windows Shutdown默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/61466" -f *+0:61466:TCP -n BLOCK -x >nul
echo 关闭木马Telecommando默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/121" -f *+0:121:TCP -n BLOCK -x >nul
echo 关闭木马BO jammerkillahV默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/666" -f *+0:666:TCP -n BLOCK -x >nul
echo 关闭木马Satanz Backdoor默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/65000" -f *+0:65000:TCP -n BLOCK -x >nul
echo 关闭木马Devil默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1001" -f *+0:1001:TCP -n BLOCK -x >nul
echo 关闭木马Silencer默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/6400" -f *+0:6400:TCP -n BLOCK -x >nul
echo 关闭木马The tHing默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1600" -f *+0:1600:TCP -n BLOCK -x >nul
echo 关闭木马Shivka-Burka默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/12346" -f *+0:12346:TCP -n BLOCK -x >nul
echo 关闭木马NetBus 1.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1807" -f *+0:1807:TCP -n BLOCK -x >nul
echo 关闭木马SpySender默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/20034" -f *+0:20034:TCP -n BLOCK -x >nul
echo 关闭木马NetBus Pro默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1981" -f *+0:1981:TCP -n BLOCK -x >nul
echo 关闭木马Shockrave默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1243" -f *+0:1243:TCP -n BLOCK -x >nul
echo 关闭木马SubSeven默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1001" -f *+0:1001:TCP -n BLOCK -x >nul
echo 关闭木马WebEx默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/30100" -f *+0:30100:TCP -n BLOCK -x >nul
echo 关闭木马NetSphere默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1011" -f *+0:1011:TCP -n BLOCK -x >nul
echo 关闭木马Doly Trojan默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1001" -f *+0:1001:TCP -n BLOCK -x >nul
echo 关闭木马Silencer默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1170" -f *+0:1170:TCP -n BLOCK -x >nul
echo 关闭木马Psyber Stream Server默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/20000" -f *+0:20000:TCP -n BLOCK -x >nul
echo 关闭木马Millenium默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1234" -f *+0:1234:TCP -n BLOCK -x >nul
echo 关闭木马Ultors Trojan默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/65000" -f *+0:65000:TCP -n BLOCK -x >nul
echo 关闭木马Devil 1.03默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1245" -f *+0:1245:TCP -n BLOCK -x >nul
echo 关闭木马VooDoo Doll默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7306" -f *+0:7306:TCP -n BLOCK -x >nul
echo 关闭木马NetMonitor默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1492" -f *+0:1492:TCP -n BLOCK -x >nul
echo 关闭木马FTP99CMP默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1170" -f *+0:1170:TCP -n BLOCK -x >nul
echo 关闭木马Streaming Audio Trojan默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1999" -f *+0:1999:TCP -n BLOCK -x >nul
echo 关闭木马BackDoor默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/30303" -f *+0:30303:TCP -n BLOCK -x >nul
echo 关闭木马Socket23默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2001" -f *+0:2001:TCP -n BLOCK -x >nul
echo 关闭木马Trojan Cow默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/6969" -f *+0:6969:TCP -n BLOCK -x >nul
echo 关闭木马Gatecrasher默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2023" -f *+0:2023:TCP -n BLOCK -x >nul
echo 关闭木马Ripper默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/61466" -f *+0:61466:TCP -n BLOCK -x >nul
echo 关闭木马Telecommando默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2115" -f *+0:2115:TCP -n BLOCK -x >nul
echo 关闭木马Bugs默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/12076" -f *+0:12076:TCP -n BLOCK -x >nul
echo 关闭木马Gjamer默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2140" -f *+0:2140:TCP -n BLOCK -x >nul
echo 关闭木马Deep Throat默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/4950" -f *+0:4950:TCP -n BLOCK -x >nul
echo 关闭木马IcqTrojen默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2140" -f *+0:2140:TCP -n BLOCK -x >nul
echo 关闭木马The Invasor默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/16969" -f *+0:16969:TCP -n BLOCK -x >nul
echo 关闭木马Priotrity默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2801" -f *+0:2801:TCP -n BLOCK -x >nul
echo 关闭木马Phineas Phucker默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1245" -f *+0:1245:TCP -n BLOCK -x >nul
echo 关闭木马Vodoo默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/30129" -f *+0:30129:TCP -n BLOCK -x >nul
echo 关闭木马Masters Paradise默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5742" -f *+0:5742:TCP -n BLOCK -x >nul
echo 关闭木马Wincrash默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/3700" -f *+0:3700:TCP -n BLOCK -x >nul
echo 关闭木马Portal of Doom默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2583" -f *+0:2583:TCP -n BLOCK -x >nul
echo 关闭木马Wincrash2默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/4092" -f *+0:4092:TCP -n BLOCK -x >nul
echo 关闭木马WinCrash默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1033" -f *+0:1033:TCP -n BLOCK -x >nul
echo 关闭木马Netspy默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/4590" -f *+0:4590:TCP -n BLOCK -x >nul
echo 关闭木马ICQTrojan默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1981" -f *+0:1981:TCP -n BLOCK -x >nul
echo 关闭木马ShockRave默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5000" -f *+0:5000:TCP -n BLOCK -x >nul
echo 关闭木马Sockets de Troie默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/555" -f *+0:555:TCP -n BLOCK -x >nul
echo 关闭木马Stealth Spy默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5001" -f *+0:5001:TCP -n BLOCK -x >nul
echo 关闭木马Sockets de Troie 1.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2023" -f *+0:2023:TCP -n BLOCK -x >nul
echo 关闭木马Pass Ripper默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5321" -f *+0:5321:TCP -n BLOCK -x >nul
echo 关闭木马Firehotcker默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/666" -f *+0:666:TCP -n BLOCK -x >nul
echo 关闭木马Attack FTP默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5400" -f *+0:5400:TCP -n BLOCK -x >nul
echo 关闭木马Blade Runner默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/21554" -f *+0:21554:TCP -n BLOCK -x >nul
echo 关闭木马GirlFriend默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5401" -f *+0:5401:TCP -n BLOCK -x >nul
echo 关闭木马Blade Runner 1.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/50766" -f *+0:50766:TCP -n BLOCK -x >nul
echo 关闭木马Fore Schwindler默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5402" -f *+0:5402:TCP -n BLOCK -x >nul
echo 关闭木马Blade Runner 2.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/34324" -f *+0:34324:TCP -n BLOCK -x >nul
echo 关闭木马Tiny Telnet Server默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5569" -f *+0:5569:TCP -n BLOCK -x >nul
echo 关闭木马Robo-Hack默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/30999" -f *+0:30999:TCP -n BLOCK -x >nul
echo 关闭木马Kuang默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/6670" -f *+0:6670:TCP -n BLOCK -x >nul
echo 关闭木马DeepThroat默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/11000" -f *+0:11000:TCP -n BLOCK -x >nul
echo 关闭木马Senna Spy Trojans默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/6771" -f *+0:6771:TCP -n BLOCK -x >nul
echo 关闭木马DeepThroat默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/23456" -f *+0:23456:TCP -n BLOCK -x >nul
echo 关闭木马WhackJob默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/6969" -f *+0:6969:TCP -n BLOCK -x >nul
echo 关闭木马GateCrasher默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/555" -f *+0:555:TCP -n BLOCK -x >nul
echo 关闭木马Phase0默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/6969" -f *+0:6969:TCP -n BLOCK -x >nul
echo 关闭木马Priority默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5400" -f *+0:5400:TCP -n BLOCK -x >nul
echo 关闭木马Blade Runner默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7000" -f *+0:7000:TCP -n BLOCK -x >nul
echo 关闭木马Remote Grab默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/4950" -f *+0:4950:TCP -n BLOCK -x >nul
echo 关闭木马IcqTrojan默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7300" -f *+0:7300:TCP -n BLOCK -x >nul
echo 关闭木马NetMonitor默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/9989" -f *+0:9989:TCP -n BLOCK -x >nul
echo 关闭木马InIkiller默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7301" -f *+0:7301:TCP -n BLOCK -x >nul
echo 关闭木马NetMonitor 1.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/9872" -f *+0:9872:TCP -n BLOCK -x >nul
echo 关闭木马Portal Of Doom默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7306" -f *+0:7306:TCP -n BLOCK -x >nul
echo 关闭木马NetMonitor 2.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/11223" -f *+0:11223:TCP -n BLOCK -x >nul
echo 关闭木马Progenic Trojan默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7307" -f *+0:7307:TCP -n BLOCK -x >nul
echo 关闭木马NetMonitor 3.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1999" -f *+0:1999:TCP -n BLOCK -x >nul
echo 关闭木马BackDoor默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5800" -f *+0:5800:TCP -n BLOCK -x >nul
echo 关闭远程控制软件VNC默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5900" -f *+0:5900:TCP -n BLOCK -x >nul
echo 关闭远程控制软件VNC默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/22222" -f *+0:22222:TCP -n BLOCK -x >nul
echo 关闭木马Prosiak 0.47默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7626" -f *+0:7626:TCP -n BLOCK -x >nul
echo 关闭木马冰河默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/4444" -f *+0:4444:TCP -n BLOCK -x >nul
echo 关闭木马msblast默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7308" -f *+0:7308:TCP -n BLOCK -x >nul
echo 关闭木马NetMonitor 4.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/6129" -f *+0:6129:TCP -n BLOCK -x >nul
echo 关闭远程控制软件（dameware nt utilities)默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2023" -f *+0:2023:TCP -n BLOCK -x >nul
echo 关闭木马Ripper默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1245" -f *+0:1245:TCP -n BLOCK -x >nul
echo 关闭木马VooDoo Doll默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/121" -f *+0:121:TCP -n BLOCK -x >nul
echo 关闭木马BO jammerkillahV默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/456" -f *+0:456:TCP -n BLOCK -x >nul
echo 关闭木马Hackers Paradise默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/555" -f *+0:555:TCP -n BLOCK -x >nul
echo 关闭木马Stealth Spy默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/666" -f *+0:666:TCP -n BLOCK -x >nul
echo 关闭木马Satanz Backdoor默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1001" -f *+0:1001:TCP -n BLOCK -x >nul
echo 关闭木马Silencer默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/1033" -f *+0:1033:TCP -n BLOCK -x >nul
echo 关闭木马Netspy默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7000" -f *+0:7000:TCP -n BLOCK -x >nul
echo 关闭木马Remote Grab默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7300 " -f *+0:7300:TCP -n BLOCK -x >nul
echo 关闭木马NetMonitor默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/23456 " -f *+0:23456:TCP -n BLOCK -x >nul
echo 关闭木马Ugly FTP默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/23456 " -f *+0:23456:TCP -n BLOCK -x >nul
echo 关闭木马Ugly FTP默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/30100 " -f *+0:30100:TCP -n BLOCK -x >nul
echo 关闭木马NetSphere默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/9872" -f *+0:9872:TCP -n BLOCK -x >nul
echo 关闭木马Portal of Doom默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/9899" -f *+0:9899:TCP -n BLOCK -x >nul
echo 关闭木马iNi-Killer默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/50505" -f *+0:50505:TCP -n BLOCK -x >nul
echo 关闭木马Sockets de Troie默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/6939" -f *+0:6939:TCP -n BLOCK -x >nul
echo 关闭木马Indoctrination默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/11000" -f *+0:11000:TCP -n BLOCK -x >nul
echo 关闭木马Senna Spy默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/12223" -f *+0:12223:TCP -n BLOCK -x >nul
echo 关闭木马Hack?99 KeyLogger默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/12362" -f *+0:12362:TCP -n BLOCK -x >nul
echo 关闭木马Whack-a-mole 1.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/20000" -f *+0:20000:TCP -n BLOCK -x >nul
echo 关闭木马Millenium默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2583" -f *+0:2583:TCP -n BLOCK -x >nul
echo 关闭木马Wincrash v2默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/53001" -f *+0:53001:TCP -n BLOCK -x >nul
echo 关闭木马Remote Windows Shutdown默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/7789" -f *+0:7789:TCP -n BLOCK -x >nul
echo 关闭木马ICKiller默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/40426" -f *+0:40426:TCP -n BLOCK -x >nul
echo 关闭木马Masters Paradise 3.x默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/5569" -f *+0:5569:TCP -n BLOCK -x >nul
echo 关闭木马RoboHack默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/8000" -f *+0:8000:TCP -n BLOCK -x >nul
echo 关闭木马huigezi默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/9872" -f *+0:9872:TCP -n BLOCK -x >nul
echo 关闭木马Portal of Doom默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2005" -f *+0:2005:TCP -n BLOCK -x >nul
echo 关闭木马黑洞2005默认服务端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/2000" -f *+0:2000:TCP -n BLOCK -x >nul
echo 关闭彩虹桥1.2默认端口…………OK!
ipseccmd -w REG -p "HFUT_SECU" -r "Block TCP/9999" -f *+0:9999:TCP -n BLOCK -x >nul
echo 关闭huigezi映射默认端口…………OK!
ipseccmd  -w REG -p "HFUT_SECU" -x >nul
gpupdate >nul
echo      
echo      
echo.
echo   封杀有害端口结束,按任意键返回!
pause >nul
goto setsave

@echo off
:virus
color 0a
cls
echo.
echo                    
echo.             
echo.
echo    
echo              请选择要进行的操作，然后按回车
echo                杀毒完成后最好重新启动!!!
echo    
echo.
echo.
echo              1.fun.xls专杀
echo.
echo              2.Auto病毒专杀
echo.
echo              3.U盘病毒专杀
echo.
echo              4.sxs svohost专杀
echo. 
echo              5.COPY.exe专杀
echo. 
echo              6.威金病毒专杀
echo. 
echo              7.熊猫烧香专杀
echo. 
echo              8.返回主菜单
echo.
echo              q.退出
echo.


:Choice4
set choice4=
set /p choice4=          请选择:
IF NOT "%Choice4%"=="" SET Choice3=%Choice3:~0,1%
if /i "%choice4%"=="1" goto killfun
if /i "%choice4%"=="2" goto killAuto
if /i "%choice4%"=="3" goto killUDisk
if /i "%choice4%"=="4" goto killsxs
if /i "%choice4%"=="5" goto killCOPY
if /i "%choice4%"=="6" goto killVking
if /i "%choice4%"=="7" goto killwhboy
if /i "%choice4%"=="8" goto menu
if /i "%choice4%"=="q" goto endd
echo 选择无效，请重新输入
echo.
goto Choice4

:killfun
@echo off
cls
title Fun.xls.exe专杀工具
echo 
echo -----------------------------------------
echo 如果你的光驱中有光盘请先弹出然后继续！
:n
echo 您要继续吗？输入y整机杀毒开始，输入u只杀u盘，输入n退出！
:retry
set /p c=请输入您的选择（y/u/n）：
if "%c%"=="y" goto s
if "%c%"=="u" goto b
if "%c%"=="n" goto t
goto retry
:b
set /p a=请输入你要查杀的盘符(e f g...):
if "%a%"=="e" goto e
if "%a%"=="f" goto f
if "%a%"=="g" goto g
if "%a%"=="h" goto h
if "%a%"=="i" goto i
if "%a%"=="j" goto j
if "%a%"=="k" goto k
if "%a%"=="l" goto l
echo 输入错误!请重新输入!&&goto b
:s
taskkill /im explorer.exe /f
taskkill /im wscript.exe /f
taskkill /im algsrvs.exe /f
start reg DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v IMJPMIG8.2 /f
start reg DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v MsServer /f
start reg DELETE HKEY_LOCAL_MACHINE\Software\Microsoft\windows\CurrentVersion\explorer\Advanced\Folder\Hidden\SHOWALL /v CheckedValue /f
start reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\EXplorer\Advanced /v ShowSuperHidden /t REG_DWORD /d 1 /f
start reg add HKEY_LOCAL_MACHINE\Software\Microsoft\windows\CurrentVersion\explorer\Advanced\Folder\Hidden\SHOWALL /v CheckedValue /t REG_DWORD /d 1 /f
start reg import kill.reg
attrib c:\fun.xls.exe -h -r -a -s
attrib c:\autorun.* -h -r -a -s
del c:\autorun.* c:fun.xls.exe /f
attrib %SYSTEMROOT%\system32\fun.xls.exe -h -r -a -s
attrib %SYSTEMROOT%\system32\autorun.* -h -r -a -s
del %SYSTEMROOT%\system32\autorun.* %SYSTEMROOT%\system32\msime82.exe %SYSTEMROOT%\system32\algsrvs.exe %SYSTEMROOT%\system32\fun.xls.exe %SYSTEMROOT%\system32\msfun80.exe /f
del %temp%\~DF8785.tmp %temp%\~DFD1D6.tmp %temp%\~DFA4C3 %temp%\~DFC86B.tmp /f /q /as
del %systemroot%\ufdata2000.log /f
attrib d:\fun.xls.exe -h -r -a -s
attrib d:\autorun.* -h -r -a -s
del d:\autorun.* d:\fun.xls.exe /f
attrib e:\fun.xls.exe -h -r -a -s
attrib e:\autorun.* -h -r -a -s
del e:\autorun.* e:\fun.xls.exe /f
attrib f:\fun.xls.exe -h -r -a -s
attrib f:\autorun.* -h -r -a -s
del f:\autorun.* f:\fun.xls.exe /f
attrib g:\fun.xls.exe -h -r -a -s
attrib g:\autorun.* -h -r -a -s
del g:\autorun.* g:\fun.xls.exe /f
attrib h:\fun.xls.exe -h -r -a -s
attrib h:\autorun.* -h -r -a -s
del h:\autorun.* h:\fun.xls.exe /f
attrib i:\fun.xls.exe -h -r -a -s
attrib i:\autorun.* -h -r -a -s
del i:\autorun.* i:\fun.xls.exe /f
attrib j:\fun.xls.exe -h -r -a -s
attrib j:\autorun.* -h -r -a -s
del j:\autorun.* j:\fun.xls.exe /f
attrib k:\fun.xls.exe -h -r -a -s
attrib k:\autorun.* -h -r -a -s
del k:\autorun.* k:\fun.xls.exe /f
attrib l:\fun.xls.exe -h -r -a -s
attrib l:\autorun.* -h -r -a -s
del l:\autorun.* l:\fun.xls.exe /f
start explorer.exe
cls
if exist c:\autorun.reg echo 病毒没有清除！&&goto n
if exist c:\fun.xls.exe echo 病毒没有清除！&&goto n
echo.
echo 杀毒成功！
echo.
echo  按任意键退出。
pause
exit
:t
echo 多谢您的支持！按任意键返回。
pause >nul
goto menu
:e
attrib e:\fun.xls.exe -h -r -a -s
attrib e:\autorun.* -h -r -a -s
cls
if not exist e:\autorun.* echo 您的u盘没有病毒！&&goto t
del e:\autorun.* e:\fun.xls.exe /f
cls
if exist e:\autorun.reg echo 病毒没有清除！&&goto n
if exist e:\fun.xls.exe echo 病毒没有清除！&&goto n
goto m
:f
attrib f:\fun.xls.exe -h -r -a -s
attrib f:\autorun.* -h -r -a -s
cls
if not exist f:\autorun.* echo 您的u盘没有病毒！&&goto t
del f:\autorun.* f:\fun.xls.exe /f
cls
if exist f:\autorun.reg echo 病毒没有清除！&&goto n
if exist f:\fun.xls.exe echo 病毒没有清除！&&goto n
goto m
:h
attrib h:\fun.xls.exe -h -r -a -s
attrib h:\autorun.* -h -r -a -s
cls
if not exist h:\autorun.* echo 您的u盘没有病毒！&&goto t
del h:\autorun.* h:\fun.xls.exe /f
cls
if exist h:\autorun.reg echo 病毒没有清除！&&goto n
if exist h:\fun.xls.exe echo 病毒没有清除！&&goto n
goto m
:i
attrib i:\fun.xls.exe -h -r -a -s
attrib i:\autorun.* -h -r -a -s
cls
if not exist i:\autorun.* echo 您的u盘没有病毒！&&goto t
del i:\autorun.* i:\fun.xls.exe /f
cls
if exist i:\autorun.reg echo 病毒没有清除！&&goto n
if exist i:\fun.xls.exe echo 病毒没有清除！&&goto n
goto m
:j
attrib j:\fun.xls.exe -h -r -a -s
attrib j:\autorun.* -h -r -a -s
cls
if not exist j:\autorun.* echo 您的u盘没有病毒！&&goto t
del j:\autorun.* j:\fun.xls.exe /f
cls
if exist j:\autorun.reg echo 病毒没有清除！&&goto n
if exist j:\fun.xls.exe echo 病毒没有清除！&&goto n
goto m
:k
attrib k:\fun.xls.exe -h -r -a -s
attrib k:\autorun.* -h -r -a -s
cls
if not exist k:\autorun.* echo 您的u盘没有病毒！&&goto t
del k:\autorun.* k:\fun.xls.exe /f
cls
if exist k:\autorun.reg echo 病毒没有清除！&&goto n
if exist k:\fun.xls.exe echo 病毒没有清除！&&goto n
goto m
:l
attrib l:\fun.xls.exe -h -r -a -s
attrib l:\autorun.* -h -r -a -s
cls
if not exist l:\autorun.* echo 您的u盘没有病毒！&&goto t
del l:\autorun.* l:\fun.xls.exe /f
cls
if exist l:\autorun.reg echo 病毒没有清除！&&goto n
if exist l:\fun.xls.exe echo 病毒没有清除！&&goto n
goto m
:m
cls
echo 杀毒成功，请按任意键返回!
echo.
echo       欢迎光临http://9thclub.cn
echo.

echo.
pause >nul
goto virus

:killAuto
@echo off
@echo Please wait while deleting the autoRun.inf files ....
FOR %%a IN ( C: D: E: F: G: H: I: J: K: L: M: N: O: P: Q: R: S: T: U: V: W: X: Y: Z: ) DO  ATTRIB -R -H -S -A %%a\AUTORUN.INF & DEL /F /Q /A -R -H -S -A %%a\AUTORUN.INF
cls
echo.
goto m
pause >nul
goto virus

:killUDisk
@echo +-------------------------------------+
@echo + 查杀sxs.exe、autorun.inf等等U盘病毒I+
@echo +-------------------------------------+
@echo !请先关闭所有程序!
@Pause
@echo off
@taskkill /F /im svchost.exe
@taskkill /F /im rundll32.exe
@taskkill /F /im explorer.exe
shutdown -a
attrib -h -r -s %windir%\system32\temp1.exe
attrib -h -r -s %windir%\system32\temp2.exe
attrib -h -r -s %windir%\xcopy.exe
attrib -h -r -s %windir%\svchost.exe
del /Q/F %windir%\system32\temp1.exe
del /Q/F %windir%\system32\temp2.exe
del /Q/F %windir%\xcopy.exe
del /Q/F %windir%\svchost.exe
@FOR /F "usebackq delims==" %%i IN (DefVrs.txt) DO @taskkill /F /im %%i
setlocal
set drives=C: D: E: F: G: H: I: J: K: L: M: N: O: P: Q: R: S: T: U: V: W: X: Y: Z:
for %%d in (%drives%) do @if exist %%d (
@FOR /F "usebackq delims==" %%i IN (DefVrs.txt) DO @attrib -h -r -s %%d\%%i
@FOR /F "usebackq delims==" %%i IN (DefVrs.txt) DO @del /Q/F %%d\%%i
)
cd
c:
attrib sxs.exe -a -h -s 
del /s /q /f sxs.exe
attrib autorun.inf -a -h -s
del /s /q /f autorun.inf
D:
attrib sxs.exe -a -h -s
del /s /q /f sxs.exe
attrib autorun.inf -a -h -s
del /s /q /f autorun.inf
E:
attrib sxs.exe -a -h -s
del /s /q /f sxs.exe
attrib autorun.inf -a -h -s
del /s /q /f autorun.inf
F:
attrib sxs.exe -a -h -s
del /s /q /f sxs.exe
attrib autorun.inf -a -h -s
del /s /q /f autorun.inf
G:
attrib sxs.exe -a -h -s
del /s /q /f sxs.exe 
attrib autorun.inf -a -h -s
del /s /q /f autorun.inf
H:
attrib sxs.exe -a -h -s 
del /s /q /f sxs.exe
attrib autorun.inf -a -h -s
del /s /q /f autorun.inf
I:
attrib sxs.exe -a -h -s 
del /s /q /f sxs.exe
attrib autorun.inf -a -h -s
del /s /q /f autorun.inf
REG DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /va /f
cls
@echo.
goto m
pause >nul
goto virus


:killsxs
*************************************************************************
 停止正在运行的SXS.EXE和SVOHOST.EXE进程                               *
*************************************************************************
TASKKILL /F /T /IM SXS.EXE
TASKKILL /F /T /IM SVOHOST.EXE 


**************************************************************************
 *删除系统目录下的SXS.EXE、SVOHOST.EXE和WINSCOK.DLL文件                *
**************************************************************************
ATTRIB -R -H -S -A %SystemRoot%\System32\SXS.EXE
ATTRIB -R -H -S -A %SystemRoot%\System32\SVOHOST.EXE
ATTRIB -R -H -S -A %SystemRoot%\System32\WINSCOK.DLL
DEL /F /Q /A -R -H -S -A %SystemRoot%\System32\SXS.EXE
DEL /F /Q /A -R -H -S -A %SystemRoot%\System32\SVOHOST.EXE
DEL /F /Q /A -R -H -S -A %SystemRoot%\System32\WINSCOK.DLL

ATTRIB -R -H -S -A %SystemRoot%\SXS.EXE
ATTRIB -R -H -S -A %SystemRoot%\SVOHOST.EXE
ATTRIB -R -H -S -A %SystemRoot%\WINSCOK.DLL
DEL /F /Q /A -R -H -S -A %SystemRoot%\SXS.EXE
DEL /F /Q /A -R -H -S -A %SystemRoot%\SVOHOST.EXE
DEL /F /Q /A -R -H -S -A %SystemRoot%\WINSCOK.DLL

ATTRIB -R -H -S -A %SystemRoot%\System\SXS.EXE
ATTRIB -R -H -S -A %SystemRoot%\System\SVOHOST.EXE
ATTRIB -R -H -S -A %SystemRoot%\System\WINSCOK.DLL
DEL /F /Q /A -R -H -S -A %SystemRoot%\System\SXS.EXE
DEL /F /Q /A -R -H -S -A %SystemRoot%\System\SVOHOST.EXE
DEL /F /Q /A -R -H -S -A %SystemRoot%\System\WINSCOK.DLL

ATTRIB -R -H -S -A %SystemRoot%\System32\dllcache\SXS.EXE
ATTRIB -R -H -S -A %SystemRoot%\System32\dllcache\SVOHOST.EXE
ATTRIB -R -H -S -A %SystemRoot%\System32\dllcache\WINSCOK.DLL
DEL /F /Q /A -R -H -S -A %SystemRoot%\System32\dllcache\SXS.EXE
DEL /F /Q /A -R -H -S -A %SystemRoot%\System32\dllcache\SVOHOST.EXE
DEL /F /Q /A -R -H -S -A %SystemRoot%\System32\dllcache\WINSCOK.DLL


#########################################################################
##            删除每个分区下的SXS.EXE和AUTORUN.INF文件                 ##
#########################################################################
FOR %%a IN ( C: D: E: F: G: H: I: J: K: L: M: N: O: P: Q: R: S: T: U: V: W: X: Y: Z: ) DO ATTRIB -R -H -S -A %%a\SXS.EXE & DEL /F /Q /A -R -H -S -A %%a\SXS.EXE & ATTRIB -R -H -S -A %%a\AUTORUN.INF & DEL /F /Q /A -R -H -S -A %%a\AUTORUN.INF


#########################################################################
##               删除注册表中自启动项                                  ##
#########################################################################
ECHO Windows Registry Editor Version 5.00>SoundMam.reg

ECHO [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\SoundMam]>>SoundMam.reg

ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]>>SoundMam.reg
ECHO "SoundMam"=->>SoundMam.reg

REGEDIT /S SoundMam.reg

DEL /F /Q SoundMam.reg


#########################################################################
##        恢复注册表中不给设置显示隐藏文件的项目                       ##
#########################################################################
ECHO Windows Registry Editor Version 5.00>SHOWALL.reg

ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\SHOWALL]>>SHOWALL.reg
ECHO "CheckedValue"=->>SHOWALL.reg

ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\SHOWALL]>>SHOWALL.reg
ECHO "CheckedValue"=dword:00000001>>SHOWALL.reg

REGEDIT /S SHOWALL.reg

DEL /F /Q SHOWALL.reg
cls
echo.
goto m
echo.
pause >nul
goto virus

:killCOPY

@echo off  
cls
c:  
cd \  
attrib -s -h -r copy.exe  
del copy.exe /F  
attrib -s -h -r *.inf  
del autorun.inf /F  
d:  
cd \  
attrib -s -h -r copy.exe  
del copy.exe /F  
attrib -s -h -r *.inf  
del autorun.inf /F  
f:  
cd \  
attrib -s -h -r copy.exe  
del copy.exe /F  
attrib -s -h -r *.inf  
del autorun.inf /F  
e:  
cd \  
attrib -s -h -r copy.exe  
del copy.exe /F  
attrib -s -h -r *.inf  
del autorun.inf /F  
g:  
cd \  
attrib -s -h -r copy.exe  
del copy.exe /F  
attrib -s -h -r *.inf  
del autorun.inf /F  
h:  
cd \  
attrib -s -h -r copy.exe  
del copy.exe /F  
attrib -s -h -r *.inf  
del autorun.inf /F 
cls
echo.
@echo 修复完成。按任意键继续……请手动重启计算机!!
echo.
echo.
goto m
echo.
pause >nul
goto virus 
  
:killVking 
@ECHO OFF
cls
del c:\winnt\logo1_.exe           
del c:\windows\logo1_.exe         
del c:\winnt\0sy.exe
del c:\windows\0sy.exe
del c:\winnt\1sy.exe
del c:\windows\1sy.exe
del c:\winnt\2sy.exe
del c:\windows\2sy.exe
del c:\winnt\3sy.exe
del c:\windows\3sy.exe
del c:\winnt\4sy.exe
del c:\windows\4sy.exe
del c:\winnt\rundl132.exe
del c:\windows\rundl132.exe
net share c$ /d                  
net share d$ /d
net share e$ /d
net share F$ /d
net share G$ /d
net share h$ /d
net share i$ /d
net share j$ /d
net share admin$ /d
net share ipc$ /d
del c:\winnt\logo1_.exe       
del c:\windows\logo1_.exe
del c:\windows\vdll.dll
del c:\winnt\vdll.dll
del c:\winnt\kill.exe
del c:\windows\kil.exe
del c:\winnt\sws32.dll
del c:\windows\sws32.dll
del c:\winnt\rundl132.exe
del c:\windows\rundl132.exe
echo.
echo.
echo.
echo.                 *****************************
echo.
echo.                  正在查毒...请不要关闭......
echo.
echo.                 *****************************
echo.
echo.
echo.
echo.
ping 127.0.0.1 -n 5          
del c:\winnt\logo1_.exe         
del c:\windows\logo1_.exe
del c:\windows\vdll.dll
del c:\winnt\vdll.dll
del c:\winnt\kill.exe
del c:\windows\kil.exe
del c:\winnt\sws32.dll
del c:\windows\sws32.dll
del c:\winnt\rundl132.exe
del c:\windows\rundl132.exe
echo.
echo.
echo.
echo.                 *****************************
echo.
echo.                  正在查毒...请不要关闭......
echo.
echo.                 *****************************
echo.
echo.
echo.
echo.
ping 127.0.0.1 -n 5            
del c:\winnt\logo1_.exe                   
del c:\windows\logo1_.exe
del c:\windows\vdll.dll
del c:\winnt\vdll.dll
del c:\winnt\kill.exe
del c:\windows\kil.exe
del c:\winnt\sws32.dll
del c:\windows\sws32.dll
del c:\windows\0sy.exe
del c:\winnt\1sy.exe
del c:\windows\1sy.exe
del c:\winnt\2sy.exe
del c:\windows\2sy.exe
del c:\winnt\3sy.exe
del c:\windows\3sy.exe
del c:\winnt\4sy.exe
del c:\windows\4sy.exe
del c:\winnt\rundl132.exe
del c:\windows\rundl132.exe
del C:\winnt\Logo1_.exe
del C:\winnt\rundl132.exe
del C:\winnt\bootconf.exe
del C:\winnt\kill.exe
del C:\winnt\sws32.dll
del C:\winnt\dll.dll
del C:\winnt\vdll.dll
del C:\winnt\system32\ShellExt\svchs0t.exe 

del C:\Program Files\Internet Explorer\0SY.exe 
del C:\Program Files\Internet Explorer\1SY.exe 
del C:\Program Files\Internet Explorer\2sy.exe 
del C:\Program Files\Internet Explorer\3sy.exe 
del C:\Program Files\Internet Explorer\4sy.exe 
del C:\Program Files\Internet Explorer\5sy.exe 
del C:\Program Files\Internet Explorer\6SY.exe 
del C:\Program Files\Internet Explorer\7sy.exe 
del C:\Program Files\Internet Explorer\8sy.exe 
del C:\Program Files\Internet Explorer\9sy.exe 


del C:\winnt\system32\Logo1_.exe
del C:\winnt\system32\rundl132.exe
del C:\winnt\system32\bootconf.exe
del C:\winnt\system32\kill.exe
del C:\winnt\system32\sws32.dll

del C:\windows\Logo1_.exe
del C:\windows\rundl132.exe
del C:\windows\bootconf.exe
del C:\windows\kill.exe
del C:\windows\sws32.dll
del C:\windows\dll.dll
del C:\windows\vdll.dll
del C:\windows\system32\ShellExt\svchs0t.exe 
del C:\windows\system32\Logo1_.exe
del C:\windows\system32\rundl132.exe
del C:\windows\system32\bootconf.exe
del C:\windows\system32\kill.exe
del C:\windows\system32\sws32.dll

del c:\_desktop.ini /f/s/q/a
del d:\_desktop.ini /f/s/q/a
del e:\_desktop.ini /f/s/q/a
del f:\_desktop.ini /f/s/q/a
del g:\_desktop.ini /f/s/q/a
del h:\_desktop.ini /f/s/q/a
del i:\_desktop.ini /f/s/q/a
del j:\_desktop.ini /f/s/q/a
del k:\_desktop.ini /f/s/q/a
echo.
cls
goto m
echo.
pause >nul
goto virus 


:killwhboy
@echo off
cls
color 0A
prompt $g
echo.
title  spcolsv/spoclsv病毒(熊猫烧香变种)批处理专杀--by HCL
@echo 【使用说明】：强烈建议在安全模式下使用本工具进行查杀。
echo.
echo.
echo.
pause
cls
color 0a
echo.
echo.
@echo::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo::停止正在运行的spcolsv.exe进程，请稍候......                           ::
@echo::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
TASKKILL /F /T /IM spcolsv.exe
TASKKILL /F /T /IM spoclsv.exe

color 0a
echo.
echo.

@echo:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo::删除drivers下的spcolsv.exe文件，请稍候......                                   ::
@echo:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
ATTRIB -R -H -S -A %SystemRoot%\System32\drivers\spcolsv.exe
ATTRIB -R -H -S -A %SystemRoot%\System32\drivers\spoclsv.exe
DEL /F /Q /A -R -H -S -A %SystemRoot%\System32\drivers\spcolsv.exe
DEL /F /Q /A -R -H -S -A %SystemRoot%\System32\drivers\spoclsv.exe

@echo::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo::删除每个分区下的setup.EXE和AUTORUN.INF文件,请稍候......               ::
@echo::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
FOR %%a IN ( C: D: E: F: G: H: I: J: K: L: M: N: O: P: Q: R: S: T: U: V: W: X: Y: Z: ) DO ATTRIB -R -H -S -A %%a\setup.EXE & DEL /F /Q /A -R -H -S -A %%a\setup.EXE & ATTRIB -R -H -S -A %%a\AUTORUN.INF & DEL /F /Q /A -R -H -S -A %%a\AUTORUN.INF


@echo::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo::删除注册表中自启动项,请稍候......                                     ::
@echo::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
ECHO Windows Registry Editor Version 5.00>svcshare.reg

ECHO [-HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\svcshare]>>svcshare.reg

ECHO [HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]>>svcshare.reg
ECHO "svcshare"=->>svcshare.reg

REGEDIT /S svcshare.reg

DEL /F /Q svcshare.reg



@echo::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo::恢复注册表中不给设置显示隐藏文件的项目,请稍候......                   ::
@echo::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
ECHO Windows Registry Editor Version 5.00>SHOWALL.reg

ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\SHOWALL]>>SHOWALL.reg
ECHO "CheckedValue"=->>SHOWALL.reg

ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\SHOWALL]>>SHOWALL.reg
ECHO "CheckedValue"=dword:00000001>>SHOWALL.reg

REGEDIT /S SHOWALL.reg

DEL /F /Q SHOWALL.reg
color 0a
echo.
@echo 病毒文件已清除! 
echo.
goto m
echo.
pause >nul
goto virus 

:endd
exit

:lmj1
@Echo off
color 0a
telnet towel.blinkenlights.nl