/* ProWeb Submitting via Graphics Example
   --------------------------------------

   Should you wish to submit a ProWeb-generated page by clicking on a graphic,
   the following example may help; a better approach might be to use Javascript!
*/

:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).
:-      multifile( proweb_question     / 2 ).

main_goal :-
  create_images_string( [red,blue,yellow,green] ) ~> ImagesString,
  proweb_post_reply( images_string, unencoded @ ImagesString ),
  proweb_send_form( images_form ),
  send_output_page.

send_output_page :-
  (  proweb_returned_input( 'red.x', _ ),
     proweb_returned_input( 'red.y', _ )
  -> proweb_send_form( output_form(red) )
  ).

send_output_page :-
  (  proweb_returned_input( 'blue.x', _ ),
     proweb_returned_input( 'blue.y', _ )
  -> proweb_send_form( output_form(blue) )
  ).

send_output_page :-
  (  proweb_returned_input( 'yellow.x', _ ),
     proweb_returned_input( 'yellow.y', _ )
  -> proweb_send_form( output_form(yellow) )
  ).

send_output_page :-
  (  proweb_returned_input( 'green.x', _ ),
     proweb_returned_input( 'green.y', _ )
  -> proweb_send_form( output_form(green) )
  ).

proweb_page( images_form, [] ).

proweb_page( output_form(_), [] ).

proweb_form( images_form, ImagesString ) :-
  proweb_posted_reply( images_string, ImagesString ).

proweb_form( output_form(Colour),
             [ `You clicked on the `,
               Colour,
               ` image!`
             ]
           ).

create_images_string( List ) :-
  forall( member( X, List ),
          ( write( `<INPUT TYPE=IMAGE SRC=` ),
            image( X, Graphic ),
            write( Graphic ),
            write( ` Name=`),
            write( X ),
            write( ` ALT=` ),
            write( X ),
            write( `> `),
            write( X ),
            html_print(br)
          )
        ).

image( red,    'images/red.jpg'    ).
image( blue,   'images/blue.jpg'   ).
image( yellow, 'images/yellow.jpg' ).
image( green,  'images/green.jpg'  ).
