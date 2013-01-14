/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).


%*% exercises the PROJEC package

:- ensure_loaded(public(projec)).

projec_test :-
	project_test([-3,3,4,5,4,3,2,-10]).

project_test(L) :-
	write('Input list : '), write(L), nl,

	keys_and_values(Pairs, L, _),

	write(' Pairs: '), write(Pairs), nl,

	keysort(Pairs, SortedPairs),

	write(' SortedPairs: '), write(SortedPairs), nl,

	keys_and_values(SortedPairs, Sorted, _), 

	write('Sorted list : '), write(Sorted), nl, nl,

	Table = [city(brussels, belgium), city(london, uk), 
		 city(bern, switzerland)],

	write('Table: '), write(Table), nl,

	project(Table, 0, Functors),

	write('  functors: '), write(Functors), nl,

	project(Table, 2, Countries), 

	write('  countries: '), write(Countries), nl.

