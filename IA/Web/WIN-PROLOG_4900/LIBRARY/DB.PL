

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A database class for multivalued attributes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class db .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    DECLARATIONS                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

category
  library .

public methods
  assert     /  1 ,   % Prolog's assert/1     + self
  asserta    /  1 ,   % Prolog's asserta/1    + self
  assertz    /  1 ,   % Prolog's assertz/1    + self
  retract    /  1 ,   % Prolog's retract/1    + self
  retractall /  1 ,   % Prolog's retractall/1 + self
  call       /  1 ,   % Prolog's call/1       + self
  (dynamic)  /  1 .   % Prolog's dynamic/1    + self

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    DEFINITIONS                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHODS: local_to_global_data / 2
%          local_to_global_data / 1
% COMMENT: Convert a local predicate into a global
%          predicate by adding self
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


local_to_global_data( LocalData, GlobalData ) :-
  ( true ; local_to_global_data( LocalData ) ),
  prolog <- def( local_to_global_data, 3, _ ),
  prolog <- local_to_global_data(
                                  LocalData,
                                  self,
                                  GlobalData
                                ),
  !.


local_to_global_data( LocalData ) :-
  functor( LocalData,     LocalPred, Arity ),
  functor( LocalSkeleton, LocalPred, Arity ),
  (
    write( self ),
    write( '<=' ),
    write( LocalPred )
  ) ~> String,
  stratm( String, GlobalPred ),
  LocalSkeleton  =.. [ LocalPred  | Params ],
  GlobalSkeleton =.. [ GlobalPred | Params ],
  prolog
  <- asserta(
              local_to_global_data(
                                    LocalSkeleton,
                                    self,
                                    GlobalSkeleton
                                  )
            ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHODS: dynamic    / 1
%          assert     / 1
%          asserta    / 1
%          assertz    / 1
%          retract    / 1
%          retractall / 1
%          call       / 1
% COMMENT: Manage the local database including self
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dynamic( LocalPred / Arity ) :-
  functor( LocalData,  LocalPred,  Arity ),
  local_to_global_data( LocalData, GlobalData ),
  functor( GlobalData, GlobalPred, Arity ),
  prolog <- dynamic( GlobalPred / Arity ).

assert( LocalData ) :-
  assertz( LocalData ).

asserta( LocalData ) :-
  local_to_global_data( LocalData, GlobalData ),
  prolog <- asserta( GlobalData ).

assertz( LocalData ) :-
  local_to_global_data( LocalData, GlobalData ),
  prolog <- assertz( GlobalData ).

retract( LocalData ) :-
  local_to_global_data( LocalData, GlobalData ),
  prolog <- retract( GlobalData ).

retractall( LocalData ) :-
  local_to_global_data( LocalData, GlobalData ),
  prolog <- retractall( GlobalData ).

call( LocalData ) :-
  local_to_global_data( LocalData, GlobalData ),
  prolog <- clause( GlobalData, true ).


end db.
