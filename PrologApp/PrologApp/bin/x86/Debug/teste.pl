user(pedro).
user(bruno).
%lig(user1,user2,forca,[tags])
%
tag(porto,[bruno,pedro]).
tag(chelsea,[bruno]).
lig(pedro,bruno,5,[amigo]).
lig(bruno,pedro,1,[urso]).

ligado(A,B):-(lig(A,B,_,_);lig(B,A,_,_)), write('ligado').

run1 :-
	member(X, [abc,def,ghi,jkl]),
	write(X).
	
run2 :-
	input( `Enter a value:`, Input ),
	read(X) <~ Input,
	member(X, [abc,def,ghi,jkl]).
	
	