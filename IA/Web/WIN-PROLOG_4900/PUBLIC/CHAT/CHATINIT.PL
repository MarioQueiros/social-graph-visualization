/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).

:- ensure_loaded(chat(chatops)).

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
