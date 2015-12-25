# $language = "VBScript"
# $interface = "1.0"
'=======================================
' Version: 1.0.0
' Author: LB
' Date: 2012-10-24
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
'=======================================
' Configurations here
'=======================================
Const SFTP_NOTE = "The system cannot find the file specified."
Const SFTP_NOTE2 = "The system cannot find the path specified."
Const SFTP_CHAR = "sftp>"

Const LOCAL_DIR = "D:/CPU-ATCA54/"
Const LOCAL_LS = "lls"
Const LOCAL_MKDIR = "lmkdir"
Const LOCAL_CD = "lcd"

Const TOOL_IP = "172.24.178.178"
Const TOOL_USER = "mxload"
Const TOOL_PASS = "mxload"
Const TOOL_DIR = "/home/mxload/Tools/CPUmeasurements/Tools/"
Const TOOL_CHAR = "]$"
Const TOOL_NOTE = "No such file or directory"
Const TOOL_LS = "ls"


Const CPU_DIR = "/var/log/CPULoad/"
Const CPU_PRI_FILE = "CPULoad.sh"
Const CPU_SEC_FILE = "proccpu.sh"

Const OMCP_ACT_IP = "172.16.33.1"
Const OMCP_USER = "root"
Const OMCP_PASS = "alcatel"
Const OMCP_DIR = "/root/"
Const OMCP_CHAR = "0#"
Const OMCP_NOTE = "No such file or directory"
Const OMCP_LS = "ls"
Const OMCP_MKDIR = "mkdir"
Const OMCP_CD = "cd"

Const DEFAULT_DUR = 30
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
res = GetDirName
MsgBox res
Exit Sub
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
  SendCmdBack scnOMCP, "date", OMCP_CHAR
  SendCmdBack scnOMCP, "./" & CPU_PRI_FILE & " " & dur, OMCP_CHAR
  
  res = DownloadResult(tabOMCP)
  If res Then
  	MsgBox "CPU files get successfully!"
  End If
End Sub
'=======================================
