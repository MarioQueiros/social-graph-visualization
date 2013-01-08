user(catia).
run1 :-
	user(catia),
	write(catia).
	
run2 :-
	input( 'Enter a value:', Input ),
	read(X) <~ Input,
	member(X, [abc,def,ghi,jkl]).
	
	