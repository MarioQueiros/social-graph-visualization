/*
   Matching or Searching for Subterms in a Term - Brian D Steel - 22 Jul 99
   ------------------------------------------------------------------------

   This predicate can be used to match or search for subterms within an
   arbitrary compound term, much in the way member/2 returns elements
   within a list. Compared with the latter, however, its arguments are
   reversed so that it can make use of first argument indexing. It
   recursively decomposes each the four 386-PROLOG compound data types,
   using head/tail pattern matching for each (note, in particular, that
   there is no need to use "univ" (=../2) in the tuple case.
*/

% a term is a subterm of itself

subterm( Term, Term ).

% find subterms in the head or tail of a list

subterm( [Head|_], Term ) :-
   subterm( Head, Term ).

subterm( [_|Tail], Term ) :-
   subterm( Tail, Term ).

% find subterms in the head or tail of a tuple

subterm( Head(|_), Term ) :-
   subterm( Head, Term ).

subterm( _(|Tail), Term ) :-
   subterm( Tail, Term ).

% find subterms in the head or tail of a conjunction

subterm( (Head,_), Term ) :-
   subterm( Head, Term ).

subterm( (_,Tail), Term ) :-
   subterm( Tail, Term ).

% find subterms in the head or tail of a disjunction

subterm( (Head|_), Term ) :-
   subterm( Head, Term ).

subterm( (_|Tail), Term ) :-
   subterm( Tail, Term ).
