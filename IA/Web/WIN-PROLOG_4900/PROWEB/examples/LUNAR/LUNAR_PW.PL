/*
   ProWeb Moon Internet Example - Rebecca Shalfield - 22-Jan-98
   ------------------------------------------------------------

   This program defines the ProWeb front-end for the LUNAR.PL phases
   of the moon example.

*/

:- multifile( proweb_page      / 2 ).
:- multifile( proweb_form      / 2 ).
:- multifile( proweb_friends   / 2 ).
:- multifile( proweb_question  / 2 ).
:- multifile( proweb_help      / 3 ).
:- multifile( proweb_expansion / 3 ).

:- initialization( ensure_loaded( examples( 'lunar\lunar' ) ) ).

lunar :-
   solution( lunar( Phase, Year, Month, Day ), Nth ),
   \+ proweb_returned_form( lunar(Nth) ),
   proweb_post_reply( phase, Phase ),
   phase_to_gif( Phase, Gif ),
   ( write(`<IMG SRC="/proweb/images/lunar/`),
     write(Gif),
     write(`" ALT="`),
     write(Phase),
     write(`">`)
   ) ~> PhaseGif,
   proweb_post_reply( phase_gif, PhaseGif ),
   proweb_post_reply( day, Day ),
   proweb_post_reply( month, Month ),
   proweb_post_reply( year, Year ),
   proweb_send_form( lunar(Nth) ).

phase_to_gif( 'New Moon',      `new.gif`   ).
phase_to_gif( 'First Quarter', `first.gif` ).
phase_to_gif( 'Third Quarter', `third.gif` ).
phase_to_gif( 'Full Moon',     `full.gif`  ).

proweb_page( lunar(_), include('lunar\page.htm')  ).
proweb_form( lunar(_), include('lunar\lunar.htm') ).
