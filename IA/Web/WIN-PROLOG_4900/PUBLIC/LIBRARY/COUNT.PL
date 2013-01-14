/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).

%*%	File:		count.pl
%*%	Author:		R.A.O'Keefe
%*%	Updated:	8 september 1982
%*%	Purpose:	count the number of clause and predicates in a
%*%			Prolog source file

%*% Updated: 3 July 1992 
%*%          for LPA 386-PROLOG (1.120) compatibility by Marc Vauclair

%    count.pl
%    
%    Information about contents of a valid Prolog file
%    Any files prefixed ":- consult(file)" will be count-ed too.
%    The information given is
%    	Number of predicates
%    	Number of clauses in each predicate
%    
%    
%    The output from "count('count.pl')" is as follows:
%    
%    5 predicates
%    count/1:   3 clauses in count.pl
%    count/2:   2 clauses in count.pl
%    summarise/0:   2 clauses in count.pl
%    dump/1:   1 clauses in count.pl
%    look_at/2:   3 clauses in count.pl

%*% The package has been updated to replace all uses of record... by asserts

:- dynamic pred_count/1.
:- dynamic pred_name/1.
:- dynamic pred_per_name_count/4.

count([File|Others]) :-
	!,
	dump(File),
	count(Others).

count([]) :-
	!,
	summarise.

count(File) :-
	dump(File),
	summarise.

summarise :-
	pred_count(I),
	write(I), write(' predicates'), nl,
	pred_name(Name),
	pred_per_name_count(Name,Arity,N,File),
	write(Name), write('/'), write(Arity), write(':   '),
	write(N), write(' clauses in '), write(File), nl,
	fail.

summarise.

/*

%*% Original code with records

summarise :-
	recorded(pred_count,I,_),
	write(I), write(' predicates'), nl,
	recorded(pred_name,Name,_),
	recorded(Name,[Arity,N,File],_),
	write(Name), write('/'), write(Arity), write(':   '),
	write(N), write(' clauses in '), write(File), nl,
	fail.

summarise.

*/

dump(File) :-
	seeing(Seeing),
	see(File),
	!,
	read(Term),
	look_at(Term,File),
	seen,
	see(Seeing).

look_at(end_of_file,_) :- !.

look_at((:- consult(Different)),File) :-
	!,
	dump(Different),
	read(Another_thing),
	look_at(Another_thing,File).

look_at(Thing,File) :-
	count(Thing,File),
	read(Another_thing),
	look_at(Another_thing,File).

count((Head :- _),File) :-
	!,
	count(Head,File).

/*

%*% Original code using records

count(Head,File) :-

	% This clause is long but straighforward.
	%   1. Get the functor name for the clause and its arity
	%   2. Count the number of occurrences of functor/arity


	functor(Head,Func_name,Arity),
	(
		recorded(Func_name, [Arity,I,File], Akey) ->
		(	J is I + 1,
			record(Func_name, [Arity,J,File], _),
			erase(Akey)
		)
	;
		record(Func_name, [Arity,1,File], _),
		(
			recorded(pred_name, Func_name, _)
		;
			record(pred_name, Func_name, _)
		),
		(
			recorded(pred_count, A, Bkey) ->
			(
				B is A + 1,
				record(pred_count, B, _),
				erase(Bkey)
			)
		;
			record(pred_count,1,_)
		)
	),
	!.

*/

count(Head,File) :-

	/* This clause is long but straighforward.
	   1. Get the functor name for the clause and its arity
	   2. Count the number of occurrences of functor/arity
	*/

	functor(Head,Func_name,Arity),
	(
		pred_per_name_count(Func_name,Arity,I,File) ->
		(	J is I + 1,
			retract(pred_per_name_count(Func_name,Arity,I,File)),
			asserta(pred_per_name_count(Func_name,Arity,J,File))
		)
	;
		asserta(pred_per_name_count(Func_name,Arity,1,File)),
		(
			pred_name(Func_name)
		;
			asserta(pred_name(Func_name))
		),
		(
			pred_count(A) ->
			(
				B is A + 1,
				retract(pred_count(A)),
				asserta(pred_count(B))
			)
		;
			asserta(pred_count(1))
		)
	),
	!.
