user(pedro).
user(bruno).
user(catia).
user(hugo).
user(mario).
user(tiago).
%lig(user1,user2,forca1para2,forca2para1,[tags1para2],[tags2para1])

tag(porto,[bruno,pedro,catia,hugo]).
tag(chelsea,[bruno]).

lig(pedro,bruno,5,[amigo]).
lig(bruno,pedro,1,[urso]).
lig(bruno,catia,2,[ese]).
lig(catia,bruno,5,[isep]).
lig(tiago,catia,2,[ese]).
lig(catia,tiago,5,[isep]).
lig(hugo,catia,2,[ese]).
lig(catia,hugo,5,[isep]).
lig(bruno,mario,2,[contador]).
lig(mario,bruno,5,[cavendish]).
lig(hugo,mario,3,[myva]).
lig(mario,hugo,5,[myva]).




%ligado(A,B):-lig(A,B,_,_), write('ligado').
ligado(A,B):-lig(A,B,_,_).

%ligacoes(User,Resposta) nivel 2
ligacoes(U,L):-findall(X,ligado(U,X),L).

%tamanho(User,Resposta) nivel 2
tamanho2(U,R):-findall(U,ligado(U,_),L),length(L,R).

tamanho3(U,R):-redeNivel3(U,L),cl(L,R).

redeNivel3(U,R):-ligacoes(U,L),percorreUser(U,L,R).
%percorre(user original, lista ligacoes, resposta)
percorreUser(U,L,R):-append([U],L,V),percorre(L,V,R).

%percorre(Amigo a verificar|restantes,Já verificados,resposta
percorre([A|L],V,R):-somaRede(A,V,RV,RX),percorre(L,RV,RS),append(RX,RS,R).
percorre([],_,[]).

somaRede(A,V,RV,[A|RX]):-ligacoes(A,TL),somaL(TL,V,RV,RX).

somaL([],V,V,[]).
somaL([LA|LB],V,RV,RX):-member(LA,V),!,somaL(LB,V,RV,RX).
somaL([LA|LB],V,RV,[LA|RS]):-append([LA],V,XV),somaL(LB,XV,RV,RS).


%obter amigos por tags
%User, Lista Tags, Amigos
amigosTag(U,T,R):-ligacoes(U,L),traduz(T,LT),filtraAmigos(L,LT,R).

traduz(T,T).
%ligacoes,tags
filtraAmigos([LA|LB],T,[LA|RX]):-verificaTags(LA,T),!,filtraAmigos(LB,T,RX).
filtraAmigos([_|LB],T,R):-filtraAmigos(LB,T,R).
filtraAmigos([],_,[]).


verificaTags(U,[TA|TB]):-tag(TA,L),member(U,L),verificaTags(U,TB).
verificaTags(_,[]).


%sugereAmigos
sugereAmigos(U,R):-redeNivel3(U,L),filtraNaoLigacoes(L,F),criaSugestao(U,F,LT,R).

filtraNaoLigacoes(U,[LA|LB],[LA|R]):-ligado(U,LA),!,filtraNaoLigacoes(U,LB,R).
filtraNaoLigacoes(U,[_|LB],R):-filtraNaoLigacoes(U,LB,R).
filtraNaoLigacoes(_,[],[]).


criaSugestao(U,[FA|FB],[FA|R]):-findall(X,tag(X,_),LT),semelhante(U,FA,LT),!,criaSugestao(U,FB,R).
criaSugestao(U,[_|FB],R):-criaSugestao(U,FB,R).
criaSugestao(_,[],[]).

%LT = lista Tags
semelhante(U,F,[TA|LT]):-tag(TA,L),member(U,L),member(F,L),!,semelhante(U,F,LT,R).
semelhante(_,_,[]):-fail.
semelhante(_,_,[_|_]).

cl(L, R) :-
        call(L, 0 , R).

% 1 - Terminating condition
call([], Count, Count).

% 2 - Recursive rule
call([H|T], Count, R) :-
        Count1 is Count + 1,
        call(T, Count1, R).


add(X,[],[X]).
add(X,[A|L],[A|L1]):- add(X,L,L1).

notmember(X,L):-(member(X,L), !, fail);true.



run1 :-
	member(X, [abc,def,ghi,jkl]),
	write(X).
	
run2 :-
	input( `Enter a value:`, Input ),
	read(X) <~ Input,
	member(X, [abc,def,ghi,jkl]).
	