unit flex;

interface
uses IntelligenceServer, SysUtils, Dialogs, Forms, Controls, multi, edit, single,flexutil;

type TFlex = class(TObject)
   function RunGoal( Command : String ) : String;

   { Reflection of the intelligence server function calls }
   function  LoadFlex( CommandLine : PChar ) : Integer;
   procedure HaltFlex ;
   function  InitGoal( Input : PChar ) : PChar;
   function  CallGoal  : PChar;
   function  TellGoal(Input : PChar ) : PChar ;
   procedure ExitGoal;
end;

implementation
var ID : Integer;


{ Run the specified command }
function TFlex.RunGoal( Command : String ) : String;
var ResultString,
    TextString,
    ItemString,
    RemainderString : String;
    Button : TMsgDlgButtons;
begin
   // Initialize the goal
   // This cast to PChar is OK as this function is in the same thread
   // as the called unit
   ResultString := InitGoal( PChar(Command) );

   // If an error occurs then return immediately with the error
   if ResultString[1] = 'E' Then
   begin
      RunGoal := ResultString;
      Exit;
   end;

   // Call the goal
   ResultString := CallGoal;

   // While flex requires more input
   while ResultString[1] = 'I' do
   begin
      // Get the text
      TextString := copy( ResultString, 10, 65535  );

      // Select on the input tag
      case ResultString[9] of
         'f' :                  // Flash a message
            begin
               MessageDlg(PChar(copy(TextString,2,65535)),mtCustom,[mbOK],0);
               ResultString := '';
            end;

         'm' :                  // A multiple selection
            ResultString := MultiBox( TextString ) + '. ';

         's' :                  // A single selection
            ResultString := ListBox( TextString ) + '. ';

         'e' :                  // An edit selection
            ResultString := EditBox( TextString );

         'x' :                  // A message box
            begin
               ItemString := flexutil.GetItem( TextString, RemainderString );

               if CompareStr( ItemString, 'ok' ) = 0 then
                     Button := [mbOK]
               else
               if CompareStr( ItemString, 'okcancel' ) = 0 then
                     Button := [mbOK,mbCancel]
               else
               if CompareStr( ItemString, 'yesno' ) = 0 then
                     Button := [mbOK,mbCancel]
               else
               if CompareStr( ItemString, 'yesnocancel' ) = 0 then
                     Button := [mbOK,mbCancel] ;

               case MessageDlg(PChar(copy(RemainderString,2,65535)),mtCustom, Button,0) of
                   mrOk :
                     ResultString := 'ok. ';
                   mrCancel:
                     ResultString := 'cancel. ';
                   mrYes:
                     ResultString := 'yes. ';
                   mrNo:
                     ResultString := 'no. ';
               end;
            end;
      end;

      // Tell flex the input string
      ResultString := TellGoal( PChar(ResultString) );
   end;

   // End the goal
   ExitGoal;

   // Return the result
   RunGoal := ResultString;
end;

{ Reflection of the intelligence server function calls }

function TFlex.LoadFlex( CommandLine : PChar ) : Integer;
var MsgString, ResultString : String;
begin
   ID := LoadProlog( CommandLine, 0, 0, 0 );

   if ID < 0 then
   begin
      case ID of
         isERR_CMUTEX:
            MsgString := 'isERR_CMUTEX';
         isERR_WMUTEX:
            MsgString := 'isERR_WMUTEX';
         isERR_LOCATE:
            MsgString := 'isERR_LOCATE';
         isERR_CREATE:
            MsgString := 'isERR_CREATE';
         isERR_MAPFIL:
            MsgString := 'isERR_MAPFIL';
         isERR_PROLOG:
            MsgString := 'isERR_PROLOG';
         isERR_WINDOW:
            MsgString := 'isERR_WINDOW';
      end;
      MsgString := 'There was an error loading flex: '+MsgString+IntToStr(ID);
      MessageDlg( PChar(MsgString), mtError, [mbOK], 0 );
      Application.Terminate;
   end;

   ResultString := InitGoal( 'ensure_loaded( prolog(flexserv) ). ' );
   ResultString := CallGoal;
   ExitGoal;

   if ResultString[1] = 'E' Then
   begin
      MessageDlg( PChar(ResultString), mtError, [mbOK], 0 );
      Application.Terminate;
   end;

   LoadFlex := ID;
end;

procedure TFlex.HaltFlex;
begin
   HaltProlog( ID );
end;

function TFlex.InitGoal( Input : PChar ) : PChar;
begin
   InitGoal := IntelligenceServer.InitGoal( ID, Input );
end;

function TFlex.CallGoal : PChar;
begin
   CallGoal := IntelligenceServer.CallGoal( ID );
end;

function TFlex.TellGoal( Input : PChar ) : PChar;
begin
   TellGoal := IntelligenceServer.TellGoal( ID, Input );
end;

procedure TFlex.ExitGoal;
begin
   IntelligenceServer.ExitGoal( ID );
end;

end.
