# $language = "VBScript"
# $interface = "1.0"

'=======================================
' Version: 1.1
' Author: LB
' Usage:
' 1) Connect Abis lsu & remote
' 2) Connect A lsu & remote
' 3) Start Abis & A lsu
' 4) Init A & Abis remote
' 5) Reg A remote
' 6) Wait for cell bar (50*7sec)
' 7) Reg Abis remote
' 8) Wait for all Abis lsu reg finish (no new output)
' 9) Run Abis & A remote
' 10) Run erlang_loop on Abis remote
' Update:
' V1.0: 2012-10-24 First version.
' V1.1: 2012-10-25 Read params from ini file.
'=======================================

'=========================================================
' Configurations here
'=========================================================
Const INI_NAME = "run_traffic_v1.1.ini"
Const SEP_CHAR = "="
'=========================================================

'=======================================
' Parameters
'=======================================
Dim TSTM_ABIS_DIR
Dim TSTM_ABIS_LSU_DIR
Dim TSTM_ABIS_LSU_NAM()
Dim TSTM_ABIS_REM_DIR
Dim TSTM_ABIS_REM_NAM

Dim TSTM_A_DIR
Dim TSTM_A_LSU_DIR
Dim TSTM_A_LSU_NAM
Dim TSTM_A_REM_DIR
Dim TSTM_A_REM_NAM

Dim TSTM_ABIS_START_CMD
Dim TSTM_ABIS_INIT_CMD
Dim TSTM_ABIS_REG_CMD
Dim TSTM_ABIS_RUN_CMD

Dim TSTM_A_START_CMD
Dim TSTM_A_INIT_CMD
Dim TSTM_A_REG_CMD
Dim TSTM_A_RUN_CMD

Dim CELL_BAR_TIM
Dim CELL_BAR_NUM

numTstmAbis = 0
'=======================================

'=======================================
' Push one Abis test manager name into array
'=======================================
Sub PushAbisName(abis)
  numTstmAbis = numTstmAbis+1
  ReDim Preserve TSTM_ABIS_LSU_NAM(numTstmAbis)
  TSTM_ABIS_LSU_NAM(numTstmAbis-1) = abis
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
    Case "TSTM_ABIS_DIR"
      TSTM_ABIS_DIR = res(1)
    Case "TSTM_ABIS_LSU_DIR"
      TSTM_ABIS_LSU_DIR = res(1)
    Case "TSTM_ABIS_LSU_NAM"
      PushAbisName res(1)
    Case "TSTM_ABIS_REM_DIR"
      TSTM_ABIS_REM_DIR = res(1)
    Case "TSTM_ABIS_REM_NAM"
      TSTM_ABIS_REM_NAM = res(1)

    Case "TSTM_A_DIR"
      TSTM_A_DIR = res(1)
    Case "TSTM_A_LSU_DIR"
      TSTM_A_LSU_DIR = res(1)
    Case "TSTM_A_LSU_NAM"
      TSTM_A_LSU_NAM = res(1)
    Case "TSTM_A_REM_DIR"
      TSTM_A_REM_DIR = res(1)
    Case "TSTM_A_REM_NAM"
      TSTM_A_REM_NAM = res(1)

    Case "TSTM_ABIS_START_CMD"
      TSTM_ABIS_START_CMD = res(1)
    Case "TSTM_ABIS_INIT_CMD"
      TSTM_ABIS_INIT_CMD = res(1)
    Case "TSTM_ABIS_REG_CMD"
      TSTM_ABIS_REG_CMD = res(1)
    Case "TSTM_ABIS_RUN_CMD"
      TSTM_ABIS_RUN_CMD = res(1)

    Case "TSTM_A_START_CMD"
      TSTM_A_START_CMD = res(1)
    Case "TSTM_A_INIT_CMD"
      TSTM_A_INIT_CMD = res(1)
    Case "TSTM_A_REG_CMD"
      TSTM_A_REG_CMD = res(1)
    Case "TSTM_A_RUN_CMD"
      TSTM_A_RUN_CMD = res(1)

    Case "CELL_BAR_TIM"
      CELL_BAR_TIM = res(1)
    Case "CELL_BAR_NUM"
      CELL_BAR_NUM = res(1)
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
' Print all Abis test manager name
'=======================================
Sub PrintAbisName
  For i = 0 to numTstmAbis-1
    MsgBox "TSTM_ABIS_LSU_NAM(" & i & ") = " & TSTM_ABIS_LSU_NAM(i)
  Next
End Sub
'=======================================

'=======================================
' Print all configuration
'=======================================
Sub PrintCfg
  MsgBox "TSTM_ABIS_DIR = " & TSTM_ABIS_DIR
  MsgBox "TSTM_ABIS_LSU_DIR = " & TSTM_ABIS_LSU_DIR
  PrintAbisName
  MsgBox "TSTM_ABIS_REM_DIR = " & TSTM_ABIS_REM_DIR
  MsgBox "TSTM_ABIS_REM_NAM = " & TSTM_ABIS_REM_NAM

  MsgBox "TSTM_A_DIR = " & TSTM_A_DIR
  MsgBox "TSTM_A_LSU_DIR = " & TSTM_A_LSU_DIR
  MsgBox "TSTM_A_LSU_NAM = " & TSTM_A_LSU_NAM
  MsgBox "TSTM_A_REM_DIR = " & TSTM_A_REM_DIR
  MsgBox "TSTM_A_REM_NAM = " & TSTM_A_REM_NAM

  MsgBox "TSTM_ABIS_START_CMD = " & TSTM_ABIS_START_CMD
  MsgBox "TSTM_ABIS_INIT_CMD = " & TSTM_ABIS_INIT_CMD
  MsgBox "TSTM_ABIS_REG_CMD = " & TSTM_ABIS_REG_CMD
  MsgBox "TSTM_ABIS_RUN_CMD = " & TSTM_ABIS_RUN_CMD

  MsgBox "TSTM_A_START_CMD = " & TSTM_A_START_CMD
  MsgBox "TSTM_A_INIT_CMD = " & TSTM_A_INIT_CMD
  MsgBox "TSTM_A_REG_CMD = " & TSTM_A_REG_CMD
  MsgBox "TSTM_A_RUN_CMD = " & TSTM_A_RUN_CMD

  MsgBox "CELL_BAR_TIM = " & CELL_BAR_TIM
  MsgBox "CELL_BAR_NUM = " & CELL_BAR_NUM
End Sub
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
' Generate log file name according to date
'=======================================
Function GetLogName
	nameDate = Year(Now) & "-" & DateAddZero(Month(Now)) & "-" & DateAddZero(Day(Now))
	nameTime = DateAddZero(Hour(Now)) & "-" & DateAddZero(Minute(Now)) & "-" & DateAddZero(Second(Now))
	GetLogName = "erlang_" & nameDate & "_" & nameTime & ".log"
End Function
'=======================================

'=======================================
' Main Sub
'=======================================
Sub main
  ' Read params from ini file
  res = ReadCfg
  If Not res Then
    Exit Sub
  End If 

  Set sess = crt.session
  
  ' Connect to Abis & A test manager
  ReDim tabTstmAbisLsu(numTstmAbis)
  For i = 0 to numTstmAbis-1
    Set tabTstmAbisLsu(i) = sess.ConnectInTab("/s " & TSTM_ABIS_DIR & "/" & TSTM_ABIS_LSU_NAM(i), True, True)
    tabTstmAbisLsu(i).Screen.Send("cd " & TSTM_ABIS_LSU_DIR & vbcr) 
  Next
  Set tabTstmAbisRem = sess.ConnectInTab("/s " & TSTM_ABIS_DIR & "/" & TSTM_ABIS_REM_NAM, True, True)
  tabTstmAbisRem.Screen.Send("cd " & TSTM_ABIS_REM_DIR & vbcr)
  Set tabTstmALsu = sess.ConnectInTab("/s " & TSTM_A_DIR & "/" & TSTM_A_LSU_NAM, True, True)
  tabTstmALsu.Screen.Send("cd " & TSTM_A_LSU_DIR & vbcr)  
  Set tabTstmARem = sess.ConnectInTab("/s " & TSTM_A_DIR & "/" & TSTM_A_REM_NAM, True, True)
  tabTstmARem.Screen.Send("cd " & TSTM_A_REM_DIR & vbcr)  

  ' Start Abis & A test manager
  For i = 0 to numTstmAbis-1
    tabTstmAbisLsu(i).Activate
    tabTstmAbisLsu(i).Screen.Send(TSTM_ABIS_START_CMD & vbcr)
    tabTstmAbisLsu(i).Screen.WaitForString("MultiSchedule.tsm Started")
    tabTstmAbisLsu(i).Screen.Send(vbcr)
  Next
  tabTstmALsu.Activate
  tabTstmALsu.Screen.Send(TSTM_A_START_CMD & vbcr)
  tabTstmALsu.Screen.WaitForString("MultiSchedule.tsm Started")
  tabTstmALsu.Screen.Send(vbcr)

  ' Init A test manager
  tabTstmARem.Activate
  tabTstmARem.Screen.Send(TSTM_A_INIT_CMD & vbcr)
  tabTstmARem.Screen.WaitForString("$")

  ' Init Abis test manager
  tabTstmAbisRem.Activate
  tabTstmAbisRem.Screen.Send(TSTM_ABIS_INIT_CMD & vbcr)
  tabTstmAbisRem.Screen.WaitForString("$")

  ' Reg A test manager
  tabTstmALsu.Activate
  Do While res = 1
    res = tabTstmALsu.Screen.WaitForString(">", 1)
  Loop
  tabTstmARem.Activate
  tabTstmARem.Screen.Send(TSTM_A_REG_CMD & vbcr)  

  ' Wait for cell bar
  crt.Sleep CELL_BAR_TIM*CELL_BAR_NUM*1000

  ' Reg Abis test manager
  tabTstmAbisRem.Activate
  tabTstmAbisRem.Screen.Send(TSTM_ABIS_REG_CMD & vbcr)  
  tabTstmAbisRem.Screen.WaitForString("$")

  ' Check reg finished
  crt.Sleep 2*60*1000
  For i = 0 to numTstmAbis-1
    tabTstmAbisLsu(i).Activate
    res = 1
    Do While res = 1
      res = tabTstmAbisLsu(i).Screen.WaitForString(">", 2)
    Loop
  Next
  
  ' Run Abis & A test manager
  tabTstmAbisRem.Activate
  tabTstmAbisRem.Screen.Send(TSTM_ABIS_RUN_CMD & vbcr)  
  tabTstmAbisRem.Screen.WaitForString("$")
  tabTstmARem.Activate
  tabTstmARem.Screen.Send(TSTM_A_RUN_CMD & vbcr)  
  tabTstmARem.Screen.WaitForString("$")
  
  ' Run erlang_loop
  logName = GetLogName
  tabTstmAbisRem.Activate
  tabTstmAbisRem.Screen.Send("./erlang_loop | tee " & logName & vbcr)
End Sub
'=======================================