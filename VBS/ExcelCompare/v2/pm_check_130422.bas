' List all check counters, and check the counters normal or not.

        Dim app_PM As Excel.Application
        Dim sht_out, sht_in As Excel.Worksheet
'       Dim sht_tmp As Excel.Worksheet
        Dim str1 As String
        Dim row_out, col_out As Integer
        Dim res
        
Sub Check_PM()
'        Set app_PM = CreateObject("Excel.application")
        Set sht_out = Worksheets("sheet3")
'                       Set sht_tmp = Worksheets("sheet2")
  sht_out.Range("A1:IV65536").Clear
  sht_out.Cells(1, 1) = "Name"
  sht_out.Cells(1, 2) = "Result"
  sht_out.Cells(1, 3) = "Standard & Comments"
  row_out = 2
  col_out = 2
  
   On Error Resume Next
   Set sht_in = Worksheets("BSC")
   If Err.Number = 0 Then
         sht_out.Cells(2, 1) = "PM Test duration"
         sht_in.Cells(3, 10) = sht_in.Cells(3, 9)
         str1 = Format(sht_in.Cells(3, 9), "h:mm:ss")
          sht_out.Cells(2, 2) = str1
   Else
     MsgBox "BSC sheet does not exist!", 16
   End If
   

  res = list_cnt_1("Abis efficient load", "BSC", "")
  res = list_cnt_1("Call drop rate", "BSC", "=0")
	res = list_cnt_1("CLR request radio interface message failure", "BSC", "=0")        
	res = list_cnt_1("CLR request O&M intervention", "BSC", "=0")        
	res = list_cnt_1("CLR request equipment failure", "BSC", "=0")        
	res = list_cnt_1("CLR request radio interface failure", "BSC", "=0")      
  res = list_cnt_1("RTCH assignment congestion rate", "BSC", "<=0.005")
  res = list_cnt_1("Duration average (sec)", "BSC", "about 50s")
  res = list_cnt_2("sum(AIP10b)", "type_1146", "SENT_UL_RTP_PACKETS")
  res = list_cnt_2("sum(AIP12)", "type_1146", "NOT_RCVD_DL_RTP_PACKETS")
  res = list_cnt_2("sum(AIP10e)","type_1146", "RCVD_DL_RTP_PACKETS")
  res = list_cnt_2("sum(AIP11)","type_1146", "NB_BSC_RCVD_DL_RTP_PACKETS_OUT_OF_DELAY")
  res = list_cnt_2("sum(AIP20b)","type_1146", "SENT_UL_MUXRTP_PACKETS")
  res = list_cnt_2("sum(AIP20e)","type_1146", "RCVD_DL_MUXRTP_PACKETS")
  res = list_cnt_2("sum(MC718)","type_1130","TCH_ASS_SUCC_TRX")
  res = list_cnt_2("sum(MC718a)", "type_1126", "FR_ASS_COMP")
  res = list_cnt_2("sum(MC718b)", "type_1126", "HR_ASS_COMP")
  res = list_cnt_2("sum(MC718c)", "type_1126", "EFR_ASS_COMP")
  res = list_cnt_2("sum(MC718d)", "type_1126", "FR_AMR_ASS_COMP")
  res = list_cnt_2("sum(MC718e)", "type_1126", "HR_AMR_ASS_COMP")
  res = list_cnt_2("sum(MC718f)", "type_1126", "AMR_WB_GMSK_ASS_COMP")
  res = list_cnt_2("sum(MC718j)", "type_1126", "")
  res = list_cnt_2("sum(MC975a)", "type_1126", "")
  res = list_cnt_2("sum(MC975c)", "type_1126", "")
  res = list_cnt_2("sum(MC975d)", "type_1126", "")
  res = list_cnt_2("sum(MC975b)", "type_1126", "")
  res = Counter_Check()
    
  app_PM.Quit
  Set app_PM = Nothing
        
End Sub


Private Function list_cnt_1(name As String, subtype As String, std_name As String)
    Dim sht_pm As Excel.Worksheet
    Dim str_sheet As String
    Dim c As Range
    Dim row1, col1 As Integer

   
   str_sheet = subtype
   On Error Resume Next
   Set sht_pm = Worksheets(str_sheet)
   If Err.Number = 0 Then
'   MsgBox str_sheet & "sheet exist."
   	Set c = sht_pm.Cells.Find(name)
   	row1 = c.Row
   	col1 = c.Column
   	row_out = row_out + 1
   
        sht_out.Cells(row_out, col_out - 1) = name
        sht_out.Cells(row_out, col_out) = sht_pm.Cells(row1, col1 + 3)
        sht_out.Cells(row_out, col_out + 1) = std_name
   				If std_name = "=0" Then
   				     If sht_out.Cells(row_out, col_out)<>0 Then 
   				     		sht_out.Cells(row_out, col_out).Interior.ColorIndex = 38
   				     	End If
   				End If
    Else
   MsgBox str_sheet & "sheet does not exist!", 16
         End If
   

End Function

Private Function list_cnt_2(name As String, subtype As String, std_name As String)
    Dim sht_pm As Excel.Worksheet
    Dim str_sheet As String
    Dim c As Range
    Dim row1, col1 As Integer
   
   str_sheet = subtype
   On Error Resume Next
   Set sht_pm = Worksheets(str_sheet)
   If Err.Number = 0 Then
  ' MsgBox str_sheet & "sheet exist."
   Set c = sht_pm.Cells.Find(name)
   row1 = c.Row
   col1 = c.Column
        row_out = row_out + 1
        sht_out.Cells(row_out, col_out - 1) = name
        sht_out.Cells(row_out, col_out) = sht_pm.Cells(row1, col1 - 2)
        sht_out.Cells(row_out, col_out + 1) = std_name
Else
   MsgBox str_sheet & "sheet does not exist!", 16
End If
End Function

Private Function Counter_Check()
                Dim d As Range
                Dim cnt1 As Single
                Dim aip10b, c718a, c718b, c718c, c718d, c718e, c718f, c718j, c975a, c975c, c975d, c975b As Long
                Dim call_dur As Integer

'   Set d = sht_out.Cells.Find("Call drop rate")
'   cnt1 = sht_out.Cells(d.Row, d.Column + 1)
'                                If cnt1 <> 0 Then
'                                sht_out.Cells(d.Row, d.Column + 1).Interior.ColorIndex = 38
'                                End If

  Set d = sht_out.Cells.Find("RTCH assignment congestion rate")
        cnt1 = sht_out.Cells(d.Row, d.Column + 1)
                                If (cnt1 < 0) Or (cnt1 > 0.005) Then
                                sht_out.Cells(d.Row, d.Column + 1).Interior.ColorIndex = 38
                                End If
    Set d = sht_out.Cells.Find("Duration average (sec)")
    		call_dur = sht_out.Cells(d.Row, d.Column + 1)
    		                        If (call_dur > 51) Or (call_dur < 49) Then
                                sht_out.Cells(d.Row, d.Column + 1).Interior.ColorIndex = 38
                                End If

                Set d = sht_out.Cells.Find("sum(AIP10b)")
                aip10b = sht_out.Cells(d.Row, d.Column + 1)
              
            If aip10b = 0 Then
                Else
                Set d = sht_out.Cells.Find("sum(MC718a)")
                c718a = sht_out.Cells(d.Row, d.Column + 1)
                Set d = sht_out.Cells.Find("sum(MC718b)")
                c718b = sht_out.Cells(d.Row, d.Column + 1)
                Set d = sht_out.Cells.Find("sum(MC718c)")
                c718c = sht_out.Cells(d.Row, d.Column + 1)
                Set d = sht_out.Cells.Find("sum(MC718d)")
                c718d = sht_out.Cells(d.Row, d.Column + 1)
                Set d = sht_out.Cells.Find("sum(MC718e)")
                c718e = sht_out.Cells(d.Row, d.Column + 1)
                Set d = sht_out.Cells.Find("sum(MC718f)")
                c718f = sht_out.Cells(d.Row, d.Column + 1)
                Set d = sht_out.Cells.Find("sum(MC718j)")
                c718j = sht_out.Cells(d.Row, d.Column + 1)
                sht_out.Cells(d.Row, d.Column + 2) = c718a + c718b + c718c + c718d + c718e + c718f
            		If c718j = c718a + c718b + c718c + c718d + c718e + c718f Then
                  Else
                sht_out.Cells(d.Row, d.Column + 1).Interior.ColorIndex = 38
                sht_out.Cells(d.Row, d.Column + 2).Interior.ColorIndex = 38  
            		MsgBox "MC718j is not equal to sum 718a-f!", 16
                End If
          End If
                
          Set d = sht_out.Cells.Find("sum(MC975a)")      
          c975a = sht_out.Cells(d.Row, d.Column + 1)      
          Set d = sht_out.Cells.Find("sum(MC975c)")      
          c975c = sht_out.Cells(d.Row, d.Column + 1) 
          	If c975a < c975c Then
          	 sht_out.Cells(d.Row-1, d.Column + 1).Interior.ColorIndex = 38
          	 sht_out.Cells(d.Row, d.Column + 1).Interior.ColorIndex = 38
          	 'MsgBox "MC975a >= MC975c >= MC975d >= MC975b check failed", 16
          	 MsgBox "MC975a >= MC975c check failed", 16
          	End If
          
          Set d = sht_out.Cells.Find("sum(MC975d)")      
          c975d = sht_out.Cells(d.Row, d.Column + 1) 
          	If c975c < c975d Then
          sht_out.Cells(d.Row-1, d.Column + 1).Interior.ColorIndex = 38
          sht_out.Cells(d.Row, d.Column + 1).Interior.ColorIndex = 38
          MsgBox "MC975c >= MC975d check failed", 16
          	End If
          
          Set d = sht_out.Cells.Find("sum(MC975b)")      
          c975b = sht_out.Cells(d.Row, d.Column + 1) 
          	If c975d < c975b Then
          sht_out.Cells(d.Row-1, d.Column + 1).Interior.ColorIndex = 38
          sht_out.Cells(d.Row, d.Column + 1).Interior.ColorIndex = 38
          MsgBox "MC975d >= MC975b check failed", 16
          	End If
          
                                          
End Function




















