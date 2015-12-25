' A "Hello, World!" program in Visual Basic.
Module Hello
    ''' <summary>
    ''' test xml
    ''' </summary>
    ''' <remarks></remarks>
    Sub Main()
        MsgBox("Hello, World!") ' Display message on computer screen.

        Dim fileReader As String
        fileReader = My.Computer.FileSystem.ReadAllText("C:\test.txt")
        MsgBox(fileReader)

        Dim students = New Integer() {1, 2, 3, 4, 5, 6}

        Dim kindergarten As Integer = students(0)
        Dim firstGrade As Integer = students(1)
        Dim sixthGrade As Integer = students(5)
        MsgBox("Students in kindergarten = " & CStr(kindergarten))
        MsgBox("Students in first grade = " & CStr(firstGrade))
        MsgBox("Students in sixth grade = " & CStr(sixthGrade))

    End Sub
End Module