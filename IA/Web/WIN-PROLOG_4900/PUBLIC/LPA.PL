/***************************************************************
 * Edinburgh Library Compatibility File for LPA-PROLOG 4.000   *
 ***************************************************************/

/* If path for 'public\library' does not exist then assert default */

test_public_file_path :- 
  not file_search_path(public,prolog('\public\library')),
  assert( file_search_path(public,prolog('\public\library')) ).

test_public_file_path :-
 !.

:- test_public_file_path.

/* If path for chat does not exist then assert default */

test_chat_file_path:- 
	not file_search_path( chat, prolog('\public\chat') ),
	assert( file_search_path( chat, prolog('\public\chat') ) ).

test_chat_file_path:-
	!.

:- test_chat_file_path.

%%% mode/1 and public/1

% Still to be coded: the access to the Windows status window

% There is no need to define the corresponding op(_,_,_) because these
% are built-in in LPA Prolog

mode(_AnyThing) :-
	writeln(`[Warning! mode declaration skipped]`).

public(_AnyThing) :-
	writeln(`[Warning! public declaration skipped]`).


%%% Utilities

writeln(Text) :-
	write(Text),
	nl.


%%% Not needed for Quintus Prolog compatibility but so often used in DEC-10 
%%% programs that it is worth defining it.

% succ(+L, ?M) compute or check the successor of L
succ(L, M) :- nonvar(L), M is L + 1.
