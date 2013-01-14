/* Proweb Frame Example - Written by Phil Vasey and Rebecca Shalfield
   ------------------------------------------------------------------

   This is a very simple frame-based ProWeb example. It expects to find
   its template files in the C:\INETPUB\PROWEB\HTML\FRAMES directory.
*/

:- multifile( proweb_page     / 2 ).
:- multifile( proweb_form     / 2 ).
:- multifile( proweb_question / 2 ).
:- multifile( proweb_frameset / 2 ).

main_goal :-
  proweb_post_reply( some_more_text, `You can have many frames defined this way but they will all appear identically!` ),
  proweb_send_form( question_form ),
  proweb_send_form( answer_form ).

proweb_frameset( include('frames/frameset.htm') ).

proweb_page( question_form, include('frames/page.htm'    ) ).
proweb_page( answer_form,   include('frames/page.htm'    ) ).
proweb_page( navigate,      include('frames/navigate.htm') ).
proweb_page( info,          include('frames/info.htm'    ) ).

proweb_form( question_form,
             [ `This is the question: `,
               ?my_question,
               p @ input(type=submit)
             ]
           ).

proweb_form( answer_form,
             [ `This is your answer: `,
               MyAnswer
             ]
           ) :-
  proweb_returned_answer( my_question, MyAnswer ).

proweb_question( my_question,
                 [ method =  radio,
                   select =  [yes,no],
                   prefill = yes
                 ]
               ).
