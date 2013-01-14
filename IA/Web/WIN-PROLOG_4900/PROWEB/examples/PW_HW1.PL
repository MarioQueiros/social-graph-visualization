/* ProWeb - First "Hello World!" Example
   -------------------------------------
*/

:- multifile( proweb_page / 2 ).
:- multifile( proweb_form / 2 ).

main_goal :-
  proweb_send_form( hello_form ).

proweb_page( hello_form, [] ).

proweb_form( hello_form, 'Hello World!' ).
