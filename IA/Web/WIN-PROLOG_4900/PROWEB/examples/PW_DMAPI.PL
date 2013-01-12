/* Web-Based Data Mining Toolkit Example
   Written by Rebecca Shalfield 27th February 2003
   -----------------------------------------------
*/

:- multifile( proweb_page     / 2 ).
:- multifile( proweb_form     / 2 ).
:- multifile( proweb_question / 2 ).

:- initialization ensure_loaded( system( dblink ) ).
:- initialization ensure_loaded( system( dm_api ) ).

main_goal :-
  (  ( proweb_returned_input( special_button, 'Restart Program' ),
       !
     ; proweb_returned_input( special_button, 'Restart Analysis' )
     )
  -> proweb_forget_forms_sent,
     ( proweb_retract( thresholds_set )
     ; true
     ),
     ( retractall( data_dm_api_global(threshold,_,_) )
     ; true
     ),
     ( dm_api_restart_analysis
     ; true
     ),
     ( proweb_retract( analyse_column_set )
     ; true
     ),
     ( proweb_forget_answer( analyse_column(_) )
     ; true
     ),
     ( proweb_retract( analyse_column_solutions(_) )
     ; true
     ),
     ( proweb_retract( conditional_expression )
     ; true
     ),
     ( proweb_retract( conditional_expression_solutions(_) )
     ; true
     ),
     ( proweb_retract( conditional_statement )
     ; true
     ),
     ( proweb_retract( conditional_statement_solutions(_) )
     ; true
     )
  ;  true 
  ),
  (  proweb_returned_input( special_button, 'Restart Program' )
  -> ( proweb_retract( base_table_set )
     ; true
     ),
     ( proweb_retract( target_expression_set )
     ; true
     ),
     ( proweb_forget_answer( target_expression )
     ; true
     ),
     ( proweb_retract( order_by_set )
     ; true
     ),
     ( disconnect_and_shutdown
     ; true
     )
  ;  true
  ),
  !,
  (  proweb_call( connected(HDBC) )
  -> true
  ;  proweb_send_form( data_source_form ),
     proweb_returned_answer( odbc_data_source, ODBCDataSource ),
     proweb_returned_answer( driver,           Driver         ),
     dm_api_startup,
     catch( ConnectionError1, one(db_connect(ODBCDataSource,HDBC)) ),
     (  ConnectionError1 = 0
     -> catch( ConnectionError2, dm_api_connect(ODBCDataSource,Driver) ),
        (  ConnectionError2 = 0
        -> proweb_assert( connected(HDBC) )
        ;  !,
           proweb_resend_form( error_form(`Failed to connect to ODBC data source`) )
        )
     ;  !,
        proweb_resend_form( error_form(`Failed to connect to ODBC data source`) )
     )
  ),
  (  proweb_call( base_table_set )
  -> true
  ;  proweb_send_form( base_table_form(HDBC) ),
     proweb_returned_answer( base_table(_), AtomBaseTable ),
     atom_string( AtomBaseTable, BaseTable ),
     dm_api_base_table( BaseTable, BaseCount ),
     proweb_assert( base_count(BaseCount) ),
     proweb_assert( base_table_set )
  ),
  (  proweb_call( target_expression_set )
  -> true
  ;  proweb_send_form( target_expression_form ),
     proweb_returned_answer( target_expression, TargetExpression ),
     catch( Error1, dm_api_target_expression(TargetExpression,TargetCount) ),
     (  Error1 = 0
     -> proweb_assert( target_count(TargetCount) ),
        proweb_assert( target_expression_set )
     ;  proweb_resend_form( target_expression_form )
     )
  ),
  (  proweb_call( order_by_set )
  -> true
  ;  proweb_send_form( order_by_form ),
     proweb_returned_answer( order_by, OrderBy ),
     proweb_returned_answer( asc_desc, AscDesc ),
     dm_api_order_by( OrderBy, AscDesc ),
     proweb_assert( order_by_set )
  ),
  (  proweb_call( thresholds_set )
  -> true
  ;  proweb_send_form( thresholds_form ),
     proweb_returned_answer( significance_threshold, SignificanceThreshold ),
     proweb_returned_answer( base_threshold,         BaseThreshold         ),
     proweb_returned_answer( hit_threshold,          HitThreshold          ),
     proweb_returned_answer( true_threshold,         TrueThreshold         ),
     dm_api_thresholds( SignificanceThreshold, BaseThreshold, HitThreshold, TrueThreshold ),
     proweb_assert( thresholds_set )
  ),
  (  proweb_call( analyse_column_set )
  -> true
  ;  proweb_send_form( analyse_column_form ),
     proweb_returned_answer( base_table(_), AtomBaseTable ),
     my_db_show_schema( columns(AtomBaseTable), ColumnNames ),
     findall( (Column,Mode),
              ( member(Column,ColumnNames,ColumnPosition),
                proweb_returned_answer(analyse_column(ColumnPosition),Status),
                (  Status = `discrete`
                -> Mode = `Discrete`
                ;  (  Status = `continuous`
                   -> Mode = `Continuous`
                   ;  fail
                   )
                )

              ),
              Columns
            ),
     forall( member((Column,Mode),Columns),
             ( catch( _, dm_api_analyse_column(Mode,Column,_) )
             )
           ),
     dm_api_conditional_expressions( NumberOfSolutions ),
     (  NumberOfSolutions > 0
     -> proweb_assert( analyse_column_solutions(NumberOfSolutions) ),
        proweb_assert( analyse_column_set ),
        proweb_send_form( analysis_form )
     ;  proweb_resend_form( analyse_column_form )
     )
  ),
  (  ( proweb_returned_input( special_button,'First Conditional Expression' )
     ; proweb_call( conditional_expression )
     )
  -> (  proweb_returned_input( special_button,'Break Out' )
     -> proweb_retract( conditional_expression ),
        proweb_retract( conditional_expression_solutions(_) )
     ;  (  proweb_call(conditional_expression)
        -> true
        ;  proweb_assert(conditional_expression)
        ),
        (  proweb_call( conditional_expression_solutions(SortedConditionalExpressionSolutions) )
        -> true
        ;  get_conditional_expression_solutions( SortedConditionalExpressionSolutions ),
           proweb_assert( conditional_expression_solutions(SortedConditionalExpressionSolutions) )
        ),
        len( SortedConditionalExpressionSolutions, NumberOfSolutions ),
        member((Cond,Var),SortedConditionalExpressionSolutions,CurrentSolution),
        proweb_send_form( conditional_expression_form(CurrentSolution,NumberOfSolutions,Cond,Var) ),
        CurrentSolution = NumberOfSolutions,
        proweb_retract( conditional_expression ),
        proweb_retract( conditional_expression_solutions(_) )
     )
  ;  true
  ),
  (  proweb_returned_input( special_button,'Conditional Expression Table' )
  -> get_conditional_expression_solutions( SortedConditionalExpressionSolutions ),
     proweb_send_form( conditional_expressions_form( SortedConditionalExpressionSolutions ) )
  ;  true
  ),
  (  ( proweb_returned_input( special_button,'First Conditional Statement' )
     ; proweb_call( conditional_statement )
     )
  -> (  proweb_returned_input( special_button,'Break Out' )
     -> proweb_retract( conditional_statement ),
        proweb_retract( conditional_statement_solutions(_) )
     ;  (  proweb_call(conditional_statement)
        -> true
        ;  proweb_assert(conditional_statement)
        ),
        get_conditional_statement_masks( Masks ),
        ( member(Mask,Masks,CurrentMask),
          (  proweb_call( conditional_statement_solutions(SortedConditionalStatementSolutions) )
          -> true
          ;  get_conditional_statement_solutions( Masks, SortedConditionalStatementSolutions ),
             proweb_assert( conditional_statement_solutions(SortedConditionalStatementSolutions) )
          ),
          len( SortedConditionalStatementSolutions, NumberOfMasks ),
          member( (Cond,Var), SortedConditionalStatementSolutions, CurrentMask ),
          proweb_send_form( conditional_statement_form(CurrentMask,NumberOfMasks,Cond,Var) ),
          proweb_unreturned_form( conditional_statement_form(CurrentMask,NumberOfMasks,Cond,Var) ),
          !
        ; true
        ),
        CurrentMask = NumberOfMasks,
        proweb_retract( conditional_statement ),
        proweb_retract( conditional_statement_solutions(_) )
     )
  ;  true
  ),
  (  proweb_returned_input( special_button,'Conditional Statement Table' )
  -> get_conditional_statement_masks( Masks ),
     get_conditional_statement_solutions( Masks, SortedConditionalStatementSolutions ),
     len( SortedConditionalStatementSolutions, NumberOfSolutions ),
     (  NumberOfSolutions > 0
     -> proweb_send_form( conditional_statements_form(SortedConditionalStatementSolutions) )
     ;  true
     )
  ;  true
  ),
  !,
  proweb_send_form( thank_you_form ).

get_conditional_expression_solutions( SortedConditionalExpressionSolutions ) :-
  (  proweb_returned_answer( select_all_conditional_expressions, on )
  -> findall( ConditionalExpression,
              dm_api_conditional_expression(ConditionalExpression,_),
              ConditionalExpressions
            )
  ;  proweb_returned_answer( conditional_expressions, ConditionalExpressions )
  ),
  (  len(ConditionalExpressions,0)
  -> !,
     proweb_resend_form( error_form(`No conditional expressions selected!`) )
  ;  findall( (Cond,Var),
              ( member( Cond, ConditionalExpressions ),
                dm_api_conditional_expression(Cond,Var)
              ),
              ConditionalExpressionSolutions
            ),
     sort_conditional_into_orderby_ascdesc_order(ConditionalExpressionSolutions,SortedConditionalExpressionSolutions)
  ).

get_conditional_statement_masks( Masks ) :-
  (  proweb_returned_answer( select_all_conditional_expressions, on )
  -> findall( ConditionalExpression,
              dm_api_conditional_expression(ConditionalExpression,_),
              ConditionalExpressions
            )
  ;  proweb_returned_answer( conditional_expressions, ConditionalExpressions )
  ),
  (  len(ConditionalExpressions,0)
  -> !,
     proweb_resend_form( error_form(`No conditional expressions selected!`) )
  ;  (  len(ConditionalExpressions,1)
     -> Masks = ConditionalExpressions
     ;  findall( Mask,
                 ( member(ConditionalExpresssion1,ConditionalExpressions,Position1),
                   member(ConditionalExpresssion2,ConditionalExpressions,Position2),
                   Position1 < Position2,
                   cat( [ConditionalExpresssion1,` AND `,ConditionalExpresssion2], Mask, _ )
                 ),
                 Masks
               )
     )
  ).

get_conditional_statement_solutions( Masks, SortedConditionalStatementSolutions ) :-
  dm_api_conditional_expressions( NumberOfConditionalExpressions ),
  findall( (Cond,Var),
           ( member(Mask,Masks),
             dm_api_conditional_statement( NumberOfConditionalExpressions, Mask, Cond, Var )
           ),
           ConditionalStatementSolutions
         ),
  sort_conditional_into_orderby_ascdesc_order( ConditionalStatementSolutions, SortedConditionalStatementSolutions ).

proweb_page( _, [ h1 @ `Web-Based Data Mining Toolkit Example` ] ).

proweb_form( data_source_form,
             [ h2 @ `ODBC Data Source`,
               p,
               `ODBC data source:`,
               br,
               ?odbc_data_source,
               /p,
               p,
               `Driver:`,
               br,
               ?driver,
               /p,
               p @ input(type=submit,value='Submit')
             ]
           ).

proweb_form( thresholds_form,
             [ h2 @ `Thresholds`,
               table,
               tr,
               td,`Minimum threshold of `,/td,
               td,?significance_threshold,`%`,/td,
               td,` for AbsoluteSignificance%`,/td,
               /tr,
               tr,
               td,`Minimum threshold of `,/td,
               td,?base_threshold,`%`,/td,
               td,` for Base%`,/td,
               /tr,
               tr,
               td,`Minimum threshold of `,/td,
               td,?hit_threshold,`%`,/td,
               td,` for Hit%`,/td,
               /tr,
               tr,
               td,`Minimum threshold of `,/td,
               td,?true_threshold,`%`,/td,
               td,` for True%`,/td,
               /tr,
               /table,
               p @ input(type=submit,value='Submit')
             ]
           ).

proweb_form( base_table_form(HDBC),
             [ h2 @ `Base Table`,
               p,
               `Select table:`,
               br,
               ?base_table(HDBC),
               /p,
               p @ input(type=submit,value='Submit')
             ]
           ).

proweb_form( target_expression_form,
             [ h2 @ `Target Expression`,
               p,
               `Base table: `,
               BaseTable,
               /p,
               p,
               `Base count: `,
               BaseCount,
               /p,
               p,
               `Columns:`,
               br,
               ul @ SortedColumns,
               /p,
               p,
               `Set target expression:`,
               br,
               ?target_expression,
               /p,
               p @ input(type=submit,value='Submit')
             ]
           ) :-
  proweb_returned_answer( base_table(_), BaseTable ),
  proweb_call( base_count(BaseCount) ),
  db_get_schema( columns(BaseTable), Columns ),
  sort( Columns, SortedColumns ).

proweb_form( order_by_form,
             [ h2 @ `Order By`,
               p,
               `Target count: `,
               TargetCount,
               /p,
               p,
               `Order by:`,
               br,
               ?order_by,
               ?asc_desc,
               /p,
               p @ input(type=submit,value='Submit')
             ]
           ) :-
  proweb_call( target_count(TargetCount) ).

proweb_form( analyse_column_form,
             [ h2 @ `Analyse Column`,
               table,
               tr,
               th(align='center'),`Column`,                 /th,
               th(align='center'),`Include`,br,`Discrete`,  /th,
               th(align='center'),`Include`,br,`Continuous`,/th,
               th(align='center'),`Exclude`,                /th,
               /tr,
               Questions,
               /table,
               p @ input(type=submit,value='Submit')
             ]
           ) :-
  proweb_returned_answer( base_table(_), BaseTable ),
  generate_analyse_column_questions( BaseTable, Questions ).

proweb_form( analysis_form,
             [ h2 @ `Analysis`,
               p,
               `Number of conditional expressions: `,
               NumberOfConditionalExpressions,
               /p,
               table,
               tr,
               td(colspan='2',align='center'),
               p,
               ?conditional_expressions,
               ?select_all_conditional_expressions,
               `Select all`,
               /p,
               /td,
               /tr,
               tr,
               td(align='center'),
               p @ input(type=submit,name='special_button',value='First Conditional Expression'),
               p @ input(type=submit,name='special_button',value='Conditional Expression Table'),
               /td,
               td(align='center'),
               p @ input(type=submit,name='special_button',value='First Conditional Statement'),
               p @ input(type=submit,name='special_button',value='Conditional Statement Table'),
               /td,
               /tr,
               /table
             ]
           ) :-
  dm_api_conditional_expressions( NumberOfConditionalExpressions ).

proweb_form( conditional_expression_form( CurrentSolution, NumberOfSolutions, ConditionalExpression, Variables ),
             [ h2 @ `Conditional Expression`,
               p,
               `Solution `,
               CurrentSolution,
               ` of `,
               NumberOfSolutions,
               /p,
               p,
               `IF `,
               b @ ConditionalExpression,
               ` THEN `,
               b @ TargetExpression,
               /p,
               table(width='100%'),
               tr,
               td(valign='top'),
               `Variables:`,
               /td,
               td,
               VariablesTable,
               /td,
               td(align='right'),
               embed(src=RelativeSVGFile,width=500,height=300,type='image/svg+xml'),
               /td,
               /tr,
               /table,
               p,
               input(type=submit,value=ButtonText),
               BreakOutButton,
               /p
             ]
           ) :-
  create_random_filename( SVGFileName ),
  cat( ['temp/',SVGFileName,'.svg'], RelativeSVGFile, _ ),
  absolute_file_name( prolog(''), ExecRoot ),
  cat( [ExecRoot,'temp\',SVGFileName,'.svg'], AbsoluteSVGFile,   _ ),
  create_svg_file( AbsoluteSVGFile, Variables ),
  proweb_returned_answer( target_expression, TargetExpression ),
  create_variables_table( Variables, VariablesTable ),
  (  CurrentSolution = NumberOfSolutions
  -> ButtonText = 'Finish',
     BreakOutButton = []
  ;  ButtonText = 'Next Conditional Expression',
     BreakOutButton = input(type=submit,name='special_button',value='Break Out')
  ).

proweb_form( conditional_expressions_form( Solutions ),
             [ h2 @ `Conditional Expressions`,
               p,
               table,
               tr,
               td,
               `Base Count:`,
               /td,
               td,
               BaseCount,
               /td,
               /tr,
               tr,
               td,
               `Target Expression:`,
               /td,
               td,
               TargetExpression,
               /td,
               /tr,
               tr,
               td,
               `Target Count:`,
               /td,
               td,
               TargetCount,
               /td,
               /tr,
               /table,
               /p,
               table(border='1'),
               tr,th,`Cond`,/th,
                  th,`Hit`,/th,
                  th,`Miss`,/th,
                  th,`True`,/th,
                  th,`False`,/th,
                  th,`Other`,/th,
                  th,`True%`,/th,
                  th,`Hit%`,/th,
                  th,`Base%`,/th,
                  th,`Sig%`,/th,
                  th,`Abs Sig%`,/th,
                  th,`Entropy`,/th,
                  th,`Expression`,/th,
               /tr,
               TableRows,
               /table,
               /p,
               p @ input(type=submit,value='Finish')
             ]
           ) :-
  proweb_returned_answer( target_expression, TargetExpression ),
  member( (_,variables(BaseCount,TargetCount,_,_,_,_,_,_,_,_,_,_,_,_)), Solutions, 1 ),
  findall( TableRow,
           ( member( (Cond,variables( _,
                                      _,
                                      ConditionalCount,
                                      HitCount,
                                      MissCount,
                                      TrueCount,
                                      FalseCount,
                                      OtherCount,
                                      TruePercentage,
                                      HitPercentage,
                                      BasePercentage,
                                      SignificancePercentage,
                                      AbsSignificancePercentage,
                                      Entropy
                                    )
                     ), Solutions ),
             fwrite( f, 7, 2, TruePercentage            ) ~> TruePercentage2,
             fwrite( f, 7, 2, HitPercentage             ) ~> HitPercentage2,
             fwrite( f, 7, 2, BasePercentage            ) ~> BasePercentage2,
             fwrite( f, 7, 2, SignificancePercentage    ) ~> SignificancePercentage2,
             fwrite( f, 7, 2, AbsSignificancePercentage ) ~> AbsSignificancePercentage2,
             fwrite( f, 7, 2, Entropy                   ) ~> Entropy2,
             TableRow = [tr,td(align='right'),ConditionalCount,/td,
                            td(align='right'),HitCount,/td,
                            td(align='right'),MissCount,/td,
                            td(align='right'),TrueCount,/td,
                            td(align='right'),FalseCount,/td,
                            td(align='right'),OtherCount,/td,
                            td(align='right'),TruePercentage2,`%`,/td,
                            td(align='right'),HitPercentage2,`%`,/td,
                            td(align='right'),BasePercentage2,`%`,/td,
                            td(align='right'),SignificancePercentage2,`%`,/td,
                            td(align='right'),AbsSignificancePercentage2,`%`,/td,
                            td(align='right'),Entropy2,/td,
                            td,Cond,/td,/tr]
           ),
           TableRows
         ).

proweb_form( conditional_statement_form( CurrentMask, NumberOfMasks, ConditionalStatement, Variables ),
             [ h2 @ `Conditional Statement`,
               p,
               `Mask `,
               CurrentMask,
               ` of `,
               NumberOfMasks,
               /p,
               p,
               `IF `,
               b @ ConditionalStatement,
               ` THEN `,
               b @ TargetExpression,
               /p,
               table(width='100%'),
               tr,
               td(valign='top'),
               `Variables:`,
               /td,
               td,
               VariablesTable,
               /td,
               td(align='right'),
               embed(src=RelativeSVGFile,width=500,height=300,type='image/svg+xml'),
               /td,
               /tr,
               /table,
               p,
               input(type=submit,value=ButtonText),
               BreakOutButton,
               /p
             ]
           ) :-
  create_random_filename( SVGFileName ),
  cat( ['temp/',SVGFileName,'.svg'], RelativeSVGFile, _ ),
  absolute_file_name( prolog(''), ExecRoot ),
  cat( [ExecRoot,'temp\',SVGFileName,'.svg'], AbsoluteSVGFile,   _ ),
  create_svg_file( AbsoluteSVGFile, Variables ),
  proweb_returned_answer( target_expression, TargetExpression ),
  create_variables_table( Variables, VariablesTable ),
  (  CurrentMask = NumberOfMasks
  -> ButtonText = 'Finish',
     BreakOutButton = []
  ;  ButtonText = 'Next Conditional Statement',
     BreakOutButton = input(type=submit,name='special_button',value='Break Out')
  ).

proweb_form( conditional_statements_form( Solutions ),
             [ h2 @ `Conditional Statements`,
               p,
               table,
               tr,
               td,
               `Base Count:`,
               /td,
               td,
               BaseCount,
               /td,
               /tr,
               tr,
               td,
               `Target Expression:`,
               /td,
               td,
               TargetExpression,
               /td,
               /tr,
               tr,
               td,
               `Target Count:`,
               /td,
               td,
               TargetCount,
               /td,
               /tr,
               /table,
               /p,
               p,
               table(border='1'),
               tr,th,`Cond`,/th,
                  th,`Hit`,/th,
                  th,`Miss`,/th,
                  th,`Truet`,/th,
                  th,`False`,/th,
                  th,`Other`,/th,
                  th,`True%`,/th,
                  th,`Hit%`,/th,
                  th,`Base%`,/th,
                  th,`Sig%`,/th,
                  th,`Abs Sig%`,/th,
                  th,`Entropy`,/th,
                  th,`Mask`,/th,
               /tr,
               TableRows,
               /table,
               /p,
               p @ input(type=submit,value='Finish')
             ]
           ) :-
  proweb_returned_answer( target_expression, TargetExpression ),
  member( (_,variables(BaseCount,TargetCount,_,_,_,_,_,_,_,_,_,_,_,_)), Solutions, 1 ),
  findall( TableRow,
           ( member( (Cond,variables( _,
                                      _,
                                      ConditionalCount,
                                      HitCount,
                                      MissCount,
                                      TrueCount,
                                      FalseCount,
                                      OtherCount,
                                      TruePercentage,
                                      HitPercentage,
                                      BasePercentage,
                                      SignificancePercentage,
                                      AbsSignificancePercentage,
                                      Entropy
                                    )
                     ), Solutions ),
             fwrite( f, 7, 2, TruePercentage            ) ~> TruePercentage2,
             fwrite( f, 7, 2, HitPercentage             ) ~> HitPercentage2,
             fwrite( f, 7, 2, BasePercentage            ) ~> BasePercentage2,
             fwrite( f, 7, 2, SignificancePercentage    ) ~> SignificancePercentage2,
             fwrite( f, 7, 2, AbsSignificancePercentage ) ~> AbsSignificancePercentage2,
             fwrite( f, 7, 2, Entropy                   ) ~> Entropy2,
             TableRow = [tr,td(align='right'),ConditionalCount,/td,
                            td(align='right'),HitCount,/td,
                            td(align='right'),MissCount,/td,
                            td(align='right'),TrueCount,/td,
                            td(align='right'),FalseCount,/td,
                            td(align='right'),OtherCount,/td,
                            td(align='right'),TruePercentage2,`%`,/td,
                            td(align='right'),HitPercentage2,`%`,/td,
                            td(align='right'),BasePercentage2,`%`,/td,
                            td(align='right'),SignificancePercentage2,`%`,/td,
                            td(align='right'),AbsSignificancePercentage2,`%`,/td,
                            td(align='right'),Entropy2,/td,
                            td,Cond,/td,/tr]
           ),
           TableRows
         ).

proweb_form( thank_you_form,
             [ h2 @ `Thank You`,
               p,
               `Thank you for running this web-based data mining toolkit example`,
               /p,
               table,
               tr,td,`Application:`,/td,td,Application,/td,/tr,
               tr,td,`Copyright:`,  /td,td,Copyright,  /td,/tr,
               tr,td,`Author:`,     /td,td,Author,     /td,/tr,
               tr,td,`Version:`,    /td,td,Version,    /td,/tr,
               tr,td,`Date:`,       /td,td,Date,       /td,/tr,
               /table,
               p,
               input(type=submit,name='special_button',value='Restart Program'),
               input(type=submit,name='special_button',value='Restart Analysis'),
               /p
             ]
           ) :-
  dm_api_header( Application, Copyright, Author, Version, Date ).

proweb_form( error_form( ErrorMessage ),
             [ h2 @ `Error`,
               p,
               ErrorMessage,
               /p
             ]
           ).

proweb_question( odbc_data_source,
                 [ method    = menubox,
                   type      = string,
                   select    = ODBCDataSources
                 ]
               ) :-
  one( db_get_schema(sources,ODBCDataSources) ).

proweb_question( driver,
                 [ method    = menubox,
                   type      = string,
                   select    = [`ANSI`,`ACCESS`,`SQL SERVER`,`ORACLE`,`DB2`],
                   prefill   = `ACCESS`
                 ]
               ). 

proweb_question( significance_threshold,
                 [ method    = input,
                   type      = integer,
                   prefill   = 1,
                   lwb       = 0,
                   upb       = 100
                 ]
               ). 

proweb_question( base_threshold,
                 [ method    = input,
                   type      = integer,
                   prefill   = 1,
                   lwb       = 0,
                   upb       = 100
                 ]
               ). 

proweb_question( hit_threshold,
                 [ method    = input,
                   type      = integer,
                   prefill   = 1,
                   lwb       = 0,
                   upb       = 100
                 ]
               ). 

proweb_question( true_threshold,
                 [ method    = input,
                   type      = integer,
                   prefill   = 1,
                   lwb       = 0,
                   upb       = 100
                 ]
               ). 

proweb_question( target_expression,
                 [ method    = input,
                   type      = string,
                   prefill   = ``,
                   rows      = 1,
                   cols      = 40
                 ]
               ).

proweb_question( base_table(HDBC),
                 [ method    = menubox,
                   type      = atom,
                   select    = Tables
                 ]
               ) :-
  one( db_get_schema(HDBC,user,Tables) ).

proweb_question( order_by,
                 [ method    = menubox,
                   type      = string,
                   select    = [ `base`,
                                 `target`,
                                 `conditional`,
                                 `hit`,
                                 `miss`,
                                 `true`,
                                 `false`,
                                 `other`,
                                 `true%`,
                                 `hit%`,
                                 `base%`,
                                 `significance%`,
                                 `absolute_significance%`,
                                 `|significance%|`,
                                 `entropy`
                               ],
                   prefill   = `hit%`
                 ]
               ).

proweb_question( asc_desc,
                 [ method    = menubox,
                   type      = string,
                   select    = [`asc`,`desc`],
                   prefill   = `desc`
                 ]
               ). 

proweb_question( analyse_column(_),
                 [ method  = radio,
                   type    = string,
                   select  = [`discrete`,`continuous`,`exclude`],
                   prefill = `exclude`,
                   infix   = [/td,td(align='center')]
                 ]
               ). 

proweb_question( conditional_expressions,
                 [ method    = multibox,
                   type      = string,
                   select    = ConditionalExpressions,
                   rows      = Rows
                 ]
               ) :-
  findall( ConditionalExpression,
           dm_api_conditional_expression(ConditionalExpression,_),
           ConditionalExpressions
         ),
  len( ConditionalExpressions, NumberOfConditionalExpressions ),
  (  NumberOfConditionalExpressions > 23
  -> Rows = 23
  ;  Rows = NumberOfConditionalExpressions
  ).

proweb_question( select_all_conditional_expressions,
                 [ method  = checkbox,
                   prefill = off
                 ]
               ).

my_db_show_schema( Term, List ) :-
  one( db_show_schema(Term) ~> String ),
  string_list( String, List ).

string_list( String, List ) :-
  string_list2( [], ReversedList ) <~ String,
  reverse( ReversedList, List ).

string_list2( Dummy, List ) :-
  find( `~M~J`, 3, Found ) ~> Element,
  (  Found = ``
  -> (  Element = ``
     -> List = Dummy
     ;  List = [Element|Dummy]
     )
  ;  (  Element = ``
     -> string_list2( Dummy,           List )
     ;  string_list2( [Element|Dummy], List )
     )
  ).

generate_analyse_column_questions( BaseTable, Questions ) :-
  my_db_show_schema( columns(BaseTable), ColumnNames ),
  len( ColumnNames, NumberOfColumns ),
  generate_analyse_column_question_rows( NumberOfColumns, ColumnNames, [], Rows ),
  Questions = Rows.

generate_analyse_column_question_rows( 0, _, Rows, Rows ) :-
  !.

generate_analyse_column_question_rows( ColumnNumber, ColumnNames, Dummy, Rows ) :-
  member( ColumnName, ColumnNames, ColumnNumber ),
  Row = [tr,td,ColumnName,/td,td(align='center'),?analyse_column(ColumnNumber),/td,/tr],
  ColumnNumber2 is ColumnNumber - 1,
  !,
  generate_analyse_column_question_rows( ColumnNumber2, ColumnNames, [Row|Dummy], Rows ). 

sort_conditional_into_orderby_ascdesc_order( ConditionalStatementSolutions, OrderedSolutions ) :-
  proweb_returned_answer( order_by, OrderBy ),
  ( member( OrderBy, [`base`,`target`,`conditional`,`hit`,`miss`,`true`,`false`,`other`,`true%`,`hit%`,`base%`,`significance%`,`absolute_significance%`,`entropy`], Position )
  ; OrderBy = `|significance%|`,
    Position = 12
  ),
  Position2 is Position + 2,
  sort( ConditionalStatementSolutions, SortedConditionalStatementSolutions, [Position2] ),
  proweb_returned_answer( asc_desc, AscDesc ),
  (  AscDesc = `asc`
  -> OrderedSolutions = SortedConditionalStatementSolutions
  ;  reverse( SortedConditionalStatementSolutions, ReversedSortedConditionalStatementSolutions ),
     OrderedSolutions = ReversedSortedConditionalStatementSolutions
  ).

create_variables_table( Variables, VariablesTable ) :-
  Variables = variables( BaseCount,
                         TargetCount,
                         ConditionalCount,
                         HitCount,
                         MissCount,
                         TrueCount,
                         FalseCount,
                         OtherCount,
                         TruePercentage,
                         HitPercentage,
                         BasePercentage,
                         SignificancePercentage,
                         AbsSignificancePercentage,
                         Entropy ),
  fwrite( f, 7, 2, TruePercentage            ) ~> TruePercentage2,
  fwrite( f, 7, 2, HitPercentage             ) ~> HitPercentage2,
  fwrite( f, 7, 2, BasePercentage            ) ~> BasePercentage2,
  fwrite( f, 7, 2, SignificancePercentage    ) ~> SignificancePercentage2,
  fwrite( f, 7, 2, AbsSignificancePercentage ) ~> AbsSignificancePercentage2,
  fwrite( f, 7, 2, Entropy                   ) ~> Entropy2,
  create_variables_table_row( `base`,                   `Base count:`,            BaseCount,                  BaseCountRow                 ),
  create_variables_table_row( `target`,                 `Target count:`,          TargetCount,                TargetCountRow               ),
  create_variables_table_row( `conditional`,            `Conditional count:`,     ConditionalCount,           ConditionalCountRow          ),
  create_variables_table_row( `hit`,                    `Hit count:`,             HitCount,                   HitCountRow                  ),
  create_variables_table_row( `miss`,                   `Miss count`,             MissCount,                  MissCountRow                 ),
  create_variables_table_row( `true`,                   `True count:`,            TrueCount,                  TrueCountRow                 ),
  create_variables_table_row( `false`,                  `False count:`,           FalseCount,                 FalseCountRow                ),
  create_variables_table_row( `other`,                  `Other count:`,           OtherCount,                 OtherCountRow                ),
  create_variables_table_row( `true%`,                  `True%:`,                 TruePercentage2,            TruePercentageRow            ),
  create_variables_table_row( `hit%`,                   `Hit%:`,                  HitPercentage2,             HitPercentageRow             ),
  create_variables_table_row( `base%`,                  `Base%:`,                 BasePercentage2,            BasePercentageRow            ),
  create_variables_table_row( `significance%`,          `Significance%:`,         SignificancePercentage2,    SignificancePercentageRow    ),
  create_variables_table_row( `absolute_significance%`, `Absolute significance:`, AbsSignificancePercentage2, AbsSignificancePercentageRow ),
  create_variables_table_row( `entropy`,                `Entropy:`,               Entropy2,                   EntropyRow                   ),
  VariablesTable = [ table,
                     BaseCountRow,
                     TargetCountRow,
                     ConditionalCountRow,
                     HitCountRow,
                     MissCountRow,
                     TrueCountRow,
                     FalseCountRow,
                     OtherCountRow,
                     TruePercentageRow,
                     HitPercentageRow,
                     BasePercentageRow,
                     SignificancePercentageRow,
                     AbsSignificancePercentageRow,
                     EntropyRow,
                     /table
                   ].

create_variables_table_row( Variable, Text, Value, Row ) :-
  Variables = [`base`,`target`,`conditional`,`hit`,`miss`,`true`,`false`,`other`,`entropy`],
  member(Variable,Variables),
  proweb_returned_answer( order_by, OrderBy ),
  (  Variable = OrderBy,
     member(OrderBy,Variables)
  -> Row = [tr,td,b @ i @ Text,/td,td(align='right'),b @ i @ Value,/td,/tr]
  ;  Row = [tr,td,        Text,/td,td(align='right'),        Value,/td,/tr]
  ).

create_variables_table_row( Variable, Text, Value, Row ) :-
  Variables = [`true%`,`hit%`,`base%`,`significance%`,`absolute_significance%`,`|significance%|`],
  member(Variable,Variables),
  proweb_returned_answer( order_by, OrderBy ),
  (  Variable = OrderBy,
     member(OrderBy,Variables)
  -> Row = [tr,td,b @ i @ Text,/td,td(align='right'),b @ i @ Value,`%`,/td,/tr]
  ;  Row = [tr,td,        Text,/td,td(align='right'),        Value,`%`,/td,/tr]
  ).

/***********************************
 * create_random_filename(-)       *
 * ?- create_random_filename( X ). *
 * X = shxagvez                    *
 ***********************************/
create_random_filename( FileName ) :-
  A is ip( rand(26) ) + 97,
  B is ip( rand(26) ) + 97,
  C is ip( rand(26) ) + 97,
  D is ip( rand(26) ) + 97,
  E is ip( rand(26) ) + 97,
  F is ip( rand(26) ) + 97,
  G is ip( rand(26) ) + 97,
  H is ip( rand(26) ) + 97,
  atom_chars( FileName, [A,B,C,D,E,F,G,H] ). 

create_svg_file( AbsoluteSVGFile, Variables ) :-
  fcreate( svg_file, AbsoluteSVGFile, -2, 0, -1 ),
  output( Old ),
  output( svg_file ),
  write( `<?xml version="1.0" encoding="UTF-8"?>` ),
  nl,
  write( `<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20001102//EN" "http://www.w3.org/TR/2000/CR-SVG-20001102/DTD/svg-20001102.dtd">` ),
  nl,
  write( `<svg width="` ),
  Width = 500,
  write(Width),
  write( `" height="` ),
  Height is 300,
  write(Height),
  write( `">` ),
  nl,
  write( `<!-- Constructed by ProWeb -->` ),
  nl,
  write( `<desc>Datamite</desc>` ),
  nl,
  write_svg_rect(0,0,500,300,white),
  draw_svg_circle( 150, 150, 149, blue ),
  draw_svg_circle( 350, 150, 149, yellow ),
  Variables = variables( BaseCount,
                         TargetCount,
                         ConditionalCount,
                         HitCount,
                         MissCount,
                         _,
                         FalseCount,
                         OtherCount,
                         TruePercentage,
                         HitPercentage,
                         BasePercentage,
                         SignificancePercentage,
                         _,
                         Entropy ),
  fwrite( f, 7, 2, TruePercentage            ) ~> TruePercentage2,
  fwrite( f, 7, 2, HitPercentage             ) ~> HitPercentage2,
  fwrite( f, 7, 2, BasePercentage            ) ~> BasePercentage2,
  fwrite( f, 7, 2, SignificancePercentage    ) ~> SignificancePercentage2,
  fwrite( f, 7, 2, Entropy                   ) ~> Entropy2,
  ( write(`BASE: `),          write(BaseCount)                           ) ~> BaseCountText,
  ( write(`TARGET: `),        write(TargetCount)                         ) ~> TargetCountText,
  ( write(`CONDITIONAL: `),   write(ConditionalCount)                    ) ~> ConditionalCountText,
  ( write(`MISS: `),          write(MissCount)                           ) ~> MissCountText,
  ( write(`HIT: `),           write(HitCount)                            ) ~> HitCountText,
  ( write(`FALSE: `),         write(FalseCount)                          ) ~> FalseCountText,
  ( write(`OTHER: `),         write(OtherCount)                          ) ~> OtherCountText,
  ( write(`TRUE%: `),         write(TruePercentage2), write(`%`)         ) ~> TruePercentageText,
  ( write(`HIT%: `),          write(HitPercentage2),  write(`%`)         ) ~> HitPercentageText,
  ( write(`BASE%: `),         write(BasePercentage2), write(`%`)         ) ~> BasePercentageText,
  ( write(`SIGNIFICANCE%: `), write(SignificancePercentage2), write(`%`) ) ~> SignificancePercentageText,
  ( write(`ENTROPY: `),       write(Entropy2)                            ) ~> EntropyText,
  write_svg_text(   0,  10, arial, serif, 14, bold, 1, black, BaseCountText              ),
  write_svg_text( 110,  20, arial, serif, 14, bold, 1, black, TargetCountText            ),
  write_svg_text( 300,  20, arial, serif, 14, bold, 1, black, ConditionalCountText       ),
  write_svg_text(  75, 150, arial, serif, 14, bold, 1, black, MissCountText              ),
  write_svg_text( 235, 150, arial, serif, 14, bold, 1, black, HitCountText               ),
  write_svg_text( 360, 150, arial, serif, 14, bold, 1, black, FalseCountText             ),
  write_svg_text(   0, 295, arial, serif, 14, bold, 1, black, OtherCountText             ),
  write_svg_text( 150, 220, arial, serif, 14, bold, 1, black, HitPercentageText          ),
  write_svg_text( 270, 220, arial, serif, 14, bold, 1, black, TruePercentageText         ),
  write_svg_text( 270,  85, arial, serif, 14, bold, 1, black, BasePercentageText         ),
  write_svg_text( 170, 280, arial, serif, 14, bold, 1, black, SignificancePercentageText ),
  write_svg_text( 200, 295, arial, serif, 14, bold, 1, black, EntropyText                ),
  write( `</svg>` ),
  nl,
  output( Old ),
  fclose( svg_file ).

write_svg_rect( X, Y, Width, Height, Colour ) :-
  write(`<rect x="`),
  write(X),
  write(`" y="`),
  write(Y),
  write(`" width="`),
  write(Width),
  write(`" height="`),
  write(Height),
  write(`" rx="4" ry="4" style="fill:`),
  write(Colour),
  write(`;"/>`),
  nl.

draw_svg_circle( X, Y, Radius, Colour ) :-
  write( `<circle cx="` ),
  write( X ),
  write( `" cy="` ),
  write( Y ),
  write( `" r="` ),
  write( Radius ),
  write( `" style="fill:` ),
  write( Colour ),
  write( `; stroke:#FF0099; fill-opacity:0.1;" />` ),
  nl.

write_svg_text( X, Y, Specific, Generic, Size, Style, Weight, FillColour, Text ) :-
  write( `<text x="` ),
  X2 is X + 3,
  write( X2 ),
  write( `" y="` ),
  Y2 is Y + 3,
  write( Y2 ),
  write( `" style="font-family:` ),
  write( Specific ),
  write(`,`),
  write( Generic ),
  write(`; font-stretch:condensed; font-style:` ),
  write( Style ),
  write( `; font-weight:` ),
  write( Weight ),
  write( `; font-size:` ),
  write( Size ),
  write( `; fill:` ),
  write( FillColour ),
  write( `; stroke:none">` ),
  write_svg_text2( Text ),
  write( `</text>` ),
  nl.

write_svg_text2( Text ) :-
  atom( Text ),
  atom_chars( Text, Chars ),
  forall( member(Char,Chars),
          (  Char > 127
          -> number_atom( Char, AtomChar ),
             write( `&#` ),
             write( AtomChar ),
             write( `;` )
          ;  atom_chars( Letter, [Char] ),
             write( Letter )
          )
        ).

write_svg_text2( Text ) :-
  write( Text ). 

proweb_shutdown :-
  absolute_file_name( prolog(''), Prolog ),
  /*************************************
   * Delete All The .SVG Files In Temp *
   *************************************/
  cat( [Prolog,'temp\*.svg'], Path, _ ),
  dir( Path, 0, List ),
  forall( member( File, List ),
          del( File )
        ),
  disconnect_and_shutdown.

disconnect_and_shutdown :-
  (  proweb_call( connected(HDBC) )
  -> proweb_retract( connected(HDBC) ),
     db_disconnect( HDBC ),
     dm_api_disconnect,
     dm_api_shutdown
  ;  true
  ). 
