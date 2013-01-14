/*
   Hash All Static User Predicates - Brian D Steel - 28 Aug 01 / 05 Nov 03
   =======================================================================

   This simple utility attempts to hash all non-optimised, static user
   predicates with a clause count greater than the given value, for example:

      ?- hash_all( 0 ).       % hashes all static user predicates
      ?- hash_all( 10 ).      % hashes user predicates with 10 or more clauses
      ?- hash_all( -1 ).      % removes hashing from all user predicates
*/

% remove hashing from all static user predicates

hash_all( Limit ) :-
   type( Limit, 1 ),
   pdict( -1, 2, 16'00100001, Hashed ),
   forall( member( (Pred,Arity), Hashed ),
           hshprd( Pred, Arity, -1, _, _, _, _ )
         ),
   cmp( 0, Limit, -1 ),
   !.

% add hashing to all suitable static user predicates

hash_all( Limit ) :-
   type( Limit, 1 ),
   pdict( -1, 1, 16'00100001, Unhashed ),
   forall( member( (Pred,Arity), Unhashed ),
           (  hshprd( Pred, Arity, 0, Count, _, _, _ ),
              cmp( 1, Limit, Count )
           -> hshprd( Pred, Arity, -1, _, _, _, _ )
           ;  true
           )
         ),
   pdict( -1, 2, 16'00100001, Hashed ),
   output( Output ),
   output( 0 ),
   write( `Predicate               ` ),
   write( `Count       Cases       ` ),
   write( `Ratio       Worst       ` ),
   write( `~M~J` ),
   write( `----------------------  ` ),
   write( `----------  ----------  ` ),
   write( `----------  ----------  ` ),
   write( `~M~J` ),
   forall( member( (Pred,Arity), Hashed ),
           (  hshprd( Pred, Arity, Quota, Count, Cases, Misht, Worst ),
              Ratio is Misht / Cases,
              (  writeq( Pred ),
                 write( `/` ),
                 write( Arity )
              ) ~> Text,
              fwrite( s, -22, -1, Text ),
              write( `  ` ),
              fwrite( n, 10, -1, Count ),
              write( `  ` ),
              fwrite( n, 10, -1, Cases ),
              write( `  ` ),
              fwrite( f, 10, -3, Ratio ),
              write( `  ` ),
              fwrite( n, 10, -1, Worst ),
              write( `  ` ),
              write( `~M~J` )
           )
         ),
   output( Output ),
   !.

% report a type or instantiation error

hash_all( Limit ) :-
   (  type( Limit, 0 )
   -> throw( 22, hash_all(Limit) )
   ;  throw( 23, hash_all(Limit) )
   ).
