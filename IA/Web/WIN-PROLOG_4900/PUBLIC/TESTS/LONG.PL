/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).


%*% exercise the LONG package

:- ensure_loaded(public(long)).

long_test :-
	eval(D1 is (2 ^ 14) * ((2 ^ 50) ^ 4) + 1),
	write('2^214 + 1 : '), portray_ratnum(D1), nl, 
	eval(D11 is ((2^8) * (2^99)) - 2 ^ 54 + 1),
	write('2^107 - 2^54 + 1 : '), portray_ratnum(D11), nl,
	eval(D12 is ((2^8) * (2^99)) + 2 ^ 54 + 1),
	write('2^107 + 2^54 + 1 : '), portray_ratnum(D12), nl,
	eval(D1 =:= D11 * D12),
	write('2^214 + 1 = (2^107 - 2^54 + 1)(2^107 + 2^54 + 1) is true'), nl,
	eval(N0 is (D11 / 5) / 857),
	write('(2^107 -2^54 + 1) /(5.857) : '), portray_ratnum(N0), nl,
	eval(Q0 is D1 div D11),
	write('(2^214+1)/(2^107 - 2^54 +1) : '), portray_ratnum(Q0), nl,

	long_factorial(10, Fact10),

	write('10! : '), portray_ratnum(Fact10), nl, putb(26), 

	long_factorial(30, Fact30),

	write('30! : '), portray_ratnum(Fact30), nl.

	

long_factorial(N, X) :-
	long_factorial(N, 1, X).

long_factorial(0, X, X).
long_factorial(N, X0, X) :-
	eval(N > 0),
	eval(M is N - 1),
	eval(X1 is X0 * N),
	long_factorial(M, X1, X).
