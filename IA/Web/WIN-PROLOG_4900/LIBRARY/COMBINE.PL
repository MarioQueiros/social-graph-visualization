/*
   Combine Prolog Source Files - Brian D Steel - 08 Dec 97 / 10 jun 00
   -------------------------------------------------------------------

   This program takes a list of file names, and analyses the source code
   contained within them, before combining them into a single target file.
   The combination process uses three rules:

   1. Any predicates shared and identical between all files are copied in
      their entirely from the first file; the remaining copies are discarded

   2. Any predicates shared between some (but not all) of the files, or which
      are shared by all but contain differences in at least one of the files,
      are renamed, and a program of the original name is added to call
      whichever version is appropriate

   3. Any predicates which are unique to any one file are copied from the
      appropriate file

   The resulting target file should contain all original comments and formats
   pertaining to the predicates, except those which may be lost in discarded
   copies of code in case (1) above.
*/

% combine the source files in the given list into the given target file

combine( [Source1|Sources], Target ) :-
   dynamic( cmb_data/1 ),
   dynamic( cmb_data/2 ),
   dynamic( cmb_data/4 ),
   forall( member( Source, [Source1|Sources] ),
           cmb_load( Source )
         ),
   findall( Name, cmb_data(Name), Names ),
   cmb_read_identical( Names ),
   cmb_read_different( Names ),
   cmb_read_unique( Names ),
   cmb_create( Target, Names ).

% load the given source file

cmb_load( Source ) :-
   absolute_file_name( Source, Name ),
   assert( cmb_data(Name) ),
   fcreate( source, Name, 0, 0, 0 ),
   input( Input ),
   input( source ),
   cmb_load( Name, 0 ),
   input( Input ),
   fclose( source ).

% read term clause in turn, recording its start and end offsets

cmb_load( _, _ ) :-
   eof,
   !.

cmb_load( Name, Pos ) :-
   eread( Term ),
   find( `~J`, 0, _ ),
   inpos( End ),
   Len is End - Pos,
   (  Term = (:- _)
   -> Item = !
   ;  Term = (?- _)
   -> Item = ?
   ;  Term = (Head :- Body)
   -> functor( Head, Pred, Arity ),
      Item = (Pred,Arity)
   ;  functor( Term, Pred, Arity ),
      Item = (Pred,Arity)
   ),
   inpos( Pos ),
   output( Output ),
   output( (``,0) ),
   copy( Len, _ ),
   output( Data ),
   output( Output ),
   Data = (Text,_),
   assert( cmb_data(Name,Term,Item,Text) ),
   !,
   cmb_load( Name, End ).

cmb_load( _, _ ).

% find predicates which are identical all files

cmb_read_identical( [Name|Names] ) :-
   forall( (  bagof( (Item,Term),
                     Text ^
                     (  cmb_data( Name, Term, (Pred,Arity), Text ),
                        Item = (Pred,Arity)
                     ),
                     Code
                   ),
              forall( member( Rest, Names ),
                      (  bagof( (Item,Term),
                                Text ^
                                (  cmb_data( Rest, Term, (Pred,Arity), Text ),
                                   Item = (Pred,Arity)
                                ),
                                Test
                              ),
                         cmb_equivalent( Code, Test )
                      )
                    )
           ),
           assert( cmb_data(identical,(Pred,Arity)) )
         ).

% find predicates which are different between files

cmb_read_different( [_] ) :-
   !.

cmb_read_different( [Name|Names] ) :-
   forall( (  cmb_data( Name, _, (Pred,Arity), _ ),
              member( Rest, Names ),
              cmb_data( Rest, _, (Pred,Arity), _ ),
              \+ cmb_data( _, (Pred,Arity) )
           ),
           assert( cmb_data(different,(Pred,Arity)) )
         ),
   cmb_read_different( Names ).

% find predicates which are unique to one file

cmb_read_unique( Names ) :-
   forall( (  member( Name, Names ),
              cmb_data( Name, _, (Pred,Arity), _ ),
              \+ cmb_data( _, (Pred,Arity) ),
              \+ cmb_data( _, (Name,Pred,Arity) )
           ),
           assert( cmb_data(unique,(Name,Pred,Arity)) )
         ).

% create the combined file from the gathered information

cmb_create( Target, Names ) :-
   absolute_file_name( Target, [file_type(source)], Name ),
   fcreate( target, Name, -1, 0, 0 ),
   output( Output ),
   output( target ),
   cmb_header( Names ),
   cmb_commands( Names ),
   cmb_queries( Names ),
   cmb_write_identical( Names ),
   cmb_write_different( Names ),
   cmb_write_unique( Names ),
   output( Output ),
   fclose( target ).

% output a header to the target file

cmb_header( Names ) :-
   time( Yr, Mt, Dy, Hr, Mn, Sc, _ ),
   mem( ['JAN','FEB','MAR','APR','MAY','JUN',
         'JUL','AUG','SEP','OCT','NOV','DEC'],
        [Mt], Mo ),
   ewrite( `%LPA% Combined file created at ` ),
   fwrite( r, 2, 10, Hr ),
   ewrite( : ),
   fwrite( r, 2, 10, Mn ),
   ewrite( : ),
   fwrite( r, 2, 10, Sc ),
   ewrite( ` on ` ),
   fwrite( r, 2, 10, Dy ),
   ewrite( - ),
   fwrite( a, 3,  0, Mo ),
   ewrite( - ),
   fwrite( r, 4, 10, Yr ),
   ewrite( `~M~J` ),
   ewrite( `%LPA% ================================================~M~J~M~J` ),
   ewrite( `%LPA% Source files combined:~M~J` ),
   ewrite( `%LPA% ----------------------~M~J~M~J` ),
   forall( member( Name, Names ),
           (  ewrite( `%LPA%    ` ),
              ewrite( Name ),
              ewrite( `~M~J` )
           )
         ),
   ewrite( `~M~J` ).

% output each unique command to the target file

cmb_commands( Names ) :-
   ewrite( `%LPA% Inline commands follow here:~M~J` ),
   ewrite( `%LPA% ----------------------------~M~J~M~J` ),
   forall( (  cmb_data( Name, Term, !, Text ),
              \+ (  cmb_data( command, Test ),
                    cmb_equivalent( Term, Test )
                 )
           ),
           (  assert( cmb_data(command,Term) ),
              ewrite( Text )
           )
         ),
   ewrite( `~M~J` ).

% output each unique query to the target file

cmb_queries( Names ) :-
   ewrite( `%LPA% Inline queries follow here:~M~J` ),
   ewrite( `%LPA% ---------------------------~M~J~M~J` ),
   forall( (  cmb_data( Name, Term, ?, Text ),
              \+ (  cmb_data( query, Test ),
                    cmb_equivalent( Term, Test )
                 )
           ),
           (  assert( cmb_data(query,Term) ),
              ewrite( Text )
           )
         ),
   ewrite( `~M~J` ).

% output the master version of each identical predicate

cmb_write_identical( [Name|Names] ) :-
   ewrite( `%LPA% Identical predicates taken from ` ),
   ewrite( Name ),
   ewrite( ` follow here:~M~J` ),
   ewrite( `%LPA% ` ),
   len( Name, Len ),
   fwrite( s, Len, -1, `---------------------------------------------------` ),
   ewrite( `---------------------------------------------~M~J~M~J` ),
   forall( cmb_data( identical, (Pred,Arity) ),
           forall( cmb_data( Name, Term, (Pred,Arity), Text ),
                   ewrite( Text )
                 )
         ),
   ewrite( `~M~J` ).

% output a rewrite for each different predicate

cmb_write_different( Names ) :-
   forall( cmb_data( different, (Pred,Arity) ),
           (  ewrite( `%LPA% Combined predicate ` ),
              ewrite( Pred ),
              ewrite( `/` ),
              ewrite( Arity ),
              ewrite( ` follows here:~M~J` ),
              ewrite( `%LPA% ` ),
              len( Pred, Len1 ),
              len( Arity, Len2 ),
              Len is Len1 + Len2,
              fwrite( s, Len, -1,
                      `---------------------------------------------------` ),
              ewrite( `----------------------------------~M~J~M~J` ),
              len( Names, Count ),
              findall( (Name,Numb,Atom),
                       (  integer_bound( 1, Numb, Count ),
                          mem( Names, [Numb], Name ),
                          (  cmb_data( Name, _, (Pred,Arity), _ )
                          -> output( Output ),
                             output( (``,0) ),
                             ewrite( `lpa` ),
                             ewrite( Numb ),
                             ewrite( `_` ),
                             ewrite( Pred ),
                             output( Data ),
                             output( Output ),
                             Data = (Text,_),
                             stratm( Text, Atom )
                          )
                       ),
                       Sources
                     ),
              cmb_build( (Pred,Arity), Sources, Clause ),
              portray_clause( Clause ),
              forall( member( (Name,_,Atom), Sources ),
                      cmp_rename( (Pred,Arity), Name, Atom )
                    )
           )
         ).

% output renamed versions of different predicates

cmp_rename( (Pred,Arity), Name, Atom ) :-
   ewrite( `%LPA% Renamed predicates taken from ` ),
   ewrite( Name ),
   ewrite( ` follow here:~M~J` ),
   ewrite( `%LPA% ` ),
   len( Name, Len ),
   fwrite( s, Len, -1, `---------------------------------------------------` ),
   ewrite( `-------------------------------------------~M~J~M~J` ),
   forall( cmb_data( Name, Term, (Pred,Arity), Text ),
           (  cmb_change( Pred, Atom, Text, Swap ),
              ewrite( Swap )
           )
         ),
   ewrite( `~M~J` )
   .

% output the unique predicates for the given file

cmb_write_unique( Names ) :-
   forall( member( Name, Names ),
           (  ewrite( `%LPA% Unique predicates taken from ` ),
              ewrite( Name ),
              ewrite( ` follow here:~M~J` ),
              ewrite( `%LPA% ` ),
              len( Name, Len ),
              fwrite( s, Len, -1,
                      `---------------------------------------------------` ),
              ewrite( `------------------------------------------~M~J~M~J` ),
              forall( cmb_data( unique, (Name,Pred,Arity) ),
                      forall( cmb_data( Name, Term, (Pred,Arity), Text ),
                              ewrite( Text )
                            )
                    ),
              ewrite( `~M~J` )
           )
         ).

% build a clause to call renamed copies of different predicates

cmb_build( (Pred,Arity), Sources, (Head:-lpa(Mode),Body) ) :-
   functor( Head, Pred, Arity ),
   cmb_build( Sources, Head, Mode, Body ).

% build the body of a predicate to perform case analysts

cmb_build( [(_,Numb,Atom)], Old, Mode, (Mode=Numb->New) ) :-
   (  Old = Pred(|Args)
   -> New = Atom(|Args)
   ;  New = Atom
   ),
   !.

cmb_build( [(_,Numb,Atom)|Sources], Old, Mode, (Mode=Numb->New;Else) ) :-
   (  Old = Pred(|Args)
   -> New = Atom(|Args)
   ;  New = Atom
   ),
   cmb_build( Sources, Old, Mode, Else ).

% change all instances of a substring in a string

cmb_change( Old, New, OldString, NewString ) :-
   stratm( OldStr, Old ),
   stratm( NewStr, New ),
   input( Input ),
   output( Output ),
   input( (OldString, 0) ),
   output( (``, 0) ),
   find( OldStr, 2, HitStr ),
   cmb_search( HitStr, NewStr ),
   output( Pair ),
   Pair = ( NewString, _ ),
   input( Input ),
   output( Output ).

cmb_search( ``, _ ) :-
   !.

cmb_search( Old, New ) :-
   swrite( New ),
   find( Old, 2, Hit ),
   cmb_search( Hit, New ).

% test the equivalence of two terms

cmb_equivalent( Term1, Term2 ) :-
   eqv( Term1, Term2 ),
   dup( Term1, Copy1 ),
   vars( Copy1, Vars1 ),
   cmb_equivalent( Vars1 ),
   dup( Term2, Copy2 ),
   vars( Copy2, Vars2 ),
   cmb_equivalent( Vars2 ),
   eqv( Copy1, Copy2 ).

% unify variables with their names for equivalence testing

cmb_equivalent( [] ).

cmb_equivalent( [(Var,Var)|Vars] ) :-
   cmb_equivalent( Vars ).
