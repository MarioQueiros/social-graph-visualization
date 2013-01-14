/*
   Save/Load Dynamic Object Files - (c) Brian D Steel - 25 Nov 99 / 10 Jun 00 
   ==========================================================================

   This program saves and loads special version-independent object files,
   and will work with versions 4.100 and later of 386-PROLOG. Because of
   the adoption of Unicode in this version, it is not possible to load any
   binary files created with earlier versions, which were based on the OEM
   extended ASCII character set. This program is designed to work only with
   incrementally compiled predicates, and can handle both dynamic and static
   ones, but not multifile. The call:

      ?- save_preds( 'fred.pd', [foo/1,bar/2] ).

   will save "foo/1" and "bar/2" into a file called "fred.pd". The call:

      ?- load_preds( 'fred.pd', List ).

   will quickly reload the file, replacing any current definitions of
   predicates contained within it, and returning a list of its predicates.
*/

% save a list of predicates into a file

save_preds( File, List ) :-
   (  type( List, 6 ),
      forall( member( Item, List ),
              (  Item = (Pred/Arity),
                 def( Pred, Arity, 1 )
              )
            )
   -> findall( (Pred,Arity,Flags),
               (  member( (Pred/Arity), List ),
                  getflg( Pred, Arity, Flags ),
                  delflg( Pred, Arity, 16'ffff )
               ),
               Data
             ),
      fcreate( File, File, -1, 0, 0 ),
      output( Current ),
      output( File ),
      slist( '?386?'(Data) ),
      forall( (  member( (Pred,Arity,Flags), Data ),
                 functor( Head, Pred, Arity ),
                 clause( Head, Body )
              ),
              (  cmp( 0, Body, true )
              -> slist( [Head] )
              ;  slist( [Head,Body] )
              )
            ),
      output( Current ),
      fclose( File ),
      forall( member( (Pred,Arity,Flags), Data ),
              addflg( Pred, Arity, Flags )
            )
   ;  throw( 23, save_preds(File,List) )
   ).

% load a file containing a list of predicates, returning that list

load_preds( File, List ) :-
   (  type( List, 0 )
   -> fcreate( File, File, 0, 0, 0 ),
      input( Current ),
      input( File ),
      sread( Term ),
      input( Current ),
      fclose( File ),
      (  Term = '?386?'(Data)
      -> forall( member( (Pred,Arity,_), Data ),
                 (  (  def( Pred, Arity, _ )
                    -> delflg( Pred, Arity, 16'ffff )
                    ;  true
                    ),
                    (  def( Pred, Arity, _ )
                    -> delprd( Pred, Arity )
                    ;  true
                    )
                 )
               ),
         sload( File ),
         forall( member( (Pred,Arity,Flags), Data ),
                 addflg( Pred, Arity, Flags )
               ),
         findall( (Pred/Arity),
                  member( (Pred,Arity,_), Data ),
                  List
                )
      ;  throw( 44, load_preds(File,List) )
      )
   ;  throw( 22, load_preds(File,List) )
   ).
