% Last Modified: 20/4/94

:- op(900,xfx,#=).	% [LPA]: Origionaly implimented as `=
:- op(900,xfx,=+).
:- op(900,xfx,=:).
:- op(450,xfy,:).
:- op(400,xfy,&).
:- op(300,fx,#).	% [LPA]: Origionaly implimented as `
:- op(200,xfx,--).
:- op(359,xf,ject).

/* 

[LPA]: The backwards quote character: ` is used by LPA Prolog to denote a 
string datatype. So all occurrances of this character have been 
replaced with the # symbol.

*/
