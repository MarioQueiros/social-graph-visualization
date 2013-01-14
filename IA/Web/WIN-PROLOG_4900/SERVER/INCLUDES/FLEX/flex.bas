
'The prolog instance identifier

Dim ID As Long


'Run the specified Command
Public Function RunGoal(Command As String) As String
   ' Initialize result string
   Dim Result$
   
   ' Initialize the goal
   Result$ = InitGoal(Command)

   ' If an error occurs then return immediately with the error
   If Left$(Result$, 1) = "E" Then
      RunGoal = Result$
      Exit Function
   End If
   
   ' Call the goal
   Result$ = CallGoal
   
   ' while flex requires more input
   While Left$(Result$, 1) = "I"
      
      ' Get the text
      Text$ = Mid$(Result$, 10)
      
      ' Select on the input tag
      Select Case Mid$(Result$, 9, 1)
         
         Case "f"                          'Flash a message
            MsgBox Mid$(Text$, 2), vbOKOnly
            Result$ = ""
         
         Case "m"                          'A multiple selection
            Result$ = Mltbox.MultiBox(Text$) + ". "
         
         Case "s"                          'A single selection
            Result$ = Lstbox.ListBox(Text$) + ". "
         
         Case "e"                          'An edit selection
            Result$ = Edtbox.EditBox(Text$)
         
         Case "x"                          'A message box
            Item$ = GetItem(Text$, Rest$)
            
            Select Case Item$
               
               Case "ok"
                 Button = vbOKOnly
               
               Case "okcancel"
                 Button = vbOKCancel
               
               Case "yesno"
                 Button = vbYesNo
               
               Case "yesnocancel"
                 Button = vbYesNoCancel
             
             End Select
             
             
             Select Case MsgBox(Mid$(Rest$, 2), Button, "Flexeg")
                
                Case vbOK
                   Result$ = "ok. "
                
                Case vbCancel
                   Result$ = "cancel. "
                
                Case vbYes
                   Result$ = "yes. "
                
                Case vbNo
                   Result$ = "no. "
             
             End Select
      
      End Select
    
      ' Tell flex the input string
      Result$ = TellGoal(Result$)
   
   Wend
   
   ' End the goal
   ExitGoal
 
   ' Return the result
   RunGoal = Result$
   
End Function
'Load prolog and the flex interface for the intelligence server
Public Sub LoadFlex(Command As String)
   ID = Prolog.LoadProlog(Command)
   
   If ID < 0 Then
      Select Case ID
         Case IS_ERR_CMUTEX
            Msg$ = "IS_ERR_CMUTEX"
         Case IS_ERR_WMUTEX
            Msg$ = "IS_ERR_WMUTEX"
         Case IS_ERR_LOCATE
            Msg$ = "IS_ERR_LOCATE"
         Case IS_ERR_CREATE
            Msg$ = "IS_ERR_CREATE"
         Case IS_ERR_MAPFIL
            Msg$ = "IS_ERR_MAPFIL"
         Case IS_ERR_PROLOG
            Msg$ = "IS_ERR_PROLOG"
         Case IS_ERR_WINDOW
            Msg$ = "IS_ERR_WINDOW"
      End Select
      
      MsgBox "There was an error loading flex: " + Msg$ + " " + Str$(ID), vbOKOnly
      
      End
   
   End If
   
   R$ = InitGoal("ensure_loaded(prolog(flexserv)). ")
   R$ = CallGoal
   ExitGoal
   
   If Left$(R$, 1) = "E" Then
      MsgBox R$, vbOKOnly
      End
   End If
   
End Sub

' Quit from flex
Public Sub HaltFlex()
   HaltProlog ID
End Sub

' The following goals reflect the underlying prolog IS calls
Public Function InitGoal(Goal As String) As String
   InitGoal = Prolog.InitGoal(ID, Goal)
End Function

Public Function CallGoal() As String
   CallGoal = Prolog.CallGoal(ID)
End Function

Public Sub ExitGoal()
    Prolog.ExitGoal (ID)
End Sub

Public Function TellGoal(Goal As String) As String
    TellGoal = Prolog.TellGoal(ID, Goal)
End Function
