/* ProWeb Caching Solution Example
   Written by Rebecca Shalfield
   -------------------------------

   This example demonstrates how a partial solution could be calculated
   and stored and then retrieved later for use in the calculation of the
   final solution.
*/

:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).
:-      multifile( proweb_question     / 2 ).

main_goal :-
   (  proweb_returned_form( input_form )
   -> true
   ;  calculate_first_part(Sum1),
      proweb_assertz( calculation_first_part(Sum1) ),
      proweb_send_form( input_form )
   ),
   proweb_call( calculation_first_part(Sum1) ),
   calculate_second_part(Result, Sum1),
   proweb_post_reply( result, Result ),
   proweb_send_form(result_form).

calculate_first_part( Sum1 ) :-
   Sum1 is 1 + 2 + 3 + 4 + 5.

calculate_second_part( Result, Sum1 ) :-
   proweb_returned_answer( missing_value, MissingValue ),
   number_string(MissingValue2, MissingValue),   
   Result is (Sum1 + MissingValue2).

proweb_page( input_form, [] ).

proweb_page( result_form, [] ).

proweb_form( input_form,
	     [ `Please enter the missing integer: `,
               ?missing_value,
               input(type=submit)
             ]
           ).

proweb_form( result_form,
	     [ `The answer is: `,
               ??result
             ]
           ).

proweb_question(missing_value,
                [method=input,
                 type = string,
                 prefill = `0`,
                 maxlength = 3]).
