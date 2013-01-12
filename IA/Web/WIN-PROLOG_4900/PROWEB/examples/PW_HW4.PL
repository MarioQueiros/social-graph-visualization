/* ProWeb - Fourth "Hello World!" Example
   --------------------------------------
*/

:- multifile( proweb_page     / 2 ).
:- multifile( proweb_form     / 2 ).
:- multifile( proweb_question / 2 ).

main_goal :-
  proweb_send_form( input_form ),
  proweb_returned_answer( name, Name ),
  proweb_send_form( hello_form(Name) ).

proweb_page( _, [] ).

proweb_form( input_form,
             [ ?name,
               input(type=submit)
             ]
           ).

proweb_form( hello_form(Name),
             [ 'Hello ',
               Name,
               unencoded @ '!'
             ]
           ).

proweb_question( name,
                 [ method = input,
                   type   = string
                 ]
               ).
