/* ProWeb Sound Example by Rebecca Shalfield 18th July 2002
   --------------------------------------------------------

   This example embeds a sound plug-in application into the HTML page sent to the client and
   allows the file START.WAV (in ProWeb's root directory on the server) to be played.

   We have only managed to make this work in Netscape Navigator and not Internet Explorer.

*/

main_goal :-
  proweb_send_form( question_form ),
  proweb_send_form( play_form     ).

proweb_page( _, [] ).

proweb_form( question_form,
             [ p,
               `Hidden: `,
               ?hidden,
               /p,
               p,
               `Volume: `,
               ?volume,
               /p,
               p,
               `Loop: `,
               ?loop,
               /p,
               p,
               `Auto Start: `,
               ?autostart,
               /p,
               p @ input(type=submit)
             ]
           ).

proweb_form( play_form,
             [ p,
               embed( src       = 'start.wav',
                      type      = 'audio/wav',
                      hidden    = Hidden,
                      volume    = Volume,
                      loop      = Loop,
                      autostart = AutoStart,
                      height    = '60',
                      width     = '146'
                    ),
               /p
             ]
           ) :-
  proweb_returned_answer( hidden,    Hidden    ),
  proweb_returned_answer( volume,    Volume    ),
  proweb_returned_answer( loop,      Loop      ),
  proweb_returned_answer( autostart, AutoStart ).

proweb_question( hidden,
                 [ method  = menubox,
                   type    = atom,
                   select  = [true,false],
                   prefill = false

                 ]
               ). 

proweb_question( volume,
                 [ method  = input,
                   type    = integer,
                   prefill = 50,
                   lwb     = 0,
                   upb     = 100
                 ]
               ).

proweb_question( loop,
                 [ method  = menubox,
                   type    = atom,
                   select  = [true,false,'2','5','10'],
                   prefill = false

                 ]
               ).

proweb_question( autostart,
                 [ method  = menubox,
                   type    = atom,
                   select  = [true,false],
                   prefill = true

                 ]
               ). 
