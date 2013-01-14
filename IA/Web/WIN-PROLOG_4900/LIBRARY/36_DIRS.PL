/*
   Old File Directory Predicate - Brian D Steel - 08 Jul 98 / 24 Jun 02
   ====================================================================

   Version 3.710 of 386-PROLOG introduced a new set of file data handling
   predicates, which subsumed and extended all of the functionality of the
   old dir/3 predicate. Together, the new predicates, dir/3 and file/2,
   provide more powerful search filtering, as well as access to additional
   file data fields and higher-resolution file times, which are themselves
   in the new time format (see the "TIME.PL" library file).

   The present library uses a special predicate, hide/2, to mask the new
   dir/3 predicate the previous one can be restored. In order for this
   trick to work, this library should be loaded at run-time, BEFORE loading
   any applications which use the previous dir/3 predicate.

   The patching technique used in this library will not work in stand-alone
   applications, so it is strongly recommended that applications be modified
   to use the new dir/3 and file/4 predicates as soon as possible.
*/

% hide the atom "dir", and then make new definition

:- hide( dir, 1 ), stratm( `dir`, DIR ),

% define the old dir/3 predicate

   assert( (  DIR( Pattern, Attributes, Directory ) :-
                 dir( Pattern, 0, Files ),
                 dir_filter( Attributes, Files, Filter ),
                 dir_info( Attributes, Filter, Directory )
           )
         ).

% filter files according to the old dir/3 attribute rules

dir_filter( Attributes, Files, Filter ) :-
   findall( File,
            (  member( File, Files ),
               catch( 0, file(File,0,Atts) ),
               (  0 =\= abs(Attributes) /\ Atts /\ 16'0000003e
               -> true
               ;  1 is abs(Attributes) /\ 16'00000001,
                  Atts /\ 16'0000003f =< 1
               )
            ),
            Filter
          ).

% return info about files if the specified attributes are positive

dir_info( Attributes, Files, Files ) :-
   Attributes < 0,
   !.

dir_info( Attributes, Files, Info ) :-
   findall( [File,[Yr,Mt,Dy,Hr,Mn,Sc2],Size,Atts2],
            (  member( File, Files ),
               file( File, 3, Written ),
               Written = (Date,Time),
               time( Date, Yr, Mt, Dy ),
               time( Time, Hr, Mn, Sc, _ ),
               Sc2 is Sc /\ 16'fffffffe,
               file( File, 4, Size ),
               file( File, 0, Atts ),
               Atts2 is Atts /\ 16'0000003f
            ),
            Info
          ).
