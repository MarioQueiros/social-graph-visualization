/* ProWeb 'Am I running in live or test mode?' Example
   ---------------------------------------------------
*/

:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).
:-      multifile( proweb_question     / 2 ).

main_goal :-
  (  def(dde_topic_dict,0,_),
     dde_topic_dict(D),
     member(www_urlecho,D)
  -> Mode = test
  ;  Mode = live
  ),
  proweb_send_form( mode_form(Mode) ).

proweb_page( mode_form(_), [] ).

proweb_form( mode_form(Mode),
             [ 'ProWeb is running in ',
               Mode,
               ' mode'
             ]
           ).
