%	Top file to ensure all other files are loaded.
% 	Last Modified 20/4/94


/* If path for chat does not exist then assert default */


test_file_path:- 
	\+ file_search_path(chat,_),
	assert(file_search_path(chat, prolog('examples\chat80\') ) ).

test_file_path:-
	!.

:- test_file_path. 

/* consult all the chat source files */

:- ensure_loaded( chat( chatops ) ). % Operators
:- ensure_loaded( chat( lpacomp ) ). % Edinburgh compatibility
:- ensure_loaded( chat( pw_top ) ).  % Main control procedures
:- ensure_loaded( chat( aggreg  ) ). % Procedures to deal with agregates
:- ensure_loaded( chat( borderp ) ). % Database of what borders what
:- ensure_loaded( chat( citiesp ) ). % database of cities
:- ensure_loaded( chat( clotab  ) ). % Grammar stuff 
:- ensure_loaded( chat( contaip ) ). % Database of what contains what
:- ensure_loaded( chat( countrp ) ). % Database of countries
:- ensure_loaded( chat( ndtabl  ) ). % Grammar stuff
:- ensure_loaded( chat( newdic  ) ). % Dictionary of words 
:- ensure_loaded( chat( newgp   ) ). % Grammar stuff
:- ensure_loaded( chat( ptree   ) ). % Tree printing routines
:- ensure_loaded( chat( qplan   ) ). % Queery plaing routines
:- ensure_loaded( chat( readin  ) ). % Text parsing routines
:- ensure_loaded( chat( riversp ) ). % Database of rivers
:- ensure_loaded( chat( scopes  ) ). % Grammar stuff
:- ensure_loaded( chat( slots   ) ). % Grammar stuff
:- ensure_loaded( chat( talkr   ) ). % Output routines
:- ensure_loaded( chat( templa  ) ). % Grammar stuff
:- ensure_loaded( chat( world0p ) ). % Database of world type things
:- ensure_loaded( chat( xgrun   ) ).


% :- ensure_loaded( chat('*.pl') ).

/* 	Modifications to the chat system for compatibility

[chatops.pl]:

	Origional Operator: 	'=  
	LPA Operator:		#=

	Origional Operator:	'
	LPA Operator:		#

[readin.pl]:

	definition for to_nl/0 changed to to_nl:-! as this predicate has no
	meaning in a windows system. For more information on this see 
	comments in file.

[newdict.pl]:
	
	Origional Predicate def: '/1
	LPA Predicate def:	 #/1

[clotab.pl]:

	All instancess of ' operator changed to #
	
[newg.pl]:

	All instancess of ' operator changed to #


[origtop.pl]:

	Origional Predicate def: '=/2
	LPA Predicate def:	 #=/2

[scopes.pl]:

	All instancess of ' operator changed to #
	
[slots.pl]:

	All instancess of ' operator changed to #


  B.W.Robinson
  Logic Programming Associates Ltd
  20/4/1994

*/
