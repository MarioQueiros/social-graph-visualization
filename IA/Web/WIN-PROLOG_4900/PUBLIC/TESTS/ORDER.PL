/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).


%*% exercises the ORDER package

:- ensure_loaded(public(order)).

order_test :-
	length(List, 5),

	write('List step 1: '), write(List), nl,

	List = [1|_],

	write('List step 2: '), write(List), nl,

	ordered(order_test_times(2), List),

	write('List step 3: '), write(List), nl,

	ordered(List),

	write(ordered(List)), write(' succeeded '), nl.


order_test_times(N1, N2, N) :- N is N1 * N2.
