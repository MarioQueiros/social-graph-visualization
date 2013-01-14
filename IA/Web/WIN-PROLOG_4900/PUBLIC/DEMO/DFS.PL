/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).


%   File   : /usr/lib/prolog/teach/mandc/depth
%   Author : Alan Bundy
%   Updated: 6 November 79
%   Purpose: Depth First Search version of Missionaries and Cannibals.

%*% Updated: 2 July 1992 
%*%          for LPA 386-PROLOG (1.120) compatibility by Marc Vauclair

%*% subtract renamed to dfs_subtract
%*% add      renamed to dfs_add

%*% updated to give a better feedback of the solution path found

/* top level */
go :-						 % to solve m & c problem 
	abolish(known, 2),			 % clear memory
	assert(known(bank(3,3,1), bank(0,0,0))), % record initial state
	depth(bank(3,3,1),bank(0,0,0), Summary), % and search from it 
	write_summary(Summary).	

depth(bank(0,0,0),bank(3,3,1), []) :-
  	/* if goal state is found */
	write('which is goal state'), nl, nl.	/* then print message and stop */

depth(Left,Right,[Move|Summary]) :-
				/* otherwise */
	make_move(Left,Right,NewLeft,NewRight,Move),
		/* make a move from the current state */
	write_state(NewLeft,NewRight),		/* print the new state */
	depth(NewLeft,NewRight,Summary).		/* and recurse */


make_move(Left,Right,NewLeft,NewRight,Move) :-		/* to make a move */
	apply_move(Left,Right,NewLeft,NewRight,Move), 	/* apply a move */
	\+ known(NewLeft,NewRight),			/* to get a new state */
	assert(known(NewLeft,NewRight)),		/* record it */
	legal(NewLeft), legal(NewRight).		/* check it is legal */

apply_move(bank(ML,CL,1),Right,NewL,NewR,move(toright,BoatLoad)) :-
	/* if boat is on left */
	 move_load(bank(ML,CL,1),Right,NewL,NewR,BoatLoad).	/* then move left to right */

apply_move(bank(ML,CL,0),Right,NewL,NewR,move(toleft,BoatLoad)) :-
	/* if boat is on right */
	move_load(Right,bank(ML,CL,0),NewR,NewL,BoatLoad).	
				/* then move right to left */

move_load(Source,Target,NewS,NewT,BoatLoad) :-	
	/* to move from source to target */
	move(BoatLoad),			/* get a move */
	applicable(Source,BoatLoad),	/* check that it is applicable */
	dfs_subtract(Source,BoatLoad,NewS),	/* take boatload from source */
	dfs_add(Target,BoatLoad,NewT),	/* and add to target */
	write_move(BoatLoad).		/* write a message */

/* The move is applicable to the state */
applicable(bank(MS,CS,1), boat(MB,CB)) :-
	MS >= MB, CS >= CB.

/* Subtract each element of boatload from each element of source */
dfs_subtract(bank(MS,CS,1), boat(MB,CB), bank(MN,CN,0)) :-
	MN is MS-MB,
	CN is CS-CB.

/* Add each element of boatload to each element of target */
dfs_add(bank(MT,CT,0), boat(MB,CB), bank(MN,CN,1)) :-
	MN is MT+MB,
	CN is CT+CB.

/* the five possible moves */
move(boat(0,1)).
move(boat(2,0)).
move(boat(0,2)).
move(boat(1,1)).
move(boat(1,0)).


/* is situation legal */
legal(bank(0,_,_)) :- !.

legal(bank(M,C,_)) :- M >= C.


/* Messages */

write_state(bank(ML,CL,BL), bank(MR,CR,_)) :-
	nl, write('The left bank contains '),
	write(ML), write(' missionaries and '),
	write(CL), write(' cannibals'),
	nl, write('The right bank contains '),
	write(MR), write(' missionaries and '),
	write(CR), write(' cannibals'), nl,
	write_boat(BL),
	nl, nl. %*% , write('Print RETURN to continue'),
	        %*% get0(_).

write_boat(1) :-
	write('The boat is on the left bank'), nl.

write_boat(0) :-
	write('The boat is on the right bank'), nl.

write_move(boat(M,C)) :-
	nl, write('Move '), write(M), write(' missionaries and '),
	write(C), write(' cannibals'), nl.

write_summary(Summary) :-
	write('Summary of successful movements: '), nl,
	write_summary_items(Summary).

write_summary_items([]).
write_summary_items([Head|Tail]) :-
	write_summary_item(Head),
	write_summary_items(Tail).

write_summary_item(move(Dir,boat(M,C))) :-
	write('  Direction: '), write(Dir), nl,
	write('     Missionaries: '), write(M),
	write('     Cannibals: '), write(C), nl.




