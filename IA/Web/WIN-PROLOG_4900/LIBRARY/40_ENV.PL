/*
   Old Environment Variable Predicate - Brian D Steel - 28 Nov 00 / 09 May 01
   ==========================================================================

   Version 4.100 of 386-PROLOG introduced full support for Unicode, and among
   the changes this forced was the abandoning of the old env/2 predicate. As
   it happened, this predicate had a flaw under Win9x and WinNT: both these
   operating systems store some environment variables with lower- or mixed-
   case names, and it is possible to add upper-case definitions with the same
   spelling; env/2 would only find the first such entry, because it used case-
   insensitive comparisons.

   The new env/1 predicate is more powerful than the predicate it replaces,
   returning a list of all environment variables in their original cases;
   together with extended functionality in fname/4, all the features of the
   old env/2 predicate are easy to emulate, as shown by the present library.
*/

% return a list containing the name of the current executable file

env( '', [File] ) :-
   fname( [], Path, Name, Extn ),
   cat( [Path,Name,Extn], File, _ ),
   !.

% return a tokenised list of atoms for the given environment variable

env( Name, List ) :-
   lwrupr( Name, Find ),
   env( Vars ),
   member( (Find,Data), Vars ),
   !,
   split_semicolons( Envs ) <~ Data,
   findall( Atom,
            (  member( Strg, Envs ),
               stratm( Strg, Atom )
            ),
            List
          ).

% split the current input string at semicolons, returning a raw list of strings

split_semicolons( [Head|Tail] ) :-
   find( `;`, 2, Hit ) ~> Head,
   (  Hit = ``
   -> Tail = []
   ;  split_semicolons( Tail )
   ).
