:- ensure_loaded( system(dblink) ). % carrega o PRODATA
:- dynamic datasource/1.

iniDb:-
	db_connect('Gandalf;Uid=ARQSI36;Pwd=gaivota;MARS_Connection=yes;',HDBC),
	assert( datasource( HDBC ) ),
	db_attach( user, 'IA_user' ),
	db_attach( traduzir, 'IA_traduzir' ),
	db_attach( lig, 'IA_lig' ),
	db_attach( strTag, 'IA_tag' ),
	db_flag( show_sql, _, off ), % nÃ£o mostra as queries SQL geradas
	criaTags.

endDb:-
	retract( datasource( HDBC ) ),
	db_disconnect( HDBC ),
	retractall(tag(_,_)).

criaTags:-findall(X,strTag(U,X),ST),findall(X,strTag(X,U),SN),criaTags(SN,ST).

criaTags([N|NR],[S|SR]):-string_to_list(S,L),assert(tag(N,L)),criaTags(NR,SR).
criaTags([],[]).



minimoMaven(3).
percentagemMaven(1.25).


%ligado(A,B):-lig(A,B,_,_), write('ligado').
ligado(A,B):-lig(A,B,_).

%ligacoes(User,Resposta) nivel 2
ligacoes(U,L):-findall(X,ligado(U,X),L).

%tamanho(User,Resposta) nivel 2
tamanho2(U,R):-redeNivel2(U,L),length(L,R).

tamanho3(U,R):-redeNivel3(U,L),cl(L,R).

redeNivel2(U,R):-user(U),findall(X,ligado(U,X),R).

redeNivel3(U,R):-user(U),ligacoes(U,L),percorreUser(U,L,R).
%percorre(user original, lista ligacoes, resposta)
percorreUser(U,L,R):-append([U],L,V),percorre(L,V,R).

%percorre(Amigo a verificar|restantes,JÃ¡ verificados,resposta
percorre([A|L],V,R):-somaRede(A,V,RV,RX),percorre(L,RV,RS),append(RX,RS,R).
percorre([],_,[]).

somaRede(A,V,RV,[A|RX]):-ligacoes(A,TL),somaL(TL,V,RV,RX).

somaL([],V,V,[]).
somaL([LA|LB],V,RV,RX):-member(LA,V),!,somaL(LB,V,RV,RX).
somaL([LA|LB],V,RV,[LA|RS]):-append([LA],V,XV),somaL(LB,XV,RV,RS).


%obter amigos por tags
%User, Lista Tags, Amigos
amigosTag(U,T,R):-ligacoes(U,L),traduz(T,LT),filtraAmigos(L,LT,R).

traduz([T|TR],[F|FR]):-traduzir(T,F),tag(F,_),!,traduz(TR,FR).
traduz([T|TR],[T|R]):-tag(T,_),traduz(TR,R).
traduz([],[]).

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
semelhante(U,F,[TA|_]):-tag(TA,L),(member(U,L);member(F,L)),!,fail.
semelhante(U,F,[_|LT]):-semelhante(U,F,LT).
semelhante(_,_,[]).


maven(T,R):-tag(T,U),cl(U,TM),minimoMaven(X),TM>X,calculaMaven(T,U,F,TM),!,estrela(U,F,R).
%Tag, users, forcas, total vertices
calculaMaven(T,[U|UR],[F|FR],TV):-forca(T,U,TV,F),calculaMaven(T,UR,FR,TV).
calculaMaven(_,[],[],_).

forca(T,U,TV,R):-tag(T,L),deletelist(L,[U],LF),calculaForcaVertices(U,LF,RS),R is RS/TV. %??.
%user, vertices c/ tag
calculaForcaVertices(U,[A|L],R):-ligado(U,A),!,calculaForcaVertices(U,L,RS),R is RS + 1.
calculaForcaVertices(U,[_|L],R):-calculaForcaVertices(U,L,R).
calculaForcaVertices(_,[],0).

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


deletelist([], _, []).                  
deletelist([X|Xs], Y, Z) :- member(X, Y), deletelist(Xs, Y, Z), !.
deletelist([X|Xs], Y, [X|Zs]) :- deletelist(Xs, Y, Zs).


%Branch and bound
camForte(O,D,Perc):-findall(P,camPesado(O,D,P),L),reverse(L,[Perc|_]).


camPesado(O,D,Perc):- go1([(0,[O])],D,P),reverse(P,Perc). 
go1([(_,Pr)|_],D,Pr):- Pr=[D|_]. 
go1([(_,[D|_])|R],D,Perc):- !, go1(R,D,Perc).
go1([(C,[Ult|T])|O],D,Perc):- findall((NC,[Z,Ult|T]),	(proximo_no(Ult,T,Z,C1),NC is C+C1),L),
 	append(O,L,NPerc),sort(NPerc,NPerc1),go1(NPerc1,D,Perc). 

proximo_no(X,T,Z,C):- lig(X,Z,C), not member(Z,T). 



%primeiro em largura
camCurto(Orig,Dest,Perc) :- largura([[Orig]],Dest,P), reverse(P,Perc). 

largura([Prim|_],Dest,Prim) :- Prim=[Dest|_]. 
largura([[Dest|_]|Resto],Dest,Perc) :- !, largura(Resto,Dest,Perc). 
largura([[Ult|T]|Outros],Dest,Perc):-findall([Z,Ult|T],proximo_no(Ult,T,Z),Lista),
 append(Outros,Lista,NPerc), largura(NPerc,Dest,Perc). 

proximo_no(X,T,Z) :- ligado(X,Z), not member(Z,T). 


%grauMedio separacao (s/ cut/complexidade)
grauMedio(R):-limpaDb,findall(X,user(X),LU),assert(lUsers(LU)),grauMedio(LU,V,C),limpaDb,R is V/C.

limpaDb:-retractall(verificado(_,_)),retractall(lUsers(_)).

%passos, contagem caminhos		
grauMedio([U|UR],V,C):-somaCaminhos(U,P,NC),grauMedio(UR,VA,RA),V is VA + P, C is RA + NC.
grauMedio([],0,0).

%passos, n caminhos
somaCaminhos(U,P,NC):-lUsers(LU),contaPassos(U,LU,P,NC).

contaPassos(U,[U|UP],P,NC):-!,contaPassos(U,UP,P,NC).
contaPassos(U,[UA|UP],P,NC):-verificado(UA,U),!,contaPassos(U,UP,P,NC).

contaPassos(U,[UA|UP],P,NC):-camCurto(U,UA,C),length(C,PX),assert(verificado(U,UA)),
							contaPassos(U,UP,PR,NR),NC is NR+1, P is PX + PR.
contaPassos(U,[_|UP],P,NC):-contaPassos(U,UP,P,NC).
contaPassos(_,[],0,0).

string_to_list(S,L):-
    cat([S,`. `],S2, _ ),
    eread(L) <~ S2.


%para criar o grafo
grafoNivel3(U,R):-user(U),redeNivel2(U,X),ligacaoCompl(U,X,R1),ligacaoAmigos(X,R2),append(R1,R2,R).

ligacaoCompl(_,[],[]).
ligacaoCompl(U1,[U2|L],R):-lig(U1,U2,Nr),add([U1,U2,Nr],R1,R),ligacaoCompl(U1,L,R1),!.

ligacaoAmigos([],[]).
ligacaoAmigos([U|L],R):-user(U),redeNivel2(U,X),ligacaoCompl(U,X,R1),ligacaoAmigos(L,R2),append(R1,R2,R).
