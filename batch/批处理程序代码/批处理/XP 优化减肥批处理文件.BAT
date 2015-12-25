@echo off
setlocal
:: ==============================================================================================================================================================
:: Windows XP 优化减肥批处理文件（原则上本优化程序经过适当修改也可以用于Windows 2000和Windows 2003）。
:: 创建日期：2006年7月1日
:: 最后修改日期：2006年7月15日
:: 提醒：在运行本批处理文件之前，务必通读一遍整个文件的内容，根据注释去掉你不想要的（或者与你的系统冲突的）部分。
::       由于删除了一些系统文件，如果优化过程中提示插入系统安装光盘，请不要这样做并选择保留不可识别的文件版本。
::       优化完成后请重新启动计算机。
:: 其它：不包括在本批处理中的其它优化内容(大部分都在“我的电脑 -> 鼠标右键 -> 属性”中设置，建议这些操作在运行本优化程序之前进行)：
:: 	1. 关闭系统还原功能。
::	2. 在硬盘最靠近XP系统所在的分区（一般是XP所在主分区的后面，另一种说法是在硬盘的正中间位置）建立一个小的分区（我推荐1G以上，2G以内），然后将pagefile.sys转移到该分区上，设定为固定大小，一般为内存的2－3倍（或者固定为512M）。当然同时将系统分区(C:)的pagefile.sys设置为无。
::	3. 编辑环境变量，将TEMP及TMP的环境变量指向到上述分区（注意TEMP变量分用户变量及系统变量两种，尽量指向不同的目录）。
::	4. 开始 -> 运行 -> DRWTSN32，去掉所有的Dr. Watson相关选项。
::      5. 修改启动选项，将默认的菜单倒计时时间设置为1或者0。同时将调试信息中的内存转储设置为“无”。
::	6. 在设置管理器中修改主、从IDE接口的高级设置，将没有接设备的接口类型设置为“无”，将接设备的接口的传送模式设置为“DMA(若可用)”。
:: =============================================================================================================================================================

:: 设置本批处理运行时的一些环境变量：tempdir为临时的工作目录，必须可写；bak为备份注册表需要用到的目录，必须可写
::set tempdir=%temp%
::set bak=F:\syssoft\system\regbak

:: 如果不存在上述目录，则建立相应的目录
::if not exist %tempdir%\. md %tempdir%
::if not exist %bak%\. md %bak%

:: ！！！！！以下优化内容请在运行前仔细阅读，原则上不需要用户修改，但请高级用户酌情进行适合自己的设置！！！！！

::echo 删除Windows的DllCache(%windir%\system32\dllcache)
::sfc /purgecache

echo 删除微软仓颉输入法
del /f /q /s /a "%windir%\system32\IME\CINTLGNT\*.*"

echo 删除微软拼音输入法
del /f /q /s /a "%windir%\system32\IME\PINTLGNT\*.*"
del /f /q /s /a "%windir%\system32\IMSC40A.IME"

echo 删除微软注音输入法
del /f /q /s /a "%windir%\system32\IME\TINTLGNT\*.*"

echo 删除其它一些Windows内置的不需要的输入法
for %%I in (chajei.ime CINTLGNT.IME dayi.ime imekr61.ime imjp81.ime MSCTFIME.IME phon.ime PINTLGNT.IME quick.ime romanime.ime TINTLGNT.IME unicdime.ime winar30.ime WINGB.IME winime.ime WINPY.IME WINSP.IME WINZM.IME) do @if exist "%windir%\system32\%%I" del /f /q "%windir%\system32\%%I"

echo 删除Windows系统分区上的其它垃圾文件
::if exist c:\io.sys attrib -s -r -h c:\io.sys
::if exist c:\msdos.sys attrib -s -r -h c:\msdos.sys
::if exist c:\io.sys del /f /q c:\io.sys
::if exist c:\msdos.sys del /f /q c:\msdos.sys
rd  /s /q    %windir%\Help\Tours
rd  /s /q    %windir%\ServicePackFiles
rd  /s /q    "%windir%\Downloaded Installations"
rd  /s /q    "%windir%\SoftwareDistribution\Download"
del /f /q /s /a %windir%\temp\*.*
del /f /q /s /a %windir%\*.log
del /f /q /s /a %windir%\*.dmp
del /f /q /s /a %windir%\*.tmp
del /f /q /s /a %windir%\*.bak
del /f /q /s /a %windir%\minidump\*.*
del /f /q /s /a %windir%\*.old
del /f /q /s /a %windir%\*.query
del /f /q    %windir%\*.txt
del /f /q /s /a "%userprofile%\Recent\*.*"
for /D %%D in ("%userprofile%\NetHood\*.*") do rd /s /q "%%D"
del /f /q /s /a "%userprofile%\NetHood\*.*"
del /f /q /s /a "%userprofile%\Local Settings\Application Data\*.*"
del /f /q /s /a "%allusersprofile%\..\iconcache.db"
del /f /q /s /a d:\autorun\log.txt

::echo 删除Windows打补丁时留下的反安装目录，一般是%windir%目录下以$开头的目录，删除的内容会记录在%tempdir%\rmlist.txt中，下同
::lmod > nul
::dir /a/b %windir%\$*.* | lmod /l* rd /s /q %windir%\[] > %tempdir%\temp.bat
::call %tempdir%\temp.bat
::type %tempdir%\temp.bat > %tempdir%\Rmlist.txt
::del %tempdir%\temp.bat

::chcp 936 > nul
::echo 删除%windir%\ime目录下的日本、韩国及繁体输入法文件
::lmod > nul
::dir /a-d /s /b %windir%\ime\imjp8_1 %windir%\ime\imkr6_1 %windir%\ime\CHTIME | lmod /l* del /f /q [] > %tempdir%\temp.bat
::call %tempdir%\temp.bat
::type %tempdir%\temp.bat >> %tempdir%\Rmlist.txt
::del %tempdir%\temp.bat

::chcp 936 > nul
::echo 删除%windir%\Prefetch目录下的预读取文件
::del /f /q %windir%\Prefetch\*.*

::echo 删除Norton杀毒软件的老病毒定义备份（一般在%ProgramFiles%\Common Files\Symantec Shared\VirusDefs目录下）
::lmod > nul
::if not exist "%ProgramFiles%\Common Files\Symantec Shared\VirusDefs\definfo.dat" goto _OpReg
::dir /ad /b /o-n "%ProgramFiles%\Common Files\Symantec Shared\VirusDefs\200*.*" | lmod /l2* rd /s /q "%ProgramFiles%\Common ::Files\Symantec Shared\VirusDefs\[]" > %temp%\temp.bat
::dir /ad /b "%ProgramFiles%\Common Files\Symantec Shared\VirusDefs\*.tmp" | lmod /l* rd /s /q "%ProgramFiles%\Common ::Files\Symantec Shared\VirusDefs\[]" >> %temp%\temp.bat
::if exist %temp%\temp.bat type %temp%\temp.bat >> %tempdir%\Rmlist.txt
::if exist %temp%\temp.bat call %temp%\temp.bat
::if exist %temp%\temp.bat del %temp%\temp.bat

::_OpReg
::chcp 936 > nul
:: Unregist Windows xp's zipfldr.dll去掉zip文件夹功能
:: 操作步骤：首先运行下面的命令，运行完成后千万不要双击zip文件（否则会重新打开XP的zip文件夹功能），立刻打开Winrar，在设置中将::所有文件类型都关联到WinRAR。
::regsvr32 /u /s zipfldr.dll

::echo 减少Windows XP的启动时间，通过修改注册表中的PrefetchParameters参数（原值为3）
::reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v ::EnablePrefetcher /t REG_DWORD /d 1 /f

::echo 加速xp的开关机，缩短杀掉服务和进程的等待时间，原值分别为20000, 20000, 12000
::reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 1000 /f
::reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 1000 /f
::reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 200 /f

::echo 关闭计算机时自动结束不响应的任务（原值为0）
::reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v AutoEndTasks /t REG_SZ /d 1 /f

:: 下面的三项优化均来自外国网站对网络部分的优化设置
::echo 备份并删除[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RemoteComputer\NameSpace\{D6277990-::4C6A-11CF-8D87-00AA0060F5BF}]
::echo 用来加快Windows XP浏览网上邻居
::if not exist %bak%\restoreshare.reg regedit /e %bak%\restoreshare.reg ::"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RemoteComputer\NameSpace\{D6277990-4C6A-11CF-8D87-::00AA0060F5BF}"
::reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RemoteComputer\NameSpace\{D6277990-4C6A-::11CF-8D87-00AA0060F5BF}" /f > nul

::echo Increase Request Buffer Size(reduce network delay)
::reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters" /v SizReqBuf /t REG_DWORD /d 16384 ::/f

::echo Increase Network Redirector Buffers(better network performance)
::reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v MaxCmds /t REG_DWORD /d 100 ::/f
::reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v MaxThreads /t REG_DWORD /d ::100 /f
::reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v MaxCollectionCount /t ::REG_DWORD /d 100 /f

::echo 关掉调试器Dr. Watson
::reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug" /v Auto /t REG_SZ /d 0 /f

::echo 设置开机磁盘扫描等待时间为0秒
::chkntfs /T:0


:: ！！！下面部分内容引用自叶子的XP优化批处理文件，经试验证实基本有效，需要进一步测试！！！
:: 关闭"系统还原"的配置界面和系统还原的功能
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\systemrestore" /v DisableConfig /t reg_dword /d 1 /f>nul
::reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\systemrestore" /v DisableSR /t reg_dword /d 1 /f>nul

::echo 缩短"关闭无响应程序"等待时间(默认值为20000我建议值是1000你可以自行更改)
::reg add "HKEY_USERS\.DEFAULT\Control Panel\Desktop" /v WaitToKillAppTimeout /d 1000 /f

::echo 修改应用程序出错的等待时间(默认值是5000也就是5秒我建议是0.5秒)
::reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /d 200 /f

::echo 在BSOD（就是蓝屏）事件中禁用自动重启动
::reg add HKLM\SYSTEM\CurrentControlSet\Control\CrashControl /v AutoReboot /t reg_dword /d 0 /f

:: 设置系统蓝屏时自动重启
::reg add HKLM\system\CurrentControlSet\Control\CrashControl /v Autoreboot /t reg_dword /d 1 /f>nul

::echo 系统出现蓝屏故障时是不是要创建dump文件
::echo 值为0时是不创建dump文件，为1时是完完全全的把内存内容保存到dump文件中，为2时是保存最重要的文件到dump文件中，为3时是只将::内存中64K的内容保存到dump文件中
::reg add HKLM\system\CurrentControlSet\Control\CrashControl /v CrashDumpEnabled /t reg_dword /d 0 /f

::echo 禁用桌面清理向导
::reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\CleanupWiz /v NoRun /t reg_dword /d 1 /f

::echo 禁用“错误报告”以及“但在发生严重错误时通知我”选项
::reg add HKLM\SOFTWARE\Microsoft\PCHealth\ErrorReporting /v DoReport /t reg_dword /d 0 /f

::echo 把Internet Explorer可同时下载的文件数目增大到10
::reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v MaxConnectionsPer1_0Server /t reg_dword /d 10 ::/f
::reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v MaxConnectionsPerServer /t reg_dword /d 10 /f

::echo 禁用磁盘剩余空间低的警告
::reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoLowDiskSpaceChecks /t reg_dword /d 1 /f>nul
:: ！！！以上优化内容取自叶子的xp优化批处理文件，由于没有经过详细测试，可能存在bug！！！

:: 屏蔽3721及其它一些垃圾网站
find /i "unionsky" %windir%\system32\drivers\etc\hosts > nul
if errorlevel 1 goto _AddHosts
goto _SkipAddHosts

:_AddHosts
echo 127.0.0.1 http://www.3721.net/ >> %windir%\system32\drivers\etc\hosts
echo 127.0.0.1 3721.com  >> %windir%\system32\drivers\etc\hosts
echo 127.0.0.1 3721.net  >> %windir%\system32\drivers\etc\hosts
echo 127.0.0.1 cnsmin.3721.com  >> %windir%\system32\drivers\etc\hosts
echo 127.0.0.1 cnsmin.3721.net  >> %windir%\system32\drivers\etc\hosts
echo 127.0.0.1 download.3721.com  >> %windir%\system32\drivers\etc\hosts
echo 127.0.0.1 download.3721.net  >> %windir%\system32\drivers\etc\hosts
echo 127.0.0.1 www.3721.com  >> %windir%\system32\drivers\etc\hosts
echo 127.0.0.1 www.3721.net  >> %windir%\system32\drivers\etc\hosts
echo 127.0.0.1 bar.baidu.com  >> %windir%\system32\drivers\etc\hosts
echo 127.0.0.1 www.unionsky.cn  >> %windir%\system32\drivers\etc\hosts

:_SkipAddHosts

:: ！！！以下部分为引用自其他的XP优化批处理，是未经测试的部分，请根据情况试用！！！
::echo 禁止设置动画效果(针对与整个windows系统)
::reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoChangeAnimation /t reg_dword /d 1 /f

::echo 禁止窗口显示动画效果
::reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t reg_binary /d 1011100 /f

::echo 禁止最大化最小化窗口的动画效果
::reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /d 0 /f

::echo 禁止光驱自动播放但是保留自动播放CD
::reg add HKLM\system\currentControlSet\Services\Cdrom /v AutoRun /t reg_dword /d 0 /f

::echo 使用传统登录窗口
::reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v LogonType /t reg_dword /d 1 /f>nul

::echo 改变菜单显示延迟
::reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /d 0 /f

::echo 删除快捷方式的箭头
::reg add HKCR\lnkfile /v IsShortcut /d - /f>nul

::echo 禁用漫游Windows XP 窗口
::reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Tour /v RunCount /t reg_dword /d 0 /f>nul
::reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Applets\Tour /v RunCount /t reg_dword /d 0 /f>nul

::echo 删除开始菜单中的最近打开的文档菜单
::reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoRecentDocsmenu /t reg_dword /d 1 /f>nul

:: 加快窗口显示速度
::reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /d 1 /f>nul

:: 屏蔽"分组相似任务栏按钮"
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v taskbarGlomming /t reg_dword /d 0 /f>nul

:: 禁用关闭通知区域清理
::reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoAutoTrayNotify /t reg_dword /d 1 /f>nul

:: 隐藏任务栏的气球提示
::reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v EnableBalloonTips /t reg_dword /d 0 /f>nul

:: 关闭提醒气球
::reg add add HKCU\SOFTWARE\Microsoft\Windows\NetCache\AssignedOfflineFolders /v NoReminders /t reg_dword /d 1 /f>nul

:: 让欢迎窗口更加清晰
reg add "HKEY_USERS\.DEFAULT\Control Panel\Desktop" /v FontSmoothingType /d 2 /f>nul
reg add "HKEY_USERS\.DEFAULT\Control Panel\Desktop" /v FontSmoothing /d 2 /f>nul

:: 隐藏快捷方式的小箭头(可以把/d参数后面null替换成你想要换成的图片格式必须是*.ico)
::reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /d null /f>nul

:: 去除xp的共享文件夹
::reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /f>nul

:: 禁止添加"快捷方式"四个字
::reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer /v link /t reg_binary /d 00000000 /f>nul

:: 让bmp自身内容作为缩略图图表显示
::reg add HKCR\Paint.Picture\DefaultIcon /v "" /d %%1 /f>nul

:: 禁止系统运行时默认的屏幕保护程序的运行
::reg add "HKEY_USERS\.DEFAULT\Control Panel\Desktop" /v screemSaveActive /t reg_dword /d 1 /f>nul

:: 增强windows核心程序的性能
::reg add "HKLM\system\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t reg_dword /d ::1 /f>nul

:: 加快打开含有大量avi文件的速度
::reg delete HKCR\CLSID\{87D62D94-71B3-4b9a-9489-5FE6850DC73E} /f>nul
::reg add HKCR\CLSID\-{87D62D94-71B3-4b9a-9489-5FE6850DC73E} /f>nul

:: 取消xp的漫游功能
::reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Tour /v RunCout /t reg_dword /d 1 /f

:: 删除文件时显示确认对话框
::reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v confirmFiledelete /t reg_dword /d 1 /f>nul

:: 禁止远程查找用户
::reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FindExtensions\Static\WabFind /f>nul

:: ！！！以上优化内容取自网络的xp优化批处理文件，由于没有经过测试，因为注释掉了很多内容，请根据情况试用！！！

:_quit
endlocal