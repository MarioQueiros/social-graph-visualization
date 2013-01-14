/* ProWeb Multiple Submit Button Example
   -------------------------------------
*/

:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).
:-      multifile( proweb_question     / 2 ).

main_goal :-
  ask_question( 1 ).

ask_question( Number ) :-
  proweb_send_form( question_form(Number) ),
  (  proweb_returned_input( question(Number), Answer )
  -> proweb_assert( question(Number,Answer) )
  ;  true
  ),
  findall( ('You answered ' - Answer1 - ' to form ' - Number1),
           proweb_call(question(Number1,Answer1)),
           Answers
         ),
  proweb_post_reply( answers, ul @ Answers ),
  NextNumber is Number + 1,
  ask_question( NextNumber ).

proweb_page( _, [] ).

proweb_form( question_form(Number),
             [ `This is form number `,
               Number,
               p,
               ??answers,
               p,
               input( type=submit, name=question(Number), value='Yes' ),
               input( type=submit, name=question(Number), value='No'  )
             ]
           ).
