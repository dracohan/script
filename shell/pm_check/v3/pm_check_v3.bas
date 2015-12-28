Attribute VB_Name = "Module1"
' List all check counters, and check the counters normal or not.

Dim sht_load_kpi, sht_cmcc_kpi, sht_in As Excel.Worksheet
Dim str1, comment As String
Dim row_out, col_out, line, ost As Integer
Dim res
Sub Check_PM()
SheetRemove ("Load PM NRT")
SheetRemove ("CMCC KPIs")
res = load_kpi_check()
res = cmcc_kpi_check()

   
End Sub
Private Function load_kpi_check()
Dim MC718A, MC718B, MC718C, MC718D, MC718E, MC718f, MC718, sum As Long
Dim MC140A, MC140B As Long
Dim MC975A, MC975B, MC975C, MC975D As Long
Dim cellFound As Range


   On Error Resume Next
SheetCreate ("Load PM NRT")
Set sht_load_kpi = Worksheets("Load PM NRT")
Worksheets("Load PM NRT").Select

  sht_load_kpi.Range("A1:IV65536").Clear
  sht_load_kpi.Cells(1, 1) = "Name"
  sht_load_kpi.Cells(1, 2) = "Content"
  sht_load_kpi.Cells(1, 3) = "State"
  sht_load_kpi.Cells(1, 4) = "Comments"

sht_load_kpi.Cells(2, 1) = "PM_CHECK_01"
comment = "no obviously incorrect values such as " & "?" & " or wrong values"
res = add_comment(sht_load_kpi.Cells(2, 2), comment)

sht_load_kpi.Cells(3, 1) = "PM_CHECK_02"
comment = "sum of MC718x=MC718"
res = add_comment(sht_load_kpi.Cells(3, 2), comment)

sht_load_kpi.Cells(4, 1) = "PM_CHECK_03"
comment = "MC140a is greater than MC140b ,and the values are correct,comparing with MC718,they are reasonable"
res = add_comment(sht_load_kpi.Cells(4, 2), comment)

sht_load_kpi.Cells(5, 1) = "PM_CHECK_04"
comment = "values should be resonable and MC975a >= MC975c >= 9C975d >= MC975b"
res = add_comment(sht_load_kpi.Cells(5, 2), comment)


sht_load_kpi.Cells(2, 2) = "check abnormal counters"
sht_load_kpi.Cells(3, 2) = "MC718 = SUMOF(MC718x)"
sht_load_kpi.Cells(4, 2) = "MC140a > MC140b"
sht_load_kpi.Cells(5, 2) = "MC975a >= MC975c >= 9C975d >= MC975b"

sht_load_kpi.Cells(2, 3) = "Pass"
sht_load_kpi.Cells(3, 3) = "Pass"
sht_load_kpi.Cells(4, 3) = "Pass"
sht_load_kpi.Cells(5, 3) = "Pass"

res = MarkCell(Range("A2:D5"), 36)
res = MarkCell(Range("A1:D1"), 45)
res = MarkCell(Range("C2: C5"), 4)




    

MC718A = find_counter("type_1126", "sum(MC718A)")
MC718B = find_counter("type_1126", "sum(MC718B)")
MC718C = find_counter("type_1126", "sum(MC718C)")
MC718D = find_counter("type_1126", "sum(MC718D)")
MC718E = find_counter("type_1126", "sum(MC718E)")
MC718f = find_counter("type_1126", "sum(MC718F)")
MC718 = find_counter("type_1130", "sum(MC718)")
MC140A = find_counter("type_1122", "sum(MC140A)")
MC140B = find_counter("type_1122", "sum(MC140B)")
MC975A = find_counter("type_1126", "sum(MC975A)")
MC975B = find_counter("type_1126", "sum(MC975B)")
MC975C = find_counter("type_1126", "sum(MC975C)")
MC975D = find_counter("type_1126", "sum(MC975D)")
sum = MC718A + MC718B + MC718C + MC718D + MC718E

For i = 1 To Worksheets.Count - 4
         Set cellFound = Worksheets(i).Range("A1:IV65536").Find("~?")
If Not cellFound Is Nothing Then
sht_load_kpi.Cells(2, 3) = "Fail"
sht_load_kpi.Cells(2, 4) = "Invalid counter " & "?" & " found at sheet: " & cellFound.Worksheet.name & " Address: " & cellFound.Address
res = MarkCell(sht_load_kpi.Cells(2, 3), 3)
Else

End If

     Next i

If Abs(MC718 - sum) > 50 Then
    sht_load_kpi.Cells(3, 3) = "Fail"
    res = MarkCell(sht_load_kpi.Cells(3, 3), 3)
End If

If MC140A < MC140B Then
    sht_load_kpi.Cells(4, 3) = "Fail"
    res = MarkCell(sht_load_kpi.Cells(4, 3), 3)
End If

If (MC975C - MC975A) > 5 Or (MC975D - MC975C) > 5 Or (MC975B - MC975D) > 5 Then
    sht_load_kpi.Cells(4, 3) = "Fail"
    res = MarkCell(sht_load_kpi.Cells(5, 3), 3)
    End If


For i = 1 To 4
                Columns(i).Select
                With Selection.Font
      .name = "Arial"
      .Size = 12
    End With
                Columns(i).AutoFit
            Next



End Function

Private Function cmcc_kpi_check()
res = skeleton_create()
res = format_cell()
res = calculate_current()
res = check_range()

End Function


Private Function skeleton_create()
Dim start As Range
Dim platform_name As String


Dim t As Range
Set t = Worksheets("BSC").Cells.Find("BSC configuration")
platform_name = t.Offset(2, 0).value



SheetCreate ("CMCC KPIs")
Set sht_cmcc_kpi = Worksheets("CMCC KPIs")
Worksheets("CMCC KPIs").Select

sht_cmcc_kpi.Range("A1:IV65536").Clear
  sht_cmcc_kpi.Cells(1, 1) = "CS Part:"
  sht_cmcc_kpi.Cells(2, 1) = "JXIBSC153"
  sht_cmcc_kpi.Cells(2, 2) = "5CCP"
  sht_cmcc_kpi.Cells(2, 3) = "std"
  sht_cmcc_kpi.Cells(2, 4) = "7CCP"
  sht_cmcc_kpi.Cells(2, 5) = "Delta"
  sht_cmcc_kpi.Cells(2, 6) = platform_name


 line = 0
res = row_fill("Call_drop_rate", "0.50%", "0.04%", "0.59%", "")
res = row_fill("RTCH_drop_rate", "0.15%", "0.00%", "0.21%", "")
res = row_fill("SDCCH_Erlang_total", "1661.15", "35.79", "1544.15", "")
res = row_fill("SDCCH_duration_avg", "3.2", "0.05", "3.2", "")
res = row_fill("RTCH_Erlang_total", "11508.01", "134.54", "10305.83", "")
res = row_fill("RTCH_duration_avg", "29.05", "1.79", "33.67", "")
res = row_fill("RTCH_assign_cong_rate", "0.03%", "0.01%", "0.02%", "")
res = row_fill("RTCH_assign_fail_radio_rate", "0.28%", "0.03%", "0.34%", "")
res = row_fill("RTCH_assign_success_rate", "99.66%", "0.02%", "99.69%", "")
res = row_fill("RTCH_assign_fail_rate", "0.29%", "0.03%", "0.35%", "")
res = row_fill("SDCCH_assign_cong_rate", "0.05%", "0.02%", "0.02%", "")
res = row_fill("SDCCH_assign_fail_rate", "1.85%", "0.07%", "2.08%", "")
res = row_fill("SDCCH_drop_rate", "0.26%", "0.03%", "0.26%", "")
res = row_fill("Call_drop_radio_rate", "0.38%", "0.03%", "0.48%", "")
res = row_fill("Call_drop_HO_rate", "0.11%", "0.01%", "0.11%", "")
res = row_fill("Call_setup_success_rate", "99.40%", "0.05%", "99.42%", "")
res = row_fill("HO_Inc_MSC_3G_2G_success_rate", "96.38%", "0.49%", "97.13%", "")
res = row_fill("CHO_better_cell_rate", "31.92%", "1.11%", "31.17%", "")
res = row_fill("CHO_DL_level_rate", "7.05%", "0.75%", "8.82%", "")
res = row_fill("CHO_UL_level_rate", "23.65%", "1.77%", "26.57%", "")
res = row_fill("CHO_UL_qualit_rate", "3.21%", "0.21%", "4.22%", "")
res = row_fill("CHO_dist_rate", "2.61%", "0.00%", "4.04%", "")
res = row_fill("HO_Inc_MSC_request", "262059.5", "16652.7", "215886.83", "")
res = row_fill("HO_Inc_MSC_cong_rate", "0.41%", "0.15%", "0.46%", "")
res = row_fill("HO_Inc_MSC_success_rate", "97.47%", "0.20%", "97.04%", "")
res = row_fill("HO_Out_MSC_2G_2G_request", "238767.5", "16939.16", "191335.33", "")
res = row_fill("HO_Out_MSC_2G_2G_ROC_rate", "1.21%", "0.11%", "1.48%", "")
res = row_fill("HO_Out_MSC_2G_2G_success_rate", "88.48%", "1.05%", "87.22%", "")
res = row_fill("HO_Inc_BSC_request", "767443", "79731.96", "518855.25", "")
res = row_fill("HO_Inc_BSC_cong_rate", "1.53%", "0.10%", "1.07%", "")
res = row_fill("HO_Inc_BSC_success_rate", "97.93%", "0.13%", "98.13%", "")
res = row_fill("HO_Out_BSC_request", "755143.5", "79213.04", "512929.83", "")
res = row_fill("HO_Out_BSC_ROC_rate", "0.63%", "0.03%", "0.92%", "")
res = row_fill("HO_Out_BSC_success_rate", "97.93%", "0.13%", "98.13%", "")

res = row_fill("", "", "", "", "")
res = row_fill("PS part:", "", "", "", "")


sht_cmcc_kpi.Cells(39, 1) = "JXIBSC153"
  sht_cmcc_kpi.Cells(39, 2) = "5CCP"
  sht_cmcc_kpi.Cells(39, 3) = "std"
  sht_cmcc_kpi.Cells(39, 4) = "7CCP"
  sht_cmcc_kpi.Cells(39, 5) = "Delta"
  sht_cmcc_kpi.Cells(39, 6) = platform_name
  line = line + 1
  
  
res = row_fill("GPRS_DL_TBF_request", "13600310.00", "111224.36", "13971016.17", "370706.17")
res = row_fill("GPRS_DL_TBF_estab_allocated_rate", "99.99%", "0.00%", "100.00%", "0.00%")
res = row_fill("GPRS_DL_TBF_success_rate", "99.19%", "0.02%", "99.15%", "-0.04%")
res = row_fill("GPRS_DL_TBF_estab_fail_GB_rate", "0.00%", "0.00%", "0.00%", "0.00%")
res = row_fill("GPRS_DL_TBF_estab_fail_cong_rate", "0.01%", "0.00%", "0.00%", "0.00%")
res = row_fill("GPRS_DL_LLC_Bytes", "37368171357.00", "1847410418.45", "35900877938.67", "-1467293418.33")
res = row_fill("GPRS_UL_LLC_Bytes", "9501359821.25", "454984244.47", "9307536638.75", "-193823182.50")
res = row_fill("GPRS_DL_TBF_drop_rate", "0.80%", "0.02%", "0.82%", "0.02%")
res = row_fill("GPRS_DL_TBF_acceptable_release_rate", "0.55%", "0.01%", "0.53%", "-0.02%")
res = row_fill("GPRS_DL_TBF_normal_release_rate", "98.65%", "0.03%", "98.65%", "0.00%")
res = row_fill("GPRS_DL_useful_throughput_radio_GPRS_TBF_avg", "11.36", "0.20", "11.56", "0.20")
res = row_fill("GPRS_DL_useful_throughput_radio_EGPRS_TBF_avg", "27.59", "0.89", "26.38", "-1.20")
res = row_fill("GPRS_DL_TBF_realloc_success_rate", "24.58%", "0.39%", "24.34%", "-0.24%")
res = row_fill("GPRS_DL_useful_bytes_CSx_ack", "5231144881.00", "204612737.88", "5431982082.83", "200837201.83")
res = row_fill("GPRS_DL_useful_bytes_MCSx_ack", "33567929711.00", "1687571521.12", "31902825958.67", "-1665103752.33")
res = row_fill("GPRS_DL_RLC_bytes_PDTCH_CSx_retrans_ack_rate", "1.40%", "0.01%", "1.39%", "-0.01%")
res = row_fill("GPRS_DL_RLC_bytes_PDTCH_MCSx_retrans_ack_rate", "7.74%", "0.10%", "7.77%", "0.03%")
res = row_fill("GPRS_DL_biased_and_DL_optimal_alloc_percent", "0.85", "0.00", "0.85", "0.00")
res = row_fill("GPRS_DL_TBF_acceptable_release_rate", "0.55%", "0.01%", "0.53%", "-0.02%")
res = row_fill("GPRS_UL_TBF_drop_rate", "1.12%", "0.02%", "1.21%", "0.08%")
res = row_fill("GPRS_UL_TBF_acceptable_release_rate", "0.21%", "0.00%", "0.21%", "0.00%")
res = row_fill("GPRS_UL_TBF_normal_release_rate", "98.66%", "0.02%", "98.59%", "-0.08%")
res = row_fill("GPRS_UL_useful_throughput_radio_GPRS_TBF_avg", "7.50", "0.07", "7.46", "-0.05")
res = row_fill("GPRS_UL_useful_throughput_radio_EGPRS_TBF_avg", "12.50", "0.30", "12.03", "-0.47")
res = row_fill("GPRS_UL_TBF_realloc_success_rate", "32.51%", "0.61%", "32.50%", "-0.01%")
res = row_fill("GPRS_UL_useful_bytes_CSx_ack", "1731452310.00", "47886025.26", "1784681967.50", "53229657.50")
res = row_fill("GPRS_UL_useful_bytes_MCSx_ack", "9167884430.75", "461311738.86", "8932126955.67", "-235757475.08")
res = row_fill("GPRS_UL_RLC_bytes_PDTCH_CSx_retrans_ack_rate", "1.36%", "0.06%", "1.38%", "0.02%")
res = row_fill("GPRS_UL_RLC_bytes_PDTCH_MCSx_retrans_ack_rate", "4.31%", "0.14%", "4.23%", "-0.08%")
res = row_fill("GPRS_UL_biased_and_UL_optimal_alloc_percent", "0.51", "0.01", "0.50", "-0.01")
res = row_fill("GPRS_UL_TBF_acceptable_release_rate", "0.21%", "0.00%", "0.21%", "0.00%")
res = row_fill("GPRS_UL_TBF_request", "29488528.75", "263553.52", "30105896.83", "617368.08")
res = row_fill("GPRS_UL_TBF_success_rate", "97.87%", "0.13%", "97.84%", "-0.02%")
res = row_fill("GPRS_UL_TBF_estab_fail_GB_rate", "0.00%", "0.00%", "0.00%", "0.00%")
res = row_fill("GPRS_UL_TBF_estab_fail_cong_rate", "0.25%", "0.03%", "0.25%", "0.00%")
res = row_fill("GPRS_UL_TBF_request", "29488528.75", "263553.52", "30105896.83", "617368.08")
res = row_fill("GPRS_UL_TBF_estab_fail_GB_rate", "0.00%", "0.00%", "0.00%", "0.00%")
res = row_fill("GPRS_UL_TBF_estab_fail_radio_rate", "1.38%", "0.11%", "1.39%", "0.01%")
res = row_fill("GPRS_UL_TBF_success_rate", "97.87%", "0.13%", "97.84%", "-0.02%")


  
End Function

Private Function row_fill(description As String, ccp5 As String, std As String, ccp7 As String, delta As String)
Dim start As Range

Set start = sht_cmcc_kpi.Range("A3")

 start.Offset(line, 0) = description
    start.Offset(line, 1) = ccp5
    start.Offset(line, 2) = std
    start.Offset(line, 3) = ccp7
    start.Offset(line, 4) = delta
    
    line = line + 1
    
End Function



Private Function find_counter(sheetname As String, countername As String)
Dim t As Range
If SheetExists(sheetname) Then
Set t = Worksheets(sheetname).Cells.Find(countername)
Set t = t.Offset(0, -2)

find_counter = t.value
Else
    find_counter = 0
End If

End Function

Public Function SheetExists(sname) As Boolean
'   Returns TRUE if sheet exists in the active workbook
Dim x As Object
        On Error Resume Next
        Set x = ActiveWorkbook.Sheets(sname)
        If Err = 0 Then SheetExists = True Else: SheetExists = False
End Function

Private Function calculate_current()

On Error Resume Next

Dim start As Range
Dim result As Double
Dim ost_row As Integer

ost_row = 0


Set start = sht_cmcc_kpi.Range("A3")

 Dim MC14c, MC621, MC736, MC739, MC718, MC642, C82, MC652, C92, MC662, C102 As Long
 Dim MC812, MC140A As Long
Dim MC142e, MC142f As Long
Dim MC8d, MC8c As Long
Dim MC149, MC04, MC148 As Long
Dim MC07, MC137, MC138 As Long
Dim MC717A, MC717B, MC712 As Long
Dim MC01, MC02, MC703 As Long
Dim MC678, MC670, MC671, MC672, MC673, MC674, MC675, MC676, MC677, MC679, MC785A, MC785D, MC785E, MC785F, MC586A, MC586B, MC586C, MC1040, MC1044, MC1050, MC461, MC448A, MC448B, MC449, MC481 As Long
Dim MC820 As Long
Dim MC922B, MC929B, MC922A, MC929A As Long
Dim MC650 As Long
Dim MC647, MC645A As Long
Dim MC646 As Long
Dim MC830 As Long
Dim MC831 As Long
Dim MC655A As Long
Dim MC657 As Long
Dim MC656 As Long

 
 
 MC14c = find_counter("type_1110", "sum(MC14c)")
 MC621 = find_counter("type_1130", "sum(MC621)")
 MC736 = find_counter("type_1130", "sum(MC736)")
 MC739 = find_counter("type_1130", "sum(MC739)")
 MC718 = find_counter("type_1130", "sum(MC718)")
 MC642 = find_counter("type_1120", "sum(MC642)")
 C82 = find_counter("type_280", "c82")
 MC652 = find_counter("type_1120", "sum(MC652)")
 C92 = find_counter("type_280", "c92")
 MC662 = find_counter("type_1120", "sum(MC662)")
 C102 = find_counter("type_280", "c102")
 MC812 = find_counter("type_1120", "sum(MC812)")
 MC140A = find_counter("type_1122", "sum(MC140a)")
 MC142e = find_counter("type_1110", "sum(MC142e)")
 MC142f = find_counter("type_1110", "sum(MC142f)")
 MC8d = find_counter("type_1110", "sum(MC8d)")
 MC8c = find_counter("type_1110", "sum(MC8c)")
 MC149 = find_counter("type_1110", "sum(MC149)")
 MC04 = find_counter("type_1110", "sum(MC04)")
 MC148 = find_counter("type_1110", "sum(MC148)")
 MC07 = find_counter("type_1110", "sum(MC07)")
 MC137 = find_counter("type_1110", "sum(MC137)")
 MC138 = find_counter("type_1110", "sum(MC138)")
 MC14c = find_counter("type_1110", "sum(MC14c)")
 MC736 = find_counter("type_1130", "sum(MC736)")
 MC739 = find_counter("type_1130", "sum(MC739)")
 MC642 = find_counter("type_1120", "sum(MC642)")
 C82 = find_counter("type_280", "C82")
 MC652 = find_counter("type_1120", "sum(MC652)")
 C92 = find_counter("type_280", "C92")
 C102 = find_counter("type_280", "C102")
 MC717A = find_counter("type_1130", "sum(MC717A)")
 MC717B = find_counter("type_1130", "sum(MC717B)")
 MC712 = find_counter("type_1130", "sum(MC712)")
 MC01 = find_counter("type_1110", "sum(MC01)")
 MC02 = find_counter("type_1110", "sum(MC02)")
 MC703 = find_counter("type_1130", "sum(MC703)")
 MC678 = find_counter("type_1120", "sum(MC678)")
 MC670 = find_counter("type_1120", "sum(MC670)")
 MC671 = find_counter("type_1120", "sum(MC671)")
 MC672 = find_counter("type_1120", "sum(MC672)")
 MC673 = find_counter("type_1120", "sum(MC673)")
 MC674 = find_counter("type_1120", "sum(MC674)")
 MC675 = find_counter("type_1120", "sum(MC675)")
 MC676 = find_counter("type_1120", "sum(MC676)")
 MC677 = find_counter("type_1120", "sum(MC677)")
 MC678 = find_counter("type_1120", "sum(MC678)")
 MC679 = find_counter("type_1120", "sum(MC679)")
 MC785A = find_counter("type_1120", "sum(MC785A)")
 MC785D = find_counter("type_1120", "sum(MC785D)")
 MC785E = find_counter("type_1120", "sum(MC785E)")
 MC785F = find_counter("type_1120", "sum(MC785F)")
 MC586A = find_counter("type_1110", "sum(MC586A)")
 MC586B = find_counter("type_1110", "sum(MC586B)")
 MC586C = find_counter("type_1110", "sum(MC586C)")
 MC1040 = find_counter("type_1120", "sum(MC1040)")
 MC1044 = find_counter("type_1120", "sum(MC1044)")
 MC1050 = find_counter("type_1120", "sum(MC1050)")
 MC461 = find_counter("type_1110", "sum(MC461)")
 MC448A = find_counter("type_1122", "sum(MC448A)")
 MC448B = find_counter("type_1122", "sum(MC448B)")
 MC449 = find_counter("type_1122", "sum(MC449)")
 MC481 = find_counter("type_1122", "sum(MC481)")
 MC673 = find_counter("type_1120", "sum(MC673)")
 MC922B = find_counter("type_1122", "sum(MC922B)")
 MC929B = find_counter("type_1122", "sum(MC929B)")
 MC820 = find_counter("type_1120", "sum(MC820)")
 MC821 = find_counter("type_1120", "sum(MC821)")
 MC922A = find_counter("type_1122", "sum(MC922A)")
 MC929A = find_counter("type_1122", "sum(MC929A)")
 
 MC650 = find_counter("type_1120", "sum(MC650)")
 MC647 = find_counter("type_1120", "sum(MC647)")
 MC645A = find_counter("type_1120", "sum(MC645A)")
 MC646 = find_counter("type_1120", "sum(MC646)")
 MC830 = find_counter("type_1120", "sum(MC830)")
 MC831 = find_counter("type_1120", "sum(MC831)")
 MC655A = find_counter("type_1120", "sum(MC655A)")
 MC657 = find_counter("type_1120", "sum(MC657)")
 MC656 = find_counter("type_1120", "sum(MC656)")
 MC400 = find_counter("type_1130", "sum(MC400)")
 MC390 = find_counter("type_1130", "sum(MC390)")
 MC921C = find_counter("type_1110", "sum(MC921C)")
 MC718B = find_counter("type_1126", "sum(MC718b)")
 MC380A = find_counter("type_1130", "sum(MC380A)")
 MC380B = find_counter("type_1130", "sum(MC380B)")
 
 
' call_drop_rate
 result = 100 * (MC14c + MC621 + MC736 + MC739) / (MC718 + (MC642 - C82) + (MC652 - C92) + (MC662 - C102))
 start.Offset(ost_row, 5) = Format(result, "Percent")
 comment = "100 * (MC14c + MC621 + MC736 + MC739) / (MC718 + (MC642 - C82) + (MC652 - C92) + (MC662 - C102))"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1
 
 ' RTCH_drop_rate
result = (MC736 + MC621 + MC14c + MC739 + MC921C) / (MC718 + MC717A + MC718B - MC662)
start.Offset(ost_row, 5) = Format(result, "Percent")
 comment = "(MC736 + MC621 + MC14c + MC739 + MC921C) / (MC718 + MC717A + MC718B - MC662)"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1
 
 'SDCCH_Erlang_total
result = MC400 / 3600
start.Offset(ost_row, 5) = result
 comment = "MC400 / 3600"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

' SDCCH_duration_avg
result = MC400 / MC390
start.Offset(ost_row, 5) = result
 comment = "MC400 / MC390"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'RTCH_Erlang_total
result = (MC380A + MC380B) / 3600
start.Offset(ost_row, 5) = result
 comment = "(MC380A + MC380B) / 3600"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'RTCH_duration_avg
result = (MC380A + MC380B) / MC718
start.Offset(ost_row, 5) = result
 comment = "(MC380A + MC380B) / MC718"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'RTCH_assign_cong_rate
result = 100 * MC812 / MC140A
start.Offset(ost_row, 5) = Format(result, "Percent")
 comment = "100 * MC812 / MC140A"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'RTCH_assign_fail_radio_rate
result = 100 * (MC140A - MC718 - MC142e - MC142f) / MC140A
start.Offset(ost_row, 5) = Format(result, "Percent")
 comment = "100 * (MC140A - MC718 - MC142e - MC142f) / MC140A"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'RTCH_assign_success_rate
result = 1 - 100 * (MC140A - MC718 - MC142e - MC142f) / MC140A
start.Offset(ost_row, 5) = Format(result, "Percent")
 comment = "1 - 100 * (MC140A - MC718 - MC142e - MC142f) / MC140A"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'RTCH_assign_fail_rate
result = 100 * (MC140A - MC718 - MC142e - MC142f) / MC140A
start.Offset(ost_row, 5) = Format(result, "Percent")
 comment = "100 * (MC140A - MC718 - MC142e - MC142f) / MC140A"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'SDCCH_assign_cong_rate
result = 100 * MC8d / MC8c
start.Offset(ost_row, 5) = Format(result, "Percent")
 comment = "100 * MC8d / MC8c"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'SDCCH_assign_fail_rate
result = 100 * ((MC149) / (MC04 + MC148))
start.Offset(ost_row, 5) = Format(result, "Percent")
 comment = "100 * ((MC149) / (MC04 + MC148))"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'SDCCH_drop_rate
result = 100 * (MC07 + MC137 + MC138) / (MC8c - MC8d)
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = "100 * (MC07 + MC137 + MC138) / (MC8c - MC8d)"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'Call_drop_radio_rate
result = MC736 / (MC718 + MC717A + MC717B - MC712)
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = " MC736 / (MC718 + MC717A + MC717B - MC712)"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1


'Call_drop_HO_rate
result = MC621 / (MC718 + MC717A + MC717B - MC712)
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = "MC621 / (MC718 + MC717A + MC717B - MC712)"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'Call_setup_success_rate
result = (1 - ((MC138 + MC07 + MC137) / (MC01 + MC02))) * (1 - (MC703 + MC812 - MC718) / (MC703 + MC812))
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = "(1 - ((MC138 + MC07 + MC137) / (MC01 + MC02))) * (1 - (MC703 + MC812 - MC718) / (MC703 + MC812))"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'HO_Inc_MSC_3G_2G_success_rate
'Placeholder
start.Offset(ost_row, 5) = Format(0, "Percent")
comment = "Placeholder"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'CHO_better_cell_rate
result = (MC678) / (MC670 + MC671 + MC672 + MC673 + MC674 + MC675 + MC676 + MC677 + MC678 + MC679 + MC785A + MC785D + MC785E + MC785F + MC586A + MC586B + MC586C + MC1040 + MC1044 + MC1050 + MC461 + MC448A + MC448B + MC449 + MC481)
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = "(MC678) / (MC670 + MC671 + MC672 + MC673 + MC674 + MC675 + MC676 + MC677 + MC678 + MC679 + MC785A + MC785D + MC785E + MC785F + MC586A + MC586B + MC586C + MC1040 + MC1044 + MC1050 + MC461 + MC448A + MC448B + MC449 + MC481)"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'CHO_DL_level_rate
result = (MC673) / (MC670 + MC671 + MC672 + MC673 + MC674 + MC675 + MC676 + MC677 + MC678 + MC679 + MC785A + MC785D + MC785E + MC785F + MC586A + MC586B + MC586C + MC1040 + MC1044 + MC1050 + MC461 + MC448A + MC448B + MC449 + MC481)
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = "(MC673) / (MC670 + MC671 + MC672 + MC673 + MC674 + MC675 + MC676 + MC677 + MC678 + MC679 + MC785A + MC785D + MC785E + MC785F + MC586A + MC586B + MC586C + MC1040 + MC1044 + MC1050 + MC461 + MC448A + MC448B + MC449 + MC481)"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'CHO_UL_level_rate
result = (MC671) / (MC670 + MC671 + MC672 + MC673 + MC674 + MC675 + MC676 + MC677 + MC678 + MC679 + MC785A + MC785D + MC785E + MC785F + MC586A + MC586B + MC586C + MC1040 + MC1044 + MC1050 + MC461 + MC448A + MC448B + MC449 + MC481)
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = "(MC671) / (MC670 + MC671 + MC672 + MC673 + MC674 + MC675 + MC676 + MC677 + MC678 + MC679 + MC785A + MC785D + MC785E + MC785F + MC586A + MC586B + MC586C + MC1040 + MC1044 + MC1050 + MC461 + MC448A + MC448B + MC449 + MC481)"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'CHO_UL_qualit_rate
result = (MC670) / (MC670 + MC671 + MC672 + MC673 + MC674 + MC675 + MC676 + MC677 + MC678 + MC679 + MC785A + MC785D + MC785E + MC785F + MC586A + MC586B + MC586C + MC1040 + MC1044 + MC1050 + MC461 + MC448A + MC448B + MC449 + MC481)
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = "(MC670) / (MC670 + MC671 + MC672 + MC673 + MC674 + MC675 + MC676 + MC677 + MC678 + MC679 + MC785A + MC785D + MC785E + MC785F + MC586A + MC586B + MC586C + MC1040 + MC1044 + MC1050 + MC461 + MC448A + MC448B + MC449 + MC481)"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'CHO_dist_rate
result = (MC674) / (MC670 + MC671 + MC672 + MC673 + MC674 + MC675 + MC676 + MC677 + MC678 + MC679 + MC785A + MC785D + MC785E + MC785F + MC586A + MC586B + MC586C + MC1040 + MC1044 + MC1050 + MC461)
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = "(MC674) / (MC670 + MC671 + MC672 + MC673 + MC674 + MC675 + MC676 + MC677 + MC678 + MC679 + MC785A + MC785D + MC785E + MC785F + MC586A + MC586B + MC586C + MC1040 + MC1044 + MC1050 + MC461)"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'HO_Inc_MSC_request
result = MC820
start.Offset(ost_row, 5) = result
comment = "MC820"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'HO_Inc_MSC_cong_rate
result = safesub(MC820 - MC821, MC820)
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = "(MC820 - MC821)/ MC820"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'HO_Inc_MSC_success_rate
result = ((MC642) - (MC922B) - (MC929B)) / ((MC820) - (MC922A) - (MC929A))
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = "((MC642) - (MC922B) - (MC929B)) / ((MC820) - (MC922A) - (MC929A))"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'HO_Out_MSC_2G_2G_request
result = MC650
start.Offset(ost_row, 5) = result
comment = "MC650"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'HO_Out_MSC_2G_2G_ROC_rate
result = (MC647) / (MC645A)
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = "(MC647) / (MC645A)"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'HO_Out_MSC_2G_2G_success_rate
result = safesub((MC646), (MC645A))
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = "(MC646)/ (MC645A)"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'HO_Inc_BSC_request
result = MC830
start.Offset(ost_row, 5) = result
comment = "MC830"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'HO_Inc_BSC_cong_rate
result = (MC830 - MC831) / MC830
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = "(MC830 - MC831) / MC830"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'HO_Inc_BSC_success_rate
result = (MC652) / (MC830)
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = "(MC652) / (MC830)"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'HO_Out_BSC_request
result = MC655A
start.Offset(ost_row, 5) = result
comment = " MC655A"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'HO_Out_BSC_ROC_rate
result = (MC657) / (MC655A)
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = "(MC657) / (MC655A)"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

'HO_Out_BSC_success_rate
result = (MC656) / (MC655A)
start.Offset(ost_row, 5) = Format(result, "Percent")
comment = "(MC656) / (MC655A)"
res = add_comment(start.Offset(ost_row, 5), comment)
 ost_row = ost_row + 1

 

End Function

Private Function safesub(a As Long, b As Long)
If b = 0 Then
safesub = 0
Else
safesub = a / b
End If

End Function

Private Function check_range()
Dim r As Range
Dim erlang As Integer
Dim delta As Double

Set r = Worksheets("CMCC KPIs").Range("F3")





    
Do While Not IsEmpty(r.Offset(i, 0))
delta = r.Offset(i, 0).value - r.Offset(i, ost).value

r.Offset(i, -1) = delta



 'If r.Offset(i, 0) = 0 Then

' Else


If delta > 0 Then
r.Offset(i, 1) = "¨J"
res = MarkCell(r.Offset(i, 1), 38)
Else
r.Offset(i, 1) = "¨K"
res = MarkCell(r.Offset(i, 1), 37)
End If

 'If Abs(delta) / r.Offset(i, ost).value > 0.03 Then
'res = MarkCell(Range(r.Offset(i, -5), r.Offset(i, 0)), 38)
' End If


 'End If
 i = i + 1
Loop


                Columns(7).AutoFit

End Function

Private Function MarkCell(TargetRange As Range, color As Integer)
    Dim cell As Range
    For Each cell In TargetRange
        cell.Interior.ColorIndex = color
    Next
    'TargetSheet.Tab.ColorIndex = 38
    
End Function

Private Function format_cell()
Dim ccpnbr As Integer
Dim t As Range


For i = 1 To 6
                Columns(i).Select
                With Selection.Font
      .name = "Arial"
      .Size = 12
    End With
                Columns(i).AutoFit
            Next

Set t = Worksheets("BSC").Cells.Find("Abis efficient load")
erlang = t.Offset(0, 3).value


If erlang Like "6*" Then
    ost = -2
    ccpnbr = 45
    Else
    ost = -4
    ccpnbr = 8
    End If
    
Range("A1").Select
Selection.Font.Bold = True
    
    Range("A38").Select
Selection.Font.Bold = True
    
res = MarkCell(Range("A3: F36"), 36)
res = MarkCell(Range("A40: F78"), 40)
res = MarkCell(Range("A2"), 3)
res = MarkCell(Range("E2"), 3)
res = MarkCell(Range("F2"), ccpnbr)
res = MarkCell(Range("F39"), ccpnbr)
res = MarkCell(Range("A39"), 3)
res = MarkCell(Range("E39"), 3)
res = MarkCell(Range("B2"), 8)
res = MarkCell(Range("C2"), 43)
res = MarkCell(Range("B39"), 8)
res = MarkCell(Range("C39"), 43)
res = MarkCell(Range("D2"), 45)
res = MarkCell(Range("D39"), 45)


End Function

Private Function SheetCreate(name As String)
Dim newsheet
Dim i As Integer

    If SheetExists(name) Then
        SheetRemove (name)
    End If
    i = Worksheets.Count
    i = i - 3
    Set newsheet = Worksheets.Add(after:=Worksheets(i))
    newsheet.name = name

    SheetCreate = name
End Function

Private Function SheetRemove(name As String)

    If SheetExists(name) Then
        Application.DisplayAlerts = False
        Sheets(name).Delete
        Application.DisplayAlerts = True
    End If

End Function
Public Function add_comment(r As Range, text As String)
Dim rangename As String
Dim commentText As String
Dim commentWidth As Double
Dim commentHeight As Double
Dim i As Integer, j As Integer
Dim c As comment

    
    r.Select
    If Not r.comment Is Nothing Then r.comment.Delete
    r.AddComment
    r.comment.Visible = True
    r.comment.text text:=text
    Set c = r.comment
    With c.Shape
        .Placement = xlFreeFloating
        .TextFrame.AutoSize = True
        With .OLEFormat.Object
            With .Font
                .name = "Courrier": .Size = 12
            End With
        End With
    End With
    r.comment.Visible = False
    
    
End Function
