/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).


%*% exercises the SAMSORT package

:- ensure_loaded(public(samsort)).

samsort_test :-
	samsort_test([-3,2,3,4,5,3,3,-10]).

samsort_test(L) :-
	write('Input list : '), write(L), nl,

	samsort(L, Sorted),

	write('Sorted list : '), write(Sorted), nl.
