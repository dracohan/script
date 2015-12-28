Option Strict On
Option Explicit On
Option Infer Off

Imports Microsoft.Office.Interop

Public Class Form1

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        Dim app As New Excel.Application
        app.Visible = True

        'Open Source 1
        Dim wbBase As Excel.Workbook = app.Workbooks.Open("D:\My Documents\temp\Differences\Base.xlsx")
        Dim base As Excel.Worksheet = CType(wbBase.Sheets("Base"), Excel.Worksheet)

        'Open Source 2
        Dim wbModified As Excel.Workbook = app.Workbooks.Open("D:\My Documents\temp\Differences\ModifiedBase.xlsx")
        Dim mods As Excel.Worksheet = CType(wbModified.Sheets("Modifications"), Excel.Worksheet)

        'Add Destination
        Dim wbDestination As Excel.Workbook = app.Workbooks.Add

        'Copy Source 1 to destination
        base.Copy(wbDestination.Sheets(1))

        'Cleanup Source 1 references
        base = Nothing
        wbBase.Close()
        wbBase = Nothing

        'Get reference to copy
        Dim DestinationBase As Excel.Worksheet = CType(wbDestination.Sheets("Base"), Excel.Worksheet)

        'Set Range to compare
        Dim ColumnD As Excel.Range = DestinationBase.Range("D2", "D5")

        'Compare and set differences
        Dim CellG As Excel.Range
        Dim cellD As Excel.Range
        For Each cellD In ColumnD.Cells
            CellG = mods.Range("G" & cellD.Row.ToString)
            If cellD.Value IsNot CellG.Value Then cellD.Value = CellG.Value
        Next

        '  Save Differences

        wbDestination.SaveAs("D:\My Documents\temp\Differences\Differences.xlsx")
        wbDestination.Close()
        wbModified.Close()

        'cleanup
        cellD = Nothing
        CellG = Nothing
        ColumnD = Nothing
        wbDestination = Nothing
        wbModified = Nothing
        app.Quit()
        app = Nothing
        GC.Collect()
    End Sub


End Class