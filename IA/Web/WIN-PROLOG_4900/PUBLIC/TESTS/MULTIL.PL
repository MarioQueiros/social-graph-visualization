/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).


%*% exercises the MULTIL package

:- ensure_loaded(public(multil)).

multil_test :-
	List = [[a,1], [a,3], [a,4], [b,4]],

	write('Input list: '), write(List), nl,

	write(' Members: '), nl,

	( ml_member(Elems, List),
	  write('  ---> '), write(Elems), nl,
	  fail
	| true
	),

	ml_taketop(List, Heads, Tails),

	write('Heads: '), write(Heads), nl,
	write('Tails: '), write(Tails), nl,

	write('single map on list: '), nl,

	mlmaplist(printslice, List),

	write('single map with extra: '), nl,

	mlmaplist(printslice, List, 'extraordinaire'),

	mlmaplist(countslice, List, 0, Count),

	write('count through mlmaplist: '), write(Count), nl.


	

printslice(Input) :-
	write('***> '), write(Input), nl.

printslice(Input, Extra) :-
	write('***> '), write(Extra), write(' <***> '), write(Input), nl.

countslice(Input, Old, New) :-
	New is Old + 1.
