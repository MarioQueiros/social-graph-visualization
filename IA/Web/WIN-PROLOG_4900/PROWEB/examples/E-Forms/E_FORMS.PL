/***********************************************
 * ProWeb E-Forms Example                      *
 * Written by Rebecca Shalfield 30th June 2000 *
 ***********************************************/

:- multifile( proweb_page     / 2 ).
:- multifile( proweb_form     / 2 ).
:- multifile( proweb_question / 2 ).

e_forms :-
  proweb_send_form( preliminary_specification_form ),
  proweb_send_form( question_type_form             ),
  proweb_returned_answer( number_of_questions, NumberOfQuestions ),
  assemble_types_selected( NumberOfQuestions, [], Types ),
  (  ( member(menubox,Types)
     ; member(multibox,Types)
     ; member(radio,Types)
     )
  -> proweb_send_form( list_based_question_options_form )
  ;  true
  ),
  proweb_send_form( question_parameters_form ),
  proweb_send_form( ask_questions_form       ),
  proweb_send_form( results_form             ).

/**********************************
 * preliminary_specification_form *
 **********************************/

proweb_form( preliminary_specification_form, include('E-Forms\form1.htm') ).

/**********************
 * question_type_form *
 **********************/

proweb_form( question_type_form,
             [ h3 @ `Form Specification Stage`,
               h4 @ `Each question must have a name and a type.`,
               table(border='1',cellspacing='0',cellpadding='3'),
               tr(bgcolor='#C0FFFF'),
               td,b,`Number`,/b,/td,
               td,b,`Name`,/b,/td,
               td,b,`Type`,/b,/td,
               HelpText,
               /tr,
               Questions,
               /table,
               p,input(type='submit',value=`Submit Form's Field Types`),/p
             ]
           ) :-
  proweb_returned_answer( number_of_questions, NumberOfQuestions ),
  proweb_returned_answer( help_text_prompting, HelpTextPrompting ),
  (  ( HelpTextPrompting = `None`
     ; HelpTextPrompting = `Default`
     )
  -> HelpText = []
  ;  HelpText = [td,b,`Help Text`,/b,/td]
  ),
  assemble_type_questions( HelpTextPrompting, NumberOfQuestions, [], Questions ).

assemble_type_questions(_, 0,Questions, List ) :-
  !,
  List = Questions.

assemble_type_questions( HelpTextPrompting, X, Questions, List ) :-
  !,
  Y is X - 1,
  number_string( X, XString ),
  (  ( HelpTextPrompting = `None`
     ; HelpTextPrompting = `Default`
     )
  -> assemble_type_questions(HelpTextPrompting,Y,[tr(bgcolor='#FFFFC0'),
                             td,XString,/td,
                             td,?question_name(X),/td,
                             td,?question_type(X),/td,
                             /tr|Questions
                            ],List)
  ;  assemble_type_questions(HelpTextPrompting,Y,[tr(bgcolor='#FFFFC0'),
                             td,XString,/td,
                             td,?question_name(X),/td,
                             td,?question_type(X),/td,
                             td,?question_prompt(X),/td,
                             /tr|Questions
                            ],List)
  ).

/************************************
 * list_based_question_options_form *
 ************************************/

proweb_form( list_based_question_options_form,
             [ h3 @ `Form Specification Stage`,
               h4 @ `Each list-based field requires its list of options to be specified.`,
               table(border='1',cellspacing='0',cellpadding='3'),
               tr(bgcolor='#C0FFFF'),
               td,b,`Name`,/b,/td,
               td,b,`Type`,/b,/td,
               td,b,`Options`,/b,/td,tr,
               Questions,
               /table,
               p,
               input(type='submit',value=`Submit Form's List-Based Field Options`),
               input(type='reset'),
               /p
             ]
           ) :-
  proweb_returned_answer( number_of_questions, NumberOfQuestions ),
  assemble_list_based_questions( NumberOfQuestions, [], Questions ).

assemble_types_selected( 0, AssembledTypes, Types ) :-
  Types = AssembledTypes.

assemble_types_selected( X, AssembledTypes, Types ) :-
  proweb_returned_answer( question_type(X), Type ),
  Y is X - 1,
  assemble_types_selected( Y, [Type|AssembledTypes], Types ).

assemble_list_based_questions(0,Questions, List ) :-
  !,
  List = Questions.

assemble_list_based_questions(X,Questions, List ) :-
  !,
  Y is X - 1,
  proweb_returned_answer( question_name(X), Name ),
  proweb_returned_answer( question_type(X), Type ),
  valid_parameters(Type,_,_,_,MaxOptions,_,_,_,_),
  (  MaxOptions > 0
  -> assemble_option_fields(X,MaxOptions,[],Options)
  ;  Options = `-`
  ),
  (  ( Type=menubox
     ; Type=multibox
     ; Type=radio
     )
  -> assemble_list_based_questions(Y,[tr(bgcolor='#FFFFC0'),
                                      td,Name,/td,
                                      td,Type,/td,
                                      td,Options,/td,
                                      /tr|Questions],List)
  ;  assemble_list_based_questions(Y,Questions,List)
  ).

assemble_option_fields(_,0,Questions, Options ) :-
  !,
  Options = Questions.

assemble_option_fields(X,Number,Questions, Options ) :-
  !,
  Next is Number - 1,
  assemble_option_fields(X,Next,[?question_options(X,Next)|Questions],Options).

/****************************
 * question_parameters_form *
 ****************************/

proweb_form( question_parameters_form,
             [ h3 @ `Form Specification Stage`,
               h4 @ `Each question is further defined by the setting of certain parameters.`,
               table(border='1',cellspacing='0',cellpadding='3'),
               tr(bgcolor='#C0FFFF'),
               td,b,`Name`,/b,/td,
               td,b,`Type`,/b,/td,
               td,b,`Height`,/b,/td,
               td,b,`Width`,/b,/td,
               td,b,`Prefill`,/b,/td,
               td,b,`Lower &`,br,`Upper Bound`,/b,/td,
               td,b,`Max`,br,`Length`,/b,/td,
               td,b,`Format`,/b,/td,/tr,
               Questions,
               /table,
               p,
               input(type='submit',value=`Submit Form's Field Parameters`),
               input(type='reset'),
               /p
             ]
           ) :-
  proweb_returned_answer( number_of_questions, NumberOfQuestions ),
  assemble_questions( NumberOfQuestions, [], Questions ).

assemble_questions(0,Questions, List ) :-
  !,
  List = Questions.

assemble_questions(X,Questions, List ) :-
  !,
  Y is X - 1,
  proweb_returned_answer( question_name(X), Name ),
  proweb_returned_answer( question_type(X), Type ),
  valid_parameters(Type,RowsFlg,ColsFlg,FormatFlg,MaxOptions,PrefillFlg,LowFlg,UpFlg,MaxLenFlg),
  (  RowsFlg = yes
  -> Rows = ?question_rows(X,Type)
  ;  Rows = `-`
  ),
  (  ColsFlg = yes
  -> Cols = ?question_cols(X,Type)
  ;  Cols = `-`
  ),
  (  FormatFlg = yes
  -> Format = ?question_format(X,Type)
  ;  Format = `-`
  ),
  (  MaxOptions > 0
  -> assemble_list_based_options(X,MaxOptions,[],Options),
     (  length(Options,0)
     -> SpecialTD = td(bgcolor='red')
     ;  SpecialTD = td
     )
  ;  SpecialTD = td
  ),
  (  PrefillFlg = yes
  -> Prefill = ?question_prefill(X,Type)
  ;  Prefill = `-`
  ),
  (  LowFlg = yes
  -> Low = ?question_lower(X,Type)
  ;  Low = `-`
  ),
  (  UpFlg = yes
  -> Up = ?question_upper(X,Type)
  ;  Up = ``
  ),
  (  MaxLenFlg = yes
  -> MaxLen = ?question_maxlength(X,Type)
  ;  MaxLen = `-`
  ),
  assemble_questions(Y,[tr(bgcolor='#FFFFC0'),
                      td,Name,/td,
                      td,Type,/td,
                      td,Rows,/td,
                      td,Cols,/td,
                      SpecialTD,Prefill,/td,
                      td,Low,Up,/td,
                      td,MaxLen,/td,
                      td,Format,/td,
                      /tr|Questions],List).

/*                Type,     Rows, Cols, Format, Options, Prefill, Low, Up,  MaxLen */
valid_parameters( atom,     yes,  yes,  no,      0,      yes,     no,  no,  yes ).
valid_parameters( checkbox, no,   no,   no,      0,      yes,     no,  no,  no  ).
valid_parameters( date,     no,   no,   yes,     0,      yes,     no,  no,  no  ).
valid_parameters( integer,  no,   yes,  no,      0,      yes,     yes, yes, yes ).
valid_parameters( menubox,  yes,  no,   no,     10,      yes,     no,  no,  no  ).
valid_parameters( multibox, yes,  no,   no,     10,      yes,     no,  no,  no  ).
valid_parameters( number,   no,   yes,  no,      0,      yes,     yes, yes, yes ).
valid_parameters( password, no,   no,   no,      0,      yes,     no,  no,  yes ).
valid_parameters( radio,    no,   no,   yes,     5,      yes,     no,  no,  no  ).
valid_parameters( string,   yes,  yes,  no,      0,      yes,     no,  no,  yes ).
valid_parameters( time,     no,   no,   yes,     0,      yes,     no,  no,  no  ).

/**********************
 * ask_questions_form *
 **********************/

proweb_form( ask_questions_form,
             [ h3 @ Title,
               h4 @ `Please complete and submit...`,
               Header,
               Questions,
               Footer,
               p @ input(type='submit',value=SubmitButtonText)
             ]
           ) :-
  proweb_returned_answer( form_title, FormTitle ),
  (  FormTitle = ``
  -> Title = `Your Form`
  ;  Title = FormTitle
  ),
  proweb_returned_answer( table_based, TableBased ),
  proweb_returned_answer( help_text_prompting, HelpTextPrompting ),
  (  TableBased = on
  -> (  HelpTextPrompting = `None`
     -> Header = [table(border='1',cellspacing='0',cellpadding='3'),
                  tr,
                  td,b,`Question`,/b,/td,
                  td,b,`Answer`,/b,/td,/tr
                 ],
        Footer = /table
     ;  Header = [table(border='1',cellspacing='0',cellpadding='3'),
                  tr,
                  td,b,`Question`,/b,/td,
                  td,b,`Answer`,/b,/td,
                  td,b,`Help Text`,/b,/td,/tr],
        Footer = /table
     )
  ;  Header = div,
     Footer = /div
  ),
  proweb_returned_answer( number_of_questions, NumberOfQuestions ),
  assemble_real_questions( TableBased, NumberOfQuestions, [], Questions ),
  proweb_returned_answer( submit_button_text, SubmitButtonText ). 

assemble_real_questions( _, 0,Questions, List ) :-
  !,
  List = Questions.

assemble_real_questions( TableBased, X, Questions, List ) :-
  !,
  Y is X - 1,
  proweb_returned_answer( question_name(X),    Name    ),
  proweb_returned_answer( question_type(X),    Type    ),
  valid_parameters(Type,RowsFlg,ColsFlg,FormatFlg,_,PrefillFlg,LowFlg,UpFlg,MaxLenFlg),
  (  RowsFlg = yes
  -> proweb_returned_answer( question_rows(X,_), Rows )
  ;  Rows = null
  ),
  (  ColsFlg = yes
  -> proweb_returned_answer( question_cols(X,_), Cols )
  ;  Cols = null
  ),
  (  FormatFlg = yes
  -> proweb_returned_answer( question_format(X,_), Format )
  ;  Format = null
  ),
  (  PrefillFlg = yes
  -> proweb_returned_answer( question_prefill(X,_), Prefill )
  ;  Prefill = null
  ),
  (  LowFlg = yes
  -> proweb_returned_answer( question_lower(X,_), Low )
  ;  Low = null
  ),
  (  UpFlg = yes
  -> proweb_returned_answer( question_upper(X,_), Up )
  ;  Up = null
  ),
  (  MaxLenFlg = yes
  -> proweb_returned_answer( question_maxlength(X,_), MaxLen )
  ;  MaxLen = null
  ),
  proweb_returned_answer( help_text_prompting, HelpTextPrompting ),
  get_help_text( HelpTextPrompting, X, Type, HelpText ),
  (  TableBased = on
  -> (  HelpTextPrompting \= `None`
     -> assemble_real_questions( TableBased, Y,
                              [ tr,
                                td,Name,/td,
                                td,
                                ?real_form_question(X,Type,Rows,Cols,Format,Prefill,Low,Up,MaxLen),
                                /td,
                                td,HelpText,/td,
                                /tr|Questions
                              ], List )
     ; assemble_real_questions( TableBased, Y,
                              [ tr,
                                td,Name,/td,
                                td,
                                ?real_form_question(X,Type,Rows,Cols,Format,Prefill,Low,Up,MaxLen),
                                /td,
                                /tr|Questions
                              ], List )
     )
  ;  assemble_real_questions( TableBased, Y,
                              [ p,Name,`: `,
                                ?real_form_question(X,Type,Rows,Cols,Format,Prefill,Low,Up,MaxLen),
                                sup,HelpText,/sup,
                                /p|Questions
                              ], List )
  ).

get_help_text( `None`, _, _, `` ).

get_help_text( `Default`, X, Type, HelpText ) :-
  help_text( X, Type, HelpText ).

get_help_text( `User`,  X, _,  HelpText ) :-
  proweb_returned_answer( question_prompt(X), HelpText  ).

get_help_text( `Mixed`,  X, Type,   HelpText ) :-
  proweb_returned_answer( question_prompt(X), Prompt ),
  (  Prompt \= ``
  -> HelpText = Prompt
  ;  help_text( X, Type, HelpText )
  ).

help_text( _, atom,     `Please enter some text`                  ).
help_text( _, checkbox, `Please tick if applicable`               ).
help_text( _, date,     `Please select the appropriate date`      ).
help_text( X, integer, HelpText ) :-
  proweb_returned_answer( question_lower(X,_), Low ),
  proweb_returned_answer( question_upper(X,_), Up ),
  ( write(`Please enter an integer between `),
    write(Low),
    write(` and `),
    write(Up),
    write(` inclusive`)
  ) ~> HelpText.
help_text( _, menubox,  `Please select one of the options`        ).
help_text( _, multibox, `Please select none, one or more options` ).
help_text( X, number, HelpText ) :-
  proweb_returned_answer( question_lower(X,_), Low ),
  proweb_returned_answer( question_upper(X,_), Up ),
  ( write(`Please enter a number between `),
    write(Low),
    write(` and `),
    write(Up),
    write(` inclusive`)
  ) ~> HelpText.
help_text( _, password, `Please enter the appropriate password`   ).
help_text( _, radio,    `Please select one of the radio buttons`  ).
help_text( _, string,   `Please enter some text`                  ).
help_text( _, time,     `Please select the appropriate time`      ).

/****************
 * results_form *
 ****************/

proweb_form( results_form,
             [ 
%               h3,
%               `Thank you for submitting your `,
%               Title,
%               `.`,
%               /h3,
%               h4 @ `The information provided is as shown below...`,
               table(border='1',cellspacing='0',cellpadding='3'),
               tr,
               td,b,`Question`,/b,/td,
               td,b,`Answer`,/b,/td,/tr,
               Results,
               /table
             ]
           ) :-
%  proweb_returned_answer( form_title, FormTitle ),
%  (  FormTitle = ``
%  -> Title = `form`
%  ;  Title = FormTitle
%  ),
  proweb_returned_answer( number_of_questions, NumberOfQuestions ),
  assemble_results( NumberOfQuestions, [], Results ).

assemble_results( 0, Results, List ) :-
  !,
  List = Results.

assemble_results( X, Results, List ) :-
  !,
  Y is X - 1,
  proweb_returned_answer( question_name(X), Name ),
  proweb_returned_answer( question_type(X), Type ),
  proweb_returned_answer( real_form_question(X,_,_,_,_,_,_,_,_), Answer ),
  assemble_reponse( X, Type, Answer, Response ),
  assemble_results(Y,[tr,
                      td,Name,/td,
                      td,verbatim @ Response,/td,
                      /tr|Results
                     ],List).

assemble_reponse( _, atom, Answer, Response ) :-
  (  Answer = ''
  -> Response = `No text was entered!`
  ;  Response = Answer
  ).
assemble_reponse( _, checkbox, Answer, Response ) :-
  (  Answer \= on
  -> Response = off
  ;  Response = Answer
  ).
assemble_reponse( _, date, Answer, Answer ).
assemble_reponse( _, integer,  Answer, Answer ).
assemble_reponse( _, menubox,  Answer, Response ) :-
  (  Answer = ``
  -> Response = `No option was selected!`
  ;  Response = Answer
  ).
assemble_reponse( _, multibox, Answer, Response ) :-
  (  Answer = []
  -> Response = `No options were selected!`
  ;  Response = Answer
  ).
assemble_reponse( _, number,   Answer, Answer ).
assemble_reponse( X, password, Answer, Response ) :-
  proweb_returned_answer( question_prefill(X,password), Password ),
  (  Answer = Password
  -> Response = `Password correct.`
  ;  Response = `Password incorrect!`
  ).
assemble_reponse( _, radio, Answer, Response ) :-
  (  Answer = ``
  -> Response = `No radio button was selected!`
  ;  Response = Answer
  ).
assemble_reponse( _, string, Answer, Response ) :-
  (  Answer = ``
  -> Response = `No text was entered!`
  ;  Response = Answer
  ).
assemble_reponse( _, time, Answer, Answer ).

/*****************
 * miscellaneous *
 *****************/

proweb_page( preliminary_specification_form,   include('E-Forms\page.htm') ).
proweb_page( question_type_form,               include('E-Forms\page.htm') ).
proweb_page( list_based_question_options_form, include('E-Forms\page.htm') ).
proweb_page( question_parameters_form,         include('E-Forms\page.htm') ).
proweb_page( ask_questions_form,               include('E-Forms\page4frm.htm') ).
proweb_page( results_form,                     include('E-Forms\page4out.htm') ).

proweb_question( form_title,
                 [ method    = input,
                   type      = string,
                   prefill   = `Form`,
                   cols      = 40
                 ]
               ).

proweb_question( help_text_prompting,
                 [ method  = radio,
                   type    = string,
                   select  = [`None`,`Default`,`User`,`Mixed`],
                   prefill = `Mixed`,
                   infix   = br
                 ]
               ).

proweb_question( table_based,
                 [ method  = checkbox,
                   prefill = off
                 ]
               ).

proweb_question( number_of_questions,
                 [ method    = input,
                   type      = integer,
                   prefill   = 3,
                   lwb       = 1,
                   upb       = Length,
                   maxlength = 2
                 ]
               ) :-
  types( Types ),
  length( Types, Length ).

proweb_question( submit_button_text,
                 [ method  = input,
                   type    = string,
                   prefill = `Submit Completed Form`,
                   cols    = 40
                 ]
               ).

proweb_question( question_name(X),
                 [ method  = input,
                   type    = string,
                   prefill = Name
                 ]
               ) :-
  NumericalName = X + 96,
  put(NumericalName) ~> Name.

proweb_question( question_type(X),
                 [ method  = menubox,
                   select  = Types,
                   prefill = Prefill
                 ]
               ) :-
  types( Types ),
  length( Types, Length ),
  proweb_returned_answer( number_of_questions, NumberOfQuestions ),
  (  NumberOfQuestions = Length
  -> member( Prefill, Types, X )
  ;  Prefill = 1
  ).

types( [ atom,
         checkbox,
         date,
         integer,
         menubox,
         multibox,
         number,
         password,
         radio,
         string,
         time
       ]
     ).

proweb_question( question_prompt(_),
                 [ method  = input,
                   type    = string,
                   cols    = 40
                 ]
               ).

proweb_question( question_options(_,_),
                 [ method = input,
                   type   = string
                 ]
               ).

proweb_question( question_format(_,date),
                 [ method  = menubox,
                   select  = Options,
                   prefill = '[dd][mm][yyyy]'
                 ]
               ) :-
  findall( Option,
           date_format( Option, _ ),
           Options
         ).

date_format( '31 12 2000',         '[dd][mm][yyyy]'     ).
date_format( '31 DEC 2000',        '[dd][M][yyyy]'      ).
date_format( '31 December 2000',   '[dd][MM][yyyy]'     ).
date_format( '31st DEC 2000',      '[d]th[M][yyyy]'     ).
date_format( '31st December 2000', '[d]th[MM][yyyy]'    ).
date_format( '31/12/2000',         '[dd]/[mm]/[yyyy]'   ).
date_format( '31-12-2000',         '[dd]-[mm]-[yyyy]'   ).
date_format( '12 31 2000',         '[mm][dd][yyyy]'     ).
date_format( 'DEC 31st 2000',      '[M][d]th[yyyy]'     ).
date_format( 'December 31st 2000', '[MM][d]th[yyyy]'    ).
date_format( '2000 12 31',         '[yyyy][mm][dd]'     ).

proweb_question( question_format(_,time),
                 [ method  = menubox,
                   select  = Options,
                   prefill = '[hh12][mm][ss]'
                 ]
               ) :-
  findall( Option,
           time_format( Option, _ ),
           Options
         ).

time_format( '11 59',       '[hh12][mm]'        ).
time_format( '23 59',       '[hh24][mm]'       ).
time_format( '11:59',       '[hh12]:[mm]'       ).
time_format( '23:59',       '[hh24]:[mm]'      ).
time_format( '11 59 am',    '[hh12][mm]am'      ).
time_format( '11 59 pm',    '[hh12][mm]pm'      ).
time_format( '11:59 am',    '[hh12]:[mm]am'     ).
time_format( '11:59 pm',    '[hh12]:[mm]pm'     ).
time_format( '11 59 59',    '[hh12][mm][ss]'     ).
time_format( '11 59 59 am', '[hh12][mm][ss]am'   ).
time_format( '11 59 59 pm', '[hh12][mm][ss]pm'   ).
time_format( '23 59 59',    '[hh24][mm][ss]'    ).
time_format( '11:59:59',    '[hh12]:[mm]:[ss]'   ).
time_format( '11:59:59 am', '[hh12]:[mm]:[ss]am' ).
time_format( '11:59:59 pm', '[hh12]:[mm]:[ss]pm' ).
time_format( '23:59:59',    '[hh24]:[mm]:[ss]'  ).

proweb_question( question_format(_,radio),
                 [ method  = radio,
                   select  = ['Single-Line','Multi-Line'],
                   prefill = 'Single-Line',
                   infix   = br
                 ]
               ) :-
  proweb_returned_answer( table_based, on ).

proweb_question( question_format(_,radio),
                 [ method  = radio,
                   select  = ['Single-Line'],
                   prefill = 'Single-Line'
                 ]
               ).

proweb_question( question_prefill(_,checkbox),
                 [ method  = checkbox
                 ]
               ).

proweb_question( question_prefill(_,date),
                 [ method  = date,
                   format  = '[dd][mm][yyyy]',
                   prefill = date(2001,12,31)
                 ]
               ).

proweb_question( question_prefill(_,time),
                 [ method  = time,
                   format  = '[hh12][mm][ss]',
                   prefill = time(23,59,59,0)
                 ]
               ).

proweb_question( question_prefill(_,integer),
                 [ method  = input,
                   type    = integer,
                   prefill = 0
                 ]
               ).

proweb_question( question_prefill(_,number),
                 [ method  = input,
                   type    = number,
                   prefill = 0
                 ]
               ).

proweb_question( question_prefill(_,password),
                 [ method  = password
                 ]
               ).

proweb_question( question_prefill(X,radio),
                 [ method  = radio,
                   type    = string,
                   select  = Options,
                   infix   = br
                 ]
               ) :-
  valid_parameters(radio,_,_,_,MaxOptions,_,_,_,_),
  assemble_list_based_options(X,MaxOptions,[],PotentialOptions),
  (  PotentialOptions = []
  -> Options = ['Warning!','No','Options','Specified']
  ;  Options = PotentialOptions
  ).

proweb_question( question_prefill(X,menubox),
                 [ method  = menubox,
                   type    = string,
                   select  = Options,
                   rows    = Rows
                 ]
               ) :-
  valid_parameters(menubox,_,_,_,MaxOptions,_,_,_,_),
  assemble_list_based_options(X,MaxOptions,[],PotentialOptions),
  (  PotentialOptions = []
  -> Options = ['Warning!','No','Options','Specified']
  ;  Options = PotentialOptions
  ),
  length(Options,Rows).

proweb_question( question_prefill(X,multibox),
                 [ method  = multibox,
                   type    = string,
                   select  = Options,
                   rows    = Rows
                 ]
               ) :-
  valid_parameters(multibox,_,_,_,MaxOptions,_,_,_,_),
  assemble_list_based_options(X,MaxOptions,[],PotentialOptions),
  (  PotentialOptions = []
  -> Options = ['Warning!','No','Options','Specified']
  ;  Options = PotentialOptions
  ),
  length(Options,Rows).

proweb_question( question_prefill(_,_),
                 [ method  = input,
                   type    = atom
                 ]
               ).

proweb_question( question_rows(X,menubox),
                 [ method  = input,
                   type    = integer,
                   cols    = 2,
                   prefill = Rows,
                   lwb     = 1,
                   upb     = Rows
                 ]
               ) :-
  valid_parameters(menubox,_,_,_,MaxOptions,_,_,_,_),
  assemble_list_based_options(X,MaxOptions,[],Options),
  length(Options,Rows).

proweb_question( question_rows(X,multibox),
                 [ method  = input,
                   type    = integer,
                   cols    = 2,
                   prefill = Rows,
                   lwb     = 1,
                   upb     = Rows
                 ]
               ) :-
  valid_parameters(multibox,_,_,_,MaxOptions,_,_,_,_),
  assemble_list_based_options(X,MaxOptions,[],Options),
  length(Options,Rows).

proweb_question( question_rows(_,_),
                 [ method  = input,
                   type    = integer,
                   cols    = 2,
                   lwb     = 1,
                   upb     = 255,
                   prefill = 1
                 ]
               ).

proweb_question( question_cols(_,atom),
                 [ method  = input,
                   type    = integer,
                   cols    = 2,
                   lwb     = 1,
                   upb     = 255,
                   prefill = 10
                 ]
               ).

proweb_question( question_cols(_,integer),
                 [ method  = input,
                   type    = integer,
                   cols    = 2,
                   lwb     = 1,
                   upb     = 10,
                   prefill = 3
                 ]
               ).

proweb_question( question_cols(_,number),
                 [ method  = input,
                   type    = integer,
                   cols    = 2,
                   lwb     = 1,
                   upb     = 16,
                   prefill = 16
                 ]
               ).

proweb_question( question_cols(_,string),
                 [ method  = input,
                   type    = integer,
                   cols    = 2,
                   lwb     = 1,
                   upb     = 255,
                   prefill = 30
                 ]
               ).

proweb_question( question_lower(_,Type),
                 [ method  = input,
                   type    = Type,
                   cols    = 2,
                   lwb     = -2147483648,
                   upb     = 2147483647,
                   prefill = 0
                 ]
               ).

proweb_question( question_upper(_,Type),
                 [ method  = input,
                   type    = Type,
                   cols    = 2,
                   lwb     = -2147483648,
                   upb     = 2147483647,
                   prefill = 10
                 ]
               ).

proweb_question( question_maxlength(_,atom),
                 [ method  = input,
                   type    = integer,
                   cols    = 4,
                   prefill = 1024,
                   lwb     = 1,
                   upb     = 1024
                 ]
               ).

proweb_question( question_maxlength(_,integer),
                 [ method  = input,
                   type    = integer,
                   cols    = 2,
                   prefill = 10,
                   lwb     = 1,
                   upb     = 10
                 ]
               ).

proweb_question( question_maxlength(_,number),
                 [ method  = input,
                   type    = integer,
                   cols    = 2,
                   prefill = 16,
                   lwb     = 1,
                   upb     = 16
                 ]
               ).

proweb_question( question_maxlength(_,password),
                 [ method  = input,
                   type    = integer,
                   cols    = 2,
                   prefill = 10,
                   lwb     = 1,
                   upb     = 10
                 ]
               ).

proweb_question( question_maxlength(_,string),
                 [ method  = input,
                   type    = integer,
                   cols    = 5,
                   prefill = 65535,
                   lwb     = 1,
                   upb     = 65535
                 ]
               ).

proweb_question( real_form_question(_,atom,Rows,Cols,_,Prefill,_,_,MaxLen),
                 [ method    = input,
                   type      = atom,
                   prefill   = Prefill,
                   rows      = Rows,
                   cols      = Cols,
                   maxlength = MaxLen
                 ]
               ).

proweb_question( real_form_question(_,number,_,Cols,_,Prefill,Low,Up,MaxLen),
                 [ method    = input,
                   type      = number,
                   prefill   = Prefill,
                   cols      = Cols,
                   lwb       = Low,
                   upb       = Up,
                   maxlength = MaxLen
                 ]
               ).

proweb_question( real_form_question(_,integer,_,Cols,_,Prefill,Low,Up,MaxLen),
                 [ method    = input,
                   type      = integer,
                   prefill   = Prefill,
                   cols      = Cols,
                   lwb       = Low,
                   upb       = Up,
                   maxlength = MaxLen
                 ]
               ).

proweb_question( real_form_question(_,checkbox,_,_,_,Prefill,_,_,_),
                 [ method  = checkbox,
                   prefill = Prefill
                 ]
               ).

proweb_question( real_form_question(_,date,_,_,PseudoFormat,Prefill,_,_,_),
                 [ method  = date,
                   format  = RealFormat,
                   prefill = Prefill
                 ]
               ) :- date_format( PseudoFormat, RealFormat ).

proweb_question( real_form_question(X,menubox,0,_,_,Prefill,_,_,_),
                 [ method  = menubox,
                   type    = string,
                   select  = Options,
                   prefill = Prefill
                 ]
               ) :-
  valid_parameters(menubox,_,_,_,MaxOptions,_,_,_,_),
  assemble_list_based_options(X,MaxOptions,[],Options).

proweb_question( real_form_question(X,menubox,Rows,_,_,Prefill,_,_,_),
                 [ method  = menubox,
                   type    = string,
                   select  = Options,
                   prefill = Prefill,
                   rows    = Rows
                 ]
               ) :-
  valid_parameters(menubox,_,_,_,MaxOptions,_,_,_,_),
  assemble_list_based_options(X,MaxOptions,[],Options).

proweb_question( real_form_question(X,multibox,0,_,_,Prefill,_,_,_),
                 [ method  = multibox,
                   type    = string,
                   select  = Options,
                   prefill = Prefill
                 ]
               ) :-
  valid_parameters(multibox,_,_,_,MaxOptions,_,_,_,_),
  assemble_list_based_options(X,MaxOptions,[],Options).

proweb_question( real_form_question(X,multibox,Rows,_,_,Prefill,_,_,_),
                 [ method  = multibox,
                   type    = string,
                   select  = Options,
                   prefill = Prefill,
                   rows    = Rows
                 ]
               ) :-
  valid_parameters(multibox,_,_,_,MaxOptions,_,_,_,_),
  assemble_list_based_options(X,MaxOptions,[],Options).

proweb_question( real_form_question(_,password,_,_,_,_,_,_,MaxLen),
                 [ method    = password,
                   maxlength = MaxLen
                 ]
               ).

proweb_question( real_form_question(X,radio,_,_,'',Prefill,_,_,_),
                 [ method  = radio,
                   type    = string,
                   select  = Options,
                   prefill = Prefill
                 ]
               ) :-
  valid_parameters(radio,_,_,_,MaxOptions,_,_,_,_),
  assemble_list_based_options(X,MaxOptions,[],Options).

proweb_question( real_form_question(X,radio,_,_,'Single-Line',Prefill,_,_,_),
                 [ method  = radio,
                   type    = string,
                   select  = Options,
                   prefill = Prefill
                 ]
               ) :-
  valid_parameters(radio,_,_,_,MaxOptions,_,_,_,_),
  assemble_list_based_options(X,MaxOptions,[],Options).

proweb_question( real_form_question(X,radio,_,_,'Multi-Line',Prefill,_,_,_),
                 [ method  = radio,
                   type    = string,
                   select  = Options,
                   prefill = Prefill,
                   infix   = br
                 ]
               ) :-
  valid_parameters(radio,_,_,_,MaxOptions,_,_,_,_),
  assemble_list_based_options(X,MaxOptions,[],Options).

proweb_question( real_form_question(_,string,Rows,Cols,_,Prefill,_,_,MaxLen),
                 [ method    = input,
                   type      = string,
                   prefill   = Prefill,
                   rows      = Rows,
                   cols      = Cols,
                   maxlength = MaxLen
                 ]
               ).

proweb_question( real_form_question(_,time,_,_,PseudoFormat,Prefill,_,_,_),
                 [ method  = time,
                   format  = RealFormat,
                   prefill = Prefill
                 ]
               ) :- time_format( PseudoFormat, RealFormat ).

assemble_list_based_options( _, 0, DummyList, Options ) :-
  !,
  Options = DummyList.

assemble_list_based_options( X, Number, DummyList, Options ) :-
  !,
  Next is Number - 1,
  proweb_returned_answer(question_options(X,Next),Option),
  (  len( Option, 0 )
  -> assemble_list_based_options(X,Next,DummyList,Options)
  ;  assemble_list_based_options(X,Next,[Option|DummyList],Options)
  ).
