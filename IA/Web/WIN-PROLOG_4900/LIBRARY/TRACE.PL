/*
   Simple Tracer for 386-PROLOG - (c) Brian D Steel - 17 Oct 95 / 05 Oct 06
   ========================================================================

   This program allows a single goal to be traced during evaluation, with
   the output sent either to the console (default) or to a named stream. For
   example, the call:

      ?( foo ).

   traces the goal "foo", outputting to the console, while the call:

      ?( foo, bar ).

   traces the goal "foo", outputting to the open file or stream "bar". Note
   that if "bar" is a DOS file or device, you must explicitly open or create
   the file first. For numbered (internal) devices, this is not necessary.

   The following keys control the tracer:

        Keyboard        Mouse           Function
        --------        -----           --------
        <space>         <left>          creep goal
        <return>        <right>         skip goal
        <escape>        <both>          abort goal
        <scroll lock>   ---             creep repeatedly
*/

% trace a single goal

?( Goal ) :-
   ?( Goal, 0 ).

?( Goal, Io ) :-
   !( Cut ),
   trc_show( Goal, Cut, 0, Io ).

% show a goal and trace it

trc_show( Goal, Cut, Depth, Io ) :-
   trc_disp( Goal, 'C', Depth, Io, Ans ),
   trc_goal( Goal, Cut, Depth, Io, Ans ),
   trc_disp( Goal, 'S', Depth, Io, _ ).

trc_show( Goal, _, Depth, Io ) :-
   trc_disp( Goal, 'F', Depth, Io, _ ),
   fail.

% trace a goal according to its type

trc_goal( Goal, Cut, Depth, Io, yes ) :-
   rpn( [Depth,1,+], NewDepth ),
   trc_call( Goal, Cut, NewCut, NewDepth, Io, NewGoal, _ ),
   !,
   !( NewCut ),
   NewGoal.

trc_goal( Goal, _, Depth, Io, yes ) :-
   fun( Goal, Pred, Arity ),
   def( Pred, Arity, Type ),
   rpn( [Type,1,+,2,/], 1 ),
   !,
   !( NewCut ),
   trc_prog( Goal, Body, 0, Number ),
   trc_disp( Goal, Number, Depth, Io, Ans ),
   rpn( [Depth,1,+], NewDepth ),
   trc_list( Body, NewCut, NewDepth, Io, Ans ).

trc_goal( Goal, Cut, _, _, _ ) :-
   trc_deep( Goal, Cut, Call ),
   Call.

% unravel a program for tracing

trc_prog( Goal, Body, Start, Number ) :-
   idxcls( [Goal], Start, Index ),
   trc_data( Goal, Body, Index, Number ).

% pick up the indexed clause

trc_data( Goal, Body, Index, Index ) :-
   getcls( [Goal|Body], Index ).

trc_data( Goal, Body, Start, Number ) :-
   trc_prog( Goal, Body, Start, Number ).

% execute the clause body

trc_list( [], _, _, _, _ ) :-
   !.

trc_list( [Body], Cut, Depth, Io, no ) :-
   !,
   Body.

trc_list( [Body], Cut, Depth, Io, yes ) :-
   trc_body( Body, Cut, Depth, Io, NewBody, 0 ),
   NewBody.

% display a line of trace data

trc_disp( Goal, Msg, Depth, Io, Ans ) :-
   output( Current ),
   output( Io ),
   trc_tabs( Depth ),
   ewrite( Msg ),
   ewrite( ' ' ),
   eprint( Goal ),
   ewrite( '~M~J' ),
   output( Current ),
   trc_wait( Ans ).

% display tabulation bars

trc_tabs( 0 ) :-
   !.

trc_tabs( Tab ) :-
   rpn( [Tab,1,-], NewTab ),
   ewrite( '| ' ),
   trc_tabs( NewTab ).

% wait for a key press unless scroll lock is on

trc_wait( Ans ) :-
   grab( Key ),
   trc_resp( Key, Wer ),
   !,
   Ans = Wer.

trc_wait( yes ) :-
   keys( Keys ),
   rpn( [Keys,16,a], 16 ),
   !.

trc_wait( Ans ) :-
   trc_wait( Ans ).

% check the key that has been pressed

trc_resp( 32, yes ).
trc_resp( -1, yes ).

trc_resp( 13, no ).
trc_resp( -2, no ).

trc_resp( 27, _ ) :-
   abort.

trc_resp( -3, _ ) :-
   abort.

trc_resp( _, _ ) :-
   putb( 7 ),
   fail.

% unravel a body for tracing

trc_body( Goal, Cut, Depth, Io, NewGoal, Flag ) :-
   trc_call( Goal, Cut, NewCut, Depth, Io, NewGoal, Flag ),
   !,
   !( NewCut ).

trc_body( Goal, Cut, Depth, Io, trc_show(Goal,Cut,Depth,Io), _ ).

% unravel a call for tracing

trc_call( Goal, _, _, _, _, Goal, _ ) :-
   type( Goal, 0 ),
   !.

trc_call( Head(|Tail), _, _, _, _, Head(|Tail), _ ) :-
   type( Head, 0 ),
   !.

trc_call( (Head,Tail), Cut, NewCut, Depth, Io, (NewHead,NewTail), 0 ) :-
   !,
   trc_body( Head, Cut, Depth, Io, NewHead, 0 ),
   trc_body( Tail, Cut, Depth, Io, NewTail, 0 ).

trc_call( (Head|Tail), Cut, NewCut, Depth, Io, (NewHead|NewTail), 1 ) :-
   !,
   trc_body( Head, Cut, Depth, Io, NewHead, 2 ),
   trc_body( Tail, Cut, Depth, Io, NewTail, 2 ).

trc_call( (Head ',' Tail), Cut, NewCut, Depth, Io, (NewHead ',' NewTail), 0 ) :-
   !,
   trc_body( Head, Cut, Depth, Io, NewHead, 0 ),
   trc_body( Tail, Cut, Depth, Io, NewTail, 0 ).

trc_call( (Head -> Body ; Tail), Cut, NewCut, Depth, Io, (NewHead -> NewBody ; NewTail), 1 ) :-
   !,
   trc_body( Head, NewCut, Depth, Io, NewHead, 2 ),
   trc_body( Body, Cut, Depth, Io, NewBody, 2 ),
   trc_body( Tail, Cut, Depth, Io, NewTail, 2 ).

trc_call( (Head ; Tail), Cut, NewCut, Depth, Io, (NewHead ; NewTail), 1 ) :-
   !,
   trc_body( Head, Cut, Depth, Io, NewHead, 2 ),
   trc_body( Tail, Cut, Depth, Io, NewTail, 2 ).

trc_call( (Head -> Tail), Cut, NewCut, Depth, Io, (NewHead -> NewTail), 1 ) :-
   !,
   trc_body( Head, NewCut, Depth, Io, NewHead, 2 ),
   trc_body( Tail, Cut, Depth, Io, NewTail, 2 ).

trc_call( forall(Head,Tail), Cut, NewCut, Depth, Io, NewGoal, _ ) :-
   !,
   trc_body( \+((Head,call(\+Tail))), NewCut, Depth, Io, NewGoal, _ ).

trc_call( Goal, Cut, NewCut, Depth, Io, NewGoal, _ ) :-
   trc_meta( Goal, NewGoal, Meta, trc_show(Meta,NewCut,Depth,Io) ),
   !.

% list goals with a single meta argument

trc_meta( O <~ Y, N <~ Y, O, N ).
trc_meta( O ~> Y, N ~> Y, O, N ).
trc_meta( X ^ O, X ^ N, O, N ).
trc_meta( bagof(X,O,Z), bagof(X,N,Z), O, N ).
trc_meta( call(O), call(N), O, N ).
trc_meta( call(O,Y), call(N,Y), O, N ).
trc_meta( catch(X,O), catch(X,N), O, N ).
trc_meta( catch(X,O,Z), catch(X,N,Z), O, N ).
trc_meta( dynamic_call(O), dynamic_call(N), O, N ).
trc_meta( findall(X,O,Z), findall(X,N,Z), O, N ).
trc_meta( force(O), force(N), O, N ).
trc_meta( ms(O,Y), ms(N,Y), O, N ).
trc_meta( not O, not N, O, N ).
trc_meta( one O, one N, O, N ).
trc_meta( phrase(O,Y), phrase(N,Y), O, N ).
trc_meta( phrase(O,Y,Z), phrase(N,Y,Z), O, N ).
trc_meta( setof(X,O,Z), setof(X,N,Z), O, N ).
trc_meta( \+ O, \+ N, O, N ).

% unravel a call, converting cuts for direct execution

trc_deep( Goal, _, Goal ) :-
   type( Goal, 0 ),
   !.

trc_deep( Head(|Tail), _, Head(|Tail) ) :-
   type( Head, 0 ),
   !.

trc_deep( (Head,Tail), Cut, (NewHead,NewTail) ) :-
   !,
   trc_deep( Head, Cut, NewHead ),
   trc_deep( Tail, Cut, NewTail ).

trc_deep( (Head|Tail), Cut, (NewHead|NewTail) ) :-
   !,
   trc_deep( Head, Cut, NewHead ),
   trc_deep( Tail, Cut, NewTail ).

trc_deep( (Head ',' Tail), Cut, (NewHead ',' NewTail) ) :-
   !,
   trc_deep( Head, Cut, NewHead ),
   trc_deep( Tail, Cut, NewTail ).

trc_deep( (Head -> Body ; Tail), Cut, (NewHead -> NewBody ; NewTail) ) :-
   !,
   !( NewCut ),
   trc_deep( Head, NewCut, NewHead ),
   trc_deep( Body, Cut, NewBody ),
   trc_deep( Tail, Cut, NewTail ).

trc_deep( (Head ; Tail), Cut, (NewHead ; NewTail) ) :-
   !,
   trc_deep( Head, Cut, NewHead ),
   trc_deep( Tail, Cut, NewTail ).

trc_deep( (Head -> Tail), Cut, (NewHead -> NewTail) ) :-
   !,
   !( NewCut ),
   trc_deep( Head, NewCut, NewHead ),
   trc_deep( Tail, Cut, NewTail ).

trc_deep( !, Cut, !(Cut) ) :-
   !.

trc_deep( !(Deep), Cut, Deep = Cut ) :-
   type( Deep, 0 ),
   !.

trc_deep( Goal, _, Goal ).
