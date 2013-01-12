/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).


%*% exercises the HEAP package

:- initialization ensure_loaded(public(heaps)).

heap_test :-
	heap_test([hfl-netherlands, ff-france, 
		   bef-belgium, fs-switzerland]).
 
heap_test(List) :-
	list_to_heap(List, Heap),

	write('The List: '), write(List), nl,
	write('The heap: '), write(Heap), nl,

	heap_to_list(Heap, Sorted),

	write('The heap_to_list result: '), write(Sorted), nl,

	min_of_heap(Heap, Key1, Datum1),

	write('Min of heap (1): '), 
	write(Key1), write(':'), write(Datum1), nl,

	min_of_heap(Heap, Key2, Datum2, Key3, Datum3),

	write('Min of heap (2a): '), 
	write(Key2), write(':'), write(Datum2), nl,
	write('Min of heap (2b): '), 
	write(Key3), write(':'), write(Datum3), nl,

	write('Pick and remove an element from the heap:'), nl,

	get_from_heap(Heap, Key4, Datum4, NewHeap),

	write('   Key: '), write(Key4), nl,
	write('   Datum: '), write(Datum4), nl,
	write('   NewHeap: '), write(NewHeap), nl.



