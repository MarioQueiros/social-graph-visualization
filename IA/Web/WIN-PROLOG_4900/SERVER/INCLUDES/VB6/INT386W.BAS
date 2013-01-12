' VB6 interface file.

Attribute VB_Name = "prolog"
#Const LPA_UNICODE = 0

Public Const ERR_ENCODE = -1
Public Const ERR_TICKLE = -2
Public Const ERR_CMUTEX = -3
Public Const ERR_WMUTEX = -4
Public Const ERR_LOCATE = -5
Public Const ERR_CREATE = -6
Public Const ERR_MAPFIL = -7
Public Const ERR_MODULE = -8
Public Const ERR_PROLOG = -9
Public Const ERR_ACTIVE = -10
Public Const ERR_WINDOW = -11

'Declaration of VINT386W.DLL SKIN interface

' If the constant LPA_UNICODE is declared as 1
#If LPA_UNICODE = 1 Then
Private Declare Function LoadP Lib "VINT386W" Alias "vLoadProlog" (ByVal Command As String, ByVal Desire As Long, ByVal Encode As Integer, ByVal Tickle As Integer) As Long
Public Declare Sub HaltProlog Lib "VINT386W" Alias "vHaltProlog" (ByVal Prolog As Long)
Public Declare Function InitG Lib "VINT386W" Alias "vInitGoalW" (ByVal Prolog As Long, Buffer As Any, ByVal size As Long) As Long
Public Declare Function CallG Lib "VINT386W" Alias "vCallGoalW" (ByVal Prolog As Long, Buffer As Any, ByVal size As Long) As Long
Public Declare Function TellG Lib "VINT386W" Alias "vTellGoalW" (ByVal Prolog As Long, Buffer As Any, OutputBuffer As Any, ByVal size As Long) As Long
Public Declare Sub ExitGoal Lib "VINT386W" Alias "vExitGoal" (ByVal Prolog As Long)
Dim Buffer() As Byte
Dim OutputBuffer() As Byte
Dim size As Long

Public Function InitGoal(ByVal Prolog As Long, ByVal Goal As String) As String
   ReDim Buffer(1 + LenB(Goal))
   Buffer() = Goal
   Count = InitG(Prolog, Buffer(0), Len(Goal))
   InitGoal = Left(Buffer, Count)
End Function
Public Function CallGoal(ByVal Prolog As Long) As String
   ReDim Buffer(size)
   Count = CallG(Prolog, Buffer(0), size)
   CallGoal = Left(Buffer, Count)
End Function
Public Function TellGoal(ByVal Prolog As Long, Goal As String) As String
   ReDim Buffer(1 + LenB(Goal))
   ReDim OutputBuffer(size + 1)
   Buffer() = Goal
   Count = TellG(Prolog, Buffer(0), OutputBuffer(0), size)
   TellGoal = Left(OutputBuffer, Count)
End Function

Public Function LoadProlog(Command As String, Optional ByVal Desire As Long = 0, Optional ByVal Encoding = 1, Optional ByVal Tickle = 0) As Integer
   If Desire = 0 Then
      size = 65535
   Else
      size = Desire
   End If
   LoadProlog = LoadP(Command, Desire, Encoding, Tickle)
End Function

' If the constant LPA_UNICODE is not declared as 1
#Else

Private Declare Function LoadP Lib "VINT386W" Alias "vLoadProlog" (ByVal Command As String, ByVal Desire As Long, ByVal Encode As Integer, ByVal Tickle As Integer) As Long
Public Declare Sub HaltProlog Lib "VINT386W" Alias "vHaltProlog" (ByVal Prolog As Long)
Public Declare Function InitGoal Lib "VINT386W" Alias "vInitGoalA" (ByVal Prolog As Long, ByVal StartGoal As String) As String
Public Declare Function CallGoal Lib "VINT386W" Alias "vCallGoalA" (ByVal Prolog As Long) As String
Public Declare Function TellGoal Lib "VINT386W" Alias "vTellGoalA" (ByVal Prolog As Long, ByVal TellGoal As String) As String
Public Declare Sub ExitGoal Lib "VINT386W" Alias "vExitGoal" (ByVal Prolog As Long)

Public Function LoadProlog(ByVal Command As String, Optional ByVal Desire As Long = 0, Optional ByVal Encoding = 0, Optional ByVal Tickle = 0) As Integer
   LoadProlog = LoadP(Command, Desire, Encoding, Tickle)
End Function

#End If

