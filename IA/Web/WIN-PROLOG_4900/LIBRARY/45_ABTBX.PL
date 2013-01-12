/*
   Implementation of About Box Predicate - Brian D Steel - 28 Oct 04
   =================================================================

   The original abtbox/3 predicate was implemented in the very first version
   of WIN-PROLOG, long before there were any general user-programmable windows
   and dialogs in the system, and was "farmed out" to a separate DLL in
   version 3.500 of WIN-PROLOG. Over the years, the design of the "About Box"
   changed, and the arity was incremented to allow additional control. The
   final version in which the abtbox/4 predicate appeared was 4.500, by which
   point it was considered an anachronism: all other functions of the separate
   DLL had been brought into WIN-PROLOG itself, and the DLL did not support
   Unicode text.

   This file faithfully reproduces the original behaviour of abtbox/4, by
   adding a custom window handler for the bdsbox/2 predicate. This version
   of the program does support Unicode on WinNT/2K/XP platforms.
*/

:- dynamic abtbox_data/4.

% display a modal about box dialog using the banner display & status box

abtbox( Term1, Term2, Font1, Font2 ) :-
   (  abtbox_fonts( Font1, Handle1 ),
      abtbox_fonts( Font2, Handle2 )
   -> ewrite( Term1 ) ~> String1,
      ewrite( Term2 ) ~> String2,
      abtbox_parse( Grafix1, 0, Handle1 ) <~ String1,
      abtbox_parse( Grafix2, 0, Handle2 ) <~ String2,
      abtbox_store( Handle1, Handle2, Grafix1, Grafix2 )
   ;  throw( 10, abtbox(Term1,Term2,Font1,Font2) )
   ).

% convert given style to a font handle

abtbox_fonts( Style, Handle ) :-
   (  Style = -1
   -> Handle = Style
   ;  fnthdl( Style, Handle )
   ).

% return existing font and text data, if any

abtbox_exist( Handle1, Handle2, String1, String2 ) :-
   (  abtbox_data( Handle1, Handle2, String1, String2 )
   -> true
   ;  fnthdl( 0, Handle ),
      (Handle1,Handle2,String1,String2) = (Handle,Handle,``,``)
   ).

% parse current input into a grafix sequence

abtbox_parse( Grafix, Ycoord, Handle ) :-
   (  fread( s, 0, -1, Head )
   -> Grafix = (text(0,Ycoord,Head),Tail),
      wfsize( font(Handle), Head, _, Height ),
      Zcoord is Ycoord + Height,
      abtbox_parse( Tail, Zcoord, Handle )
   ;  Grafix = text(0,Ycoord,``)
   ).

% store about box data, and show the banner display & status box

abtbox_store( Handle1, Handle2, Grafix1, Grafix2 ) :-
   dynamic( abtbox_data/4 ),
   assert( abtbox_data(Handle1,Handle2,Grafix1,Grafix2) ),
   window_handler( 3, abtbox_handler ),
   wenable( 0, 0 ),
   bdsbox( ``, 1 ),
   (  repeat,
      wait( 0 ),
      bdsbox( _, Mode ),
      Mode = -1
   -> window_handler( 3, window_handler ),
      dynamic( abtbox_data/4 )
   ),
   wenable( 0, 1 ),
   wfocus( 1 ).

% on left down, close the banner & display status box

abtbox_handler( _, msg_leftdown, _, done ) :-
   bdsbox( ``, -1 ).

% on paint, display the stored text on the banner & display status box

abtbox_handler( _, msg_paint, _, _ ) :-
   abtbox_exist( Handle1, Handle2, Grafix1, Grafix2  ),
   gfx_begin( 3 ),
   gfx( ( (  fore=stock(white_fore),
             font=font(Handle1),
             @(10,10)
          -> Grafix1
          ),
          (  fore=stock(black_fore),
             font=font(Handle2),
             @(10,328)
          -> Grafix2
          )
        )
      ),
   gfx_end( 3 ).

% for all other messages, defer to the default window handler

abtbox_handler( Window, Message, Data, Result ) :-
   window_handler( Window, Message, Data, Result ).
