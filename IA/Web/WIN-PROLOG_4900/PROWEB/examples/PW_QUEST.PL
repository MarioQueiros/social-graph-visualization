/*   ProWeb Dynamic Number of Questions on a Form Example
   Written by Rebecca Shalfield and Melly - 7th January 1999
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   This ProWeb program sends two question forms followed by an answers form.
   The first of the question forms includes the questions making up schema 1
   and the second question form includes the questions making up schema 2.
   As some of the questions overlap, these are prefilled on the second
   question form.
   The number of questions per schema (in the question_list/2 clause) can be
   altered. The second argument of each question_list/2 is a list of questions
   to be asked, their method and type; additional arguments could be added,
   such as a selection (hardwird at present) for a menubox perhaps.
*/

main_goal :-
  question_list( FormName, _ ),
  proweb_send_unique_form( question_form(FormName) ).

main_goal :-
  proweb_send_form( final_form ).

proweb_page( _, [] ).

proweb_form( question_form(FormName), [Questions,p,input(type=submit),input(type=reset)] ) :-
  findall( [QuestionToAsk,':',ActualQuestion],
           ( questions_to_ask( FormName, QuestionToAsk, _, _ ),
             ActualQuestion = ?QuestionToAsk
           ),
           Questions
        ).

proweb_form( final_form,
             [Answers]
           ) :-
  findall( [p,Question,' = ',Answer,' (Method = ',verbatim @ Method,', Type = ',Type,')'],
           ( proweb_data_answer( _, _, Question, Answer ),
             one( proweb_data_question( _, _, Method, Type, _, Question ) )
           ),
           Answers
        ).

proweb_question( QuestionToAsk,
                 [ method = Method,
                   type   = Type,
                   select = [ford,peugeot,fiat]
                 ]
               ) :-
  question_list( FormName, _ ),
  \+ proweb_returned_form( FormName ),
  questions_to_ask( FormName, QuestionToAsk, Method, Type ).

questions_to_ask( FormName, QuestionToAsk, Method, Type ) :-
  question_list( FormName, QuestionsToAsk ),
  member( (QuestionToAsk,Method,Type), QuestionsToAsk ).

question_list( schema1,
               [ ( car_id, input,   integer ),
                 ( type,   input,   string  ),
                 ( model,  menubox, atom    )
               ]
              ).

question_list( schema2,
               [ ( car_id, input,   integer ),
                 ( type,   input,   string  ),
                 ( model,  menubox, atom    ),
                 ( year,   input,   number ),
                 ( price,  input,   number  )
               ]
              ).
