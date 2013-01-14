/*
   Automatic Memory Adjustment - Brian D Steel - 14 Nov 03
   =======================================================

   This file contains a simple error handler which intercepts memory full
   errors and adjust the appropriate memory before trying the goal again.

   Note that Backtrack, Local, Reset and Heap Full errors cannot be processed
   directly, because these errors need more of the exhausted resource in
   order to build a call to the error handler. Careful use of catch/2 and
   xinit/9 can be used to handle these cases if required.
*/

:- dynamic error_reserve/1.

:- dynamic error_reserve/4.

% error handler tries memory cases first, and calls error hook if no good

'?ERROR?'( Error, Goal ) :-
   (  error_space( Error, Current, Setting )
   -> error_write( Error, Current, Setting ),
      Goal
   ;  error_hook( Error, Goal )
   ).

% see whether we have any spare memory to reuse

error_space( Error, Current, Setting ) :-
   (  error_reserve( Error, Count, Adjust, Template ),
      cmp( 1, Count, 0 )
   -> Less is Count - 1,
      (  retract( error_reserve(Error,Count,Adjust,Template) )
      -> assert( error_reserve(Error,Less,Adjust,Template) )
      ),
      dup( Template, Duplicate ),
      Duplicate = Current(|Get),
      xinit( |Get ),
      Template = Setting(|Set),
      Setting is Current + Adjust,
      error_zero( Set ),
      abolish( error_reserve/1 ),
      xinit( |Set ),
      assert( error_reserve(`the quick brown fox jumps over a lazy dog`) )
   ).

% write a simple report to the user to show that memory has been increased

error_write( Error, Current, Setting ) :-
   errmsg( Error, Message ),
   output( Output ),
   output( 0 ),
   write( `Potential "` ),
   write( Message ),
   write( `" error avoided by increasing allocation from ` ),
   write( Current ),
   write( ` to ` ),
   write( Setting ),
   write( ` kilobytes~M~J` ),
   output( Output ).

% zero any variables in the call template

error_zero( [] ).

error_zero( [Head|Tail] ) :-
   (  type( Head, 0 )
   -> Head = 0
   ;  type( Head, 1 )
   ),
   error_zero( Tail ).

% reserve a little text space for use by the xinit/9 predicate

error_reserve( `the quick brown fox jumps over a lazy dog` ).

% specify the number of times and amounts by which memory should be increased

error_reserve( 1, 9,   32, Bak(Bak,_,_,_,_,_,_,_,_) ).
error_reserve( 2, 9,   32, Loc(_,Loc,_,_,_,_,_,_,_) ).
error_reserve( 3, 9,   32, Rst(_,_,Rst,_,_,_,_,_,_) ).
error_reserve( 4, 9,  256, Hep(_,_,_,Hep,_,_,_,_,_) ).
error_reserve( 5, 9, 1024, Txt(_,_,_,_,Txt,_,_,_,_) ).
error_reserve( 6, 9, 4096, Prg(_,_,_,_,_,Prg,_,_,_) ).
error_reserve( 7, 9,   32, Stk(_,_,_,_,_,_,Stk,_,_) ).
error_reserve( 8, 9,  128, Inp(_,_,_,_,_,_,_,Inp,_) ).
error_reserve( 9, 9,  128, Oup(_,_,_,_,_,_,_,_,Oup) ).
