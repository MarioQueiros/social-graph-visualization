' Source code for the .NET LPA.DLL
' If you have problems with the distributed LPA.DLL, for example if
' your project is using a different .NET framework, use this file
' to build it as a new .DLL project using the same .NET framework
' as your project.

Public Class PrologException
    Inherits Exception
    Private hMessage As String
    Public Overrides ReadOnly Property Message() As String
        Get
            Return hMessage
        End Get
    End Property

    Public Sub setMessage(ByVal err As Int32)
        hMessage = "Prolog Load Error: "
        Select Case err
            Case -1
                hMessage = hMessage + "INVALID MODE"
            Case -2
                hMessage = hMessage + "TICKLE ERROR"
            Case -3
                hMessage = hMessage + "CREATE MUTEX FAILED"
            Case -4
                hMessage = hMessage + "WAIT FOR MUTEX FAILED"
            Case -5
                hMessage = hMessage + "ALL SLOTS ALREADY IN USE"
            Case -6
                hMessage = hMessage + "CREATE FILE MAPPING FAILED"
            Case -7
                hMessage = hMessage + "MAP VIEW OF FILE FAILED"
            Case -8
                hMessage = hMessage + "CANNOT FIND MODULE"
            Case -9
                hMessage = hMessage + "CANNOT EXECUTE WIN-PROLOG"
            Case -10
                hMessage = hMessage + "PROLOG INSTANCE NO LONGER ACTIVE"
            Case -11
                hMessage = hMessage + "WIN-PROLOG DID NOT RESPOND"
        End Select
        hMessage = hMessage + " " + Str(err)
    End Sub
End Class

Public Class IntServer

    Private Declare Ansi Function nativeLoadPrologA Lib "Int386w.dll" Alias "LoadProlog" (ByVal command As String, ByVal buffersize As Int32, ByVal encoding As Int32, ByVal tickle as Int32) As Int32
    Private Declare Ansi Function nativeInitGoalA Lib "Int386w.dll" Alias "InitGoal" (ByVal id As Int32, ByVal goal As String) As String
    Private Declare Ansi Function nativeCallGoalA Lib "int386w.dll" Alias "CallGoal" (ByVal id As Int32) As String
    Private Declare Ansi Function nativeExitGoalA Lib "int386w.dll" Alias "ExitGoal" (ByVal id As Int32) As Int32
    Private Declare Ansi Function nativeTellGoalA Lib "int386w.dll" Alias "TellGoal" (ByVal id As Int32, ByVal goal As String) As String
    Private Declare Ansi Function nativeHaltPrologA Lib "int386w.dll" Alias "HaltProlog" (ByVal id As Int32) As Int32

    Private Declare Unicode Function nativeLoadPrologW Lib "Int386w.dll" Alias "LoadProlog" (ByVal command As String, ByVal buffersize As Int32, ByVal encoding As Int32, ByVal tickle As Int32) As Int32
    Private Declare Unicode Function nativeInitGoalW Lib "Int386w.dll" Alias "InitGoal" (ByVal id As Int32, ByVal goal As String) As String
    Private Declare Unicode Function nativeCallGoalW Lib "int386w.dll" Alias "CallGoal" (ByVal id As Int32) As String
    Private Declare Unicode Function nativeExitGoalW Lib "int386w.dll" Alias "ExitGoal" (ByVal id As Int32) As Int32
    Private Declare Unicode Function nativeTellGoalW Lib "int386w.dll" Alias "TellGoal" (ByVal id As Int32, ByVal goal As String) As String
    Private Declare Unicode Function nativeHaltPrologW Lib "int386w.dll" Alias "HaltProlog" (ByVal id As Int32) As Int32

    Dim id As Int32
    Dim uFlag As Boolean

    Public Sub New(ByVal command As String, ByVal buffersize As Int32, ByVal flag As Integer, ByVal tickle As Int32)
        Dim e As PrologException
        If flag = 0 Then
            id = nativeLoadPrologA(command, buffersize, flag, tickle)
            If id < 0 Then
                e = New PrologException()
                e.setMessage(id)
                id = 0
                Throw e
            End If
            uFlag = False
        ElseIf flag = 1 Then
            id = nativeLoadPrologW(command, buffersize, flag, tickle)
            If id < 0 Then
                e = New PrologException()
                e.setMessage(id)
                id = 0
                Throw e
            End If
            uFlag = True
        End If

    End Sub

    Public Function InitGoal(ByVal Goal As String) As String
        If uFlag Then
            Return nativeInitGoalW(id, Goal)
        Else
            Return nativeInitGoalA(id, Goal)
        End If
    End Function

    Public Function CallGoal() As String
        If uFlag Then
            Return nativeCallGoalW(id)
        Else
            Return nativeCallGoalA(id)
        End If
    End Function

    Public Function ExitGoal() As Int32
        If uFlag Then
            Return nativeExitGoalW(id)
        Else
            Return nativeExitGoalA(id)
        End If
    End Function

    Public Function TellGoal(ByVal Goal As String) As String
        If uFlag Then
            Return nativeTellGoalW(id, Goal)
        Else
            Return nativeTellGoalA(id, Goal)
        End If
    End Function

    Public Function HaltProlog() As Int32
        Dim result As Int32

        If uFlag Then
            result = nativeHaltPrologW(id)
        Else
            result = nativeHaltPrologA(id)
        End If
        If result <> 0 Then id = 0
        Return result

    End Function

    Protected Overrides Sub Finalize()
        If id <> 0 Then
            HaltProlog()
        End If

        MyBase.Finalize()
    End Sub
End Class
