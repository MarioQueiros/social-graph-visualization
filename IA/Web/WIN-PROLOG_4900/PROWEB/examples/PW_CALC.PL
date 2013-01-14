/* ProWeb-based calculator
   Written by Rebecca Shalfield  1st May 2003
   ------------------------------------------
*/

main_goal :-
  proweb_send_form( calculator_form('') ),
  proweb_returned_answer( calculation, OldCalculation ),
  (  proweb_call( calculation(OldCalculationStored) )
  -> (  OldCalculation = OldCalculationStored
     -> true
     ;  proweb_retract( calculation(OldCalculationStored) ),
        proweb_assert( calculation(OldCalculation) )
     )
  ;  proweb_asserta( calculation('') )
  ),
  proweb_returned_input( button, ButtonClicked ),
  process_button( OldCalculation, ButtonClicked, Answer ),
  proweb_forget_answer( calculation ),
  !,
  proweb_resend_form( calculator_form(Answer) ).

process_button( OldCalculation, '=', Answer ) :-
  !,
  cat( [OldCalculation,'. '], AtomCalculationToBeProcessed, _ ),
  atom_string( AtomCalculationToBeProcessed, StringCalculationToBeProcessed ),
  eread( CalculationToBeProcessed ) <~ StringCalculationToBeProcessed,
  Answer is CalculationToBeProcessed.

process_button( OldCalculation, 'C', Answer ) :-
  !,
  ( proweb_retract( calculation(OldCalculation) )
  ; true
  ),
  proweb_assert( calculation('') ),
  Answer = ''.

process_button( OldCalculation, ButtonClicked, Answer ) :-
  cat( [OldCalculation,ButtonClicked], NewCalculation, _ ),
  ( proweb_retract( calculation(OldCalculation) )
  ; true
  ),
  proweb_assert( calculation(NewCalculation) ),
  Answer = ''.

proweb_page( _, [] ).

proweb_form( calculator_form( Answer ),
             [ div(align='center'),
               h2 @ `ProWeb-Based Calculator`,
               p,
               `Calculation: `,
               ?calculation,
               /p,
               table(border='0'),
               tr,
               td,input(type='submit',name='button',value='7'),/td,
               td,input(type='submit',name='button',value='8'),/td,
               td,input(type='submit',name='button',value='9'),/td,
               td,/td,
               td,input(type='submit',name='button',value='C'),/td,
               /tr,
               tr,
               td,input(type='submit',name='button',value='4'),/td,
               td,input(type='submit',name='button',value='5'),/td,
               td,input(type='submit',name='button',value='6'),/td,
               td,input(type='submit',name='button',value='*'),/td,
               td,input(type='submit',name='button',value='/'),/td,
               /tr,
               tr,
               td,input(type='submit',name='button',value='1'),/td,
               td,input(type='submit',name='button',value='2'),/td,
               td,input(type='submit',name='button',value='3'),/td,
               td,input(type='submit',name='button',value='+'),/td,
               td,input(type='submit',name='button',value='-'),/td,
               /tr,
               tr,
               td,input(type='submit',name='button',value='0'),/td,
               td,input(type='submit',name='button',value='.'),/td,
               td,/td,
               td,/td,
               td,input(type='submit',name='button',value='='),/td,
               /tr,
               /table,
               p,
               `Answer: `,
               Answer,
               /p,
               /div
             ]
           ).

proweb_question( calculation,
                 [ method  = input,
                   type    = atom,
                   cols    = 40,
                   prefill = Calculation
                 ]
               ) :-
  ( proweb_call( calculation(Calculation) )
  ; Calculation = ''
  ). 
