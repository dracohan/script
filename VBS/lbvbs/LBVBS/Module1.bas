Attribute VB_Name = "Module1"
    Dim app_codec As Excel.Application
    Dim wbk_codec As Excel.Workbook
    Dim sht_codec As Excel.Worksheet
    Dim sht_out As Excel.Worksheet
    Dim sht_tmp As Excel.Worksheet
    
    Dim total_cell, total_trx, upp_codec, lft_pm, upp_out As Integer
    Dim cul_used As Integer
    Dim res

Sub AUPoIP_HO()

    Dim i, j As Integer

    Set app_codec = CreateObject("Excel.application")
    wbk_codec = app_codec.Workbooks.Open("D:\ѧϰ\script\VBS\lbpm\ATCA88_Codec.xls")
    Set sht_codec = wbk_codec.Worksheets("Configuration")

    Set sht_out = Worksheets("sheet1")
    Set sht_tmp = Worksheets("sheet2")
    
    total_cell = sht_codec.Cells(9, 10)
    total_trx = sht_codec.Cells(10, 10)
    upp_codec = 17
    lft_pm = 3
    upp_out = 2
    cul_used = 0
    
    res = list_info("#BTS")
    res = list_info("#Sect")
    res = list_info("Pool")
    res = list_info("Codec")
    
    res = list_counter("1126", "MC975a")
    res = list_counter("1126", "MC975b")
    res = list_counter("1126", "MC975c")
    res = list_counter("1126", "MC975d")
 '   res = list_counter("1126", "MC719c")
 '   res = list_counter("1126", "MC719d")
 '   res = list_counter("1126", "MC719e")
 '   res = list_counter("1126", "MC719f")
 '   res = list_counter("1126", "MC719g")
 '   res = list_counter("1126", "MC719h")
 '   res = list_counter("1120", "MC642")
 '   res = list_counter("1120", "MC646")
    res = list_counter("1120", "MC652")
    res = list_counter("1120", "MC656")
    res = list_counter("1120", "MC662")
    res = list_counter("1122", "MC490a")
    res = list_counter("1122", "MC490b")
    res = list_trx_counter("1130", "MC718")
      
    wbk_codec.Close
    app_codec.Quit
    Set app_codec = Nothing

End Sub

Private Function list_counter(subtype As String, counter As String)
    Dim str_sheet As String
    Dim sht_pm As Excel.Worksheet
    Dim c As Rangeif
    Dim cul_count, row_count As Integer
    Dim ci, cul_cell, row_cell As Integer
    Dim i As Integer
    Dim cul_ci, cul_codec As Integer
    
    str_sheet = "type_" + subtype
    Set sht_pm = Worksheets(str_sheet)
    
    Set c = sht_pm.UsedRange
    cul_count = c.Columns.Count - lft_pm
    row_count = Int((total_cell - 1) / cul_count) + 1
    
    Set c = sht_codec.Cells.Find("CI")if
    cul_ci = c.column
    
    Set c = sht_codec.Cells.Find("codec")
    cul_codec = c.column
    
    cul_used = cul_used + 1
    
    Set c = sht_pm.Cells.Find(counter)
    sht_out.Cells(total_cell + 1 + upp_out, cul_used) = c.row
    i = 1
    Do While i < row_count
        i = i + 1
        Set c = sht_pm.Cells.FindNext(after:=c)
        sht_out.Cells(total_cell + i + upp_out, cul_used) = c.row
    Loop
    
    sht_out.Cells(1, cul_used) = sht_pm.Cells(c.row, lft_pm - 1)
    sht_out.Cells(2, cul_used) = sht_pm.Cells(c.row, lft_pm)
    
    For i = 1 To total_cell
        ci = sht_codec.Cells(upp_codec + i - 1, cul_ci)
        row_cell = Int((ci - 1) / cul_count) + 1
        cul_cell = ci - (row_cell - 1) * cul_count + lft_pm
        
        row_cell = sht_out.Cells(row_cell + total_cell + upp_out, cul_used)
        
        sht_out.Cells(i + upp_out, cul_used) = sht_pm.Cells(row_cell, cul_cell)
        sht_out.Cells(i + upp_out, cul_used).Interior.ColorIndex = sht_codec.Cells(upp_codec + i - 1, cul_codec).Interior.ColorIndex
    Next
    
    For i = 1 To row_count
        sht_out.Cells(total_cell + i + upp_out, cul_used) = ""
    Next

End Function

Private Function list_info(name As String)
    Dim i As Integer
    Dim cul_info As Integer
    Dim c As Range
    
    Set c = sht_codec.Cells.Find(name)
    cul_info = c.column
    
    cul_used = cul_used + 1
        
    sht_out.Cells(upp_out, cul_used) = sht_codec.Cells(upp_codec - 1, cul_info)
    
    For i = 1 To total_cell
        sht_out.Cells(i + upp_out, cul_used) = sht_codec.Cells(upp_codec + i - 1, cul_info)
        sht_out.Cells(i + upp_out, cul_used).Interior.ColorIndex = sht_codec.Cells(upp_codec + i - 1, cul_info).Interior.ColorIndex
    Next
    
End Function

Private Function list_trx_counter(subtype As String, counter As String)
    Dim str_sheet As String
    Dim sht_pm As Excel.Worksheet
    Dim c As Range
    Dim cul_count, row_count As Integer
    Dim ci, cul_cell, row_cell As Integer
    Dim ri, cul_trx, row_trx As Integer
    Dim i As Integer
    Dim cul_ci, cul_codec As Integer
    Dim b_old, c_old, c_sum As Integer
    
    str_sheet = "type_" + subtype
    Set sht_pm = Worksheets(str_sheet)
    
    Set c = sht_pm.UsedRange
    cul_count = c.Columns.Count - lft_pm
    row_count = Int((total_trx - 1) / cul_count) + 1
    
    Set c = sht_pm.Cells.Find(counter)
    sht_tmp.Cells(total_trx + 1, 3) = c.row
    i = 1
    Do While i < row_count
        i = i + 1
        Set c = sht_pm.Cells.FindNext(after:=c)
        sht_tmp.Cells(total_trx + i, 3) = c.row
    Loop
    
    Set c = sht_pm.Cells.Find("BTS")
    sht_tmp.Cells(total_trx + 1, 1) = c.row
    i = 1
    Do While i < row_count
        i = i + 1
        Set c = sht_pm.Cells.FindNext(after:=c)
        sht_tmp.Cells(total_trx + i, 1) = c.row
    Loop

    Set c = sht_pm.Cells.Find("SECTOR")
    sht_tmp.Cells(total_trx + 1, 2) = c.row
    i = 1
    Do While i < row_count
        i = i + 1
        Set c = sht_pm.Cells.FindNext(after:=c)
        sht_tmp.Cells(total_trx + i, 2) = c.row
    Loop
    
    b_old = -1
    c_old = -1
    c_sum = 0
    ci = 0
    For i = 1 To total_trx
        ri = Int((i - 1) / cul_count) + 1
        cul_trx = i - (ri - 1) * cul_count + lft_pm
        
        row_trx = sht_tmp.Cells(ri + total_trx, 1)
        sht_tmp.Cells(i, 1) = sht_pm.Cells(row_trx, cul_trx)

        row_trx = sht_tmp.Cells(ri + total_trx, 2)
        sht_tmp.Cells(i, 2) = sht_pm.Cells(row_trx, cul_trx)

        row_trx = sht_tmp.Cells(ri + total_trx, 3)
        sht_tmp.Cells(i, 3) = sht_pm.Cells(row_trx, cul_trx)
        
        If sht_tmp.Cells(i, 1) <> b_old Or sht_tmp.Cells(i, 2) <> c_old Then
            If b_old > 0 Then
                ci = ci + 1
                sht_tmp.Cells(ci, 4) = c_sum
            End If
            b_old = sht_tmp.Cells(i, 1)
            c_old = sht_tmp.Cells(i, 2)
            c_sum = sht_tmp.Cells(i, 3)
        Else
            c_sum = c_sum + sht_tmp.Cells(i, 3)
        End If
    Next
    If b_old > 0 Then
        ci = ci + 1
        sht_tmp.Cells(ci, 4) = c_sum
    End If
    

    Set c = sht_codec.Cells.Find("CI")
    cul_ci = c.column

    Set c = sht_codec.Cells.Find("codec")
    cul_codec = c.column

    cul_used = cul_used + 1

    Set c = sht_pm.Cells.Find(counter)

    sht_out.Cells(1, cul_used) = sht_pm.Cells(c.row, lft_pm - 1)
    sht_out.Cells(2, cul_used) = sht_pm.Cells(c.row, lft_pm)

    For i = 1 To total_cell
        ci = sht_codec.Cells(upp_codec + i - 1, cul_ci)

        sht_out.Cells(i + upp_out, cul_used) = sht_tmp.Cells(ci, 4)
        sht_out.Cells(i + upp_out, cul_used).Interior.ColorIndex = sht_codec.Cells(upp_codec + i - 1, cul_codec).Interior.ColorIndex
    Next

End Function
