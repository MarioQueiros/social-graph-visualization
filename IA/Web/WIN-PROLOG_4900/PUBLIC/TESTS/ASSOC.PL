/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).

% Test (derived from the test program given at the end of the ASSOC package)

:- ensure_loaded(public(assoc)).

:- dynamic test_tree/1.

insert(K,V) :-            % Insert pair K,V into the recorded
  retract(test_tree(T)),  % tree. Note, the code above does not
  !,
  put_assoc(K,T,V,T1),    % record the tree anywhere. You have to
  assert(test_tree(T1)).  % do it yourself.

test(_) :-                % Test(T) will build up a small tree
  retract(test_tree(_)),  % Remove any existing tree(s)
  fail.

test(T) :-
  assert(test_tree(t)),   % Create an empty tree
  insert(mean, bean),     % Hang some rhyming pairs off it
  insert(hoe,go),
  insert(foo,you),
  insert(bee,flea),
  insert(jack,stack),
  insert(nick,quick),
  insert(why,sky),
  insert(word,bird),
  insert(funny,money),
  insert(ping,sing),
  test_tree(T).
                  % Usage of assoc_to_list
balance_tree(T,B) :-          % This balances the tree +T giving -B
  assoc_to_list(T,L),     % If you need balanced trees, of course,
  assoc_to_list(B,L).     % there are better ways than this

% a test for map_assoc: the "abbrev" predicate deletes all letters
% in a name after the third

test_map(T,U) :-      % Call test_map(-T,-U)
  test_tree(T), 
  map_assoc(abbrev,T,U).

abbrev(Long,Cut) :-
  name(Long,Letters),
  abbrev_list(3,Letters,Fewer_letters),
  name(Cut,Fewer_letters).

abbrev_list(_,[],[]) :- !.
abbrev_list(0,_,[]) :- !.
abbrev_list(N,[H|T],[H|U]) :-
  M is N - 1,
  abbrev_list(M,T,U).
