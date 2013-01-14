{ LPA-Delphi Logic Server
  PROGRAM: INT386W.PAS
  PURPOSE: Interface unit to the intelligence server DLL
  CREATED: May 1996
  MODIFIED for unicode: February 2001
  MODIFIED for changes to LoadProlog : March 2003
  AUTHOR:  Alan Westwood

  Copyright (c) 2003 LPA Ltd.
}

// Defining LPAUNICODE before compilation allows the use of wide strings
// but in that case String constants will need to be type cast with
// PChar( 'fred' ) or PWideChar( 'fred' ) .
// use either LoadProlog encoding 0 or encoding 1 ( eg. LoadProlog( "", 0, 1, 0 )
// or LoadProlog( "", 0, 0, 0 ) )
// Not defining LPAUNICODE will mean that the interface will work in it's old
// Ansi string mode.
// use LoadProlog encoding 0, ( eg. LoadProlog("",0,0,0) ) otherwise PChar will
// be interpreted as PWideChar
// within the interface.

//{$DEFINE LPAUNICODE}

unit IntelligenceServer;

interface

   const  isERR_ENCODE = -1;
   const  isERR_TICKLE = -2;
   const  isERR_CMUTEX = -3;
   const  isERR_WMUTEX = -4;
   const  isERR_LOCATE = -5;
   const  isERR_CREATE = -6;
   const  isERR_MAPFIL = -7;
   const  isERR_MODULE = -8;
   const  isERR_PROLOG = -9;
   const  isERR_ACTIVE = -10;
   const  isERR_WINDOW = -11;

{ prototypes }
   function  LoadProlog( CommandLine : PChar; Desire, Encode, Tickle : Integer   ) : Integer; stdcall;
   procedure HaltProlog( PrologID : Integer ) ; stdcall;
   procedure ExitGoal( PrologID : Integer )  ; stdcall;

{$IFDEF LPAUNICODE }
   function  InitGoal( PrologID : Integer; Input : PChar )     : PChar ; stdcall; overload;
   function  InitGoal( PrologID : Integer; Input : PWideChar ) : PWideChar ; stdcall; overload;

   function  TellGoal( PrologID : Integer; Input : PChar )     : PChar ; stdcall; overload;
   function  TellGoal( PrologID : Integer; Input : PWideChar ) : PWideChar ; stdcall; overload;

   function  CallGoal( PrologID : Integer ) : Pointer ; stdcall;
{$ELSE}
   function  InitGoal( PrologID : Integer; Input : PChar )   : PChar ; stdcall;
   function  TellGoal( PrologID : Integer; Input : PChar )   : PChar ; stdcall;
   function  CallGoal( PrologID : Integer )                  : PChar ; stdcall;
{$ENDIF}


implementation

   function  LoadProlog( CommandLine : PChar; Desire, Encode, Tickle : Integer ) : Integer; stdcall;  external 'INT386W.DLL';
   procedure HaltProlog( PrologID : Integer ); stdcall;  external 'INT386W.DLL';
   procedure ExitGoal( PrologID : Integer );  stdcall;  external 'INT386W.DLL';

{$IFDEF LPAUNICODE }
   function  InitGoal( PrologID : Integer; Input : PChar )     : PChar; stdcall;  external 'INT386W.DLL';
   function  InitGoal( PrologID : Integer; Input : PWideChar ) : PWideChar; stdcall;  external 'INT386W.DLL';

   function  TellGoal( PrologID : Integer; Input : PChar )     : PChar; stdcall; external 'INT386W.DLL';
   function  TellGoal( PrologID : Integer; Input : PWideChar ) : PWideChar; stdcall; external 'INT386W.DLL';

   function  CallGoal( PrologID : Integer ) : Pointer; stdcall;  external 'INT386W.DLL';
{$ELSE}
   function  InitGoal( PrologID : Integer; Input : PChar ) : PChar; stdcall;  external 'INT386W.DLL';
   function  CallGoal( PrologID : Integer )                : PChar; stdcall;  external 'INT386W.DLL';
   function  TellGoal( PrologID : Integer; Input : PChar ) : PChar; stdcall; external 'INT386W.DLL';
{$ENDIF}

end.

