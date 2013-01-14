/*
    Example Flex Server -  Alan Westwood - 17 Feb 1999
    ==================================================
    
    The predicates contained in this file allow flex to call the dialogs
    implemented at the client end of the intelligence server.
    
    NOTE: To use this flex server you need to have purchased and installed 
    the Intelligence Server toolkit.
    
    The predicates that define the interface are:
    
    ask_/5
    explain_/1
    flash/1             hook for a message box
    echo/1              calls flash/1

    These are utility predicates.
    gensym/2
    init_gensym/1
    tty_flush/0
    
    The predicates that define the dialogs are:

    server_separator/1  specify the ASCII value of the input string 
         separator
    flx_mltbox/5        hook for a multiple choice list box
    flx_lstbox/5        hook for a single choice list box
    flx_edtbox/5        hook for an edit input box
    flx_msgbox/3        hook for a message box

    For all the calls to input/2, the predicate used to notify callbacks
    in the intelligence server, the special separator of ASCII value 1 is
    used to separate the items of data. This can be changed by changing
    the value specified in the separator/1 clause in this file.

    The intelligence server interface relies on character codes to denote
    which dialogs are to be called at the client end. These characters 
    are specified in the input string that is sent to the client end of 
    the interface.

    The characters that are used are shown in the following table:

    Flag                Dialog
    ----                ------
    f                   flash message box
    m                   multiple choice list box
    s                   single choice list box
    e                   edit input box
    x                   message box

    
    Message Boxes
    -------------
    For message boxes the Buttons argument is a concatenation of the text 
    of the buttons. For example a message box with just an "OK" button has
    a Buttons argument of ok and a message box with two buttons "Yes" and 
    "No" has a Buttons argument of yesno.

    
    Explanations
    ------------
    To request the explanation facility a flex dialog must return the string:
    `??. `
    
*/


% Change this for your application to the appropriate path.

:- initialization( load_files(prolog(flex)) ) .


explain([N|NS]) :-                          % list of rule names
  explain_([N|NS]),
  !.
explain(NS).


answer(N,V) :-
  isa_value(N,T),
  !,
  V=T.
answer(N,V) :-
  ask(N,T),
  !,
  V=T.


ask(N) :-
  ask(N,V).
ask(N,V) :-
  get_question(N,WS,A,E),     % pick up the actual question
  ask_(A,WS,N,E,V),           % get an answer or explain reason for question
  new_value(N,V),             % assign answer to question name
  !.


get_question(N,WS,A,E) :-
  isa_question(N,WS,A,E),
  !.
get_question(N,WS,A,E) :-
  isa_question(catchall,WS,A,E),
  !.
get_question(N,WS,A,E) :-
  error_(['Unknown question :',N,
          '~M~JTry defining a question called ~Bcatchall~D']).



% Generic ask the user for information

ask_( input, WS, N, E, V ) :-
  ask_input( set, WS, N, E, V ).

% DUMMY
ask_( input(Type), WS, N, E, V ) :-
  ask_input( Type, WS, N, E, V ).


% SINGLE CHOICE MENU

ask_( single(M), WS, N, E, V ) :-
  (  atom( M )
  -> flatten_group( M, MS )
  ;  M = MS 
  ),
  flx_cnv_list_to_string(WS,Msg,atom,` `),
  repeat,
  (  flx_lstbox('Single Choice Options Menu',Msg,MS,Option, 'Explain...' )
  -> !,
     V=Option
  ;  explainit(E,N),
     fail 
  ).


% MULTIPLE CHOICE MENU

ask_( multiple(M), WS, N, E, V ) :-
  (  atom( M ) 
  -> flatten_group( M, MS )
  ;  M = MS 
  ),
  flx_cnv_list_to_string(WS,Msg,atom,` `),
  repeat,
  (  flx_mltbox('Multiple Choice Options Menu',Msg,MS,Cs,'Explain...')
  -> !,
     V=Cs
  ;  explainit(E,N),
     fail 
  ).

% PROGRAMMATIC ANSWER

ask_( ':'(T,C), WS, N, E, T ) :-
  !,
  C.


% CATCHALL

ask_( T, WS, N, E, V ) :-
  error_(['Unable to ask question ... ',N] ).


% FLASH

flex_flash(Terms) :-
   flx_cnv_list_to_string(Terms,Message,atom,` `),
   flx_message_box( ok, Message, Result ).


% EXPLANATION

explain_( NS ) :-
  flx_cnv_list_to_string( NS, Options, atom, `~M~J` ),
  repeat,
  (  flx_lstbox( 'Order of rule firing', 'Choose a rule to explain ...', Options, Option )
  -> 'ÄÄ'( Option ),
     fail
  ;  ! 
  ).


/**** END EXPORTED predicates ****/


% KEYBOARD INPUT

ask_input(Type,WS,N,E,V) :-
   flx_cnv_list_to_string(WS,Msg,atom,` `),
   ask_input(Type,``,Msg,N,E,V).

ask_input(Type,String1,Msg,N,E,V) :-
   (  flx_edtbox('Typed Input',Msg,String1,String2,'Explain...')
   -> atom_string(Atom,String2),
      (  check_type(Type,Atom,VV)
      -> V=VV
      ;  ask_input(Type,String2,Msg,N,E,V) 
      )
   ;  explainit(E,N),
      ask_input(Type,String1,Msg,N,E,V) 
   ).


% BROWSE FILE

explainit(file(F),N) :-
  !,
  browse(F,N).


% FLASH TEXT

explainit(text(M),N) :-
  !,
  flex_flash(M).


% NO EXPLANATION

explainit(_,N) :-
  flex_flash(['No explanation available for ... ',N]).


check_type( name, Atom, Atom ) :-
   !.
check_type( set, Atom, Set ) :-
   !,
   atom_string( Atom, String ),
   cat( [String,` . `], StringDot, _ ),
   (  read_tokens( Tokens ) <~ StringDot
   -> strip_functors( Tokens, Set )
   ;  Set = [] 
   ).
   
check_type( Type, Atom, Val ) :-
   name( Atom, String ),
   name( Val, String ),
   (  check_type( Type, Val )
   -> true
   ;  (  Type = (_:prove(Condition))
      -> functor(Condition,Pred,_),
         Message = ['Answer must satisfy :',Pred]
      ;  Type = (_:Condition)
      -> functor(Condition,Pred,_),
         Message = ['Answer must satisfy :',Pred]
      ;  Type = integer
      -> Message = ['Please type in an integer !']
      ;  Message = ['Please type in a',Type,!] 
      ),
      flex_flash( Message ),
      fail 
   ).

check_type( :(Val,Condition), Val ) :-
   !,
   Condition.
check_type( Type, Val ) :-
   Test =.. [Type,Val],
   Test.


strip_functors( [], [] ).
strip_functors( ['.'|_], [] ) :- !. % DUMMY
strip_functors( [Token|Tokens], [Head|Tail] ) :-
    (  arg( 1, Token, Head )
    -> true
    ;  Head = Token ),
    strip_functors( Tokens, Tail ).


gensym(P,O) :-
  gensym_(P,O).

init_gensym( Root ) :-
   init_gensym_( Root ).

% specify the ASCII value of the input string separator

separator( 1 ).


% display a list of terms as a message ignore the result 

flash(Terms) :-
   separator( S ),
   ( write( f ),
     put( S ),
     writelist( Terms )
   ) ~> MsgString,
   input( MsgString, _ ).


% write out a list of terms with spaces 

writelist( [] ).
writelist( [Head|Tail] ) :-
   write( Head ),
   write( ' ' ),
   writelist( Tail ).


% write out a list of terms with a given separator

writelist( [], _ ).
writelist( [Head|Tail], Separator ) :-
   put( Separator ),
   write( Head ),
   writelist( Tail, Separator ).


% display a list of terms as a message ignore the result 

echo(Terms) :-
   flash(Terms).




% display a multichoice list box and return the resultant selections 

% In this emulation the Button is ignored
% as it is standard for all runtime dialogs

flx_mltbox( Title, Message, Items, Selections, Button ) :-
   separator( S ),
   ( write( m ),
     writelist( [Title,Message|Items], S )
   ) ~> MultString ,
   input( MultString, ReturnString ),
   read( Term ) <~ ReturnString,
   Term \= '??',
   Selections = Term .


% display a single choice list box and return the resultant selection 

flx_lstbox( Title, Message, Items, Selection ) :-
   flx_lstbox( Title, Message, Items, Selection, _ ) .

flx_lstbox( Title, Message, Items, Selection, Button  ) :-
   list( Items ),
   !,
   separator( S ),
   ( write( s ),
     writelist( [Title,Message|Items], S )
   ) ~> SnglString,
   input( SnglString, ReturnString ),
   read( Term ) <~ ReturnString,
   Term \= '??',
   Selection = Term .

flx_lstbox( Title, Message, Atom, Selection, Button  ) :-
   atom( Atom ),
   !,
   atom_string( Atom, String ),
   flx_lstbox( Title, Message, String, Sel, Button ),
   atom_string( Selection, Sel ).

flx_lstbox( Title, Message, String, Selection, Button  ) :-
   string( String ),
   flx_utl_list_string( List, String ),
   flx_lstbox( Title, Message, List, Selection, Button ).

% display an edit box and return the result 

% In this emulation the Button argument is ignored
% as it is the same for all runtime dialogs

flx_edtbox( Title, Message, Input, Output, Button ) :-
   separator( S ),
   ( write( e ),
     writelist( [Title,Message,Input], S )
   ) ~> EditString,
   input( EditString, ReturnString ),
   eread( Term ) <~ ReturnString,
   Term \= '??',
   Output = ReturnString .


% display a messagebox and return the selected button 

flx_message_box( Buttons, Message, Result ) :-
   separator( S ),
   ( write( x ),
     writelist( [Buttons,Message], S )
   ) ~> MSGString,
   input( MSGString, ReturnString ),
   read( Return ) <~ ReturnString,
   Result = Return .

/* Utilities */

flx_utl_list_string( List, String ) :-
   string( String ),
   !,
   flx_utl_str_to_lst( String, List ).

flx_utl_list_string( List, String ) :-
   list( List ),
   flx_utl_lst_to_str( List, String ).


% **** **** **** **** **** **** **** **** **** **** **** **** 
% Convert a string to a list

flx_utl_str_to_lst( String, List ) :-
   flx_utl_str_to_lst( List ) <~ String .

flx_utl_str_to_lst( [] ) :-
   eof,
   !.

flx_utl_str_to_lst( [Item|Rest] ) :-
   fread( c, 0, 0, X ),
   flx_utl_item_to_str( X, Item ),
   flx_utl_str_to_lst( Rest ).


% convert a list to a string

flx_utl_lst_to_str( List, String ) :-
   flx_utl_lst_to_str( List ) ~> String .


% write out a list to stdout

flx_utl_lst_to_str( [] ) :- !.

flx_utl_lst_to_str( [ Item|Rest] ) :-
   write( Item ),
   nl,
   flx_utl_lst_to_str( Rest ).


% Convert an item to a string

% s - Item  represents a pre-selected item 
% (pre-pended with a tab originally)
flx_utl_item_to_str( [ 9 | Rest ], s-Item ) :-
   !,
   flx_utl_strip_control( Rest, Stripped ),
   string_chars( Item, Stripped ).

% Otherwise Item represents an unselected item
flx_utl_item_to_str( Bytes, Item ) :-
   !,
   flx_utl_strip_control( Bytes, Stripped ),
   string_chars( Item, Stripped ).


% **** **** **** **** **** **** **** **** **** **** **** **** 
% remove all control characters from a list  

flx_utl_strip_control( [], [] ) :- 
   !.

flx_utl_strip_control( [X|Rest], Huh ) :- % Strip Control Characters
   X =< 31,
   !,
   flx_utl_strip_control( Rest, Huh ).

flx_utl_strip_control( [X|Rest], [X|Huh] ) :-
   flx_utl_strip_control( Rest, Huh ).

/* TYPE conversions */

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Conversion between the simple types (atom,chars & string) %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

flx_cnv_atom_to_chars( Atom, Chars ) :-
   atom( Atom ),
   (  Atom = []
   -> Chars = "[]"
   ;  catch( Error, atom_chars( Atom, Chars ) )
   -> Error = 0 
   ).

flx_cnv_chars_to_atom( Chars, Atom ) :-
   (  Chars == "[]"
   -> Atom = []
   ;  catch( Error, atom_chars( Atom, Chars ) )
   -> Error = 0 
   ).

flx_cnv_atom_to_string( Atom, String ) :-
   atom( Atom ),
   (  Atom = []
   -> String = `[]`
   ;  catch( Error, atom_string( Atom, String ) )
   -> Error = 0 
   ).

flx_cnv_string_to_atom( String, Atom ) :-
   string( String ),
   (  String = `[]`
   -> Atom = []
   ;  catch( Error, atom_string( Atom, String ) )
   -> Error = 0 
   ).

flx_cnv_chars_to_string( Chars, String ) :-
   (  catch( Error, string_chars( String, Chars ) )
   -> Error = 0 
   ).

flx_cnv_string_to_chars( String, Chars ) :-
   (  catch( Error, string_chars( String, Chars ) )
   -> Error = 0 
   ).




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Conversion from the simple types to general terms (with variables) %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

flx_cnv_atom_to_term( Atom, Term, Vars ) :-
   flx_cnv_atom_to_string( Atom, String ),
   flx_cnv_string_to_term( String, Term, Vars ).

flx_cnv_chars_to_term( Chars, Term, Vars ) :-
   flx_cnv_chars_to_string( Chars, String ),
   flx_cnv_string_to_term( String, Term, Vars ).

flx_cnv_string_to_term( String, Term, Vars ) :-
   string( String ),
   cat( [String,` . `], StringDot, _ ),
   (  catch( Error, eread( Term, Vars ) ) <~ StringDot
   -> Error = 0 
   ).



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Conversion to the simple types from general terms (with variables) %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

flx_cnv_term_to_atom( Term, Atom, Vars ) :-
   flx_cnv_term_to_string( Term, String, Vars ),
   flx_cnv_string_to_atom( String, Atom ).

flx_cnv_term_to_chars( Term, Chars, Vars ) :-
   flx_cnv_term_to_string( Term, String, Vars ),
   flx_cnv_string_to_chars( String, Chars ).

flx_cnv_term_to_string( Term, String, Vars ) :-
   (  catch( Error, eprint( Term, Vars ) ) ~> TempString
   -> Error = 0 
   ),
   String = TempString.




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Conversion from the simple types to a list of atom,chars,string or term %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

flx_cnv_atom_to_list( Atom, List, Type, Sepr ) :-
   flx_cnv_atom_to_chars( Atom, Chars ),
   flx_cnv_chars_to_list( Chars, List, Type, Sepr ).

flx_cnv_string_to_list( String, List, Type, Sepr ) :-
   flx_cnv_string_to_chars( String, Chars ),
   flx_cnv_chars_to_list( Chars, List, Type, Sepr ).

flx_cnv_chars_to_list( Chars, List, Type, Sepr ) :-
   chars( Chars ),
   nonvar( Type ),
   flx_cnv_sepr_to_chars( Sepr, SeprChars ),
   (  SeprChars = []
   -> flx_cnv_chars_to_typed_list( Chars, Type, List )
   ;  flx_cnv_chars_to_typed_list( Chars, SeprChars, Type, List ) 
   ).

flx_cnv_sepr_to_chars( Sepr, SeprChars ) :-
   (  atom( Sepr )   
   -> flx_cnv_atom_to_chars( Sepr, SeprChars )
   ;  string( Sepr ) 
   -> flx_cnv_string_to_chars( Sepr, SeprChars )
   ;  chars( Sepr )  
   -> SeprChars = Sepr
   ;  flx_cnv_term_to_chars( Sepr, SeprChars, [] ) 
   ).

flx_cnv_chars_to_typed_list( [], _, [] ).
flx_cnv_chars_to_typed_list( [Char|Chars], Type, [Head|Tail] ) :-
   flx_cnv_chars_to_typed_item( Type, [Char], Head ),
   flx_cnv_chars_to_typed_list( Chars, Type, Tail ).

flx_cnv_chars_to_typed_list( [], _, _, [] ).
flx_cnv_chars_to_typed_list( [Char|Chars], SeprChars, Type, [Head|Tail] ) :-
   append( SeprChars, AfterChars, SeprAfterChars ),
   append( BeforeChars, SeprAfterChars, [Char|Chars] ),
   !,
   flx_cnv_chars_to_typed_item( Type, BeforeChars, Head ),
   (  AfterChars = []
   -> Tail = [Last],
      flx_cnv_chars_to_typed_item( Type, [], Last )
   ;  flx_cnv_chars_to_typed_list( AfterChars, SeprChars, Type, Tail ) 
   ).

flx_cnv_chars_to_typed_list( [Char|Chars], _, Type, [Last] ) :-
   flx_cnv_chars_to_typed_item( Type, [Char|Chars], Last ).

flx_cnv_chars_to_typed_item( chars, Chars, Chars ).

flx_cnv_chars_to_typed_item( atom, Chars, Atom ) :-
   flx_cnv_chars_to_atom( Chars, Atom ).

flx_cnv_chars_to_typed_item( string, Chars, String ) :-
   flx_cnv_chars_to_string( Chars, String ).

flx_cnv_chars_to_typed_item( term, Chars, Term ) :-
   flx_cnv_chars_to_term( Chars, Term, _ ).




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Conversion to the simple types from a list of atom,chars,string or term %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

flx_cnv_list_to_atom( List, Atom, Sepr ) :-
   flx_cnv_list_to_atom( List, Atom, term, Sepr ).
flx_cnv_list_to_atom( List, Atom, Type, Sepr ) :-
   flx_cnv_list_to_string( List, String, Type, Sepr ),
   flx_cnv_string_to_atom( String, Atom ).

flx_cnv_list_to_chars( List, Chars, Sepr ) :-
   flx_cnv_list_to_chars( List, Chars, term, Sepr ).
flx_cnv_list_to_chars( List, Chars, Type, Sepr ) :-
   flx_cnv_list_to_string( List, String, Type, Sepr ),
   flx_cnv_string_to_chars( String, Chars ).

flx_cnv_list_to_string( List, String, Sepr ) :-
   flx_cnv_list_to_string( List, String, term, Sepr ).
flx_cnv_list_to_string( List, String, Type, Sepr ) :-
   nonvar( Type ),
   flx_cnv_sepr_to_string( Sepr, SeprString ),
   flx_cnv_write_typed_list( List, Type, SeprString ) ~> TempString,
   String = TempString.

flx_cnv_sepr_to_string( Sepr, SeprString ) :-
   (  atom( Sepr )   
   -> flx_cnv_atom_to_string( Sepr, SeprString )
   ;  string( Sepr ) 
   -> Sepr = SeprString
   ;  chars( Sepr )  
   -> flx_cnv_chars_to_string( Sepr, SeprString )
   ;  flx_cnv_term_to_string( Sepr, SeprString, [] ) 
   ).

flx_cnv_write_typed_list( [], _, _ ).
flx_cnv_write_typed_list( [Head|Tail], Type, SeprString ) :-
   flx_cnv_write_typed_list( Tail, Head, Type, SeprString ).

flx_cnv_write_typed_list( [], Head, Type, _ ) :-
   flx_cnv_write_typed_item( Type, Head ).
flx_cnv_write_typed_list( [Next|Tail], Head, Type, SeprString ) :-
   flx_cnv_write_typed_item( Type, Head ),
   write( SeprString ),
   flx_cnv_write_typed_list( Tail, Next, Type, SeprString ).

flx_cnv_write_typed_item( atom, Atom ) :-
   atom( Atom ),
   write( Atom ).
flx_cnv_write_typed_item( chars, Chars ) :-
   chars( Chars ),
   flx_cnv_chars_to_string( Chars, String ),
   write( String ).
flx_cnv_write_typed_item( string, String ) :-
   string( String ),
   write( String ).
flx_cnv_write_typed_item( term, Term ) :-

% DJW Maintenance 18-Apr-96
% writeq/1 changed to write/1 so that the text of questions has the terms
% beginning with capital letters unquoted

    write( Term ).



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Convert a list of strings to a list of atoms                            %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

flx_strings_to_atoms( [], []  ).
flx_strings_to_atoms( [Item|R1], [Atom|R2] ) :-
   string( Item ),
   atom_string( Atom, Item ),
   !,
   flx_strings_to_atoms( R1, R2 ).
flx_strings_to_atoms( [A|R1], [A|R2] ) :-
   !,
   flx_strings_to_atoms( R1, R2 ).


% DJW Maintenance 22-March-96
% the following program added to allow multiple and single choice menus
% to return atoms and numbers rather than strings

flx_cnv_strings_to_terms( [], [] ).
flx_cnv_strings_to_terms( [S|Ss], [T|Ts] ) :-
   (  number_string( T, S )
   -> true
   ;  atom_string( T, S )
   ),
   flx_cnv_strings_to_terms( Ss, Ts ).


