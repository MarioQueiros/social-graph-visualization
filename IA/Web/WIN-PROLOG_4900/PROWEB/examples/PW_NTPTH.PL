/* ProWeb Network Paths Example
   Written by Rebecca Shalfield
   ----------------------------

   This file contains the source code for the ProWeb front-end
   to the network paths program in NETPATH.PL.
   
   It is documented in full within chapter 9 of the ProWeb Server
   User Guide.
*/

:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).
:-      multifile( proweb_question     / 2 ).

/******************
 * ProWeb Clauses *
 ******************/

main_goal :-
   ensure_loaded( examples(netpath) ),
   proweb_send_form( node_selection_form ),
   proweb_returned_answer( start_node, StartNode ),
   proweb_returned_answer( end_node, EndNode ),
   (  proweb_call( solutions(Solutions) )
   -> true
   ;  setof( Solution,
             search( StartNode, EndNode, Solution ),
             Solutions
           ),
      proweb_asserta( solutions(Solutions) ),
      proweb_returned_input( my_name, Name ),
      len( Name, L ),
      (  L > 0
      -> cat([' ',Name],Name1,_)
      ;  Name1 = Name
      ),
      proweb_asserta( name(Name1) )
   ),
   (  StartNode = EndNode
   -> ( write(`<IMG SRC=images/netpaths/`),
        write(StartNode),
        write(`.gif>`)
      ) ~> GraphicalNode,
      proweb_post_reply( node, unencoded @ GraphicalNode ),
      proweb_send_form( already_there_form )
   ;  member( Solution, Solutions, Nth ),
      proweb_post_unique_reply( solution_nth, Nth ),
      construct_graphical_solution( Solution, GraphicalSolution ),
      proweb_post_reply( solution, GraphicalSolution ),
      proweb_send_form( solutions_form(Nth) )
   ).

main_goal :-
   proweb_returned_form( node_selection_form ),
   proweb_call( name(Name) ),
   proweb_post_reply( my_name, Name ),
   proweb_send_form( no_more_solutions_form ).

proweb_page( [ Form ],
             [ include('netpaths/head.htm'),
               Title,
               include('netpaths/body.htm'),
               proweb(form),
               include('netpaths/foot.htm')
             ]
           ) :- form_title_file( Form, Title, _ ).

form_footer( node_selection_form,
        [table('WIDTH=100%'),
         tr,
         td('WIDTH=50%',align=center),
         input(type=submit, value='Get Solutions'),
         /td,
         td('WIDTH=50%',align=center),
         input(type=reset),
         /td,
         /tr,
         /table
        ]
      ).

form_footer( solutions_form(_),
        [table('WIDTH=100%'),
         tr,
         td('WIDTH=50%',align=center),
         input(type=submit, value=`Get Next Solution`),
         /td,
         td('WIDTH=50%',align=center),
         include('netpaths/link_hp.htm'),
         /td,
         /tr,
         /table
        ]
      ).

form_footer( no_more_solutions_form,
        [ center @ include('netpaths/link_hp.htm') ]
      ).

form_footer( already_there_form,
        [p(align='center') @ include('netpaths/link_hp.htm')
        ]
      ).

proweb_form( Form, [include(File),Footer] ) :-
  form_title_file( Form, _, File ),
  form_footer( Form, Footer ).

form_title_file( node_selection_form,   `Node Selection Form`,    'netpaths/tmplate1.htm' ).
form_title_file( solutions_form(_),     `Solutions Form`,         'netpaths/tmplate2.htm' ).
form_title_file( no_more_solutions_form,`No More Solutions Form`, 'netpaths/tmplate3.htm' ).
form_title_file( already_there_form,    `Already There Form`,     'netpaths/tmplate4.htm' ).

proweb_question( start_node,
                 [ method = menubox,
                   select = Nodes
                 ]
               ) :-
  setof( Node, A^linked(Node,A), Nodes ).

proweb_question( end_node,
                 [ method  = menubox,
                   select  = Nodes,
                   prefill = Last
                 ]
               ) :-
  setof( Node, A^linked(Node,A), Nodes ),
  length(Nodes,Len),
  member(Last,Nodes,Len).

construct_graphical_solution( [], [] ).

construct_graphical_solution( [Node|Nodes], [Tag|Tags] ) :-
   construct_graphical_node( Node, Tag ),
   construct_graphical_solution( Nodes, Tags ).

construct_graphical_node( Node, Tag ) :-
   Tag = img( src = verbatims @ [`images/netpaths/`,Node,`.gif`] ).
