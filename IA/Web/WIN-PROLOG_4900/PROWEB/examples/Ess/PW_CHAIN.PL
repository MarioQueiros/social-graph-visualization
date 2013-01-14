:- proweb_dynamic( fact/2 ).

consultation :-
  proweb_send_form( chaining_form ),
  proweb_returned_answer( chaining, Chaining ),
  (  Chaining = `Backwards`
  -> chain_top_down
  ;  chain_bottom_up
  ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                            %
% Rule Chaining - Top Down                                   %
% ________________________                                   %
%                                                            %
% To demonstrate B find a rule "if A then B" and demonstrate %
% all of A.                                                  %
%                                                            %
%                                                            %
% Rule Chaining - Bottom Up                                  %
% _________________________                                  %
%                                                            %
% Find a rule "if A then B" where A is satisfied and add B   %
% to working memory until no more rules can be applied.      %
%                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                           %
% Test Suite - Top Down                     %
% _____________________                     %
%                                           %
% ? x.  e=yes a=yes b=yes                   %
% yes                                       %
% ? x.  e=yes a=no                          %
% no                                        %
% ? y.  e=yes a=yes c=yes                   %
% yes                                       %
% ? y.  e=yes a=yes c=no d=yes              %
% no                                        %
%                                           %
% Test Suite - Bottom Up                    %
% ______________________                    %
%                                           %
% a=yes  b=yes  c=yes  d=yes  e=yes  =>  x  %
% a=yes  b=no   c=yes  d=yes  e=yes  =>  y  %
% a=no   d=yes  c=yes  e=yes         =>  y  %
% a=yes  b=no   c=no                 =>  ?  %
%                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- op( 1190,  fx, (if  ) ).
:- op( 1180, xfx, (then) ).
:- op( 1170, xfy, (and ) ).

if   'Blood is Warm'				% Askable condition
then 'animal is warm blooded'.			% Intermediate conclusion

if   'Blood is Cold'				% Askable condition
then 'animal is cold blooded'.			% Intermediate conclusion

if   'animal is warm blooded'			% Intermediate conclusion
and  'Skin is Fur'				% Askable condition
and  'Motion is Walk'				% Askable condition
then 'animal is mammal'.			% Intermediate conclusion

if   'animal is warm blooded'			% Intermediate conclusion
and  'Skin is Fur'				% Askable condition
and  'Motion is Swim'				% Askable condition
then 'animal is sea based mammal'.		% Intermediate conclusion

if   'animal is sea based mammal'	   
and  'Size is Large'
then 'whale' .					      % Terminal conclusion

if   'animal is sea based mammal'	   
and  'Size is Medium'
then 'dolphin' .					      % Terminal conclusion

if   'animal is sea based mammal'	   
and  'Size is Small'
then 'baby dolphin' .					% Terminal conclusion

if   'animal is warm blooded'			% Intermediate conclusion
and  'Skin is Feather'				% Askable condition
and  'Habitat is Tree'				% Askable condition
and  'Motion is Fly'				% Askable condition
then 'animal is sky based bird'.		% Intermediate conclusion

if   'animal is warm blooded'			% Intermediate conclusion
and  'Skin is Feather'				% Askable condition
and  'Habitat is Land'				% Askable condition
and  'Motion is Walk'				% Askable condition
and  'Motion is Swim'				% Askable condition
and  'Size is Medium'				% Askable condition
then 'animal is land based bird'.		% Intermediate conclusion

if   'animal is cold blooded'			% Intermediate conclusion
and  'Skin is Scale'				% Askable condition
and  'Habitat is Sea'				% Askable condition
and  'Motion is Swim'				% Askable condition
then 'animal is sea water fish'.		% Intermediate conclusion

if   'animal is sea water fish'			% Intermediate conclusion
and  'Colour is Pink'				% Askable condition
then 'salmon'.		                        % Terminal conclusion

if   'animal is sea water fish'			% Intermediate conclusion
and  'Colour is Red'				% Askable condition
then 'red snapper'.		                        % Terminal conclusion

if   'animal is sea water fish'			% Intermediate conclusion
and  'Size is Small'				% Askable condition
then 'mackeral'.		           				 % Terminal conclusion

if   'animal is sea water fish'			% Intermediate conclusion
and  'Size is Medium'				% Askable condition
then 'sea trout'.		           				 % Terminal conclusion

if   'animal is sea water fish'			% Intermediate conclusion
and  'Size is Large'				% Askable condition
then 'cod'.		           				 % Terminal conclusion

if   'animal is cold blooded'			% Intermediate conclusion
and  'Skin is Scale'				% Askable condition
and  'Habitat is River'				% Askable condition
and  'Habitat is Land'				% Askable condition
and  'Motion is Swim'				% Askable condition
and  'Motion is Walk'				% Askable condition
then 'animal is reptile'.			% Intermediate conclusion

if   'animal is cold blooded'			% Intermediate conclusion
and  'Skin is Scale'				% Askable condition
and  'Habitat is River'				% Askable condition
and  'Motion is Swim'				% Askable condition
then 'animal is fresh water fish'.		% Intermediate conclusion

if   'animal is cold blooded'			% Intermediate conclusion
and  'Habitat is Land'				% Askable condition
and  'Motion is Walk'				% Askable condition
then 'animal is insect'.				% Intermediate conclusion

if   'animal is sky based bird'			% Intermediate conclusion
and  'Colour is Black and White'		% Askable condition
then 'magpie'.		                        % Terminal conclusion

if   'animal is land based bird'		% Intermediate conclusion
and  'Colour is Black and White'		% Askable condition
then 'penguin'.		                        % Terminal conclusion

if   'animal is land based bird'		% Intermediate conclusion
and  'Speed is Very Fast'			% Askable condition
then 'ostrich'.		                        % Terminal conclusion

if   'animal is fresh water fish'		% Intermediate conclusion
and  'Colour is Pink'				% Askable condition
then 'salmon'.		                        % Terminal conclusion

if   'animal is insect'				% Intermediate conclusion
and  'Size is Small'				% Askable condition
then 'spider'.		                        % Terminal conclusion

if   'animal is reptile'		% Intermediate conclusion
and  'Size is Small'				% Askable condition
then 'iguana'.		                        % Terminal conclusion

if   'animal is mammal'  			% Intermediate conclusion
and  'animal is carnivore'			% Intermediate conclusion
and  'Legs are Four'				% Askable condition
then 'animal is feline'.			% Intermediate conclusion

if   'animal is feline'				% Intermediate conclusion
and  'Size is Medium'				% Askable condition
then 'animal is medium cat'.			% Intermediate conclusion

if   'animal is feline'				% Intermediate conclusion
and  'Size is Large'				% Askable condition
and  'Meal is Human'				% Askable condition
and  'Status is Predator'			% Askable condition
then 'animal is big cat'.			% Intermediate conclusion

if   'animal is big cat'			% Intermediate conclusion
and  'Pattern is Stripes'			% Askable condition
then 'tiger'.		                        % Terminal conclusion

if   'animal is big cat'			% Intermediate conclusion
and  'Pattern is Spots'			        % Askable condition
then 'leopard'.		                        % Terminal conclusion

if   'animal is big cat'			% Intermediate conclusion
and  'Colour is Brown'		                % Askable condition
then 'lion'.		                        % Terminal conclusion

if   'animal is medium cat'			% Intermediate conclusion
and  'Tail is Long and Furry'			% Askable condition
then 'domestic cat'.	                        % Terminal conclusion

if   'animal is medium cat'			% Intermediate conclusion
and  'Tail is Missing'				% Askable condition
then 'manx cat'.	                        % Terminal conclusion

if   'animal is mammal'  			% Intermediate conclusion
and  'animal is carnivore'			% Intermediate conclusion
and  'Legs are Two'				% Askable condition
then 'human-eating_meat'.				% Terminal conclusion

if   'animal is mammal'  			% Intermediate conclusion
and  'animal is herbivore'			% Intermediate conclusion
and  'Legs are Four'				% Askable condition
and  'Size is Large'				% Askable condition
then 'elephant'.						% Terminal conclusion

if   'animal is mammal'  			% Intermediate conclusion
and  'animal is herbivore'			% Intermediate conclusion
and  'Legs are Four'				% Askable condition
and  'Size is Medium'				% Askable condition
then 'cow'.						% Terminal conclusion

if   'animal is mammal'  			% Intermediate conclusion
and  'animal is herbivore'			% Intermediate conclusion
and  'Legs are Two'				% Askable condition
then 'human-vegetarian'.				% Terminal conclusion

if   'animal is mammal'				% Intermediate conclusion
and  'animal is herbivore'			% Intermediate conclusion
and  'Size is Small'				% Askable condition
then 'animal is rodent'.			% Intermediate conclusion

if   'animal is rodent'				% Intermediate conclusion
and  'Status is Pest'				% Askable condition
and  'Tail is Short and Thin'			% Askable condition
and  'Habitat is Sewer'				% Askable condition
then 'rat'.		                        % Terminal conclusion

if   'animal is rodent'				% Intermediate conclusion
and  'Status is Pest'				% Askable condition
and  'Tail is Long and Bushy'			% Askable condition
and  'Colour is Grey'				% Askable condition
then 'grey squirrel'.	                        % Terminal conclusion

if   'animal is rodent'				% Intermediate conclusion
and  'Tail is Long and Bushy'			% Askable condition
and  'Colour is Red'				% Askable condition
then 'red squirrel'.	                        % Terminal conclusion

if   'animal is rodent'				% Intermediate conclusion
and  'Tail is Missing'   			% Askable condition
and  'Habitat is Desert'			% Askable condition
then 'hamster'.		                        % Terminal conclusion

if   'Meal is Meat'				% Askable condition
then 'animal is carnivore'.			% Intermediate conclusion

if   'Meal is Plant'				% Askable condition
then 'animal is herbivore'.			% Intermediate conclusion

question('Blood is Cold', `Is it cold blooded?`, ['Blood is Warm'-no], ['Blood is Warm'-yes]).
question('Blood is Warm', `Is it warm blooded?`, ['Blood is Cold'-no], ['Blood is Cold'-yes]).

question('Legs are Two', `Is it cold blooded?`, ['Legs are Four'-no], []).
question('Legs are Four', `Is it warm blooded?`, ['Legs are Two'-no], []).

question('Colour is Black and White', `Is it black and white?`, ['Colour is Grey'-no, 'Colour is Brown'-no, 'Colour is Pink'-no,'Colour is Red'-no], []).
question('Colour is Grey',  `Is it grey?`,  ['Colour is Black and White'-no, 'Colour is Brown'-no, 'Colour is Pink'-no,'Colour is Red'-no], []).
question('Colour is Brown', `Is it brown?`, ['Colour is Black and White'-no, 'Colour is Grey'-no,  'Colour is Pink'-no,'Colour is Red'-no], []).
question('Colour is Pink',  `Is it pink?`,  ['Colour is Black and White'-no, 'Colour is Brown'-no, 'Colour is Grey'-no,'Colour is Red'-no], []).
question('Colour is Red',   `Is it red?`,  ['Colour is Black and White'-no, 'Colour is Brown'-no, 'Colour is Grey'-no,'Colour is Pink'-no], []).

question('Habitat is Sewer',  `Does it live in the sewer?`,  ['Habitat is Jungle'-no, 'Habitat is Tree'-no],[]).
question('Habitat is Jungle', `Does it live in the jungle?`, ['Habitat is Sea'-no,    'Habitat is Sewer'-no], []).
question('Habitat is Tree',   `Does it live in a tree?`,     ['Habitat is Sea'-no,    'Habitat is River'-no], []).
question('Habitat is Land',   `Does it live on the land only?`,   ['Habitat is Sea'-no,    'Habitat is River'-no], []).
question('Habitat is Sea',    `Does it live in the sea?`,    ['Habitat is Land'-no],  []).
question('Habitat is River',  `Does it live in a river?`,    ['Habitat is Land'-no],  []).
question('Habitat is Desert', `Does it live in the desert?`,['Habitat is Sea'-no,'Habitat is River'-no],  []).

question('Pattern is Spots' ,  `Does it have spots?`  , ['Pattern is Stripes'-no], []).
question('Pattern is Stripes', `Does it have stripes?`, ['Pattern is Spots'  -no], []).

question('Meal is Meat' , `Does it eat meat?`  , ['Meal is Plant'-no], ['Meal is Plant'-yes]).
question('Meal is Plant', `Does it eat plants?`, ['Meal is Meat' -no], ['Meal is Meat' -yes]).

question('Motion is Walk', `Does it walk?`,[],[]).
question('Motion is Swim', `Does it swim?`,[],[]).
question('Motion is Fly',  `Does it fly?`, [],[]).

question('Size is Small',  `Is it small in size?`,  ['Size is Medium'-no, 'Size is Large' -no], []).
question('Size is Medium', `Is it medium in size?`, ['Size is Small' -no, 'Size is Large' -no], []).
question('Size is Large',  `Is it large in size?`,  ['Size is Small' -no, 'Size is Medium'-no], []).

question('Skin is Fur',    `Is it covered in fur?`,      ['Skin is Feather'-no,'Skin is Scale'-no],[]).
question('Skin is Feather',`Is it covered in feathers?`, ['Skin is Fur'-no,    'Skin is Scale'-no],[]).
question('Skin is Scale',  `Is it covered in scales?`,   ['Skin is Feather'-no,'Skin is Fur'-no  ],[]).

question('Status is Pest',   `Is it considered a pest?`,    [],[]).

question('Status is Predator',`Is it considered a predator?`,[],[]).

question(
	'Tail is Long and Bushy',
	`Is its tail long and bushy?`,
	['Tail is Missing'-no,'Tail is Long and Furry'-no,'Tail is Short and Thin'-no],
	[]
	).

question('Tail is Short and Thin', `Is its tail short and thin?`, ['Tail is Missing'-no, 'Tail is Long and Furry'-no, 'Tail is Long and Bushy'-no], []).
question('Tail is Long and Furry', `Is its tail long and furry?`, ['Tail is Missing'-no, 'Tail is Short and Thin'-no, 'Tail is Long and Bushy'-no], []).
question('Tail is Missing',        `Is its tail missing?`,        ['Tail is Long and Bushy'-no, 'Tail is Long and Furry'-no, 'Tail is Short and Thin'-no], []).

question( Q, QT, [], [] ) :-
  ( write(`Is it true that `),
    write(Q),
    write(`?`)
  ) ~> QT.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                   %
% Top Down Resolution                               %
% ___________________                               %
%                                                   %
% A terminal is any conclusion (then part) which    %
% does not occur in the if part of another rule.    %
% e.g. x and y above are terminals but              %
%      p and q are not terminals                    %
%                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

chain_top_down :-
        chain_terminal_conclusion( R ),         % Any terminal conclusion
        chain_demo( R, Rule ),                  % Which can be demonstrated
        chain_post_result( conclusive(R) ).     % Is a conclusive result

chain_top_down :-
        chain_post_result( inconclusive ).      % Inconclusive result

chain_demo( (A and B), Rule ) :-                      % Conjunction
        !,
        chain_demo( A, Rule ),
        chain_demo( B, Rule ).

chain_demo( Q, Rule ) :-                              % An askable condition
        \+ (if _ then Q),                             % Which is not a conclusion
        !,
        chain_user_confirmation( Q, Rule ).           % Must be confirmed by user

chain_demo( R, _Rule ) :-                             % For a conclusion
        (if C then R),                                % Find any matching rule
        Rule = rule(C,R),
        chain_demo( C, Rule ).                        % Demonstrate conditions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bottom Up Resolution - Case 1                     %
% There is a terminal conclusion in working memory. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

chain_bottom_up :-
        chain_terminal_conclusion( R ),         % Any terminal conclusion
        chain_working_memory( R ),              % In working memory
        chain_post_result( conclusive(R) ).     % Is a conclusive result

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bottom Up Resolution - Case 2               %
% Fire the first satisfied rule and continue. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

chain_bottom_up :-
        (
           Flag = dont_ask              % First try without asking user
        ;
           Flag = ask                   % Then try by asking the user
        ),
        (if C then R),                  % Pick up any rule
        Rule = rule(C,R),
        \+ chain_working_memory( R ),   % Whose conclusion is not in WM
        chain_satisfiable( C ),         % Whose conditions are satisfiable
        chain_satisfied( C, Flag, Rule ),     % And are indeed satisfied
        !,
        chain_add_working_memory( R ),  % Add the conclusion to WM
        chain_bottom_up.                % Continue

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bottom Up Resolution - Case 3 %
% Inconclusive result.          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

chain_bottom_up :-
        chain_post_result( inconclusive ).

%%%%%%%%%%%%%%%%%%%%%%%
% Communal Procedures %
%%%%%%%%%%%%%%%%%%%%%%%

% User confirmation if there is a previous answer or
% a new question (but not both) and that in either
% case the answer is in the affirmative.

chain_user_confirmation( Q, Rule ) :-
        (
           chain_user_answer( Q, Answer )
        ->
           true
        ;
           chain_user_question( Q, Answer, Rule )
        ),
        Answer = yes.

% A terminal conclusion is one which does NOT
% appear in the "if" part of another rule!

chain_terminal_conclusion( R ) :-
        (if _ then R),
        \+ chain_condition( R ).

chain_condition( C ) :-
        (if A then _),
        chain_condition( A, C ).

chain_condition( C, C ).

chain_condition( (A and _B), C ) :-
        chain_condition( A, C ).

chain_condition( (_A and B), C ) :-
        chain_condition( B, C ).

% Satisfiable conditions are those which could be satisfied
% if all the unanswered conditions were in the affirmative
% and all the intermediate conclusions are in working memory

chain_satisfiable( (A and B) ) :-       % Conjunction
        !,
        chain_satisfiable( A ),
        chain_satisfiable( B ).

chain_satisfiable( R ) :-
        (if _ then R),                  % For a derived conclusion
        !,
        chain_working_memory( R ).      % It must be in WM

chain_satisfiable( Q ) :-               % For an askable condition
        \+ chain_user_answer( Q, no ).  % The user has NOT answered no

% Satisfied conditions when all the answers are in the affirmative
% and all intermediate conclusions are in working memory

chain_satisfied( (A and B), Flag, Rule ) :-   % Conjunction
        !,
        chain_satisfied( A, Flag, Rule),
        chain_satisfied( B, Flag, Rule ).

chain_satisfied( R, _Flag, _Rule ) :-
        (if _ then R),                  % For a derived conclusion
        !,
        chain_working_memory( R ).      % It must be in WM

chain_satisfied( Q, ask, Rule ) :-            % For an askable condition
        chain_user_confirmation( Q, Rule ).   % The user confirms it

/* ****************************************************************** */

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ProWeb User-Interface Code %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

chain_add_working_memory( R ) :-
        proweb_assert( chain_working_memory( R ) ).

chain_working_memory( R ) :-
        proweb_call( chain_working_memory( R ) ).

chain_user_question( Q, Answer, Rule ) :-
        proweb_send_form( chain_affirmation_form(Q-Rule) ),
        chain_user_answer( Q, Answer ).

chain_user_answer( Q, Answer ) :-
  proweb_returned_answer( chain_affirmation_question(Q), Answer ),
  % The next line should really be on the end of chain_user_question/2
  assert_related_facts( Q, Answer ).

chain_user_answer( Q, Answer ) :-
  proweb_call( fact(Q,Answer) ).

assert_related_facts( Q, YesNo ) :-
  question( Q, _, YesFactList, NoFactList ),
  member( YesNo-FactList, [yes-YesFactList, no-NoFactList]),
  forall( member(A-V,FactList),
          proweb_unique_assert(fact(A,V))
        ).

proweb_unique_assert( X ) :-
  ( proweb_call(X) -> true; proweb_assert(X) ).

chain_post_result( Result ) :-
        proweb_send_form( chain_result(Result) ).

%%%%%%%%%%%%%%%%%
% Chaining Form %
%%%%%%%%%%%%%%%%%

proweb_question(
                 chaining,
                 [
                   method  = radio,
                   type    = string,
                   select  = [`Backwards`,`Forwards`],
                   prefill = `Backwards`,
                   infix = br
                 ]
               ).

proweb_form( chaining_form, include('ess\chain.htm') ).

proweb_help( chaining_help, `Help`, `Backward chaining is bottom up.~M~JForward chaining is top down.` ).

proweb_page( chaining_form, include('ess\page.htm') ).

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Chain Affirmation Form %
%%%%%%%%%%%%%%%%%%%%%%%%%%

proweb_question( chain_affirmation_question(_Q),
                 [ method  = radio,
                   type    = atom,
                   select  = [yes,no],
                   prefill = yes,
                   infix   = br
                 ]
               ).

proweb_form( chain_affirmation_form(Q-R),
             [ table(border='1',cellspacing='0',cellpadding='3'),
               tr(bgcolor='#C0FFFF'),
               td(colspan='3'),b,`Question`,/b,/td,
               /tr,
               tr(bgcolor='#FFFFC0'),
               td,
               p,
               QT,
               ???why(R),
               /p,
               ?chain_affirmation_question(Q),
               p @ input(type=submit,value=`Confirm`),
               /td,
               td(align='center'),
               p @ ???knowledge,
               p @ ???answers,
               p @ ???deductions,
               p @ ???assumptions,
               /td,
               /tr,
               /table
             ]
           ) :- question( Q, QT, _, _ ).

proweb_help( why(R), `Why?`, Text ) :-
  R = rule( Cond, Conc ),
  ( write(`I am trying to prove the rule:~M~J~M~J`),
    write(`IF:~M~J`),
    write(Cond),
    write(`~M~J`),
    write(`THEN:~M~J`),
    write(Conc)
  ) ~> Text.

proweb_help( answers, `Answers`, AnswersText ) :-
  (  \+ proweb_data_answer(chain_affirmation_question(_),_)
  -> AnswersText = `There are no answers!`
  ;  write(`You gave the following answers to questions asked:~M~J~M~J`) ~> Title,
     proweb_data_page(CurrentPage),
     forall( (  proweb_data_question(Page,_,_,_,chain_affirmation_question(Q)),
                Page < CurrentPage,
                proweb_data_answer(chain_affirmation_question(Q),Answer)
             ),
             ( write(Q),
               write(`=`),
               write(Answer),
               write(`~M~J`)
             )
           ) ~> Answers,
     ( write(Title),
       write(Answers)
     ) ~> AnswersText
  ).

proweb_help( deductions, `Deductions`, DeductionsText ) :-
  (  \+ proweb_call(chain_working_memory(_))
  -> proweb_returned_answer( chaining, Chaining ),
     (  Chaining = `Backwards`
     -> DeductionsText = `There are no deductions as you are using the backward chaining method!`
     ;  DeductionsText = `There are no deductions!`
     )
  ;  write(`The following deductions have been made:~M~J~M~J`) ~> Title,
     forall( proweb_call(chain_working_memory(R)),
             ( write(R),write(`~M~J`))
           ) ~> Deductions,
     ( write(Title),
       write(Deductions)
     ) ~> DeductionsText
  ).

proweb_help( assumptions, `Assumptions`, AssumptionsText ) :-
  (  \+ proweb_call(fact(_,_))
  -> AssumptionsText = `There are no assumptions!`
  ;  write(`The following assumptions have been made:~M~J~M~J`) ~> Title,
     forall( proweb_call(fact(A,V)),
             ( write(A),
               write(`=`),
               write(V),
               write(`~M~J`)
             )
           ) ~> FactValuePairs,
     ( write(Title),
       write(FactValuePairs)
     ) ~> AssumptionsText
  ).

proweb_help( knowledge, `Knowledge`, KnowledgeText ) :-
  ( write(`I know about the following animals:~M~J~M~J`),
  findall( TermConc,
           chain_terminal_conclusion(TermConc),
           TermConcs
         ),
  sort( TermConcs, SortedTermConcs ),
  forall( member(X,SortedTermConcs),
          (write(X),nl)
        )
  ) ~> KnowledgeText.

proweb_page( [chain_affirmation_form(_)|_], include('ess\page.htm') ).

%%%%%%%%%%%%%%%%%%%%%
% Chain Result Form %
%%%%%%%%%%%%%%%%%%%%%

proweb_form( chain_result(conclusive(R)), include('ess\result.htm') ) :-
  ( write(`I have concluded that the animal in question is a `),
    write(R)
  ) ~> ResultText,
  proweb_post_reply( result, ResultText ).
               
proweb_form( chain_result(inconclusive), include('ess\result.htm') ) :-
  proweb_post_reply( result, `Sorry, I cannot conclude anything!` ).

proweb_page( [chain_result(_)|_], include('ess\page.htm') ).

/* ****************************************************************** **

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prolog User-Interface Code %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-      initialization
        chain_startup.

chain_startup :-
        dynamic( chain_working_memory / 1 ),
        dynamic( chain_user_answer    / 2 ).

chain_add_working_memory( R ) :-
        assert( chain_working_memory( R ) ).

chain_user_question( Q, Answer, Rule ) :-
        (
          write( `Is it true that ` ),
          nl,
          nl,
          write( Q )
        ) ~> QuestionText,
        message_box( yesno, QuestionText, Answer ),
        assert( chain_user_answer( Q, Answer ) ).

chain_post_result( Result ) :-
        chain_print_result( Result ) ~> ResultText,
        message_box( ok, ResultText, ok ).

chain_print_result( conclusive(R) ) :-
        write( `I have concluded that: ` ),
        write( R ).

chain_print_result( inconclusive ) :-
        write( `Sorry, I cannot conclude anything!` ).

** ****************************************************************** */
