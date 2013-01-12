% [LPA FILE] - This file has been added by LPA for compatibility with 
% Edinburough functions
% Last modified: 20/4/94

%%% mode/1 and public/1

% Still to be coded: the access to the Windows status window

% There is no need to define the corresponding op(_,_,_) because these
% are buil-in in LPA Prolog

mode(_AnyThing) :-
	writeln(`[Warning! mode declaration skipped]`).

public(_AnyThing) :-
	writeln(`[Warning! public declaration skipped]`).


%%% Utilities

writeln(Text) :-
	html_print_nl( p ),
	write(Text).


%%% Not needed for Quintus Prolog compatibility but so often used in DEC-10 
%%% programs that it is worth defining it.

% succ(+L, ?M) compute or check the successor of L
succ(L, M) :- nonvar(L), M is L + 1.

% LPA Prolog has no recorded/3, erase/1 and recordz/3 predicates.
% This is a temporary implementation of them in order to make CHAT80 run.
% To be rewritten later on.

:- dynamic record_database/3.

recorded(Key, Term, Ref) :-
        Ref = ref(Key, Term),
        record_database(Key, Term, Ref).

recordz(Key, Term, Ref) :-
        Ref = ref(Key, Term),
        assertz(record_database(Key, Term, Ref)).

erase(Ref) :-
        my_retractall(record_database(_ /* Key */, _ /* Term */, Ref)).

my_retractall(Term) :-
        retract(Term),
        fail.

my_retractall(_ /* Term */).

