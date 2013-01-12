/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).


%*% exercises the LAZY package

:- ensure_loaded(public(lazy)).

next_int(N, N1) :- N1 is N + 1.

lazy_test :-
	make_lazy(0, next_int, List),

	write('The starting lazy list: '), write(List), nl,

	head_lazy(List, H),

	write(' Head : '), write(Head), nl,

	tail_lazy(List, T), 

	write(' Tail : '), write(Tail), nl,
	write(' List after tail : '), write(List), nl,

	member_check_lazy(5, List), 

	write(' member_check of 5 in List succeeds '), nl,

	write(' List after member_check of 5: '), write(List), nl.
