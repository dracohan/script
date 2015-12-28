	Dim sFile As String
	Dim i As Integer
	Dim result
Sub PmReportDiff()
    Dim wCur, wPre As Excel.Worksheet	
	Dim app As Excel.Application
    Dim wbk As Excel.Application.workbook

	' open target file
    Set app = CreateObject("Excel.application")
    Set wbk = app.Workbooks.Open(sFile)

    ' choose target file 
	Initilize()
	
	' comparation
    For i = 1 To ActiveWorkbook.Worksheets.Count
        result = CompareWorksht(ActiveWorkbook.Worksheets(i), _
        		wbk.Worksheets(i))
    Next i

    CleanUp()
End sub

Sub Initilize()
	Dim sPrompt As String
	
	Application.ScreenUpdating = True

	sPrompt = "Please enter the file location:"
	Set sFile = Application.InputBox(prompt:=sPrompt, _
	Title:="Address", _
	Type:=8)



End Sub

Sub CompareWorksht(ws1 As Worksheet, ws2 As Worksheet)
    Dim cell As Range
    Dim cf1 As Double, cf2 As Double
    Dim delta2 As Double, deltapercent As Double

	For Each cell In ws1.UsedRange
		If IsConsistent(cell) Then
		Else 
			InConsistent(cell)
		End If

		If IsCharacter(cell) Then
			' only compare same or not
			If ChkCharacter(cell) Then
			Else
				DiffCharacter(cell)
		End If

		If IsNumeric(cell) Then 
			' compare the numeric value '
			If ChkNumeric(cell) Then
			Else
				Diffnumberic(cell)
		End If 
	Next
End sub

Sub CleanUp()
	Application.ScreenUpdating = False
End sub

