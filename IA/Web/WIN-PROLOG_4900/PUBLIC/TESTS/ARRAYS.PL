/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).


%*% Demonstrate the ARRAYS package

:- initialization ensure_loaded(public(arrays)).

list_array_sort(List, SortedList) :-
	list_to_array(List, Array),

		write('Array before sorting: '), write(Array), nl,

	array_sort(Array, SortedArray),

		write('Sorted array: '), write(SortedArray), nl,

	array_to_list(SortedArray, SortedList).


array_sort(Array, SortedArray) :-
	array_length(Array, Length),

		write('Array length: '), write(Length), nl,

	array_sort(Length, Array, SortedArray).

array_sort(0, Array, Array).
array_sort(1, Array, Array).
array_sort(N, Array, NewArray) :-
	N > 1,

		write('Handling position: '), write(N),

	array_max(N, Array, N, Position),

		write(' Max found at: '), write(Position),

	fetch(N, Array, NthElem),
	fetch(Position, Array, MaxElem),

		write(' (Value: '), write(MaxElem), write(')'), nl,

	store(Position, Array, NthElem, Array1),
	store(N,  Array1, MaxElem, Array2),

		write('Array after permutation: '), write(Array2), nl,

	N1 is N - 1,
	array_sort(N1, Array2, NewArray).


array_max(0, _Array, PosMax, PosMax).

array_max(Index, Array, PosMaxSoFar, PosMax) :-
	fetch(PosMaxSoFar, Array, MaxSoFar),
	fetch(Index, Array, Elem),
	Index1 is Index - 1,
	( Elem > MaxSoFar
	-> array_max(Index1, Array, Index, PosMax), !
	|  array_max(Index1, Array, PosMaxSoFar, PosMax)
	).


