/*
   Automatic Memory Handling during Call - Brian D Steel - 19 Nov 03
   =================================================================

   This simple program attempts to perform a given Goal, and if it fails
   due to a memory full error, it reallocates memory and tries again. A
   total retry count is specified to prevent infinite memory expansion.
   For example, the call:

      ?- call( len(X,99999), 5, Used ).

   attempts to create a list of 99,999 elements, expanding memory as
   required up to 5 times, and returning the number of increments used.
*/

call( Goal, Count, Used ) :-
   call_exec( Goal, Count, Count, Used ).

% retry the goal as needed, returning the number increments used

call_exec( Goal, Count, Init, Used ) :-
   catch( Error, (Goal,!) ),
   (  Error = 0
   -> Used is Init - Count
   ;  cmp( 1, Error, 0 ),
      cmp( -1, Error, 10 ),
      cmp( 1, Count, 0 )
   -> call_data( Error, Adjust, Current(|Get) ),
      call_data( Error, Adjust, Setting(|Set) ),
      xinit( |Get ),
      Setting is Current + Adjust,
      call_zero( Set ),
      xinit( |Set ),
      Less is Count - 1,
      call_exec( Goal, Less, Init, Used )
   ;  throw( Error, Goal )
   ).

% zero any variables in the call template

call_zero( [] ).

call_zero( [Head|Tail] ) :-
   (  type( Head, 0 )
   -> Head = 0
   ;  type( Head, 1 )
   ),
   call_zero( Tail ).

% specify amounts by which memory should be increased

call_data( 1,   32, Bak(Bak,_,_,_,_,_,_,_,_) ).
call_data( 2,   32, Loc(_,Loc,_,_,_,_,_,_,_) ).
call_data( 3,   32, Rst(_,_,Rst,_,_,_,_,_,_) ).
call_data( 4,  256, Hep(_,_,_,Hep,_,_,_,_,_) ).
call_data( 5, 1024, Txt(_,_,_,_,Txt,_,_,_,_) ).
call_data( 6, 4096, Prg(_,_,_,_,_,Prg,_,_,_) ).
call_data( 7,   32, Stk(_,_,_,_,_,_,Stk,_,_) ).
call_data( 8,  128, Inp(_,_,_,_,_,_,_,Inp,_) ).
call_data( 9,  128, Oup(_,_,_,_,_,_,_,_,Oup) ).
