/********************************
 * ProWeb Network Paths Example *
 ********************************/

/**************
 * Directives *
 **************/

:- ensure_loaded( examples('netpath2\netpth') ).

/******************
 * ProWeb Clauses *
 ******************/

netpaths :-
   proweb_send_form( node_selection_form ),
   proweb_returned_answer( start_node, StartNode ),
   proweb_returned_answer( end_node, EndNode ),
   (  proweb_call( solutions(Solutions) )
   -> true
   ;  findall( Solution,
               ( integer_bound(2,NodesVisited,9),
                 search(StartNode,EndNode,Solution),
                 len(Solution,NodesVisited)
               ),
               Solutions
             ),
      proweb_asserta( solutions(Solutions) )
   ),
   (  StartNode = EndNode
   -> GraphicalNode = img( src = verbatims @ [`/proweb/images/netpath2/`,StartNode,`.gif`] ),
      proweb_post_reply( node, GraphicalNode ),
      proweb_send_form( already_there_form )
   ;  member( Solution, Solutions, Nth ),
      proweb_post_unique_reply( solution_nth, Nth ),
      len( Solutions, Length ),
      proweb_post_reply( solutions, Length ),
      construct_graphical_solution( Solution, GraphicalSolution ),
      proweb_post_reply( solution, GraphicalSolution ),
      assemble_grid( Solution ),
      proweb_send_form( solutions_form(Nth) )
   ).

netpaths :-
   proweb_returned_form( node_selection_form ),
   proweb_send_form( no_more_solutions_form ).

proweb_page( node_selection_form,    include('netpath2\page.htm') ).
proweb_page( solutions_form(_),      include('netpath2\page.htm') ).
proweb_page( no_more_solutions_form, include('netpath2\page.htm') ).
proweb_page( already_there_form,     include('netpath2\page.htm') ).

proweb_form( Form, include(File) ) :-
  form_file( Form, File ).

form_file( node_selection_form,    'netpath2\tmplate1.htm' ).
form_file( solutions_form(_),      'netpath2\tmplate2.htm' ).
form_file( no_more_solutions_form, 'netpath2\tmplate3.htm' ).
form_file( already_there_form,     'netpath2\tmplate4.htm' ).

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
   Tag = img( src = verbatims @ [`/proweb/images/netpath2/`,Node,`.gif`] ).

assemble_grid( Solution ) :-
  ( html_print( table(border='0',cellpadding='0',cellspacing='0') ),
    html_print(tr),
    html_print(td),grid01( Solution ),html_print(/td),
    html_print(td),grid02( Solution ),html_print(/td),
    html_print(td),grid03( Solution ),html_print(/td),
    html_print(td),grid04( Solution ),html_print(/td),
    html_print(/tr),
    html_print(tr),
    html_print(td),grid05( Solution ),html_print(/td),
    html_print(td),grid06( Solution ),html_print(/td),
    html_print(td),grid07( Solution ),html_print(/td),
    html_print(td),grid08( Solution ),html_print(/td),
    html_print(/tr),
    html_print(tr),
    html_print(td),grid09( Solution ),html_print(/td),
    html_print(td),grid10( Solution ),html_print(/td),
    html_print(td),grid11( Solution ),html_print(/td),
    html_print(td),grid12( Solution ),html_print(/td),
    html_print(/tr),
    html_print(tr),
    html_print(td),grid13( Solution ),html_print(/td),
    html_print(td),grid14( Solution ),html_print(/td),
    html_print(td),grid15( Solution ),html_print(/td),
    html_print(td),grid16( Solution ),html_print(/td),
    html_print(/tr),
    html_print(tr),
    html_print(td),grid17( Solution ),html_print(/td),
    html_print(td),grid18( Solution ),html_print(/td),
    html_print(td),grid19( Solution ),html_print(/td),
    html_print(td),grid20( Solution ),html_print(/td),
    html_print(/tr),
    html_print(/table)
  ) ~> Grid,
  proweb_post_reply( grid, unencoded @ Grid ).

write_img_tag( GIF, AltText ) :-
  html_print( img(src=[`/proweb/images/netpath2/`,GIF],alt=AltText) ).

grid01( Solution ) :-
  (  node_sequence( [a,c], Solution )
  -> write_img_tag( '01ac.gif', `` )
  ;  write_img_tag( '01a.gif', `'A' is not visited during this path`  )
  ).

grid02( Solution ) :-
  (  node_sequence( [a,c], Solution )
  -> (  node_sequence( [c,e], Solution )
     -> write_img_tag( '02ace.gif', `` )
     ;  write_img_tag( '02ac.gif', ``  )
     )
  ;  (  node_sequence( [c,e], Solution )
     -> write_img_tag( '02ce.gif', `` )
     ;  write_img_tag( '02.gif', ``  )
     )
  ).

grid03( Solution ) :-
  (  node_sequence( [c,e], Solution )
  -> (  node_sequence( [e,f], Solution )
     -> write_img_tag( '03cef.gif', `` )
     ;  (  node_sequence( [e,h], Solution )
        -> write_img_tag( '03ceh.gif', `` )
        ;  write_img_tag( '03ce.gif', ``  )
        )
     )
  ;  (  node_sequence( [e,f], Solution )
     -> (  node_sequence( [e,h], Solution )
        -> write_img_tag( '03feh.gif', `` )
        ;  write_img_tag( '03ef.gif', `` )
        )
     ;  (  node_sequence( [e,h], Solution )
        -> write_img_tag( '03eh.gif', `` )
        ;  write_img_tag( '03e.gif', `'E' is not visited during this path`  )
        )
     )
  ).

grid04( Solution ) :-
  (  node_sequence( [e,h], Solution )
  -> write_img_tag( '04eh.gif', `` )
  ;  write_img_tag( '04.gif', ``   )
  ).

grid05( Solution ) :-
  (  node_sequence( [b,c], Solution )
  -> write_img_tag( '05bc.gif', `` )
  ;  write_img_tag( '05.gif', ``   )
  ).

grid06( Solution ) :-
  node_sequence( [a,c], Solution ),
  (  node_sequence( [c,b], Solution )
  -> write_img_tag( '06acb.gif', `` )
  ;  (  node_sequence( [c,e], Solution )
     -> write_img_tag( '06ace.gif', `` )
     ;  (  node_sequence( [c,f], Solution )
        -> write_img_tag( '06acf.gif', `` )
        ;  write_img_tag( '06ac.gif', ``  )
        )
     )
  ).

grid06( Solution ) :-
  node_sequence( [b,c], Solution ),
  (  node_sequence( [a,c], Solution )
  -> write_img_tag( '06acb.gif', `` )
  ;  (  node_sequence( [c,e], Solution )
     -> write_img_tag( '06bce.gif', `` )
     ;  (  node_sequence( [c,f], Solution )
        -> write_img_tag( '06bcf.gif', `` )
        ;  write_img_tag( '06bc.gif', ``  )
        )
     )
  ).

grid06( Solution ) :-
  node_sequence( [e,c], Solution ),
  (  node_sequence( [c,b], Solution )
  -> write_img_tag( '06bce.gif', `` )
  ;  (  node_sequence( [c,a], Solution )
     -> write_img_tag( '06ace.gif', `` )
     ;  (  node_sequence( [c,f], Solution )
        -> write_img_tag( '06ecf.gif', `` )
        ;  write_img_tag( '06ce.gif', ``  )
        )
     )
  ).

grid06( Solution ) :-
  node_sequence( [f,c], Solution ),
  (  node_sequence( [c,b], Solution )
  -> write_img_tag( '06bcf.gif', `` )
  ;  (  node_sequence( [c,e], Solution )
     -> write_img_tag( '06ecf.gif', `` )
     ;  (  node_sequence( [c,a], Solution )
        -> write_img_tag( '06acf.gif', `` )
        ;  write_img_tag( '06cf.gif', ``  )
        )
     )
  ).

grid06( Solution ) :-
  write_img_tag( '06c.gif', `'C' is not visited during this path` ).

grid07( Solution ) :-
  node_sequence( [e,f], Solution ),
  (  node_sequence( [f,h], Solution )
  -> write_img_tag( '07efh.gif', `` )
  ;  write_img_tag( '07ef.gif', ``  )
  ).

grid07( Solution ) :-
  node_sequence( [f,h], Solution ),
  write_img_tag( '07fh.gif', `` ).

grid07( Solution ) :-
  node_sequence( [c,f], Solution ),
  node_sequence( [f,h], Solution ),
  write_img_tag( '07cfh.gif', `` ).

grid07( Solution ) :-
  node_sequence( [c,f], Solution ),
  node_sequence( [f,e], Solution ),
  write_img_tag( '07cfe.gif', `` ).

grid07( Solution ) :-
  node_sequence( [c,f], Solution ),
  write_img_tag( '07cf.gif', `` ).

grid07( Solution ) :-
  write_img_tag( '07.gif', `` ).

grid08( Solution ) :-
  (  node_sequence( [e,h], Solution )
  -> (  node_sequence( [f,h], Solution )
     -> write_img_tag( '08ehf.gif', `` )
     ;  write_img_tag( '08eh.gif', `` )
     )
  ;  (  node_sequence( [f,h], Solution )
     -> write_img_tag( '08fh.gif', `` )
     ;  write_img_tag( '08h.gif', `'H' is not visited during this path`  )
     )
  ).

grid09( Solution ) :-
  node_sequence( [b,c], Solution ),
  (  node_sequence( [b,d], Solution )
  -> write_img_tag( '09cbd.gif', `` )
  ;  (  node_sequence( [b,f], Solution )
     -> write_img_tag( '09cbf.gif', `` )
     ;  write_img_tag( '09bc.gif', `` )
     )
  ).

grid09( Solution ) :-
  node_sequence( [b,d], Solution ),
  (  node_sequence( [b,c], Solution )
  -> write_img_tag( '09cbd.gif', `` )
  ;  (  node_sequence( [b,f], Solution )
     -> write_img_tag( '09dbf.gif', `` )
     ;  write_img_tag( '09bd.gif', `` )
     )
  ).

grid09( Solution ) :-
  node_sequence( [b,f], Solution ),
  (  node_sequence( [b,d], Solution )
  -> write_img_tag( '09dbf.gif', `` )
  ;  (  node_sequence( [b,c], Solution )
     -> write_img_tag( '09cbf.gif', `` )
     ;  write_img_tag( '09bf.gif', `` )
     )
  ).

grid09( Solution ) :-
  write_img_tag( '09b.gif', `'B' is not visited during this path` ).

grid10( Solution ) :-
  (  node_sequence( [b,f], Solution )
  -> (  node_sequence( [d,f], Solution )
     -> write_img_tag( '10bdf.gif', `` )
     ;  write_img_tag( '10bf.gif', ``  )
     )
  ;  (  node_sequence( [d,f], Solution )
     -> write_img_tag( '10df.gif', `` )
     ;  write_img_tag( '10.gif', ``  )
     )
  ).

grid11( Solution ) :-
  node_sequence( [f,b], Solution ),
  (  node_sequence( [f,c], Solution )
  -> write_img_tag( '11bfc.gif', `` )
  ;  (  node_sequence( [f,d], Solution )
     -> write_img_tag( '11bfd.gif', `` )
     ;  (  node_sequence( [f,e], Solution )
        -> write_img_tag( '11bfe.gif', `` )
        ;  (  node_sequence( [f,g], Solution )
           -> write_img_tag( '11bfg.gif', `` )
           ;  (  node_sequence( [f,h], Solution )
              -> write_img_tag( '11bfh.gif', `` )
              ;  write_img_tag( '11bf.gif', `` )
              )
           )
        )
     )
  ).

grid11( Solution ) :-
  node_sequence( [f,c], Solution ),
  (  node_sequence( [f,b], Solution )
  -> write_img_tag( '11bfc.gif', `` )
  ;  (  node_sequence( [f,d], Solution )
     -> write_img_tag( '11cfd.gif', `` )
     ;  (  node_sequence( [f,e], Solution )
        -> write_img_tag( '11cfe.gif', `` )
        ;  (  node_sequence( [f,g], Solution )
           -> write_img_tag( '11cfg.gif', `` )
           ;  (  node_sequence( [f,h], Solution )
              -> write_img_tag( '11cfh.gif', `` )
              ;  write_img_tag( '11cf.gif', `` )
              )
           )
        )
     )
  ).

grid11( Solution ) :-
  node_sequence( [f,d], Solution ),
  (  node_sequence( [f,b], Solution )
  -> write_img_tag( '11bfd.gif', `` )
  ;  (  node_sequence( [f,c], Solution )
     -> write_img_tag( '11cfd.gif', `` )
     ;  (  node_sequence( [f,e], Solution )
        -> write_img_tag( '11dfe.gif', `` )
        ;  (  node_sequence( [f,g], Solution )
           -> write_img_tag( '11dfg.gif', `` )
           ;  (  node_sequence( [f,h], Solution )
              -> write_img_tag( '11dfh.gif', `` )
              ;  write_img_tag( '11df.gif', `` )
              )
           )
        )
     )
  ).

grid11( Solution ) :-
  node_sequence( [f,e], Solution ),
  (  node_sequence( [f,b], Solution )
  -> write_img_tag( '11bfe.gif', `` )
  ;  (  node_sequence( [f,c], Solution )
     -> write_img_tag( '11cfe.gif', `` )
     ;  (  node_sequence( [f,d], Solution )
        -> write_img_tag( '11dfe.gif', `` )
        ;  (  node_sequence( [f,g], Solution )
           -> write_img_tag( '11efg.gif', `` )
           ;  (  node_sequence( [f,h], Solution )
              -> write_img_tag( '11efh.gif', `` )
              ;  write_img_tag( '11ef.gif', `` )
              )
           )
        )
     )
  ).

grid11( Solution ) :-
  node_sequence( [f,g], Solution ),
  (  node_sequence( [f,b], Solution )
  -> write_img_tag( '11bfg.gif', `` )
  ;  (  node_sequence( [f,c], Solution )
     -> write_img_tag( '11cfg.gif', `` )
     ;  (  node_sequence( [f,d], Solution )
        -> write_img_tag( '11dfg.gif', `` )
        ;  (  node_sequence( [f,e], Solution )
           -> write_img_tag( '11efg.gif', `` )
           ;  (  node_sequence( [f,h], Solution )
              -> write_img_tag( '11gfh.gif', `` )
              ;  write_img_tag( '11fg.gif', `` )
              )
           )
        )
     )
  ).

grid11( Solution ) :-
  node_sequence( [f,h], Solution ),
  (  node_sequence( [f,b], Solution )
  -> write_img_tag( '11bfh.gif', `` )
  ;  (  node_sequence( [f,c], Solution )
     -> write_img_tag( '11cfh.gif', `` )
     ;  (  node_sequence( [f,d], Solution )
        -> write_img_tag( '11dfh.gif', `` )
        ;  (  node_sequence( [f,e], Solution )
           -> write_img_tag( '11efh.gif', `` )
           ;  (  node_sequence( [f,g], Solution )
              -> write_img_tag( '11gfh.gif', `` )
              ;  write_img_tag( '11fh.gif', `` )
              )
           )
        )
     )
  ).

grid11( Solution ) :-
  write_img_tag( '11f.gif', `'F' is not visited during this path` ).

grid12( Solution ) :-
  write_img_tag( '12.gif', `` ).

grid13( Solution ) :-
  (  node_sequence( [b,d], Solution )
  -> write_img_tag( '13bd.gif', `` )
  ;  write_img_tag( '13.gif', `` )
  ).

grid14( Solution ) :-
  node_sequence( [b,d], Solution ),
  (  node_sequence( [d,f], Solution )
  -> write_img_tag( '14bdf.gif', `` )
  ;  (  node_sequence( [d,g], Solution )
     -> write_img_tag( '14bdg.gif', `` )
     ;  write_img_tag( '14bd.gif', ``  )
     )
  ).

grid14( Solution ) :-
  node_sequence( [d,f], Solution ),
  (  node_sequence( [d,b], Solution )
  -> write_img_tag( '14bdf.gif', `` )
  ;  (  node_sequence( [d,g], Solution )
     -> write_img_tag( '14fdg.gif', `` )
     ;  write_img_tag( '14df.gif', ``  )
     )
  ).

grid14( Solution ) :-
  node_sequence( [d,g], Solution ),
  (  node_sequence( [d,b], Solution )
  -> write_img_tag( '14bdg.gif', `` )
  ;  (  node_sequence( [d,f], Solution )
     -> write_img_tag( '14fdg.gif', `` )
     ;  write_img_tag( '14dg.gif', ``  )
     )
  ).

grid14( Solution ) :-
  write_img_tag( '14d.gif', `'D' is not visited during this path` ).

grid15( Solution ) :-
  (  node_sequence( [f,g], Solution )
  -> write_img_tag( '15fg.gif', `` )
  ;  write_img_tag( '15.gif', ``   )
  ).

grid16( Solution ) :-
  (  node_sequence( [g,i], Solution )
  -> write_img_tag( '16gi.gif', `` )
  ;  write_img_tag( '16i.gif', `'I' is not visited during this path`  )
  ).

grid17( Solution ) :-
  write_img_tag( '17.gif', `` ).

grid18( Solution ) :-
  (  node_sequence( [d,g], Solution )
  -> write_img_tag( '18dg.gif', `` )
  ;  write_img_tag( '18.gif', ``   )
  ).

grid19( Solution ) :-
  node_sequence( [d,g], Solution ),
  (  node_sequence( [f,g], Solution )
  -> write_img_tag( '19dgf.gif', `` )
  ;  (  node_sequence( [g,i], Solution )
     -> write_img_tag( '19dgi.gif', `` )
     ;  write_img_tag( '19dg.gif', `` )
     )
  ).

grid19( Solution ) :-
  node_sequence( [f,g], Solution ),
  (  node_sequence( [d,g], Solution )
  -> write_img_tag( '19dgf.gif', `` )
  ;  (  node_sequence( [g,i], Solution )
     -> write_img_tag( '19fgi.gif', `` )
     ;  write_img_tag( '19fg.gif', `` )
     )
  ).

grid19( Solution ) :-
  node_sequence( [i,g], Solution ),
  (  node_sequence( [d,g], Solution )
  -> write_img_tag( '19dgi.gif', `` )
  ;  (  node_sequence( [f,g], Solution )
     -> write_img_tag( '19fgi.gif', `` )
     ;  write_img_tag( '19gi.gif', `` )
     )
  ).

grid19( Solution ) :-
  write_img_tag( '19g.gif', `'G' is not visited during this path` ).

grid20( Solution ) :-
  (  node_sequence( [g,i], Solution )
  -> write_img_tag( '20gi.gif', `` )
  ;  write_img_tag( '20.gif', `` )
  ).

node_sequence( [Node1,Node2], Solution ) :-
  member( Node1, Solution, Pos1 ),
  member( Node2, Solution, Pos2 ),
  ( Pos1 is Pos2 + 1
  ; Pos1 is Pos2 - 1
  ).
