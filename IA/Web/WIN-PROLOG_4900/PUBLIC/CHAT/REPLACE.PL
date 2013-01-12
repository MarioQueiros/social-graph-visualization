func(Term,Func,Arity):-
	var(Term),
	integer(Arity),
	atom(Func),
	var_list(Arity,VList),
	append([Func],VList,TList),
	Term =.. TList.

func(Term,Func,Arity):-
	var(Arity),
	var(Func),
	Term =.. [Func|AList],
	length(AList,Arity).

var_list(0,[]):-
	!.

var_list(Num,[V|Rest]):-
	NewNum is Num - 1,
	var_list(NewNum,Rest).
	

args(N,[Head|Rest],Arg):-
	!,
	member(Arg,[Head|Rest],N).
	

args(N,Pred,Arg):-
	Pred =.. [_|Rest],
	args(N,Rest,Arg),
	!.
