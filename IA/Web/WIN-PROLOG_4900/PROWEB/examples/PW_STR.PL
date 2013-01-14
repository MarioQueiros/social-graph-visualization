/* ProWeb String Example - Written by Rebecca Shalfield
   ----------------------------------------------------

   This example demonstrates how a LPA string containing HTML syntax can
   be created using html_print/1 and html_print_nl/1. The resulting string
   is then displayed using the default method (i.e. unencoded), encoded,
   unencoded and verbatim so as to observe the difference in their output.
*/

:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).
:-      multifile( proweb_question     / 2 ).

main_goal :-
   create_string ~> String,
   proweb_post_reply( string, String ),
   proweb_send_form(first_form).

proweb_page( first_form, [] ).

proweb_form( first_form,
	     [ ??string,
               p,
               encoded @ ??string,
               p,
               unencoded @ ??string,
               p,
               verbatim @ ??string
             ]
           ).

create_string :-
   html_print_nl(table),
   html_print_nl(td),
   html_print(b),
   html_print(i @ `Hello`),
   tab(5),
   write(`World!`),
   html_print_nl(/b),
   html_print_nl(/td),
   html_print_nl(/table).
