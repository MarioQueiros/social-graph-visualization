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

%ligado(A,B):-lig(A,B,_,_), write('ligado').
ligado(A,B):-lig(A,B,_,_).

%ligacoes(User,Resposta) nivel 2
ligacoes(U,L):-findall(X,ligado(U,X),L).

%tamanho(User,Resposta) nivel 2
tamanho2(U,R):-findall(U,ligado(U,_),L),length(L,R).

%tamanho(User,Resposta) nivel 3
tamanho3(U,R):-findall(U,ligado(U,_),L),percorre(U,L,T),length(L,R1), R is R1+T.

%percorre(user original, lista ligacoes, resposta)
percorre(U,L,T):-percorre(U,L,[],0,T).
%percorre(user, Amigo a verificar|restantes,Já verificados,Somatório,resposta
percorre(U,[A|L],V,S,T):-ligacoes(A,LR),somaRede(U,LR,V,T1)notmember(H,V),  ,percorre(U,L,V,S1,T1)

somaRede(U,[U|L],V,R):-somaRede(U,L,V,R).
somaRede(U,[A|L],V,R):-notmember(A,V),add(A,V,V1),R is R+1

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
	
	