/********************************
 * Prolog Network Paths Example *
 ********************************/

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
