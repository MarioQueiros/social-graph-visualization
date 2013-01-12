/* ProWeb Second "Hello World!" Example
   ------------------------------------
*/

:- multifile( proweb_page     / 2 ).
:- multifile( proweb_form     / 2 ).
:- multifile( proweb_question / 2 ).

main_goal :-
  proweb_send_form( input_form ).

proweb_page( input_form, [] ).

proweb_form( input_form, ?name ).

proweb_question( name,
                 [ method = input,
                   type   = string
                 ]
               ).
