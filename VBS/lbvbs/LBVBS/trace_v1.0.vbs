# $language = "VBScript"
# $interface = "1.0"

'=======================================
' Version: 1.0
' Author: LB
' Usage:
' 1) Run trace.vbs on SecuredCRT
' 2) Enter choice. Choose 1) when need to collect trace again and then upload trace to server, or choose 2) when only need to upload trace to server
' 3) If choose 2), skip to step 10)
' 4) Choose server to upload. The server list can be edited in trace.ini file, just follow the existing form.
' 5) Enter trace name, e.g. "tp-takeover".
' 6) Trace full path will be displayed then, nothing need to be input, just for easily copying the link of the trace.
'    Trace position will be under server trace directory according to ini file, then date (YYYYMMDD), then time (HHmm) add name input in 5)
' 7) Input start time (BSC time), e.g. "201302100130" for 2013 Feb 10th 01:30. It should be between 2013 Jan 1st 00:00 and current BSC time. Current BSC time will be shown in the title.
' 8) Input end time (BSC time). It should be between start time and current BSC time.
' 9) TCK will begin to collect trace then.
' 10) After trace collected, trace will be zipped then downloaded automaticallly to local PC under indicated directory in ini file, like "D:/ATCA54/Trace/", then uploaded to trace server and unzipped.
' Update:
' V1.0: 2013-01-15 First version.
'=======================================

'=======================================
' Configurations here
'=======================================
Const INI_NAME = "trace_v1.0.ini"
Const SEP_CHAR = "="
'=======================================

'=======================================
' Parameters
'=======================================
Dim SERV_IP()
Dim SERV_USER()
Dim SERV_PASS()
Dim SERV_DIR()
Dim SERV_CHAR()

Dim OMCP_ACT_IP
Dim OMCP_STB_IP
Dim OMCP_USER
Dim OMCP_PASS
Dim OMCP1_CHAR
Dim OMCP2_CHAR
Dim OMCP_CHAR
Dim OMCP_TCK_PATH
Dim OMCP_TRA_PATH
Dim OMCP_LS
Dim OMCP_NOTE
Dim OMCP_CD
Dim OMCP_RM

'Dim TCK_YON_CHAR
'Dim TCK_ENQ_CHAR
'Dim TCK_UNAV_CHAR
'Dim TCK_COMP_CHAR

Dim LOCAL_DIR
Dim LOCAL_LS
Dim LOCAL_MKDIR
Dim LOCAL_CD

Dim SFTP_CHAR
Dim SFTP_NOTE
Dim SFTP_LS
Dim SFTP_MKDIR
Dim SFTP_CD
'Dim SFTP_NOTE2

numServ = 0
'=======================================

'=======================================
' Push one server into array
'=======================================
Sub PushServer
  numServ = numServ+1
  ReDim Preserve SERV_IP(numServ)
  ReDim Preserve SERV_USER(numServ)
  ReDim Preserve SERV_PASS(numServ)
  ReDim Preserve SERV_DIR(numServ)
  ReDim Preserve SERV_CHAR(numServ)
End Sub
'=======================================

'=======================================
' Get configuration from one line
'=======================================
Sub GetCfg(cfgStr)
  ' Only the first seperater char will be treated as seperater
  res = split(cfgStr, SEP_CHAR, 2)
  num = UBound(res)
  ' Exclude lines without seperater char
  If num = -1 Then
    Exit Sub
  End If
  
  Select Case res(0)
  	Case "SERV_IP"
	  	PushServer
  	  SERV_IP(numServ-1) = res(1)
	 	Case "SERV_USER"
  	  SERV_USER(numServ-1) = res(1)
	 	Case "SERV_PASS"
  	  SERV_PASS(numServ-1) = res(1)
	 	Case "SERV_DIR"
  	  SERV_DIR(numServ-1) = res(1)
	 	Case "SERV_CHAR"
  	  SERV_CHAR(numServ-1) = res(1)
	 		
    Case "OMCP_ACT_IP"
      OMCP_ACT_IP = res(1)
    Case "OMCP_STB_IP"
      OMCP_STB_IP = res(1)
    Case "OMCP_USER"
      OMCP_USER = res(1)
    Case "OMCP_PASS"
      OMCP_PASS = res(1)
    Case "OMCP1_CHAR"
      OMCP1_CHAR = res(1)
    Case "OMCP2_CHAR"
      OMCP2_CHAR = res(1)
    Case "OMCP_CHAR"
      OMCP_CHAR = res(1)
    Case "OMCP_TCK_PATH"
      OMCP_TCK_PATH = res(1)
    Case "OMCP_TRA_PATH"
      OMCP_TRA_PATH = res(1)
    Case "OMCP_LS"
      OMCP_LS = res(1)
    Case "OMCP_NOTE"
      OMCP_NOTE = res(1)
    Case "OMCP_CD"
      OMCP_CD = res(1)
    Case "OMCP_RM"
      OMCP_RM = res(1)
	
'    Case "TCK_YON_CHAR"
'      TCK_YON_CHAR = res(1)
'    Case "TCK_ENQ_CHAR"
'      TCK_ENQ_CHAR = res(1)
'    Case "TCK_UNAV_CHAR"
'      TCK_UNAV_CHAR = res(1)
'    Case "TCK_COMP_CHAR"
'      TCK_COMP_CHAR = res(1)

    Case "LOCAL_DIR"
      LOCAL_DIR = res(1)
    Case "LOCAL_LS"
      LOCAL_LS = res(1)
    Case "LOCAL_MKDIR"
      LOCAL_MKDIR = res(1)
    Case "LOCAL_CD"
      LOCAL_CD = res(1)

    Case "SFTP_CHAR"
      SFTP_CHAR = res(1)
    Case "SFTP_NOTE"
      SFTP_NOTE = res(1)
    Case "SFTP_LS"
      SFTP_LS = res(1)
    Case "SFTP_MKDIR"
      SFTP_MKDIR = res(1)
    Case "SFTP_CD"
      SFTP_CD = res(1)
'    Case "SFTP_NOTE2"
'      SFTP_NOTE2 = res(1)

  End Select
End Sub
'=======================================

'=======================================
' Get all configuration from ini file
'=======================================
Function ReadCfg
  scriptName = crt.ScriptFullName
  pos = InstrRev(scriptName, "\")
  iniFile = Left(scriptName, pos-1) & "\" & INI_NAME

  ' Open ini file
  Set fso = CreateObject("Scripting.FileSystemObject")
  If fso.FileExists(iniFile) Then
    Set fil = fso.OpenTextFile(iniFile, 1)
  Else
    MsgBox "Ini file does not exist!"
    Set fso = Nothing
    ReadCfg = False
    Exit Function
  End If
  
  Do While Not fil.AtEndOfStream
    ' Read each line until end of file
    cfgLine = fil.ReadLine
    If Mid(cfgLine, 1, 1) <> "#" Then
	    GetCfg cfgLine
	  End If
  Loop
  
  fil.Close
  Set fso = Nothing
  ReadCfg = True
End Function
'=======================================

'=======================================
' Print all server info
'=======================================
Sub PrintServer
  For i = 0 to numServ-1
    MsgBox "SERV_IP(" & i & ") = " & SERV_IP(i)
    MsgBox "SERV_USER(" & i & ") = " & SERV_USER(i)
    MsgBox "SERV_PASS(" & i & ") = " & SERV_PASS(i)
    MsgBox "SERV_DIR(" & i & ") = " & SERV_DIR(i)
    MsgBox "SERV_CHAR(" & i & ") = " & SERV_CHAR(i)
  Next
End Sub
'=======================================

'=======================================
' Print all configuration
'=======================================
Sub PrintCfg
	PrintServer
	
  MsgBox "OMCP_ACT_IP = " & OMCP_ACT_IP
  MsgBox "OMCP_STB_IP = " & OMCP_STB_IP
  MsgBox "OMCP_USER = " & OMCP_USER
  MsgBox "OMCP_PASS = " & OMCP_PASS
  MsgBox "OMCP1_CHAR = " & OMCP1_CHAR
  MsgBox "OMCP2_CHAR = " & OMCP2_CHAR
  MsgBox "OMCP_CHAR = " & OMCP_CHAR
  MsgBox "OMCP_TCK_PATH = " & OMCP_TCK_PATH
  MsgBox "OMCP_TRA_PATH = " & OMCP_TRA_PATH
  MsgBox "OMCP_LS = " & OMCP_LS
  MsgBox "OMCP_NOTE = " & OMCP_NOTE
  MsgBox "OMCP_CD = " & OMCP_CD
  MsgBox "OMCP_RM = " & OMCP_RM

'	MsgBox "TCK_YON_CHAR = " & TCK_YON_CHAR
'	MsgBox "TCK_ENQ_CHAR = " & TCK_ENQ_CHAR
'	MsgBox "TCK_UNAV_CHAR = " & TCK_UNAV_CHAR
'	MsgBox "TCK_COMP_CHAR = " & TCK_COMP_CHAR

  MsgBox "LOCAL_DIR = " & LOCAL_DIR
  MsgBox "LOCAL_LS = " & LOCAL_LS
  MsgBox "LOCAL_MKDIR = " & LOCAL_MKDIR
  MsgBox "LOCAL_CD = " & LOCAL_CD

  MsgBox "SFTP_CHAR = " & SFTP_CHAR
  MsgBox "SFTP_NOTE = " & SFTP_NOTE
  MsgBox "SFTP_LS = " & SFTP_LS
  MsgBox "SFTP_MKDIR = " & SFTP_MKDIR
  MsgBox "SFTP_CD = " & SFTP_CD
'  MsgBox "SFTP_NOTE2 = " & SFTP_NOTE2
End Sub
'=======================================

'=======================================
' Enter command
'=======================================
Sub SendCmd(scn, cmd)
  scn.Send(cmd & vbcr)
End Sub
'=======================================

'=======================================
' Enter command and wait for back char
'=======================================
Sub SendCmdBack(scn, cmd, char)
  scn.Send(cmd & vbcr)
  scn.WaitForString(char)
End Sub
'=======================================

'=======================================
' Enter command and check output having key word
' Return True when having key, return False otherwise
'=======================================
Function SendCmdKey(scn, cmd, key, char)
  scn.Send(cmd & vbcr)
  res = scn.WaitForStrings(key, char)
  If res = 1 Then
    SendCmdKey = True
    scn.WaitForStrings(char)
  Else
    SendCmdKey = False
  End If
End Function
'=======================================

'=======================================
' Enter command and wait for key word
' Return True when having key, return False otherwise
'=======================================
Function SendCmdWait(scn, cmd, key, char)
  scn.Send(cmd & vbcr)
  res = scn.WaitForStrings(key, char)
  If res = 1 Then
    SendCmdWait = True
  Else
  	MsgBox res
    SendCmdWait = False
  End If
End Function
'=======================================

'=======================================
' Add zero char for date and time
'=======================================
Function DateAddZero(value)
  If value < 10 Then
  	value = "0" & value
  End If
  DateAddZero = value
End Function
'=======================================

'=======================================
' Check file or directory exist
'=======================================
Function CheckExist(scn, cmd, path, note, char)
  res = SendCmdKey(scn, cmd & " " & path, note, char)
  If res = True Then
    CheckExist = False
  Else
    CheckExist = True
  End If
End Function
'=======================================

'=======================================
' Input trace start or end time
' Should be large or small than ref
'=======================================
Function GetTraceTime(scn, txt, title, up, low)
	Do
		ti = crt.Dialog.Prompt("Please input " & txt & ": (" & low & "~" & up & ")", title)
		If ti = "" Then
			GetTraceTime = ""
			Exit Function
		End If
		If Not IsNumeric(ti) Then
			MsgBox "Please input number!"
		Else
			If Sgn(ti-low) <> -1 And Sgn(ti-up) <> 1 Then
				' Month <= 12, Day <= 31, Hour <= 23, Minute <= 59
				If Mid(ti, 5, 2) > 12 Or Mid(ti, 7, 2) > 31 Or Mid(ti, 9, 2) > 23 Or Mid(ti, 11, 2) > 59 Then
					MsgBox "Input out of range!"
				Else
					GetTraceTime = ti
					Exit Function
				End If
			Else
				MsgBox "Input should between " & low & " and " & up & "!"
			End If
		End If
	Loop
End Function
'=======================================

'=======================================
' Run TCK to collect trace
' Return True if standby OMCP is available
'=======================================
Function RunTck(scn)
	res = SendCmdWait(scn, OMCP_TCK_PATH, "[y/n]", OMCP_CHAR)
	If res Then
		SendCmdWait scn, "y", "[e/n/q]", OMCP_CHAR
	Else
		RunTck = False
		Exit Function
	End If
	SendCmdWait scn, "n", "Current BSC Time: ", OMCP_CHAR
	' Fri Jan 11 10:13:09 UTC 2013
	curFullTime = scn.ReadString("3.")
	arrTime = Split(curFullTime)
	num = UBound(arrTime)
	' Jan 11, 2013'
	curDate = arrTime(1) & " " & arrTime(2) & ", " & arrTime(5)
	' HH:mm:SS
	curTime = arrTime(3)
	curYear = Year(curDate)
	curMon = Month(curDate)
	curDay = Day(curDate)
	curHour = Hour(curTime)
	curMin = Minute(curTime)
	curSec = Second(curTime)
	' YYYYMMDD
	curDateStr = curYear & DateAddZero(curMon) & DateAddZero(curDay)
	' HHmm
	curTimeStr = DateAddZero(curHour) & DateAddZero(curMin)
	' YYYYMMDDHHmm
	curDateTime = curDateStr & curTimeStr
	' YYYY-MM-DD HH:mm:SS
	curDateTimeStr = curYear & "-" & curMon & "-" & curDay & " " & curTime
	refTime = "201301010000"
	If curDateTime < refTime Then
		RunTck = False
		Exit Function
	End If
	startTime = GetTraceTime(scn, "start time",  "Start time - " & curDateTimeStr, curDateTime, refTime)
	If startTime = "" Then
		RunTck = False
    scn.Send chr(3)
		Exit Function
	End If
	endTime = GetTraceTime(scn, "end time", "End time - " & curDateTimeStr, curDateTime, startTime)
	If endTime = "" Then
		RunTck = False
    scn.Send chr(3)
		Exit Function
	End If
	SendCmdWait scn, startTime, "Input EndTime", OMCP_CHAR
	RunTck = SendCmdKey(scn, endTime, "Complete!", OMCP_CHAR)
End Function
'=======================================

'=======================================
' Download trace from one OMCP to local PC
' To be finished...
'=======================================
Sub SftpDownloadR(scnSftp, path, note, char)
  SendCmdWait scn, "ls " & path, note, char
	fileNames = scn.ReadString(char)
End Sub
'=======================================

'=======================================
' Make each directory for the path
'=======================================
Sub CreatePath(scn, path, ls, mdir, note, char)
	pos = 1
	Do
		pos = InStr(pos, path, "/")
		If pos = 0 Then
			Exit Do
		End If
		tmpPath = Mid(path, 1, pos-1)
		pos = pos+1
	  res = CheckExist(scn, ls, tmpPath, note, char)
	  If Not res Then
	    SendCmdBack scn, mdir & " " & tmpPath, char
  	End If
	Loop
End Sub
'=======================================

'=======================================
' Download trace from one OMCP to local PC
'=======================================
Function DownloadOneToLocal(ip, dat, nam)
  ' Connect to OMCP
  Set tabOMCP = crt.Session.ConnectInTab("/ssh2 /L " & OMCP_USER & " /PASSWORD " & OMCP_PASS & " " & ip, , True)
  If Not tabOMCP.Session.Connected Then
    MsgBox "Cannot connect to active OMCP!"
    DownloadToLocal = False
    Exit Function
  End If

  Set scnOMCP = tabOMCP.Screen
  scnOMCP.Synchronous = True
  numOMCP = scnOMCP.WaitForStrings(OMCP1_CHAR, OMCP2_CHAR)
  
  ' Check trace directory on OMCP exist
  res = CheckExist(scnOMCP, OMCP_LS, OMCP_TRA_PATH, OMCP_NOTE, OMCP_CHAR)
  If Not res Then
  	MsgBox "Trace directory " & OMCP_TRA_PATH & " does not exist!"
	  DownloadOneToLocal = False
  	Exit Function
  End If
  
  Set tabSftp = tabOMCP.ConnectSftp
  Set scnSftp = tabSftp.Screen
  scnSftp.Synchronous = True
  scnSftp.WaitForStrings(SFTP_CHAR)
  
  datePath = LOCAL_DIR & dat & "/"
  namePath = datePath & nam & "/"
  nameFile = "OMCP" & numOMCP
  If ip = OMCP_ACT_IP Then
  	nameFile = nameFile & "-Act.tar"
  Else
  	nameFile = nameFile & ".tar"
  End If

  ' Check trace directory exist on local PC, if not create
  CreatePath scnSftp, namePath, LOCAL_LS, LOCAL_MKDIR, SFTP_NOTE, SFTP_CHAR
  res = CheckExist(scnSftp, LOCAL_LS, namePath, SFTP_NOTE, SFTP_CHAR)
  If Not res Then
  	DownloadOneToLocal = False
  	Exit Function
  End If

  res = CheckExist(scnOMCP, OMCP_LS, OMCP_TRA_PATH & nameFile, OMCP_NOTE, OMCP_CHAR)
  If res Then
    SendCmdBack scnOMCP, OMCP_RM & " " & OMCP_TRA_PATH & nameFile, OMCP_CHAR
  End If

	'Tar trace to one file
	SendCmdBack scnOMCP, OMCP_CD & " " & OMCP_TRA_PATH, OMCP_CHAR
	SendCmdBack scnOMCP, "tar cvf " & nameFile & " *", OMCP_CHAR
	
	' Download trace to local PC
	SendCmdBack scnSftp, LOCAL_CD & " " & namePath, SFTP_CHAR
	SendCmdBack scnSftp, "get " & OMCP_TRA_PATH & nameFile, SFTP_CHAR
	
	' Remove tmp tar file on OMCP	
	SendCmdBack scnOMCP, OMCP_RM & " " & OMCP_TRA_PATH & nameFile, OMCP_CHAR

  DownloadOneToLocal = True
End Function
'=======================================

'=======================================
' Download trace from both OMCP to local PC
'=======================================
Function DownloadToLocal(dat, nam)
	res1 = DownloadOneToLocal(OMCP_ACT_IP, dat, nam)
	If res1 Then
		res2 = DownloadOneToLocal(OMCP_STB_IP, dat, nam)
	End If
	DownloadToLocal = res1
End Function
'=======================================

'=======================================
' Upload trace to selected server
'=======================================
Function UploadToServer(srv, dat, nam)
  ' Connect to trace server
  Set tabSrv = crt.Session.ConnectInTab("/ssh2 /L " & SERV_USER(srv-1) & " /PASSWORD " & SERV_PASS(srv-1) & " " & SERV_IP(srv-1), , True)
  If Not tabSrv.Session.Connected Then
    MsgBox "Cannot connect to server " & SERV_IP(srv-1) & " !"
    UploadToServer = False
    Exit Function
  End If
  
  srvChr = SERV_CHAR(srv-1)

  Set scnSrv = tabSrv.Screen
  scnSrv.Synchronous = True
  scnSrv.WaitForStrings(srvChr)

  Set tabSftp = tabSrv.ConnectSftp
  Set scnSftp = tabSftp.Screen
  scnSftp.Synchronous = True
  scnSftp.WaitForStrings(SFTP_CHAR)

  datePath = SERV_DIR(srv-1) & dat & "/"
  namePath = datePath & nam & "/"

  localDatePath = LOCAL_DIR & dat & "/"
  localNamePath = localDatePath & nam & "/"

  ' Check trace directory exist on server, if not create
  CreatePath scnSftp, namePath, SFTP_LS, SFTP_MKDIR, SFTP_NOTE, SFTP_CHAR
  res = CheckExist(scnSftp, LOCAL_LS, namePath, SFTP_NOTE, SFTP_CHAR)
  If Not res Then
  	UploadToServer = False
  	Exit Function
  End If

	SendCmdBack scnSftp, SFTP_CD & " " & namePath, SFTP_CHAR
	SendCmdBack scnSftp, "put " & localNamePath & "*.tar", SFTP_CHAR
	
	SendCmdBack scnSrv, "cd " & namePath, srvChr
	SendCmdBack scnSrv, "for i in `ls *.tar`; do j=${i/%.tar/}; mkdir $j; mv $i $j; cd $j; tar xvf $i; rm $i; cd ..; done", srvChr

	UploadToServer = True
End Function
'=======================================

'=======================================
' Transfer trace onto selected server
'=======================================
Function TransTrace(srv, dat, nam)
	res = DownloadToLocal(dat, nam)
	If Not res Then
		TransTrace = False
		Exit Function
	End If
	res = UploadToServer(srv, dat, nam)
	TransTrace = res
End Function
'=======================================

'=======================================
' Main Sub
'=======================================
Sub Main
'  On Error Resume Next

  ' Read params from ini file
  res = ReadCfg
  If Not res Then
    Exit Sub
  End If 

	' Choose to collect trace then upload or upload directly
  Do
    opt = crt.Dialog.Prompt("Enter your choice: 1) Collect and upload; 2) Upload only", "Option", "1")
  Loop Until opt = "1" Or opt = "2" Or opt = ""
  If opt = "" Then
    Exit Sub
  End If

	' Select which trace server to upload
	info = "Enter trace upload site: "
  For i = 0 to numServ-1
  	info = info & i+1 & ")" & SERV_IP(i)
  	If i <> numServ-1 Then
  		info = info & "; "
  	End If
  Next
  Do
    ser = crt.Dialog.Prompt(info, "Select site", "1")
    If ser = "" Then
    	Exit Do
   	End If
    If IsNumeric(ser) Then
    	If Sgn(ser-1) <> -1 And Sgn(ser-numServ) <> 1 Then
    		Exit Do
   		End If
   	End If
  Loop
  If ser = "" Then
    Exit Sub
  End If
  
  Do
	  traDir = crt.Dialog.Prompt("Enter trace name:", "Trace name")
	Loop Until traDir <> ""
	traDate = Year(Now) & DateAddZero(Month(Now)) & DateAddZero(Day(Now))
	traTime = DateAddZero(Hour(Now)) & DateAddZero(Minute(Now))
	traName = traTime & "_" & traDir
	traDir = SERV_DIR(ser-1) & traDate & "/" & traName
	traPath = "ftp://" & SERV_USER(ser-1) & ":" & SERV_PASS(ser-1) & "@" & SERV_IP(ser-1) & ":" & traDir
	crt.Dialog.Prompt "Trace full path:", "Trace path", traPath

  ' Connect to active OMCP
  Set tabActOMCP = crt.Session.ConnectInTab("/ssh2 /L " & OMCP_USER & " /PASSWORD " & OMCP_PASS & " " & OMCP_ACT_IP, , True)
  If Not tabActOMCP.Session.Connected Then
    MsgBox "Cannot connect to active OMCP!"
    Exit Sub
  End If
  
  Set scnActOMCP = tabActOMCP.Screen
  scnActOMCP.Synchronous = True
  scnActOMCP.WaitForStrings(OMCP_CHAR)
  
  If opt = "1" Then
  	res = RunTCK(scnActOMCP)
  End If
  If Not res Then
  	Exit Sub
  End If

	res = TransTrace(ser, traDate, traName)

	MsgBox "Done!"

End Sub
'=======================================