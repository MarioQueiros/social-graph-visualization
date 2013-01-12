/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).


%*% exercises the QUEUES package

:- ensure_loaded(public(queues)).

queues_test :-
	list_to_queue([a,b,c], Q),

	write('Starting queue '), write(Q), nl,

	join_queue(z, Q, Q1),

	write('queue after addition of z at end: '), write(Q1), nl,

	list_join_queue([z1,z2,z3], Q1, Q2),

	write('queue after addition of [z1,z2,z3] at end: '), write(Q2), nl,

	jump_queue(w, Q2, Q3),

	write('queue after addition of w at begin: '), write(Q3), nl,

	list_jump_queue([w1,w2,w3], Q3, Q4),

	write('queue after addition of [w1,w2,w3] at begin: '), write(Q4), nl,

	head_queue(Q4, Head),

	write('head of queue: '), write(Head), nl,

	length_queue(Q4, Length),

	write('length of queue: '), write(Length), nl,

	serve_queue(Q4, Elem, Q5),

	write('elem served: '), write(Elem), nl,

	write('queue after servicing: '), write(Q5), nl,

	queue_to_list(Q5, L5),

	write('list from last queue: '), write(L5), nl.
