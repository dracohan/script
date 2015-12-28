' With the macro below it is possible to compare the content of two worksheets.
' The result is displayed in a new workbook listing all cell differences.
Dim app As Excel.Application
Dim wbk As Excel.Workbook
Dim res

Private Function CompareWorksheets(ws1 As Worksheet, ws2 As Worksheet)
    Dim cell As Range

    For Each cell In ws1.UsedRange
        If isInvalidCounter(cell) Or isInvalidCounter(ws2.Cells(cell.Row, cell.Column)) Then
            MsgBox("invalid PM counters")
        End If

        If IsNumeric(cell.Value) And IsNumeric(ws2.Cells(cell.Row, cell.Column)) Then
            ' MsgBox (cell)
            ' MsgBox (ws2.Cells(cell.Row, cell.Column))
            res = CompareCells(cell, ws2.Cells(cell.Row, cell.Column))
        End If
    Next

End Function

Private Function isInvalidCounter(cl As Range)
    Dim var As String
    Dim isInvalidCounter As Boolean
    var = cl.Value

    If var = "?" Or var = "*" Then
        isInvalidCounter = True
    Else
        isInvalidCounter = False
    End If

End Function

Private Function CompareCells(cl1 As Range, cl2 As Range)
    Dim cf1 As Double, cf2 As Double
    Dim DiffCount As Integer
    Dim delta As Double, deltapercent As Double

    On Error Resume Next
    cf1 = cl1.Value
    cf2 = cl2.Value
    On Error GoTo 0
    delta = cf1 - cf2
    deltapercent = delta / cf2

    If deltapercent > 0.03 Then
        DiffCount = DiffCount + 1
        cl1.Formula = "'" & cf1 & " <> " & cf2
    End If

End Function

Private Function counterlogiccheck()
    Dim a718 As Long, b718 As Long, c718 As Long, d718 As Long, e718 As Long, f718 As Long, a140 As Long, b140 As Long
    Dim a975 As Long, b975 As Long, c975 As Long, d975 As Long
    Dim delta As Long
    Dim sum718 As Long, all718 As Long
    Dim sh_type1122 As Excel.Worksheet, sh_type1126 As Excel.Worksheet, sh_type1130 As Excel.Worksheet

    sh_type1122 = Worksheets("type_1122")
    sh_type1126 = Worksheets("type_1126")
    sh_type1130 = Worksheets("type_1130")

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
    c975 = Val(sh_type1126.Cells(26, 1).Value)
    d975 = Val(sh_type1126.Cells(26, 1).Value)

    ' MC718 = sum of MC718a, MC718b, MC718c, MC718d, MC718e and MC718f
    all718 = Val(sh_type1130.Cells(48, 1).Value)
    sum718 = a718 + b718 + c718 + d718 + e718 + f718
    delta = Abs(all718 - sum718)
    If delta > 100 Then
        MsgBox("MC718 is not equal to sum of MC718a, MC718b, MC718c, MC718d, MC718e, MC718f")
    End If


    ' MC140a >= MC140b
    If a140 < b140 Then
        MsgBox("MC140a is less than MC140b")
    End If

    ' MC718 >= MC140a
    If all718 > a140 Then
        MsgBox("MC718 greater than MC140a!")
    End If

    'MC975a >= MC975c >= MC975d >= MC975b
    If (c975 - a975) > 10 Or (d975 - c975) > 10 Or (b975 - d975) > 10 Then
        MsgBox("MC975a >= MC975c >= MC975d >= MC975b is not true!")
    End If

End Function

Sub TestCompareWorksheets()
    Dim I As Integer

    ' Turn off screen updating to improve performance
    Application.ScreenUpdating = False
    On Error Resume Next

    ' Open standard PM report stored at D:\学习\script\VBS\ExcelCompare\PM\f.xls
    app = CreateObject("Excel.application")
    wbk = app.Workbooks.Open("D:\学习\script\VBS\ExcelCompare\PM\f.xls")

    ' Perform PM counter logical test
    res = counterlogiccheck()

    ' compare each worksheet
    For I = 1 To wbk.Worksheets.Count
        res = CompareWorksheets(ActiveWorkbook.Worksheets(I), wbk_codec.Worksheets(I))
    Next I

    ' cleanup
    res = Err.Clear()
    Application.ScreenUpdating = True
    app = Nothing

End Sub



