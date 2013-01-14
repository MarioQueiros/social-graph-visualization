/* ProWeb Form Variation Example - Written by Rebecca Shalfield
   ------------------------------------------------------------

   This example shows three instances of the same form, each was a slight
   variation from the previous. It demonstrates how the same form can be
   sent more than once by giving it a parameter, and how such a parameter
   can influence the input field contained within the form.
*/
:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).
:-      multifile( proweb_question     / 2 ).

proweb_settings :-
   proweb_setting( max_forms_per_page, 1    ).

:- proweb_settings.

main_goal :-
   proweb_post_reply( my_reply(1), `This is the 1st instance of this form`),
   proweb_post_reply( my_reply(2), `This is the 2nd instance of this form`),
   proweb_post_reply( my_reply(3), `This is the 3rd instance of this form`),
   proweb_send_form( my_form(1) ),
   proweb_returned_form( my_form(1) ),
   proweb_send_form( my_form(2) ),
   proweb_returned_form( my_form(2) ),
   proweb_send_form( my_form(3) ).

proweb_page( _, [] ).

proweb_form( my_form(Nth),
             [ include('choice.htm') ]
           ).

proweb_question( my_question(Nth),
                 [ method = Method,
                   select = Choice
                 ] 
               ) :-
  question_choice( Nth, Method, Choice ).

question_choice( 1, menubox,  [a,b,c]          ).
question_choice( 2, radio,    [car,bus,train]  ).
question_choice( 3, multibox, [crawl,walk,run] ).
