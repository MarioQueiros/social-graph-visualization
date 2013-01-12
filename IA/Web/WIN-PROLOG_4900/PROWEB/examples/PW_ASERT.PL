/* ProWeb Assertion Example
   ------------------------
*/

:- multifile( proweb_page     / 2 ).
:- multifile( proweb_form     / 2 ).
:- multifile( proweb_question / 2 ).
:- multifile( proweb_help     / 3 ).

main_goal :-
  process_form( name_form,    name,    Name ),
  process_form( age_form,     age,     Age ),
  process_form( address_form, address, Address ),
  process_form( telno_form,   telno,   TelNo ),
  proweb_send_form( final_form  ).

process_form( Form, Answer, Value ) :-
  proweb_send_form( Form ),
  proweb_returned_answer( Answer, Value ),
  proweb_unique_assert( fact(Answer,Value) ),
  proweb_post_reply( Answer, Value ).

proweb_unique_assert( X ) :-
  ( proweb_call(X) -> true; proweb_assert(X) ).

proweb_page( _, 
             [ 
               proweb(form),
               table(border='1'),
               tr,
               td,
               ul @ FactsViaProWebCall,
               /td,
               /tr,
               tr,
               td,
               pre @ ??listing_proweb_data_answer,
               /td,
               /tr,
               tr,
               td,
               pre @ ??listing_proweb_data_fact,
               /td,
               /tr,
               /table
             ]
           ) :-
  list_proweb_data_answer,
  list_proweb_data_fact,
  findall( X-Y,
           proweb_call( fact(X,Y) ),
           FactsViaProWebCall
         ).

proweb_form( name_form,
             [ h2 @ `1. Name:`,    ?name,    input(type=submit) ]
           ).

proweb_form( age_form,
             [ h2 @ `2. Age:`,     ?age,     input(type=submit) ]
           ).

proweb_form( address_form,
             [ h2 @ `3. Address:`, ?address, input(type=submit) ]
           ).

proweb_form( telno_form,
             [ h2 @ `4. Tel No:`,  ?telno,   input(type=submit) ]
           ).

proweb_form( final_form,
             [ h2 @ `5. Details:`,p @ ??name,p @ ??age,p @ ??address,p @ ??telno ]
           ).

proweb_question( name,    [ method = input, type = string  ] ).
proweb_question( age,     [ method = input, type = integer ] ).
proweb_question( address, [ method = input, type = string  ] ).
proweb_question( telno,   [ method = input, type = string  ] ).

list_proweb_data_answer :-
  listing( proweb_data_answer ) ~> ProwebDataAnswer,
  proweb_post_reply( listing_proweb_data_answer, ProwebDataAnswer ).

list_proweb_data_fact :-
  listing( proweb_data_fact ) ~> ProwebDataFact,
  proweb_post_reply( listing_proweb_data_fact, ProwebDataFact ).
