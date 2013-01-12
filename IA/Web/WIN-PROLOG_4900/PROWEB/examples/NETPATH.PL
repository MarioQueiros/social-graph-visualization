/* Prolog Network Paths Example
   Written by Rebecca Shalfield
   ----------------------------

   This example is a self-contained Prolog network paths program.
   
   It is intended to be used in conjunction with a ProWeb front-end
   defined in the file NETPTHPW.PL.

   It is documented in full within chapter 9 of the ProWeb Server
   User Guide.
*/

search( StartNode, EndNode, Path ) :-
   search( StartNode, EndNode, [StartNode], Path ).

search( Node, Node, _, [Node] ).

search( ThisNode, EndNode, NodesVisited, [ThisNode|Path] ) :-
   linked( ThisNode, NextNode ),
   \+( member(NextNode,NodesVisited) ),
   search( NextNode, EndNode, [NextNode|NodesVisited], Path ).

linked( X, Y ) :-
   arc( X, Y ); arc( Y, X ).

arc( a, c ).
arc( b, c ).
arc( b, d ).
arc( b, f ).
arc( c, e ).
arc( c, f ).
arc( d, f ).
arc( d, g ).
arc( e, f ).
arc( e, h ).
arc( f, g ).
arc( f, h ).
arc( g, i ).
