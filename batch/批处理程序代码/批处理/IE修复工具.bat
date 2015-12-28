复制↓
@echo off
cls
echo.
echo                 IE 组件修复脚本程序
echo.
echo.
echo           正在修复 IE 组件注册，请稍候……
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
echo           IE 组件注册成功！不能打开某些链接等错误被修正！
echo           如果仍然存在问题， 建议关闭 IE 后重新执行本程序，
echo           或者重新启动计算机后再执行本程序！
echo.
echo           修复操作完毕！任意键退出！
pause>nul
