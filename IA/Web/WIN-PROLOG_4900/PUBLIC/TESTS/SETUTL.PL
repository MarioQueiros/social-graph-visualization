/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).

%%%
%
% Test program for: setutl.pl
%
%%%

:- op( 1200, xfx, (==>) ).
:- initialization ensure_loaded(public(setutl)).

test :-
  ( Call ==> Result ),
  writeq( Call ),
  nl,
  catch( Error, call( Call, Port ) ),
  ( Result = error(Error)  -> fail
  ; Port == Result         -> fail
  ; Port == done, Result   -> fail
  ; Result = error(Number) -> WhatHappened = (error(Number) \= error(Error))
  ; Port \== done          -> WhatHappened = (port(Port) \= port(done))
  ; otherwise              -> WhatHappened = (\+ Result) ),
  nl,
  writeq( WhatHappened ),
  nl,
  fail.

test.


% tests & expected results

% Pred(Args) ==> Result.
% where Result is either the successful unification,
%                 or true for success
%		  or fail for failure
%		  or error(ErrNum) for error
%                 or exit
%		  or done

add_element(a, [a,b,c,d], S)				==> S == [a,b,c,d].
add_element(a, [e,f,g], S)				==> S == [a,e,f,g].
add_element(a, [], S)					==> S == [a].

del_element(a, [a,b,c,d], S)				==> S == [b,c,d].
del_element(a, [e,f,g], S)				==> S == [e,f,g].
del_element(a, [], S)					==> S == [].

disjoint([])						==> done.
disjoint([a,b,c])					==> done.
disjoint([a,b,c,a])					==> fail.

disjoint([], [])					==> done.
disjoint([a,b,c], [d,e,f])				==> done.
disjoint([a,b,c], [c,d,e])				==> fail.
disjoint([a,b,c], [])					==> done.

intersect([a,b,d], [a,b,e,f])				==> done.
intersect([a,b,c], [d,e,f])				==> fail.
intersect([a,b,c], [])					==> fail.
intersect([], [])					==> fail.

intersect([a,b,d], [a,b,e,f], I)			==> I == [a,b].
intersect([a,b,c], [d,e,f], I)				==> I == [].
intersect([a,b,c], [], I)				==> I == [].
intersect([], [], I)					==> I == [].
intersect([a,b,c], [f,a,c], [a,c])			==> done.
intersect([a,b,c], [f,a,c], [c,a])			==> fail.
intersect([a,b,c], [a,b,c], [c])			==> fail.
intersect([a,b,c], [a,b,c], [])				==> fail.

listtoset([a,b,c], S)					==> S == [a,b,c].
listtoset([a,b,c,a,a,b,c], S)				==> S == [a,b,c].
listtoset([], S)					==> S == [].

memberchk(a, [a,b,d])					==> done.
memberchk(c, [a,b,d])					==> fail.
memberchk(a, [a,b,a,d])					==> done.
memberchk(a, [])					==> fail.
memberchk(a, L)						==> L = [a|_].
memberchk(A, [a,b,c])					==> A == a.
memberchk(A, [A])					==> done.
memberchk(A, [])					==> fail.

nonmember(a, [b,c,d])					==> done.
nonmember(a, [b,a,c,a,d])				==> fail.
nonmember(a(X), [a(u), b(c)])				==> done.
nonmember(a(u), [a(u), b(c)])				==> fail.
nonmember(a(X), [a(X), b(C)])				==> fail.
nonmember(a(X), [a(Y), b(C)])				==> done.

seteq([],[])						==> done.
seteq([a,b,c], [c,a,a,b,b,c])				==> done.
seteq([a,b,c], [c,a,d,e])				==> fail.
seteq([a,b,c], [c,b,a])					==> done.
seteq([], [a,b,c])					==> fail.

subset([a,b], [a,b,d,e])				==> done.
subset([], [a,c])					==> done.
subset([a,b], [a,c])					==> fail.
subset([a], [])						==> fail.
