# $language = "VBScript"
# $interface = "1.0"

'=======================================
' Version: 1.1
' Author: LB
' Usage:
' 1) Check CPU measurement scripts exist on active OMCP
' 1-1) If not exist on active OMCP, check exist on local PC
' 1-1-1) If not exist on local PC, check exist on tool server
' 1-1-1-1) If not exist on tool server, exit this script
' 1-1-1-2) If exist on tool server, download to local PC
' 1-1-2) If exist on local PC or downloaded from tool server, upload to active OMCP
' 1-2) If exist on active OMCP or uploaded from local PC, continue
' 2) ask for test duration
' 3) Run CPU measurement scripts and wait for finish
' 4) Download output from active OMCP to local PC
' Update:
' V1.0: 2012-10-24 First version.
' V1.1: 2012-10-25 Read params from ini file.
'=======================================

'=======================================
' Configurations here
'=======================================
Const INI_NAME = "cpu_v1.1.ini"
Const SEP_CHAR = "="
'=======================================

'=======================================
' Parameters
'=======================================
Dim SFTP_NOTE
Dim SFTP_NOTE2
Dim SFTP_CHAR

Dim LOCAL_DIR
Dim LOCAL_LS
Dim LOCAL_MKDIR
Dim LOCAL_CD

Dim TOOL_IP
Dim TOOL_USER
Dim TOOL_PASS
Dim TOOL_DIR
Dim TOOL_CHAR
Dim TOOL_NOTE
Dim TOOL_LS

Dim CPU_DIR
Dim CPU_PRI_FILE
Dim CPU_SEC_FILE

Dim OMCP_ACT_IP
Dim OMCP_USER
Dim OMCP_PASS
Dim OMCP_DIR
Dim OMCP_CHAR
Dim OMCP_NOTE
Dim OMCP_LS
Dim OMCP_MKDIR
Dim OMCP_CD

Dim DEFAULT_DUR
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
    Case "SFTP_NOTE"
      SFTP_NOTE = res(1)
    Case "SFTP_NOTE2"
      SFTP_NOTE2 = res(1)
    Case "SFTP_CHAR"
      SFTP_CHAR = res(1)
      
    Case "LOCAL_DIR"
      LOCAL_DIR = res(1)
    Case "LOCAL_LS"
      LOCAL_LS = res(1)
    Case "LOCAL_MKDIR"
      LOCAL_MKDIR = res(1)
    Case "LOCAL_CD"
      LOCAL_CD = res(1)

    Case "TOOL_IP"
      TOOL_IP = res(1)
    Case "TOOL_USER"
      TOOL_USER = res(1)
    Case "TOOL_PASS"
      TOOL_PASS = res(1)
    Case "TOOL_DIR"
      TOOL_DIR = res(1)
    Case "TOOL_CHAR"
      TOOL_CHAR = res(1)
    Case "TOOL_NOTE"
      TOOL_NOTE = res(1)
    Case "TOOL_LS"
      TOOL_LS = res(1)

    Case "CPU_DIR"
      CPU_DIR = res(1)
    Case "CPU_PRI_FILE"
      CPU_PRI_FILE = res(1)
    Case "CPU_SEC_FILE"
      CPU_SEC_FILE = res(1)

    Case "OMCP_ACT_IP"
      OMCP_ACT_IP = res(1)
    Case "OMCP_USER"
      OMCP_USER = res(1)
    Case "OMCP_PASS"
      OMCP_PASS = res(1)
    Case "OMCP_DIR"
      OMCP_DIR = res(1)
    Case "OMCP_CHAR"
      OMCP_CHAR = res(1)
    Case "OMCP_NOTE"
      OMCP_NOTE = res(1)
    Case "OMCP_LS"
      OMCP_LS = res(1)
    Case "OMCP_MKDIR"
      OMCP_MKDIR = res(1)
    Case "OMCP_CD"
      OMCP_CD = res(1)

    Case "DEFAULT_DUR"
      DEFAULT_DUR = res(1)
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
    
    GetCfg cfgLine
  Loop
  
  fil.Close
  Set fso = Nothing
  ReadCfg = True
End Function
'=======================================

'=======================================
' Print all configuration
'=======================================
Sub PrintCfg
  MsgBox "SFTP_NOTE = " & SFTP_NOTE
  MsgBox "SFTP_NOTE2 = " & SFTP_NOTE2
  MsgBox "SFTP_CHAR = " & SFTP_CHAR

  MsgBox "LOCAL_DIR = " & LOCAL_DIR
  MsgBox "LOCAL_LS = " & LOCAL_LS
  MsgBox "LOCAL_MKDIR = " & LOCAL_MKDIR
  MsgBox "LOCAL_CD = " & LOCAL_CD

  MsgBox "TOOL_IP = " & TOOL_IP
  MsgBox "TOOL_USER = " & TOOL_USER
  MsgBox "TOOL_PASS = " & TOOL_PASS
  MsgBox "TOOL_DIR = " & TOOL_DIR
  MsgBox "TOOL_CHAR = " & TOOL_CHAR
  MsgBox "TOOL_NOTE = " & TOOL_NOTE
  MsgBox "TOOL_LS = " & TOOL_LS

  MsgBox "CPU_DIR = " & CPU_DIR
  MsgBox "CPU_PRI_FILE = " & CPU_PRI_FILE
  MsgBox "CPU_SEC_FILE = " & CPU_SEC_FILE

  MsgBox "OMCP_ACT_IP = " & OMCP_ACT_IP
  MsgBox "OMCP_USER = " & OMCP_USER
  MsgBox "OMCP_PASS = " & OMCP_PASS
  MsgBox "OMCP_DIR = " & OMCP_DIR
  MsgBox "OMCP_CHAR = " & OMCP_CHAR
  MsgBox "OMCP_NOTE = " & OMCP_NOTE
  MsgBox "OMCP_LS = " & OMCP_LS
  MsgBox "OMCP_MKDIR = " & OMCP_MKDIR
  MsgBox "OMCP_CD = " & OMCP_CD
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
' Input duration
'=======================================
Function GetDuration
	dur = crt.Dialog.Prompt("Enter duration:", "Duration", DEFAULT_DUR)
	If Not IsNumeric(dur) Then
		dur = DEFAULT_DUR
	End If
	If dur < 0 Then
		dur = -dur
	End If
	dur = dur\1
	GetDuration = dur
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
' Generate directory name according to date
'=======================================
Function GetDirName
	nameDate = Year(Now) & "-" & DateAddZero(Month(Now)) & "-" & DateAddZero(Day(Now))
	nameTime = DateAddZero(Hour(Now)) & "-" & DateAddZero(Minute(Now)) & "-" & DateAddZero(Second(Now))
	GetDirName = nameDate & "-" & nameTime
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
' Check CPU scripts exist
'=======================================
Function CheckCPUExist(scn, ls, dirr, note, char)
  res1 = CheckExist(scn, ls, dirr & CPU_PRI_FILE, note, char)
  res2 = CheckExist(scn, ls, dirr & CPU_SEC_FILE, note, char)
  If Not res1 Or Not res2 Then
  	CheckCPUExist = False
  Else
  	CheckCPUExist = True
  End If
End Function
'=======================================

'=======================================
' Download CPU scripts from tool server
'=======================================
Function DownloadFromTool
  ' Connect to tool server
  Set tabTool = crt.Session.ConnectInTab("/ssh2 /L " & TOOL_USER & " /PASSWORD " & TOOL_PASS & " " & TOOL_IP, , True)
  If Not tabTool.Session.Connected Then
    MsgBox "Cannot connect to tool server!"
    DownloadFromTool = False
    Exit Function
  End If
  
  Set scnTool = tabTool.Screen
  scnTool.Synchronous = True
  scnTool.WaitForStrings(TOOL_CHAR)

  ' Check CPU scripts exist on tool server
  res = CheckCPUExist(scnTool, TOOL_LS, TOOL_DIR, TOOL_NOTE, TOOL_CHAR)
  If Not res Then
  	' If not both exist, exit script
  	MsgBox "CPU scripts not found on tool server!"
  	DownloadFromTool = False
  	Exit Function
  End If

	' If both exist, download to local PC
  Set tabSftp = tabTool.ConnectSftp
  Set scnSftp = tabSftp.Screen
  scnSftp.Synchronous = True
  scnSftp.WaitForStrings(SFTP_CHAR)

  ' Check CPU directory exist on local PC, if not, create
  res = CheckExist(scnSftp, LOCAL_LS, LOCAL_DIR, SFTP_NOTE, SFTP_CHAR)
  If Not res Then
    SendCmdBack scnSftp, LOCAL_MKDIR & " " & LOCAL_DIR, SFTP_CHAR
  End If

	' Download result files
	SendCmdBack scnSftp, LOCAL_CD & " " & LOCAL_DIR, SFTP_CHAR
	SendCmdBack scnSftp, "get " & TOOL_DIR & CPU_PRI_FILE, SFTP_CHAR
	SendCmdBack scnSftp, "get " & TOOL_DIR & CPU_SEC_FILE, SFTP_CHAR
  DownloadFromTool = True
End Function
'=======================================

'=======================================
' Upload CPU scripts from local
'=======================================
Function UploadFromLocal(tabb)
  Set tabSftp = tabb.ConnectSftp
  Set scnSftp = tabSftp.Screen
  scnSftp.Synchronous = True
  scnSftp.WaitForStrings(SFTP_CHAR)
  
  ' Check CPU scripts exist on local PC
  res1 = CheckCPUExist(scnSftp, LOCAL_LS, LOCAL_DIR, SFTP_NOTE, SFTP_CHAR)
  res2 = CheckCPUExist(scnSftp, LOCAL_LS, LOCAL_DIR, SFTP_NOTE2, SFTP_CHAR)
  If Not res1 Or Not res2 Then
  	' If not both exist, download from tool server
  	res = DownloadFromTool
  	If Not res Then
  		UploadFromLocal = False
  		Exit Function
    End If
  End If
  
  ' If both exist, or downloaded from tool server successfully, upload to OMCP
  ' Check root directory exist on active OMCP, if not, create
  res = CheckExist(scnSftp, OMCP_LS, OMCP_DIR, SFTP_NOTE, SFTP_CHAR)
  If Not res Then
    SendCmdBack scnSftp, OMCP_MKDIR & " " & OMCP_DIR, SFTP_CHAR
  End If

	' Download result files
	SendCmdBack scnSftp, OMCP_CD & " " & OMCP_DIR, SFTP_CHAR
	SendCmdBack scnSftp, "put " & LOCAL_DIR & CPU_PRI_FILE, SFTP_CHAR
	SendCmdBack scnSftp, "put " & LOCAL_DIR & CPU_SEC_FILE, SFTP_CHAR

  UploadFromLocal = True
End Function
'=======================================

'=======================================
' Download result files to local
'=======================================
Function DownloadResult(tabb)
  Set scn = tabb.Screen
  res = CheckExist(scn, OMCP_LS, CPU_DIR, OMCP_NOTE, OMCP_CHAR)
  If Not res Then
  	MsgBox "No result file generated!"
  	DownloadResult = False
  	Exit Function
  End If
  
  Set tabSftp = tabb.ConnectSftp
  Set scnSftp = tabSftp.Screen
  scnSftp.Synchronous = True
  scnSftp.WaitForStrings(SFTP_CHAR)
  
  ' Check CPU directory exist on local PC, if not create
  res = CheckExist(scnSftp, LOCAL_LS, LOCAL_DIR, SFTP_NOTE, SFTP_CHAR)
  If Not res Then
    SendCmdBack scnSftp, LOCAL_MKDIR & " " & LOCAL_DIR, SFTP_CHAR
  End If
  dirName = GetDirName
	SendCmdBack scnSftp, LOCAL_MKDIR & " " & LOCAL_DIR & dirName, SFTP_CHAR

	' Download result files
	SendCmdBack scnSftp, LOCAL_CD & " " & LOCAL_DIR & dirName, SFTP_CHAR
	SendCmdBack scnSftp, "get " & CPU_DIR & "*", SFTP_CHAR
  DownloadResult = True
End Function
'=======================================

'=======================================
' Main Sub
'=======================================
Sub Main
  On Error Resume Next

  ' Read params from ini file
  res = ReadCfg
  If Not res Then
    Exit Sub
  End If 

  ' Connect to active OMCP
  Set tabOMCP = crt.Session.ConnectInTab("/ssh2 /L " & OMCP_USER & " /PASSWORD " & OMCP_PASS & " " & OMCP_ACT_IP, , True)
  If Not tabOMCP.Session.Connected Then
    MsgBox "Cannot connect to active OMCP!"
    Exit Sub
  End If
  
  Set scnOMCP = tabOMCP.Screen
  scnOMCP.Synchronous = True
  scnOMCP.WaitForStrings(OMCP_CHAR)
  
  ' Check CPU scripts exist on active OMCP
  res = CheckCPUExist(scnOMCP, OMCP_LS, OMCP_DIR, OMCP_NOTE, OMCP_CHAR)
  If Not res Then
  	' If not both exist, upload from local
  	res = UploadFromLocal(tabOMCP)
  	If Not res Then
  		Exit Sub
    End If
  End If
	SendCmdBack scnOMCP, "chmod 755 " & CPU_PRI_FILE & " " & CPU_SEC_FILE, OMCP_CHAR
  
  ' Run script and wait for result
  dur = GetDuration
  tabOMCP.Activate
  SendCmdBack scnOMCP, "date", OMCP_CHAR
  SendCmdBack scnOMCP, "./" & CPU_PRI_FILE & " " & dur, OMCP_CHAR
  
  res = DownloadResult(tabOMCP)
  If res Then
  	MsgBox "CPU files get successfully!"
  End If
End Sub
'=======================================