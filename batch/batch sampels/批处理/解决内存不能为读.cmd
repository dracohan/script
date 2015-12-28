@echo off  
color F2 
echo 即将进行重新自动注册DLL文件 
echo. 

echo 以解决部分程序提示“内存不能为Read的错误” 

echo. 
echo 程序运行时间较长，请耐心等候！ 
echo.  

echo 按任意键开始，点关闭按钮退出 
pause>nul 
for %%1 in (%systemroot%\system32\*.dll) do regsvr32 /s %%1 
for %%1 in (%systemroot%\system32\*.ocx) do regsvr32 /s %%1  