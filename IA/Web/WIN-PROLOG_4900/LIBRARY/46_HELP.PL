/*
   Perform a Help Command - Brian D Steel - 10 Oct 96 / 18 Apr 07
   ==============================================================

   The help/3 predicate was removed from WIN-PROLOG 4.700, because support
   for "classical" 32-bit Windows has been dropped from Windows itself with
   the advent of Windows Vista. This file contains the exact implementation
   that was used up to and including WIN-PROLOG 4.650, and can simply be
   loaded into any application which requires old-style help.
*/

help( File, Command, Info ) :-
   (  type( File, 3 ),
      type( Command, 1 ),
      (  type( Info, 1 )
      ;  type( Info, 4 )
      )
   -> wndhdl( 0, Handle ),
      stratm( String, File ),
      winapi( (user32,'WinHelpA'), [Handle,String,Command,Info], 0, _ )
   ;  (  type( File, 0 )
      ;  type( Command, 0 )
      ;  type( Info, 0 )
      )
   -> throw( 22, help(File,Command,Info) )
   ;  throw( 23, help(File,Command,Info) )
   ).
