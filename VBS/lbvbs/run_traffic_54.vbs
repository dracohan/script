# $language = "VBScript"
# $interface = "1.0"

'=========================================================
' Configure here!
'=========================================================
TSTM_ABIS_DIR = "tdm_nominal4500_new_tstm"
TSTM_ABIS_LSU_DIR = "."
TSTM_ABIS_LSU_NAM = Array("tstmabis1", "tstmabis2", "tstmabis3", "tstmabis4", "tstmabis5", "tstmabis6", "tstmabis7")
TSTM_ABIS_REM_DIR = "."
TSTM_ABIS_REM_NAM = "tstmabis_remote"
TSTM_A_DIR = "tdm_hsl_a"
TSTM_A_LSU_DIR = "lsu"
TSTM_A_LSU_NAM = "mx20ca_lsu"
TSTM_A_REM_DIR = "remote/Nom4500"
TSTM_A_REM_NAM = "mx20ca_remote"

TSTM_ABIS_START_CMD = "./start*"
TSTM_ABIS_INIT_CMD = "./init_all_abis"
TSTM_ABIS_REG_CMD = "./reg_all_abis"
TSTM_ABIS_RUN_CMD = "./run_all_abis"
TSTM_A_START_CMD = "./start_a_MX20C"
TSTM_A_INIT_CMD = "./init_a_MX20C*"
TSTM_A_REG_CMD = "./reg_a_MX20C*"
TSTM_A_RUN_CMD = "./run_a_MX20C*"

CELL_BAR_TIM = 50
CELL_BAR_NUM = 7
'=========================================================

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

Set scn = crt.screen
Set sess = crt.session

Sub main
  ' Connect to Abis & A test manager
  numTstmAbis = UBound(TSTM_ABIS_LSU_NAM)+1
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
    tabTstmAbisLsu(i).Screen.Send(TSTM_ABIS_START_CMD & vbcr)
    tabTstmAbisLsu(i).Screen.WaitForString("MultiSchedule.tsm Started")
    tabTstmAbisLsu(i).Screen.Send(vbcr)
  Next
  tabTstmALsu.Screen.Send(TSTM_A_START_CMD & vbcr)
  tabTstmALsu.Screen.WaitForString("MultiSchedule.tsm Started")
  tabTstmALsu.Screen.Send(vbcr)

  ' Init A test manager
  tabTstmARem.Screen.Send(TSTM_A_INIT_CMD & vbcr)
  tabTstmARem.Screen.WaitForString("$")

  ' Init Abis test manager
  tabTstmAbisRem.Screen.Send(TSTM_ABIS_INIT_CMD & vbcr)
  tabTstmAbisRem.Screen.WaitForString("$")

  ' Reg A test manager
  Do While res = 1
    res = tabTstmALsu.Screen.WaitForString(">", 1)
  Loop
  tabTstmARem.Screen.Send(TSTM_A_REG_CMD & vbcr)  

  ' Wait for cell bar
  crt.Sleep CELL_BAR_TIM*CELL_BAR_NUM*1000

  ' Reg Abis test manager
  tabTstmAbisRem.Screen.Send(TSTM_ABIS_REG_CMD & vbcr)  
  tabTstmAbisRem.Screen.WaitForString("$")

  ' Check reg finished
  crt.Sleep 2*60*1000
  For i = 0 to numTstmAbis-1
    res = 1
    Do While res = 1
      res = tabTstmAbisLsu(i).Screen.WaitForString(">", 2)
    Loop
  Next
  
  ' Run Abis & A test manager
  tabTstmAbisRem.Screen.Send(TSTM_ABIS_RUN_CMD & vbcr)  
  tabTstmAbisRem.Screen.WaitForString("$")
  tabTstmARem.Screen.Send(TSTM_A_RUN_CMD & vbcr)  
  tabTstmARem.Screen.WaitForString("$")
  
  ' Run erlang_loop
  logName = GetLogName
  tabTstmAbisRem.Screen.Send("./erlang_loop | tee " & logName & vbcr)
End Sub