/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).


/*  Program to solve any cryptarithmetic puzzle.

	Luis E. Jenkins
	Dept. of Artificial Intelligence
	University of Edinburgh
	
	October, 1981.
*/

%*% Updated: 2 July 1992 
%*%          for LPA 386-PROLOG (1.120) compatibility by Marc Vauclair

:- initialization ensure_loaded(public(setutl)).


/* 

A Cryptomatic puzzle is one in which three words are given, the problem is 
to find a numerical value for each letter in all words that producess the 
expression Word1 + Word2 = Word3 

ie CROSS + ROADS = DANGER.

The input to this program is three lists of variables. The program 
calculates the required values and assignes them to the variables, then 
prints the values as an equasion.


Examples of use:

solve([C,R,O,S,S] + [R,O,A,D,S] = [D,A,N,G,E,R]).

solve([D,O,N,A,L,D] + [G,E,R,A,L,D] = [R,O,B,E,R,T]).

*/

solve(Arg1 + Arg2 = Resul) :-
     in_form(Arg1,Resul,Lt1,Dlen1),
     in_form(Arg2,Resul,Lt2,Dlen2),
     %*% ORIG: rev(Resul,Lt3),
     reverse(Resul,Lt3),
     add_parallel(Lt1,Lt2,0,Lt3,[1,2,3,4,5,6,7,8,9,0]),
     out_form(Lt1,Lu1,Dlen1),
     out_form(Lt2,Lu2,Dlen2),
     report(Lu1,Lu2,Resul).


add_parallel([A],[B],Ca,[C],Poss) :-
       add(A,B,Ca,C,0,Poss,Unassig).

add_parallel([Letter1|Rest1],[Letter2|Rest2],Ca,[Letter3|Rest3],Poss) :-
       add(Letter1,Letter2,Ca,Letter3,Cr,Poss,Unassig),
       add_parallel(Rest1,Rest2,Cr,Rest3,Unassig).


add(Letter1,Letter2,Ca,Sres,Cr,Poss,Unassig) :-
   digit(Letter1,Poss,Pt),
   digit(Letter2,Pt,Pu),
   M is Letter1+Letter2+Ca,
   Gres is M mod 10,
   check(Sres,Gres,Pu,Unassig),
   calc_carry(Cr,M).


check(Sres,Gres,P,P) :-
      integer(Sres),
      Gres is Sres.

check(Sres,Gres,Poss,Unassig) :-
     var(Sres),
     select(Gres,Poss,Unassig),
     Sres is Gres.

calc_carry(1,Res) :- Res >= 10.

calc_carry(0,Res) :- Res < 10.


digit(Letter,L,L) :-
     integer(Letter).

digit(Letter,Poss,Unassig) :-
     var(Letter),
     select(Letter,Poss,Unassig).


in_form(Lin,Lref,Lout,Dlen) :-
	 pad(Lin,Lref,Lt,Dlen),
         %*% ORIG: rev(Lt,Lout).
         reverse(Lt,Lout).


pad(Lin,Lref,Lout,Dlen) :-
   length(Lin,Nlen),
   length(Lref,Len2),
   Dlen is Len2-Nlen,
   extend(Lin,Lout,Dlen,0).


extend(L,L,0,Char) :- !.

extend(Lin,Lout,N,Char) :-
      append([Char],Lin,Lt),
      M is N-1,
      extend(Lt,Lout,M,Char).


out_form(Lin,Lout,Dlen) :-
	%*% ORIG: rev(Lin,Lt),
	reverse(Lin,Lt),
	extend(Lu,Lt,Dlen,0),
	extend(Lu,Lout,Dlen,' ').


report(Arg1,Arg2,Resul) :-
      printlst(Arg1),
      printlst(Arg2),
      length(Resul,N),
      printchr('-',N),
      printlst(Resul),
      nl. %*% added


printlst(List) :-
	nl,
	tab(10),
	putlt(List).


printchr(Char,N) :-
	nl,
	tab(10),
	putch(Char,N).

putlt([]).

putlt([Head|Tail]) :-
	write(Head),
	putlt(Tail).


putch(Char,0) :- !.

putch(Char,N) :-
	write(Char),
	M is N-1,
	putch(Char,M).



