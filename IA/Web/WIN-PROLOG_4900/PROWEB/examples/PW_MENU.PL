/* ProWeb menu example
   Written by Rebecca Shalfield  30th April 2003
   --------------------------------------------- */

main_goal :-
  proweb_send_form( menu_bar_form ),
  ( proweb_call( menu_bar_option(MenuBarSelection) )
  ; proweb_returned_input( menu_bar_option, MenuBarSelection ),
    proweb_assert( menu_bar_option(MenuBarSelection) )
  ),
  proweb_send_form( menu_form(MenuBarSelection) ),
  ( proweb_call( menu_option(MenuSelection) )
  ; proweb_returned_input( menu_option, MenuSelection ),
    proweb_assert( menu_option(MenuSelection) )
  ),
  (  menu_option( menubar,          MenuBarSelection ),
     menu_option( MenuBarSelection, MenuSelection    ),
     menu_option( MenuSelection,    _                )
  -> proweb_send_form( submenu_form(MenuSelection) ),
     proweb_returned_input( sub_menu_option, SubMenuSelection ),
     process_menu_selection( MenuBarSelection, MenuSelection, SubMenuSelection )
  ;  process_menu_selection( MenuBarSelection, MenuSelection, _                )
  ),
  reset_menu_selection,
  !,
  main_goal.

reset_menu_selection :-
  proweb_forget_forms_sent,
  proweb_retract( menu_bar_option(_) ),
  proweb_retract( menu_option(_)     ).

proweb_page( _, [] ).

proweb_form( menu_bar_form,
             [ h1 @ `Menu Bar`,
               MenuOptions
             ]
           ) :-
  assemble_menu_bar_options( MenuOptions ).

proweb_form( menu_form( MenuBarSelection ),
             [ h1,
               MenuBarSelection,
               ` Menu`,
               /h1,
               MenuOptions
             ]
           ) :-
  assemble_menu_options( MenuBarSelection, MenuOptions ). 

proweb_form( submenu_form( MenuSelection ),
             [ h1,
               MenuSelection,
               ` Menu`,
               /h1,
               MenuOptions
             ]
           ) :-
  assemble_sub_menu_options( MenuSelection, MenuOptions ). 

assemble_menu_bar_options( MenuOptions ) :-
  findall( [input(type=submit,name=menu_bar_option,value=Value)],
           menu_option( menubar, Value ),
           MenuOptions
         ). 

assemble_menu_options( MenuBarSelection, MenuOptions ) :-
  findall( [input(type=submit,name=menu_option,value=Value),br],
           menu_option( MenuBarSelection, Value ),
           MenuOptions
         ). 

assemble_sub_menu_options( MenuSelection, MenuOptions ) :-
  findall( [input(type=submit,name=sub_menu_option,value=Value),br],
           menu_option( MenuSelection, Value ),
           MenuOptions
         ). 

menu_option( menubar,  'File'    ).
menu_option( 'File',   'New'     ).
menu_option( 'File',   'Open'    ).
menu_option( 'File',   'Save'    ).
menu_option( 'File',   'Save As' ).
menu_option( 'File',   'Export'  ).
menu_option( 'File',   'Exit'    ).
menu_option( menubar,  'Edit'    ).
menu_option( 'Edit',   'Copy'    ).
menu_option( 'Edit',   'Paste'   ).
menu_option( menubar,  'Search'  ).
menu_option( 'Search', 'Find'    ).
menu_option( 'Search', 'Change'  ).
menu_option( menubar,  'Sound'   ).
menu_option( 'Sound',  'Beep'    ).
menu_option( 'Export', 'CSV'     ).
menu_option( 'Export', 'RTF'     ). 

process_menu_selection( 'Sound', 'Beep', _ ) :-
  !,
  beep( 440, 250 ).

process_menu_selection( 'File', 'Exit', _ ) :-
  !,
  fail.

process_menu_selection( MenuBarSelection, MenuSelection, SubMenuSelection ) :-
  proweb_send_form( menu_selection_confirmation_form(MenuBarSelection,MenuSelection,SubMenuSelection) ). 

proweb_form( menu_selection_confirmation_form( MenuBarSelection, MenuSelection, SubMenuSelection ),
             [ h1 @ `You clicked on the following menu option:`,
               h2,
               MenuBarSelection,
               `\`,
               MenuSelection,
               SubMenuSelectionBit,
               /h2,
               input(type='submit')
             ]
           ) :-
  (  var(SubMenuSelection)
  -> SubMenuSelectionBit = []
  ;  SubMenuSelectionBit = [`\`,SubMenuSelection]
  ). 
