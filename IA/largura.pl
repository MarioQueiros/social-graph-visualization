camCurto(Orig,Dest,Perc) :- largura([[Orig]],Dest,P), reverse(P,Perc). 

largura([Prim|Resto],Dest,Prim) :- Prim=[Dest|_]. 

largura([[Dest|T]|Resto],Dest,Perc) :- !, largura(Resto,Dest,Perc). 

largura([[Ult|T]|Outros],Dest,Perc):-findall([Z,Ult|T],proximo_no(Ult,T,Z),Lista),
 append(Outros,Lista,NPerc), largura(NPerc,Dest,Perc). 

proximo_no(X,T,Z) :- ligado(X,Z), not member(Z,T). 

inverte(L,LI) :- inverte(L,[],LI). 
inverte([],LI,LI). 
inverte([H|T],L,LI) :- inverte(T,[H|L],LI)