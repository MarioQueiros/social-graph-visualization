/*
   WIN-PROLOG Message Reporter - Brian D Steel - 05 Mar 99 / 09 Jun 04
   ===================================================================

   This program uses the message hook, '?MESSAGE?'/4, to intercept and
   report window messages, using its own window, "Messages". This code
   is self-running, and can only be stopped by manually abolishing the
   message hook predicate.
*/

:- flag( 0 ).

'?MESSAGE?'( Wnd, Num, Dta, Cal ) :-
   (  (  wndhdl( msg, _ )
      -> Wnd \= (msg,1)
      ;  wcreate( msg, text, `Messages`, 0, 0, 0, 0, 0 )
      ),
      msg( Num, Msg )
   -> eprint( Wnd ) ~> Win,
      rpn( [Dta,16'0ffff,a], Low ),
      rpn( [Dta,16'10000,/], Hgh ),
      (  fwrite( s, -15, -1, Win ), ewrite( ` ` ),
         fwrite( s, -15, -1, Msg ), ewrite( ` ` ),
         fwrite( r,   5, 10, Low ), ewrite( ` ` ),
         fwrite( r,   5, 10, Hgh ), ewrite( ` ` ),
         fwrite( r,   8, 16, Dta ), ewrite( ` ` ),
         eprint( Cal ), nl
      ) ~> Txt,
      wrchsel( (msg,1), 16'7fffffff, 16'7fffffff ),
      wrchtxt( (msg,1), -2, Txt )
   ;  true
   ),
   message_hook( Wnd, Num, Dta, Cal).

msg( 00, `msg_menu`        ).
msg( 01, `msg_sysmenu`     ).
msg( 02, `msg_close`       ).
msg( 03, `msg_focus`       ).
msg( 04, `msg_fuzzy`       ).
msg( 05, `msg_change`      ).
msg( 06, `msg_button`      ).
msg( 07, `msg_select`      ).
msg( 08, `msg_double`      ).
msg( 09, `msg_size`        ).
msg( 10, `msg_move`        ).
msg( 11, `msg_horz`        ).
msg( 12, `msg_vert`        ).
msg( 13, `msg_paint`       ).
msg( 14, `msg_leftdown`    ).
msg( 15, `msg_leftdouble`  ).
msg( 16, `msg_leftup`      ).
msg( 17, `msg_rightdown`   ).
msg( 18, `msg_rightdouble` ).
msg( 19, `msg_rightup`     ).
msg( 20, `msg_wheeldown`   ).
msg( 21, `msg_wheeldouble` ).
msg( 22, `msg_wheelup`     ).
msg( 23, `msg_mousemove`   ).
msg( 24, `msg_mouseenter`  ).
msg( 25, `msg_mousehover`  ).
msg( 26, `msg_mouseleave`  ).
msg( 27, `msg_char`        ).
msg( 28, `msg_key`         ).
msg( 29, `msg_help`        ).
msg( 30, `msg_popup`       ).

msg( XX, Msg ) :-
   (  ewrite( `?` ),
      ewrite( XX ),
      ewrite( `?` )
   ) ~> Msg.
