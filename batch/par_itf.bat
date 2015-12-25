SETLOCAL
for /f %%a IN ('dir /b *.lsu') do splitsctp_asb.exe %%a splitted_%%a
ENDLOCAL