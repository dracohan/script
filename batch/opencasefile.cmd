@echo off
set AUTORUNROOT=\\192.168.0.49\root\autorun

set actfile=%1
set select1=%2
set select2=%3
if /I NOT "%select2%"=="" (
	set select=%select1%.%select2:~-1%
) else (
	set select=%select1%
)

REM DEBUG begin
echo 1=%1
echo 2=%2
echo 3=%3
echo actfile=%actfile%
echo select1=%select1%
echo select2=%select2%
echo select=%select%
REM goto :EOF
REM DEBUG end


if "%select%"=="" exit

set ext=%select:~-4%
if "%ext%"==".csv" (
rem #########  selection is a csv file
    for /R %AUTORUNROOT%\src\csv %%i in (%select%*) do (
        if %%~nxi==%select% "C:\Program Files\UltraEdit\Uedit32.exe" "%%i"
    )
    goto :EOF
)

set checkfilename=%actfile:\scenario\=%
set neth=%actfile:*\scenario\=%
set neth=%neth:\=&rem.%
if NOT "%checkfilename%"=="%actfile%" (
rem #########  active file is a scenario. selection is message
    for /R %AUTORUNROOT%\src\msg\%neth% %%i in (%select%*) do (
        if /I %%~nxi==%select% "C:\Program Files\UltraEdit\Uedit32.exe" "%%i"
    )
    goto :EOF
)

