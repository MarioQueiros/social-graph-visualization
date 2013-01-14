/* ProWeb Formatted Output in a List on the Fly Example
   Written by Rebecca Shalfield
   ----------------------------------------------------

   This example outputs an HTML page containing a list featuring formatted
   (i.e. bolded and italicised) text assembled on the fly.
*/

:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).
:-      multifile( proweb_question     / 2 ).

main_goal :-
  get_formatted_list( FormattedList ),
  proweb_post_reply( formatted_list, ul @ FormattedList ),
  proweb_send_form( my_form ).

proweb_page( my_form, [] ).

proweb_form( my_form,
             [ ??formatted_list
             ]
           ).

get_formatted_list( FormattedList ) :-
  findall( Element,
           ( text( BoldText, ItalicsText ),
             ( html_print( b ),
               write( BoldText ),
               html_print( /b ),
               write( ` - ` ),
               html_print( i ),
               write( ItalicsText ),
               html_print( /i )
             ) ~> Element
           ),
           FormattedList
         ).

text( `Bold1`, `Italics1` ).
text( `Bold2`, `Italics2` ).
text( `Bold3`, `Italics3` ).
