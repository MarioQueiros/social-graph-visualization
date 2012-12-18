user(pedro).
user(bruno).
user(catia).
user(hugo).
user(mario).
user(tiago).
%lig(user1,user2,forca1para2,forca2para1,[tags1para2],[tags2para1])

tag(porto,[bruno,pedro,catia]).
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

%tamanho(User,Resposta) nivel 3
tamanho3(U,R):-ligacoes(U,L),percorre(U,L,R).

%percorre(user original, lista ligacoes, resposta)
percorre(U,L,R):-append([U],L,V),percorre(L,V,0,R).

%percorre(Amigo a verificar|restantes,Já verificados,Somatório,resposta
percorre([A|L],V,S,R):-somaRede(A,V,S,RS,RV),percorre(L,RV,RS,R).
percorre([],_,S,S).

somaRede(A,V,S,RS,RV):-ligacoes(A,TL),somaL(TL,V,RSL,RV),RS is S + 1 + RSL.

somaL([],V,0,V).
somaL([LA|LB],V,RS,RV):-member(LA,V),!,somaL(LB,V,RS,RV).
somaL([LA|LB],V,RS,RV):-append([LA],V,TV),somaL(LB,TV,TS,RV),RS is TS+1.



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
	
	