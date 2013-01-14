Public Class flex
    Private prolog As IntServer

    Public Sub New(Optional ByVal command As String = "")
        prolog = New IntServer(command, 0, 0, 0)
        prolog.InitGoal("ensure_loaded(prolog(flexserv)). ")
        prolog.CallGoal()
        prolog.ExitGoal()
    End Sub

    Public Function rungoal(ByVal command As String) As String
        'Initialise result string
        Dim result, text, item, rest As String
        Dim buttonid As MsgBoxStyle

        'Initialise the goal
        result = prolog.InitGoal(command)

        'If an error occured return the error
        If result.Substring(0, 1) = "E" Then
            rungoal = result
            Exit Function
        End If

        'Call the initialised valid goal
        result = prolog.CallGoal

        'while flex requires more input
        While result.Substring(0, 1) = "I"
            'get the text
            text = result.Substring(9)
            rest = ""
            ' Select on the input flag
            Select Case result.Substring(8, 1)
                Case "f"    'Flash a message
                    MsgBox(text.Substring(1), MsgBoxStyle.OkOnly)
                    result = ""
                Case "m"    'A multiple selection
                    result = mltbox.multibox(text)
                Case "s"    'A single selection
                    result = lstbox.listbox(text)
                Case "e"  'An edit box
                    result = edtbox.editbox(text)
                Case "x"  'A message box
                    item = flxutil.getitem(text, rest)
                    Select Case item
                        Case "ok"
                            buttonid = MsgBoxStyle.OkOnly
                        Case "okcancel"
                            buttonid = MsgBoxStyle.OkCancel
                        Case "yesno"
                            buttonid = MsgBoxStyle.YesNo
                        Case "yesnocancel"
                            buttonid = MsgBoxStyle.YesNoCancel
                    End Select
                    Select Case MsgBox(rest.Substring(1), buttonid, "Flex Example")
                        Case vbOK
                            result = "ok"
                        Case vbCancel
                            result = "cancel"
                        Case vbYes
                            result = "yes"
                        Case vbNo
                            result = "no"
                    End Select
            End Select
            result = prolog.TellGoal(result + " . ")
        End While
        'Exit the goal
        prolog.ExitGoal()

        'return the result
        rungoal = result
    End Function
    Public Function initGoal(ByVal goal As String) As String
        initGoal = prolog.InitGoal(goal)
    End Function
    Public Function callGoal() As String
        callGoal = prolog.CallGoal()
    End Function
    Public Sub exitgoal()
        prolog.ExitGoal()
    End Sub
End Class
