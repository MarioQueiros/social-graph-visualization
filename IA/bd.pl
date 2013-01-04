user(pedro).
user(bruno).
user(catia).
user(hugo).
user(mario).
user(tiago).
%lig(user1,user2,forca1para2,forca2para1,[tags1para2],[tags2para1])

tag(porto,[bruno,pedro,catia,hugo]).
tag(chelsea,[bruno]).
tag(comida,[mario,bruno,hugo,carlos]).

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
lig(carlos,mario,2,[testeMaven]).
lig(mario,carlos,1,[testeMaven]).

%Verificar 
minimoMaven(3).
percentagemMaven(1.25).


%ligado(A,B):-lig(A,B,_,_), write('ligado').
ligado(A,B):-lig(A,B,_,_).

%ligacoes(User,Resposta) nivel 2
ligacoes(U,L):-findall(X,ligado(U,X),L).

%tamanho(User,Resposta) nivel 2
tamanho2(U,R):-redeNivel2(U,L),length(L,R).

tamanho3(U,R):-redeNivel3(U,L),cl(L,R).

redeNivel2(U,R):-findall(X,ligado(U,X),R).

redeNivel3(U,R):-ligacoes(U,L),percorreUser(U,L,R).
%percorre(user original, lista ligacoes, resposta)
percorreUser(U,L,R):-append([U],L,V),percorre(L,V,R).

%percorre(Amigo a verificar|restantes,J� verificados,resposta
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
sugereAmigos(U,R):-redeNivel3(U,L),filtraNaoLigacoes(U,L,F),deletelist(L,F,LF),criaSugestao(U,LF,R),!.

filtraNaoLigacoes(U,[LA|LB],[LA|R]):-ligado(U,LA),!,filtraNaoLigacoes(U,LB,R).
filtraNaoLigacoes(U,[_|LB],R):-filtraNaoLigacoes(U,LB,R).
filtraNaoLigacoes(_,[],[]).


criaSugestao(U,[FA|FB],[FA|R]):-findall(X,tag(X,_),LT),semelhante(U,FA,LT),!,criaSugestao(U,FB,R).
criaSugestao(U,[_|FB],R):-criaSugestao(U,FB,R).
criaSugestao(_,[],[]).

%LT = lista Tags
semelhante(U,F,[TA|LT]):-tag(TA,L),member(U,L),member(F,L),!,semelhante(U,F,LT).
semelhante(_,_,[]):-fail.
semelhante(_,_,[_|_]).

%Ver Calculo Equilibrio vertices Estrela
%Maven(T,R):-tag(T,U),cl(U,TM),minimoMaven(X),TM>X,calculaMaven(T,U,TM,R).

%calculaMaven(T,[U|UR],TV,UA,VA,R):-forca(T,U,TV,CL),CL>VA,!,calculaMaven(T,UR,TV,U,CL,R).
%calculaMaven(T,[_|UR],TV,UA,VA,R):-calculaMaven(T,UR,RV,UA,VA,R).
%calculaMaven(_,[],_,UA,_,UA).

maven(T,R):-tag(T,U),cl(U,TM),minimoMaven(X),TM>X,calculaMaven(T,U,F,TM),!,estrela(U,F,R).
%Tag, users, forcas, total vertices
calculaMaven(T,[U|UR],[F|FR],TV):-forca(T,U,TV,F),calculaMaven(T,UR,FR,TV).
calculaMaven(_,[],[],_).

forca(T,U,TV,R):-tag(T,L),deletelist(L,[U],LF),calculaForcaVertices(U,LF,RS),R is RS/TV. %??.
%user, vertices c/ tag
calculaForcaVertices(U,[A|L],R):-ligado(U,A),!,calculaForcaVertices(U,L,RS),R is RS + 1.
calculaForcaVertices(U,[_|L],R):-calculaForcaVertices(U,L,R).
calculaForcaVertices(_,[],0).

%estrela(U,F,R):-estrela(U,F,F,R).

%estrela([U|UR],[F|FR],OF,U):-percorreForca(F,OF),!.
%estrela([_|UR],[_|FR],OF,R):-estrela(UR,FR,OF,R).
%estrela([],[],_,_):-write('Nao existe ninguem com forca maven'),fail.

estrela(U,F,R):-estrela(U,F,U,F,R).
%manipulados e originais, max actuais, resposta
estrela([U|UR],[F|FR],OU,OF,U):-percorreForca(U,F,OU,OF),!.
estrela([_|UR],[_|FR],OU,OF,R):-estrela(UR,FR,OU,OF,R).
estrela([],[],_,_,_):-fail.

%forca
percorreForca(U,F,[U|UR],[F|FR]):-percorreForca(U,F,UR,FR).
percorreForca(U,F,[_|UR],[V|FR]):-percentagemMaven(X),T is V*X,F>T,percorreForca(U,F,UR,FR).
percorreForca(_,_,[],[]).

grafoComum(U,U,_):-fail.
grafoComum(UA,UB,G):-redeNivel2(UA,R1),redeNivel2(UB,R2),intersect(R1,R2,G).


intersect([ ],_,[ ]).
intersect([X|L1],L2,[X|LI]):-member(X,L2),!,intersect(L1,L2,LI).
intersect([_|L1],L2, LI):- intersect(L1,L2,LI).

cl(L, R) :-
        call(L, 0 , R).

% 1 - Terminating condition
call([], Count, Count).

% 2 - Recursive rule
call([_|T], Count, R) :-
        Count1 is Count + 1,
        call(T, Count1, R).


add(X,[],[X]).
add(X,[A|L],[A|L1]):- add(X,L,L1).

notmember(X,L):-(member(X,L), !, fail);true.




%Branch and bound
camPesado(O,D,Perc):- go1([(0,[O])],D,P),reverse(P,Perc). 

go1([(_,Pr)|_],D,Pr):- Pr=[D|_]. 
go1([(_,[D|_])|R],D,Perc):- !, go1(R,D,Perc).
go1([(C,[Ult|T])|O],D,Perc):- findall((NC,[Z,Ult|T]),	(proximo_no(Ult,T,Z,C1),NC is C+C1),L),
 	append(O,L,NPerc),sort(NPerc,NPerc1),go1(NPerc1,D,Perc). 

proximo_no(X,T,Z,C):- lig(X,Z,C,_), not member(Z,T). 

camForte(O,D,Perc):-findall(P,camPesado(O,D,P),L),reverse(L,[Perc|_]).

%primeiro em largura
camCurto(Orig,Dest,Perc) :- largura([[Orig]],Dest,P), reverse(P,Perc). 

largura([Prim|Resto],Dest,Prim) :- Prim=[Dest|_]. 
largura([[Dest|T]|Resto],Dest,Perc) :- !, largura(Resto,Dest,Perc). 
largura([[Ult|T]|Outros],Dest,Perc):-findall([Z,Ult|T],proximo_no(Ult,T,Z),Lista),
 append(Outros,Lista,NPerc), largura(NPerc,Dest,Perc). 

proximo_no(X,T,Z) :- ligado(X,Z), not member(Z,T). 



run1 :-
	member(X, [abc,def,ghi,jkl]),
	write(X).
	
run2 :-
	input( `Enter a value:`, Input ),
	read(X) <~ Input,
	member(X, [abc,def,ghi,jkl]).
	

deletelist([], _, []).                  
deletelist([X|Xs], Y, Z) :- member(X, Y), deletelist(Xs, Y, Z), !.
deletelist([X|Xs], Y, [X|Zs]) :- deletelist(Xs, Y, Zs).
