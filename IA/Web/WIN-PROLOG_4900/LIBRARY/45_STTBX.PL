/*
   Implementation of Status Box Predicates - Brian D Steel - 28 Oct 04
   ===================================================================

   The sttbox/2 predicate was implemented in the very first version of
   WIN-PROLOG, long before there were any general user-programmable windows
   and dialogs in the system, and was "farmed out" to a separate DLL in
   version 3.500 of WIN-PROLOG. The final version in which this predicate
   appeared was 4.500, by which point it was considered an anachronism: all
   other functions of the separate DLL had been brought into WIN-PROLOG
   itself, and the DLL did not support Unicode text.

   This file faithfully reproduces the original, quirky behaviour of sttbox/2,
   together with its sister predicates, status_box/1 and erase_status_box/0,
   with the single exception of the case where "65535" is specified as the
   "font": this was designed to display the WIN-PROLOG welcome banner, which
   function is now handled by the bdsbox/2 predicate. On the other hand, this
   version of the program does support Unicode on WinNT/2K/XP platforms.
*/

:- dynamic sttbox_data/2.

% show message in default status box

status_box( Message ) :-
   wdict( -1, Windows ),
   forall( member( Window, Windows ),
           wenable( Window, 0 )
         ),
   sttbox( Message, 0 ).

% hide status box

erase_status_box :-
   sttbox( ``, -1 ),
   wdict( -1, Windows ),
   forall( member( Window, Windows ),
           wenable( Window, 1 )
         ).

% show message in, or hide specific status box

sttbox( Content, Style ) :-
   (  sttbox_fonts( Style, Handle )
   -> ewrite( Content ) ~> String,
      sttbox_exist( Exist, Stored ),
      sttbox_parse( News ) <~ String,
      sttbox_parse( Olds ) <~ Stored,
      sttbox_merge( News, Olds, Merge ),
      sttbox_build( Merge, Status ),
      sttbox_store( Status, Exist, Handle )
   ;  throw( 10, sttbox(Content,Style) )
   ).

% convert given style to a font handle

sttbox_fonts( Style, Handle ) :-
   (  Style = -1
   -> Handle = Style
   ;  fnthdl( Style, Handle )
   ).

% return existing font and text data, if any

sttbox_exist( Exist, Stored ) :-
   (  sttbox_data( Exist, Stored )
   -> true
   ;  (Exist,Stored) = ([],``)
   ).

% parse current input into a list

sttbox_parse( List ) :-
   (  fread( s, 0, -1, Head )
   -> List = [Head,`~M~J`|Tail],
      sttbox_parse( Tail )
   ;  List = []
   ).

% merge two lists of text items

sttbox_merge( List, Text, Merge ) :-
   (  List = []
   -> Merge = Text
   ;  List = [New,Join|News]
   -> (  Text = []
      -> Head = New,
         Olds = Text
      ;  Text = [Old,_|Olds],
         (  New = ``
         -> Head = Old
         ;  Head = New
         )
      ),
      Merge = [Head,Join|Tail],
      sttbox_merge( News, Olds, Tail )
   ).

% store status box data, and show the status box as required

sttbox_store( Status, Exist, Handle ) :-
   dynamic( sttbox_data/2 ),
   assert( sttbox_data(Handle,Status) ),
   (  Handle = -1
   -> (  wndhdl( sttbox, _ )
      -> wclose( sttbox )
      ;  true
      )
   ;  Handle = Exist,
      wndhdl( sttbox, _ )
   -> wtext( sttbox, Status ),
      wshow( sttbox, 1 ),
      wfocus( sttbox )
   ;  wfsize( font(Handle), `#`, PixW, PixD ),
      winapi( (user32,'GetDesktopWindow'), [], 0, Window ),
      wsize( Window, _, _, PixX, PixY ),
      W is 51 * PixW + 6,
      D is 16 * PixD + 6,
      X is (PixX-W) // 2,
      Y is (PixY-D) // 2,
      Style = [ws_popup,ws_ex_dlgmodalframe],
      wccreate( sttbox, static, Status, X, Y, W, D, Style ),
      wfont( sttbox, font(Handle) ),
      wshow( sttbox, 1 )
   ).

% build the new status box string

sttbox_build( Merge, Status ) :-
   (  Merge = []
   -> Status = ``
   ;  cat( Merge, Status, _ )
   ).
