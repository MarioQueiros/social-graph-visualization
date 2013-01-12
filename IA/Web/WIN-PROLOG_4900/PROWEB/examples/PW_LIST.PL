/* ProWeb Multibox Example
   -----------------------
*/

:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).
:-      multifile( proweb_question     / 2 ).

main_goal :-
  proweb_send_form( input_form  ),
  proweb_send_form( output_form ).

proweb_page( _, [] ).

proweb_form( input_form,
             [ ?list,
               input(type=submit)
             ]
           ).

proweb_form( output_form,
             [ verbatim @ List ]
           ) :-
  proweb_returned_answer( list, List ).

proweb_question( list,
                 [ method = multibox,
                   type   = atom,
                   select = [a,b,c,d,e],
                   rows   = 5
                 ]
               ).
