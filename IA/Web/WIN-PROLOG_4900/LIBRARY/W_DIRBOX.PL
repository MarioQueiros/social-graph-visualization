/*
   The dirbox/4 Predicate - Brian D Steel - 05 Sep 95 / 18 Jun 02
   --------------------------------------------------------------

   The dirbox/4 predicate was written in assembler code and built in to
   early Windows 3.1 versions of WIN-PROLOG, but was re-implemented as a
   Prolog program in September 1995 to support long filenames in Windows 95.

   Two years on, it has been removed from WIN-PROLOG so that the environment
   can use the common dialog boxes for opening and saving files in its place,
   but for reasons of backwards compatibility of existing code, the 1995
   Prolog implemention is presented here. New applications should use the
   common dialog box predicates, opnbox/5 and savbox/5, instead of dirbox/4.
*/

% obtain a file name from the user from the given title, prompt and pattern

dirbox( Title, Prompt, Pattern, File ) :-
   (  len( Prompt, 0 )
   -> write( Title ) ~> StringTitle
   ;  write( Title  - [Prompt] ) ~> StringTitle
   ),
   stratm( StringPattern, Pattern ),
   wdcreate( dirbox,               StringTitle,   100, 100, 350, 240, [ ws_popup, ws_caption, ws_sysmenu, ws_ex_dlgmodalframe ] ),
   wccreate( (dirbox,11), static,  `Path:`,        10,  12,  25,  14, [                           ws_child, ws_visible                                              ] ),
   wccreate( (dirbox,12), static,  ``,             40,  12, 195,  14, [                           ws_child, ws_visible                                              ] ),
   wccreate( (dirbox,13), static,  `F&ile:`,       10,  42,  25,  14, [                           ws_child, ws_visible                                              ] ),
   wccreate( (dirbox,51), edit,    StringPattern,  40,  39, 195,  20, [ es_left, es_autohscroll,  ws_child, ws_visible, ws_border,             ws_tabstop           ] ),
   wccreate( (dirbox,14), static,  `&Files:`,      10,  72,  60,  14, [                           ws_child, ws_visible                                              ] ),
   wccreate( (dirbox,21), listbox, ``,             10,  99, 175, 112, [ lbs_sort, lbs_notify,     ws_child, ws_visible, ws_border, ws_vscroll, ws_tabstop           ] ),
   wccreate( (dirbox,15), static,  `&Paths:`,     200,  72,  60,  14, [                           ws_child, ws_visible                                              ] ),
   wccreate( (dirbox,22), listbox, ``,            200,  99, 130, 112, [ lbs_sort, lbs_notify,     ws_child, ws_visible, ws_border, ws_vscroll, ws_tabstop           ] ),
   wccreate( (dirbox,01), button,  `OK`,          250,   8,  80,  22, [ bs_defpushbutton,         ws_child, ws_visible,                        ws_tabstop, ws_group ] ),
   wccreate( (dirbox,02), button,  `Cancel`,      250,  38,  80,  22, [ bs_pushbutton,            ws_child, ws_visible,                        ws_tabstop           ] ),
   dirbox_init,
   window_handler( dirbox, dirbox_handler ),
   call_dialog( dirbox, OK ),
   wtext( (dirbox,12), Path ),
   wtext( (dirbox,51), Name ),
   window_handler( dirbox, window_handler ),
   wclose( dirbox ),
   !,
   OK = ok,
   (  strchr( Path, Bytes ),
      Bytes = [_,0':,0'\]
   -> cat( [Path,Name], StringFile, _ )
   ;  cat( [Path,`\`,Name], StringFile, _ )
   ),
   stratm( StringFile, MixFile ),
   lwrupr( File, MixFile ).

% initialise the dirbox dialog with the current drive, path and filename

dirbox_init :-
   wtext( (dirbox,51), StringPattern ),
   stratm( StringPattern, Pattern ),
   fname( Pattern, Path, Root, Sufx ),
   (  Root = ''
   -> Name = '*',
      (  Sufx = ''
      -> Extn = '.*'
      ;  Extn = Sufx
      )
   ;  Name = Root,
      Extn = Sufx
   ),
   cat( [Name,Extn], File, _ ),
   stratm( FileString, File ),
   wtext( (dirbox,51), FileString ),
   (  Path = ''
   -> true
   ;  catch( 0, chdir(Path) )
   ),
   !,
   cat( [*,Extn], Search, _ ),
   dir( Search, 16'00100000, Files ),
   repeat,
   \+ wlbxdel( (dirbox,21), 0 ),
   !,
   forall( member( Atom, Files ),
           (  stratm( String, Atom ),
              wlbxadd( (dirbox,21), -1, String )
           ) ),
   dir( *.*, 16'00000010, Dirs ),
   repeat,
   \+ wlbxdel( (dirbox,22), 0 ),
   !,
   forall( (  member( Atom, Dirs ),
              Atom \= '.'
           ),
           (  write( [Atom] ) ~> String,
              wlbxadd( (dirbox,22), -1, String )
           ) ),
   forall( (  integer_bound( 0, Number, 25 ),
              Letter is Number + 0'A,
              strchr( Drive, [Letter,0':,0'\] ),
              winapi( (kernel32,'GetDriveTypeA'), [Drive], 0, Type ),
              Type > 1
           ),
           (  strchr( String, [0'[,Letter,0':,0']] ),
              integer_bound( 0, Position, 32767 ),
              \+ catch( 0, wlbxsel((dirbox,22),Position,_) ),
              wlbxadd( (dirbox,22), Position, String )
           ) ),
   chdir( CurrentPath ),
   stratm( PathString, CurrentPath ),
   wtext( (dirbox,12), PathString ).

% handle messages to the dirbox dialog

dirbox_handler( (dirbox,01), msg_button, _, ok ) :-
   dirbox_init,
   wfocus( Window ),
   Window \= (dirbox,22),
   wtext( (dirbox,51), FileString ),
   find( `*`, 0, Hit1 ) <~ FileString,
   find( `?`, 0, Hit2 ) <~ FileString,
   (Hit1,Hit2) = (``,``),
   !.

dirbox_handler( (dirbox,01), msg_button, _, _ ) :-
   dirbox_init,
   !.

dirbox_handler( (dirbox,21), msg_select, _, _ ) :-
   !,
   dirbox_file.

dirbox_handler( (dirbox,21), msg_double, _, ok ) :-
   !,
   dirbox_file.

dirbox_handler( (dirbox,22), msg_select, _, _ ) :-
   !,
   dirbox_directory.

dirbox_handler( (dirbox,22), msg_double, _, _ ) :-
   !,
   dirbox_directory,
   dirbox_init.

dirbox_handler( Window, Message, Data, Button ) :-
   window_handler( Window, Message, Data, Button ).

% process the selection of a file entry

dirbox_file :-
   integer_bound( 0, Index, 32767 ),
   (  catch( 0, wlbxsel((dirbox,21),Index,Select) )
   -> true
   ;  !,
      fail
   ),
   Select = 1,
   !,
   wlbxget( (dirbox,21), Index, String ),
   wtext( (dirbox,51), String ).

% process the selection of a directory entry

dirbox_directory :-
   integer_bound( 0, Index, 32767 ),
   (  catch( 0, wlbxsel((dirbox,22),Index,Select) )
   -> true
   ;  !,
      fail
   ),
   Select = 1,
   !,
   wlbxget( (dirbox,22), Index, Selection ),
   len( Selection, Length ),
   Split is Length - 2,
   cat( List, Selection, [1,Split] ),
   List = [_,String,_],
   wtext( (dirbox,51), StringPattern ),
   stratm( StringPattern, Pattern ),
   fname( Pattern, Path, Name, Extn ),
   stratm( StringName, Name ),
   stratm( StringExtn, Extn ),
   (  strchr( String, Bytes ),
      Bytes = [_,0':]
   -> cat( [String,StringName,StringExtn], StringNew, _ )
   ;  cat( [String,`\`,StringName,StringExtn], StringNew, _ )
   ),
   wtext( (dirbox,51), StringNew ).
