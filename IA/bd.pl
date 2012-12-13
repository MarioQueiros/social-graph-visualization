user(pedro).
user(bruno).
user(catia).
%lig(user1,user2,forca1para2,forca2para1,[tags1para2],[tags2para1])


tag(porto,[bruno,pedro,catia]).
tag(chelsea,[bruno]).

lig(pedro,bruno,5,[amigo]).
lig(bruno,pedro,1,[urso]).
lig(bruno,catia,2,[ese]).
lig(catia,bruno,5,[isep]).

ligado(A,B):-lig(A,B,_,_), write('ligado').

%tamanho(User,Resposta)
tamanho(U,R):-findall(U,ligado(U,_),L),length(L,R).


run1 :-
	member(X, [abc,def,ghi,jkl]),
	write(X).
	
run2 :-
	input( `Enter a value:`, Input ),
	read(X) <~ Input,
	member(X, [abc,def,ghi,jkl]).
	
	