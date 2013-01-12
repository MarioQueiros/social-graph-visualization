/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% To run, type "hi.<enter>"

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).

%	Top file to ensure all other files are loaded.
% 	Last Modified 21/12/98

/* consult all the chat source files */

:- ensure_loaded( chat( chatinit ) ). % LPA Initialisations
:- ensure_loaded( chat( chatops  ) ). % Operators
:- ensure_loaded( chat( origtop  ) ). % Main control pprocedures
:- ensure_loaded( chat( aggreg   ) ). % Procedures to deal with agregates
:- ensure_loaded( chat( borderp  ) ). % Database of what borders what
:- ensure_loaded( chat( citiesp  ) ). % database of cities
:- ensure_loaded( chat( clotab   ) ). % Grammar stuff 
:- ensure_loaded( chat( contaip  ) ). % Database of what contains what
:- ensure_loaded( chat( countrp  ) ). % Database of countries
:- ensure_loaded( chat( ndtabl   ) ). % Grammar stuff
:- ensure_loaded( chat( newdic   ) ). % Dictionary of words 
:- ensure_loaded( chat( newgp    ) ). % Grammar stuff
:- ensure_loaded( chat( ptree    ) ). % Tree printing routines
:- ensure_loaded( chat( qplan    ) ). % Queery plaing routines
:- ensure_loaded( chat( readin   ) ). % Text parsing routines
:- ensure_loaded( chat( riversp  ) ). % Database of rivers
:- ensure_loaded( chat( scopes   ) ). % Grammar stuff
:- ensure_loaded( chat( slots    ) ). % Grammar stuff
:- ensure_loaded( chat( talkr    ) ). % Output routines
:- ensure_loaded( chat( templa   ) ). % Grammar stuff
:- ensure_loaded( chat( world0p  ) ). % Database of world type things
:- ensure_loaded( chat( xgrun    ) ).

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


  B.W.Robison
  Logic Programming Associates Ltd
  20/4/1994

*/	
