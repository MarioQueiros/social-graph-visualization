/*
   Compare Two Prolog Source Files - Brian D Steel - 25 Nov 97 / 24 Jun 02
   -----------------------------------------------------------------------

   This program takes a pair of file names, and analyses their respective
   definitions for logical equivalence, producing a report containing the
   following information:

   1. Predicates in file 1 but not file 2
   2. Predicates in file 2 but not file 1
   3. Predicates identical in both file 1 and file 2
   4. Clauses in file 1 but not file 2
   5. Clauses in file 2 but not file 1
   6. Clauses in file 1 and file 2 but transposed

   Unlike simple text comparison methods, this program compares the logical
   relationship between two Prolog files. Variable names, comments, layout
   and other "noise" is ignored.
*/

% compare two prolog files for equivalence, and display a report

compare( File1, File2 ) :-
   absolute_file_name( File1, Name1 ),
   consult( File1 ),
   forall( source_file( Pred, Name1 ),
           (  functor( Pred, Functor, Arity ),
              delflg( Functor, Arity, 1 ),
              addflg( Functor, Arity, 2 ),
              hide( Functor, 1 )
           )
         ),
   absolute_file_name( File2, Name2 ),
   consult( File2 ),
   forall( source_file( Pred, Name2 ),
           (  functor( Pred, Functor, Arity ),
              delflg( Functor, Arity, 1 ),
              addflg( Functor, Arity, 2 ),
              hide( Functor, 1 )
           )
         ),
   dynamic( compare/4 ),
   compare_test( Name1, Name2 ),
   compare_show( Name1, Name2 ),
   abolish_files( File1 ),
   abolish_files( File2 ).

% report predicates both in file 1 and file 2

compare_test( Name1, Name2 ) :-
   source_file( Pred1, Name1 ),
   source_file( Pred2, Name2 ),
   equivalent( Pred1, Pred2 ),
   assert( compare(shared,Pred1,Pred2,[]) ),
   fail.

% report predicates in file 1 but not file 2

compare_test( Name1, Name2 ) :-
   source_file( Pred1, Name1 ),
   \+ (  source_file( Pred2, Name2 ),
         equivalent( Pred1, Pred2 )
      ),
   assert( compare(unique,Name1,Pred1,[]) ),
   fail.

% report predicates in file 2 but not file 1

compare_test( Name1, Name2 ) :-
   source_file( Pred2, Name2 ),
   \+ (  source_file( Pred1, Name1 ),
         equivalent( Pred1, Pred2 )
      ),
   assert( compare(unique,Name2,Pred2,[]) ),
   fail.

% for shared predicates, report which are identical

compare_test( _, _ ) :-
   compare( shared, Pred1, Pred2, [] ),
   clauses( Pred1, Prog1 ),
   clauses( Pred2, Prog2 ),
   equivalent( Prog1, Prog2 ),
   assert( compare(identical,Pred1,Pred2,[]) ),
   fail.

% for non-identical shared predicates, report their existence

compare_test( Name1, Name2 ) :-
   compare( shared, Pred1, Pred2, [] ),
   \+ compare( identical, Pred1, Pred2, [] ),
   assert( compare(different,Pred1,Pred2,[]) ),
   fail.

% for different predicates, report clauses in file 1 but not file 2

compare_test( Name1, Name2 ) :-
   compare( different, Pred1, Pred2, [] ),
   clause( Pred1, Body1, Posn1 ),
   \+ (  clause( Pred2, Body2 ),
         equivalent( (Pred1,Body1), (Pred2,Body2) )
      ),
   assert( compare(additional,Name1,Pred1,Posn1) ),
   fail.

% for different predicates, report clauses in file 2 but not file 1

compare_test( Name1, Name2 ) :-
   compare( different, Pred1, Pred2, [] ),
   clause( Pred2, Body2, Posn2 ),
   \+ (  clause( Pred1, Body1 ),
         equivalent( (Pred1,Body1), (Pred2,Body2) )
      ),
   assert( compare(additional,Name2,Pred2,Posn2) ),
   fail.

% for different predicates, report clauses in both files but transposed

compare_test( Name1, Name2 ) :-
   compare( different, Pred1, Pred2, [] ),
   clause( Pred1, Body1, Posn1 ),
   clause( Pred2, Body2, Posn2 ),
   equivalent( (Pred1,Body1), (Pred2,Body2) ),
   Posn1 \= Posn2,
   assert( compare(transposed,Pred1,Pred2,(Posn1,Posn2)) ),
   fail.

% succeed when all test are done

compare_test( _, _ ).

% show results of the tests

compare_show( Name1, Name2 ) :-
   write( `~M~JComparison of ` ),
   write( Name1 ),
   write( ` and ` ),
   write( Name2 ),
   write( `~M~J========================================================~M~J` ),
   fail.

% show predicates in file 1 but not file 2

compare_show( Name1, Name2 ) :-
   write( `~M~JPredicates in ` ),
   write( Name1 ),
   write( ` but not ` ),
   write( Name2 ),
   write( `~M~J--------------------------------------------------------~M~J` ),
   compare( unique, Name1, Pred1, [] ),
   write( `~I` ),
   write( Pred1 ),
   write( `~M~J` ),
   fail.

% show predicates in file 2 but not file 1

compare_show( Name1, Name2 ) :-
   write( `~M~JPredicates in ` ),
   write( Name2 ),
   write( ` but not ` ),
   write( Name1 ),
   write( `~M~J--------------------------------------------------------~M~J` ),
   compare( unique, Name2, Pred2, [] ),
   write( `~I` ),
   write( Pred2 ),
   write( `~M~J` ),
   fail.

% for shared predicates, show those which are identical

compare_show( Name1, Name2 ) :-
   write( `~M~JPredicates identical in both ` ),
   write( Name1 ),
   write( ` and ` ),
   write( Name2 ),
   write( `~M~J--------------------------------------------------------~M~J` ),
   compare( identical, Pred1, Pred2, [] ),
   write( `~I` ),
   write( Pred1 ),
   write( `~M~J` ),
   fail.

% for different predicates, show clauses in file 1 but not file 2

compare_show( Name1, Name2 ) :-
   write( `~M~JClauses in ` ),
   write( Name1 ),
   write( ` but not ` ),
   write( Name2 ),
   write( `~M~J--------------------------------------------------------~M~J` ),
   compare( additional, Name1, Pred1, Posn1 ),
   write( `~I` ),
   write( Pred1 ),
   write( ` (` ),
   write( Posn1 ),
   write( `) ~M~J` ),
   fail.

% for different predicates, show clauses in file 2 but not file 1

compare_show( Name1, Name2 ) :-
   write( `~M~JClauses in ` ),
   write( Name2 ),
   write( ` but not ` ),
   write( Name1 ),
   write( `~M~J--------------------------------------------------------~M~J` ),
   compare( additional, Name2, Pred2, Posn2 ),
   write( `~I` ),
   write( Pred2 ),
   write( ` (` ),
   write( Posn2 ),
   write( `) ~M~J` ),
   fail.

% for different predicates, show clauses in both files but transposed

compare_show( Name1, Name2 ) :-
   write( `~M~JClauses in ` ),
   write( Name1 ),
   write( ` and ` ),
   write( Name2 ),
   write( ` but transposed` ),
   write( `~M~J--------------------------------------------------------~M~J` ),
   compare( transposed, Pred1, Pred2, (Posn1,Posn2) ),
   write( `~I` ),
   write( Pred1 ),
   write( ` (` ),
   write( Posn1 ),
   write( ` : ` ),
   write( Posn2 ),
   write( `) ~M~J` ),
   fail.

% succeed when all showing is done

compare_show( _, _ ).

% test the equivalence of two terms

equivalent( Term1, Term2 ) :-
   eqv( Term1, Term2 ),
   dup( Term1, Copy1 ),
   vars( Copy1, Vars1 ),
   equivalent( Vars1 ),
   dup( Term2, Copy2 ),
   vars( Copy2, Vars2 ),
   equivalent( Vars2 ),
   eqv( Copy1, Copy2 ).

% unify variables with their names for equivalence testing

equivalent( [] ).

equivalent( [(Var,Var)|Vars] ) :-
   equivalent( Vars ).
