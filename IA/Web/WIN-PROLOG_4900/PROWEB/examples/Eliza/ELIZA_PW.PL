/* ProWeb - Eliza Example */

:- multifile( proweb_page / 2 ).
:- multifile( proweb_form / 2 ).

% Required for the ProWeb version
:- proweb_dynamic( mem/1 ).

:- ensure_loaded( examples('eliza\eliza') ).

eliza_pw :-
  proweb_retractall( mem(_) ),
  proweb_send_form( initial_f(``-`Hello. I am ELIZA. How can I help you?`) ),
  proweb_returned_input( client_says, AtomClientSays ),
  atom_string( AtomClientSays, ClientSays ),
  ClientSays \= ``,
  !,
  eliza_main( ClientSays, ElizaSays ),
  (  
     ElizaSays = `Goodbye. My secretary will send you a bill.` 
  -> proweb_send_form( goodbye_f(ClientSays-ElizaSays) )
  ;  proweb_resend_form( continue_f(ClientSays-ElizaSays) )
  ).

eliza_pw :-
  proweb_resend_form( continue_f(``-`You're very quiet.`) ).

proweb_page( Form, include(PageLocation) ) :- 
  Form = FormName(ClientSays-ElizaSays),
  location( FormName, _, PageLocation ).

proweb_form( Form, include(FormLocation) ) :-
  Form = FormName(ClientSays-ElizaSays),
  location( FormName, FormLocation, _ ),
  proweb_post_reply( client_said, ClientSays ),
  proweb_post_reply( eliza_says,  ElizaSays  ).

location( initial_f,  'eliza/initial.htm',  'eliza/page.htm' ).
location( continue_f, 'eliza/continue.htm', 'eliza/page.htm' ).
location( goodbye_f,  'eliza/goodbye.htm',  'eliza/page.htm' ).

% A ProWeb-aware version of eliza/0 in eliza.pl.
eliza_main( ClientSays, ElizaSays ) :-
  read_atomics(Input) <~ ClientSays,
  process_input(Input,[],Input2),
  eliza_simplify(Input2,Input3),
  findkeywords(Input3,KeyWords),
  sortkeywords(KeyWords,KeyWords2),
  makecomment(KeyWords2,Input3,Comment),
  flatten(Comment,Comment2),
  writecomment(Comment2) ~> ElizaSays.
