Attribute VB_Name = "Module1"
' With the macro below it is possible to compare the content of two worksheets.
' The result is displayed in a new workbook listing all cell differences.

Dim RES, bAdvanceMode As Boolean, bFinalResult As Boolean
Sub TestCompareWorksheets()
    
    bAdvanceMode = False
    bFinalResult = True
    
    
    RES = counterlogiccheck()

    If bAdvanceMode = True Then
        Application.ScreenUpdating = False
    
       Set app = CreateObject("Excel.application")
      Set wbk = app.Workbooks.Open("D:\daydayup\script\VBS\ExcelCompare\pm_check_v2\standard.xls")
    
       For I = 1 To wbk.Worksheets.Count
          RES = CompareWorksheets(ActiveWorkbook.Worksheets(I), wbk.Worksheets(I))
     Next I
    
    wbk.Close
        
     Application.ScreenUpdating = True
       
    End If

    If bFinalResult = True Then
        MsgBox ("Execute finished! All checks passed! No problem!")
    Else
        MsgBox ("Execute finished! There are errors in this PM report!Please check the pink color items!")
    End If
    
End Sub
Private Function counterlogiccheck()
    Dim a718 As Long, b718 As Long, c718 As Long, d718 As Long, e718 As Long, f718 As Long, a140 As Long, b140 As Long
    Dim a975 As Long, b975 As Long, c975 As Long, d975 As Long
    Dim delta As Long
    Dim sum718 As Long, all718 As Long
    Dim calldroprate As Double
    Dim sh_bsc As Excel.Worksheet, sh_type1122 As Excel.Worksheet, sh_type1126 As Excel.Worksheet, sh_type1130 As Excel.Worksheet

    ' set sheets
    Set sh_type1122 = Worksheets("type_1122")
    Set sh_type1126 = Worksheets("type_1126")
    Set sh_type1130 = Worksheets("type_1130")
    Set sh_bsc = Worksheets("BSC")
    
    ' get counter values
    a718 = Val(sh_type1126.Cells(3, 1).Value)
    b718 = Val(sh_type1126.Cells(4, 1).Value)
    c718 = Val(sh_type1126.Cells(5, 1).Value)
    d718 = Val(sh_type1126.Cells(6, 1).Value)
    e718 = Val(sh_type1126.Cells(7, 1).Value)
    f718 = Val(sh_type1126.Cells(8, 1).Value)
    a140 = Val(sh_type1122.Cells(4, 1).Value)
    b140 = Val(sh_type1122.Cells(5, 1).Value)
    a975 = Val(sh_type1126.Cells(25, 1).Value)
    b975 = Val(sh_type1126.Cells(26, 1).Value)
    c975 = Val(sh_type1126.Cells(27, 1).Value)
    d975 = Val(sh_type1126.Cells(28, 1).Value)
    calldroprate = Val(sh_bsc.Cells(61, 10).Value)
    
    ' call drop rate should be zero
    If calldroprate <> 0 Then
        RES = MarkCell(sh_bsc.Range("J61"), sh_bsc)
        MsgBox ("call drop rate is not zero!")
        'sh_bsc.Range("J61").Select
        ' RES = MarkCell(sh_type1126.Cells(3, 1))
    End If
    
    ' MC718 = sum of MC718a, MC718b, MC718c, MC718d, MC718e and MC718f
    all718 = Val(sh_type1130.Cells(48, 1).Value)
    sum718 = a718 + b718 + c718 + d718 + e718 + f718
    delta = Abs(all718 - sum718)
    If delta > 50 Then
        RES = MarkCell(sh_type1126.Range("A3", "A8"), sh_type1126)
        'RES = MarkCell(sh_type1126.Range("A32", "A37"), sh_type1126)
        RES = MarkCell(sh_type1130.Range("A48"), sh_type1130)
        'RES = MarkCell(sh_type1130.Range("A107"), sh_type1130)
        MsgBox ("MC718 = sum(MC718a, MC718b, MC718c, MC718d, MC718e, MC718f) check failed")
        'sh_type1126.Range("A3").Select
        ' RES = MarkCell(sh_type1126.Cells(3, 1))
    End If


    ' MC140a >= MC140b
    If a140 < b140 Then
       RES = MarkCell(sh_type1122.Range("A4", "A5"), sh_type1122)
       'RES = MarkCell(sh_type1122.Range("A81", "A82"), sh_type1122)
       MsgBox ("MC140a >= MC140b check failed")
        'sh_type1122.Range("A4").Select
        'sub140ab = True
    End If

    ' MC718 <= MC140a
    If all718 > a140 Then
        RES = MarkCell(sh_type1130.Range("A48"), sh_type1130)
        'RES = MarkCell(sh_type1130.Range("A107"), sh_type1130)
        RES = MarkCell(sh_type1122.Range("A4"), sh_type1122)
        'RES = MarkCell(sh_type1122.Range("A81"), sh_type1122)
        MsgBox ("MC718 <= MC140a check failed")
        'sh_type1122.Range("A48").Select
    End If

    'MC975a >= MC975c >= MC975d >= MC975b
    If (c975 - a975) > 10 Or (d975 - c975) > 10 Or (b975 - d975) > 10 Then
       RES = MarkCell(sh_type1126.Range("A25", "A28"), sh_type1126)
       'RES = MarkCell(sh_type1126.Range("A54", "A57"), sh_type1126)
       MsgBox ("MC975a >= MC975c >= MC975d >= MC975b check failed")
       'sh_type1126.Range("A25").Select
    End If

End Function

Private Function CompareWorksheets(ws1 As Worksheet, ws2 As Worksheet)
    Dim cell As Range
    Dim cf1 As Double, cf2 As Double
    Dim delta2 As Double, deltapercent As Double

    For Each cell In ws1.UsedRange
        If isInvalidCounter(cell) Then
            RES = MarkCell(cell, ws1)
            MsgBox ("Invalid cell was found at worksheet: " _
            & ws1.Name & " Column: " & cell.Column & " Row: " & cell.Row)
        End If
        
        If IsNumeric(cell.Value) And ws2.Cells(cell.Row, cell.Column).Value <> 0 Then
            cf1 = cell.Value
            cf2 = ws2.Cells(cell.Row, cell.Column).Value
            delta2 = Abs(cf1 - cf2)
            deltapercent = delta2 / cf2
            If Round(deltapercent, 2) > Round(0.03, 2) Then
                RES = MarkCell(cell, ws1)
                MsgBox (">3% value delta was found at: " _
                & ws1.Name & " Column: " & cell.Column & " Row: " & cell.Row)
            End If
        End If
   Next
End Function

Private Function isInvalidCounter(cl As Range)
    Dim var As String
    var = cl.Value

    ' check invalid char ?, *
    If var = "?" Or var = "*" Then
        isInvalidCounter = True
    Else
        isInvalidCounter = False
    End If

End Function

Private Function MarkCell(TargetRange As Range, TargetSheet As Worksheet)
    Dim cell As Range
    For Each cell In TargetRange
        cell.Interior.ColorIndex = 38
    Next
    'TargetSheet.Tab.ColorIndex = 38
    bFinalResult = False
End Function





