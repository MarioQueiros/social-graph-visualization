/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).


%*% exercises the GRAPHS package

:- initialization ensure_loaded(public(graphs)).

test :-
	%*% the test GRAPH in P-representation
	PGraph = [a-b,a-c,b-d,b-e,b-f,c-g,e-j,f-k,k-u],

	write('The P-graph: '), write(PGraph), nl,

	p_to_s_graph(PGraph, SGraph), 

	write('The S-graph: '), write(SGraph), nl,

	warshall(SGraph, SClosure),

	write('The S-Closure: '), write(SClosure), nl,

	s_to_p_graph(SClosure, PClosure),

	write('The P-Closure: '), write(PClosure), nl,

	vertices(SGraph, SGraphVertices), 

	write('S-Graph vertices: '), write(SGraphVertices), nl,

	s_to_p_trans(SGraph, PGraphTransposed), 

	write('P-Graph transposed by s_to_p_trans: '), 
	write(PGraphTransposed), nl,

	p_transpose(PGraph, PGraphT),

	write('P-Graph transposed by p_transpose: '), 
	write(PGraphT), nl,

	s_transpose(SGraph, SGraphT),

	write('S-Graph transposed by s_transpose: '), 
	write(SGraphT), nl,

	write('p_member enumeration: '), nl,

	( p_member(X,Y,PGraph),
	  write('    '), write(X), write(' -> '), write(Y), nl,
	  fail
	| true
        ),

	write('s_member enumeration: '), nl,

	( s_member(X,Y,SGraph),
	  write('    '), write(X), write(' -> '), write(Y), nl,
	  fail
	| true
        ),

	top_sort(SGraph, SGraphSorted),

	write('S-graph topologically sorted: '), write(SGraphSorted), nl.
