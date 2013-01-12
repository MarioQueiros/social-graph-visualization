/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).


%*% Demonstrate the LOGARR package

:- ensure_loaded(public(logarr)).

list_logarray_sort(List, SortedList) :-
	list_to_logarray(List, Array),

	length(List, Size),

		write('Array before sorting: '), write(Array), nl,
		write('Array length: '), write(Length), nl,

	array_sort(Size, Array, SortedArray),

		write('Sorted array: '), write(SortedArray), nl,

	array_to_list(SortedArray, SortedList).


list_to_logarray(List, Array) :-
	new_array(StartArray),
	list_to_logarray(List, 1, StartArray, Array).

list_to_logarray([], _N, Array, Array).
list_to_logarray([Head|Tail], N, OldArray, NewArray) :-
	aset(N, OldArray, Head, InterArray),
	N1 is N + 1,
	list_to_logarray(Tail, N1, InterArray, NewArray).

array_sort(0, Array, Array).
array_sort(1, Array, Array).
array_sort(N, Array, NewArray) :-
	N > 1,

		write('Handling position: '), write(N),

	array_max(N, Array, N, Position),

		write(' Max found at: '), write(Position),

	aref(N, Array, NthElem),
	aref(Position, Array, MaxElem),

		write(' (Value: '), write(MaxElem), write(')'), nl,

	aset(Position, Array, NthElem, Array1),
	aset(N,  Array1, MaxElem, Array2),

		write('Array after permutation: '), write(Array2), nl,

	N1 is N - 1,
	array_sort(N1, Array2, NewArray).


array_max(0, _Array, PosMax, PosMax).

array_max(Index, Array, PosMaxSoFar, PosMax) :-
	aref(PosMaxSoFar, Array, MaxSoFar),
	aref(Index, Array, Elem),
	Index1 is Index - 1,
	( Elem > MaxSoFar
	-> array_max(Index1, Array, Index, PosMax), !
	|  array_max(Index1, Array, PosMaxSoFar, PosMax)
	).


