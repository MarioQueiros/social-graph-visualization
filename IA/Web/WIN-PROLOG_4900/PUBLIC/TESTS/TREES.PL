/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).


%*% Demonstrate the TREES package

:- ensure_loaded(public(trees)).

list_tree_sort(List, SortedList) :-
	list_to_tree(List, Tree),

		write('Tree before sorting: '), write(Tree), nl,

	tree_sort(Tree, SortedTree),

		write('Sorted tree: '), write(SortedTree), nl,
		
		write('The same tree printed using map_tree '), nl,

	map_tree(tree_print_node, SortedTree, _),

	tree_to_list(SortedTree, SortedList).

tree_print_node(Node, Node) :-
	write('    '), write(Node), nl.

tree_sort(Tree, SortedTree) :-
	tree_size(Tree, Size),

		write('Tree Size: '), write(Size), nl,

	tree_sort(Size, Tree, SortedTree).

tree_sort(0, Tree, Tree). % added to handle the empty list case !
tree_sort(1, Tree, Tree).
tree_sort(N, Tree, NewTree) :-
	N > 1,

		write('Handling position: '), write(N),

	tree_max(N, Tree, N, Position),

		write(' Max found at: '), write(Position),

	get_label(N, Tree, NthElem),
	get_label(Position, Tree, MaxElem),

		write(' (Value: '), write(MaxElem), write(')'), nl,

	put_label(Position, Tree, NthElem, Tree1),
	put_label(N,  Tree1, MaxElem, Tree2),

		write('Tree after permutation: '), write(Tree2), nl,

	N1 is N - 1,
	tree_sort(N1, Tree2, NewTree).


tree_max(0, _Tree, PosMax, PosMax).

tree_max(Index, Tree, PosMaxSoFar, PosMax) :-
	get_label(PosMaxSoFar, Tree, MaxSoFar),
	get_label(Index, Tree, Elem),
	Index1 is Index - 1,
	( Elem > MaxSoFar
	-> tree_max(Index1, Tree, Index, PosMax), !
	|  tree_max(Index1, Tree, PosMaxSoFar, PosMax)
	).


