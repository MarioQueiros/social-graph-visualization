/*
   Implementation of Old Text Search Predicate - Brian D Steel - 02 Sep 98
   =======================================================================

   Version 3.900 of 386-PROLOG introduced a new, considerably more advanced
   text predicate than had previously been available: the new find/3 subsumes
   the functionality of the old find/1. This simple library file contains a
   definition of the previous predicate to aid with porting code to the new
   version of Prolog.
*/

% define the old find/1 predicate

find( Text ) :-
   (  type( Text, 3 )
   -> stratm( Find, Text )
   ;  type( Text, 4 )
   -> Find = Text
   ;  type( Text, 0 )
   -> throw( 22, find(Text) )
   ;  throw( 23, find(Text) )
   ),
   find( Find, 0, Hit ),
   cmp( 1, Hit, `` ).
