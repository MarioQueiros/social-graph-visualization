/* ProWeb 'Prolog Database' Example - Written by Rebecca Shalfield 10-8-2001
   -------------------------------------------------------------------------
*/

:- multifile( proweb_page/2 ).
:- multifile( proweb_form/2 ).

main_goal :-
  proweb_dynamic( my_fact/1 ),
  proweb_send_form( my_facts_form(none) ),
  proweb_assert( my_fact(green) ),
  proweb_send_form( my_facts_form(after_assert) ),
  proweb_asserta( my_fact(blue) ),
  proweb_send_form( my_facts_form(after_asserta) ),
  proweb_assertz( my_fact(red) ),
  proweb_send_form( my_facts_form(after_assertz) ),
  proweb_retract( my_fact(green) ),
  proweb_send_form( my_facts_form(after_retract) ),
  proweb_retractall( my_fact(_) ),
  proweb_send_form( my_facts_form(after_retractall) ).

proweb_page( my_facts_form(_), [] ).

proweb_form( my_facts_form(_),
             [
               p @ `I currently have the following facts in memory:`,
               ul @ MyFacts,
               input(type=submit)
             ]
           ) :-
  findall( MyFact,
           proweb_call( my_fact(MyFact) ),
           MyFacts
         ).
