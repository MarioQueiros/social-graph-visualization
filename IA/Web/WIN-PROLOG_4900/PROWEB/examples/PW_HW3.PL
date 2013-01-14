/* ProWeb - Third "Hello World!" Example
   -------------------------------------
*/

:- multifile( proweb_page     / 2 ).
:- multifile( proweb_form     / 2 ).
:- multifile( proweb_question / 2 ).

main_goal :-
  proweb_send_form( input_form ),
  proweb_send_form( hello_form ).

proweb_page( _, [] ).

proweb_form( input_form, ?name ).

proweb_form( hello_form, 'Hello World!' ).

proweb_question( name,
                 [ method = input,
                   type   = string
                 ]
               ).
