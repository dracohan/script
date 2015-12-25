# $language = "VBScript"
# $interface = "1.0"

Sub Main
  tabNum = crt.GetTabCount
  tabSrp = crt.GetScriptTab.Index
  For i = 1 to tabNum
    Set tabCur = crt.GetTab(tabNum-i+1)
    If tabCur.Session.Connected Then
      tabCur.Screen.Send chr(3)
      tabCur.Session.Disconnect
    End If
    If i+tabSrp <> tabNum+1 Then
        tabCur.Close
    End If
  Next
End Sub
