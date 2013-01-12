/*
   Undocumented Message Box Predicate - Brian D Steel - 13 Aug 99 / 27 Feb 02
   --------------------------------------------------------------------------

   While rewriting the reference manual for WIN-PROLOG 4.0, a number
   of undocumented predicates were found. Many were not used anywhere
   within the system, and were therefore simply removed; others, like
   those in the present file, were used internally but never published.

   WIN-PROLOG 4.0 retains the documented message_box/3 and msgbox/4
   predicates, but the following predicate has been removed to this
   library file. Please note that its argument order is non-standard
   with respect to all other WIN-PROLOG dialogs (notably, the title
   is its second argument, and not the first).
*/

message_box( Buttons, Title, Message, Button ) :-
   message_box_buttons( Buttons, Mode ),
   busy( Busy ),
   msgbox( Title, Message, Mode, Response ),
   busy( Busy ),
   message_box_response( Response, Button ).

message_box_buttons( ok,          48 ).
message_box_buttons( okcancel,    49 ).
message_box_buttons( yesno,       36 ).
message_box_buttons( yesnocancel, 35 ).

message_box_response( 1, ok     ).
message_box_response( 2, cancel ).
message_box_response( 6, yes    ).
message_box_response( 7, no     ).
