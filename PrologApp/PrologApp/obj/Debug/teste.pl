
run1 :-
	member(X, [abc,def,ghi,jkl]),
	write(X).
	
run2 :-
	input( `Enter a value:`, Input ),
	read(X) <~ Input,
	member(X, [abc,def,ghi,jkl]).
	
	