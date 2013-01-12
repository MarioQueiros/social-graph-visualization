% Chat-80 : A small subset of English for database querying.

:-public hi/0, hi/1, quote/1.

:- mode control(+),
	doing(+,+),
	uses(+,?),
        process(+),
        simplify(+,?),
        simplify(+,?,?),
	simplify_not(+,?),
        revand(+,+,?),
        report(?,+,+,+),
        report_item(+,?).

/* Control loop */

ask(user,P) :- !,
   write('Question: '),
   ttyflush,
   read_in(P).
ask(File,P) :-
   seeing(Old),
   see(File),
   read_in(P),
   nl,
   doing(P,0),
   nl,
   see(Old).

doing([],_) :- !.
doing([X|L],N0) :-
   out(X),
   advance(X,N0,N),
   doing(L,N).

out(nb(X)) :- !,
   write(X).
out(A) :-
   write(A).

advance(X,N0,N) :-
   uses(X,K),
   M is N0+K,
 ( M>72, !,
      proweb_nl,
      N is 0;
   N is M+1,
      put(" ")).

uses(nb(X),N) :- !,
   chars(X,N).
uses(X,N) :-
   chars(X,N).

chars(X,N) :- atomic(X), !,
   name(X,L),
   length(L,N).
chars(_,2).

end(user) :- !.

end(F) :-
   close(F).

control([bye]) :- !,
   write( bye ).

control([bye,'.']) :- !,
   write( bye ).

control(U0) :-
   check_words(U0,U),
   process(U).
 
process(U) :-
   sentence(E,U,[],[],[]),
   i_sentence(E,QT),
   clausify(QT,UE),
   simplify(UE,S),
   qplan(S,S1), 
   !,
   answer(S1),
   !,
   proweb_nl,
   proweb_post_reply(your_reply,S1).


process(_) :-
   failure.

benchmark_query(U) :-
   statistics(runtime,_),
   sentence(E,U,[],[],[]),
   statistics(runtime,[_,Et0]), 
   i_sentence(E,QT),
   clausify(QT,UE),
   simplify(UE,S),
   statistics(runtime,[_,Et1]),
   qplan(S,S1), !,
   statistics(runtime,[_,Et2]),
   answer1(S1,Ans), !,
   statistics(runtime,[_,Et3]),
   simplify_answer(Ans,SAns),
   write([SAns,parse-Et0,semantics-Et1,plan-Et2,reply-Et3]),proweb_nl.
benchmark_query(_) :-
   failure.

answer1((answer([]):-E),B) :- !, holds(E,B).
answer1((answer([X]):-E),S) :- !, seto(X,E,S).
answer1((answer(X):-E),S) :- seto(X,E,S).

simplify_answer([A|As],N-solutions):-
	!,length([A|As],N).
simplify_answer(A,A).

failure :-
   write('I don''t understand!'),
   proweb_nl.

report(Item,Label,Time,Mode) :-
   proweb_nl, write(Label), write(': '), write(Time), write('msec.'), proweb_nl,
   tracing =: on, !, 
   report_item(Mode,Item).
report(_,_,_,_).

report_item(none,_).
report_item(expr,Item) :-
   write_tree(Item), proweb_nl.
report_item(tree,Item) :-
   print_tree(Item), proweb_nl.
report_item(quant,Item) :-
   pp_quant(Item,2), proweb_nl.

quote(A&R) :-
   atom(A), !,
   quote_amp(R).
quote(_-_).
quote(_--_).
quote(_+_).
quote(verb(_,_,_,_,_)).
quote(wh(_)).
quote(name(_)).
quote(prep(_)).
quote(det(_)).
quote(quant(_,_)).
quote(int_det(_)).

quote_amp('$VAR'(_)) :- !.
quote_amp(R) :-
   quote(R).

simplify(C,(P:-R)) :- !,
   unequalise(C,(P:-Q)),
   simplify(Q,R,true).

simplify(setof(X,P0,S),R,R0) :- !,
   simplify(P0,P,true),
   revand(R0,setof(X,P,S),R).
simplify((P,Q),R,R0) :-
   simplify(Q,R1,R0),
   simplify(P,R,R1).
simplify(true,R,R) :- !.
simplify(X^P0,R,R0) :- !,
   simplify(P0,P,true),
   revand(R0,X^P,R).
simplify(numberof(X,P0,Y),R,R0) :- !,
   simplify(P0,P,true),
   revand(R0,numberof(X,P,Y),R).
simplify(\+P0,R,R0) :- !,
   simplify(P0,P1,true),
   simplify_not(P1,P),
   revand(R0,P,R).
simplify(P,R,R0) :-
   revand(R0,P,R).

simplify_not(\+P,P) :- !.
simplify_not(P,\+P).

revand(true,P,P) :- !.
revand(P,true,P) :- !.
revand(P,Q,(Q,P)).

unequalise(C0,C) :-
   numbervars(C0,1,N),
   functor(V,v,N),
   functor(M,v,N),
   inv_map(C0,V,M,C).

inv_map('$VAR'(I),V,_,X) :- !,
   arg(I,V,X).
inv_map(A=B,V,M,T) :- !,
   drop_eq(A,B,V,M,T).
inv_map(X^P0,V,M,P) :- !,
   inv_map(P0,V,M,P1),
   exquant(X,V,M,P1,P).
inv_map(A,_,_,A) :- atomic(A), !.
inv_map(T,V,M,R) :-
   functor(T,F,K),
   functor(R,F,K),
   inv_map_list(K,T,V,M,R).

inv_map_list(0,_,_,_,_) :- !.
inv_map_list(K0,T,V,M,R) :-
   arg(K0,T,A),
   arg(K0,R,B),
   inv_map(A,V,M,B),
   K is K0-1,
   inv_map_list(K,T,V,M,R).

drop_eq('$VAR'(I),'$VAR'(J),V,M,true) :- !,
 ( I=\=J, !,
      irev(I,J,K,L), 
      arg(K,M,L),
      arg(K,V,X),
      arg(L,V,X);
   true).
drop_eq('$VAR'(I),T,V,M,true) :- !,
   deref(I,M,J),
   arg(J,V,T),
   arg(J,M,0).
drop_eq(T,'$VAR'(I),V,M,true) :- !,
   deref(I,M,J),
   arg(J,V,T),
   arg(J,M,0).
drop_eq(X,Y,_,_,X=Y).

deref(I,M,J) :-
   arg(I,M,X),
  (var(X), !, I=J;
   deref(X,M,J)).

exquant('$VAR'(I),V,M,P0,P) :-
   arg(I,M,U),
 ( var(U), !,
      arg(I,V,X),
       P=(X^P0);
   P=P0).

irev(I,J,I,J) :- I>J, !.
irev(I,J,J,I).

:- mode check_words(+,-).

check_words([],[]).
check_words([Word|Words],[RevWord|RevWords]) :-
   check_word(Word,RevWord),
   check_words(Words,RevWords).

:- mode check_word(+,-).

check_word(Word,Word) :- word(Word), !.
check_word(Word,NewWord) :-
   write(`Sorry, I do not understand the word "`),
   write( Word ),
   write( '"'),
   write( `.` ),
   fail .

:- mode #=(+,+), =+(+,-), =:(+,?).

Var #= Val :-
 ( recorded(Var,val(_),P), erase(P)
 | true), !,
 recordz(Var,val(Val),_).

Var =+ Val :-
 ( recorded(Var,val(Val0),P), erase(P)
 | Val0 is 0), !,
   Val is Val0+1,
   recordz(Var,val(Val),_).

Var =: Val :-
   recorded(Var,val(Val),_).

put_edinburgh([C]) :- !, put(C).
put_edinburgh(C) :- put(C).
