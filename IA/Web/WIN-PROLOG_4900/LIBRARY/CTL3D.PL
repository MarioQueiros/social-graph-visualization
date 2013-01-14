/*
   Ctl3d Functions for WIN-PROLOG - Brian D Steel - 09 Jun 95 / 21 Jun 02
   ======================================================================

   The predicate, ctl3d/1, was built into WIN-PROLOG between 1995 and 2001,
   finally being removed for release 4.200, which handles background colour
   in dialogs automatically. This library file contains the code used in
   ctl3d/1, in case it is required for compatibility reasons.
*/

:- dynamic( known_ctl3d/1 ).

% return the current status of ctl3d.dll

ctl3d( State ) :-
   type( State, 0 ),
   !,
   (  known_ctl3d( _ )
   -> State = 1
   ;  State = 0
   ).

% turn ctl3d.dll on or off

ctl3d( State ) :-
   type( State, 1 ),
   !,
   (  State = 0
   -> (  known_ctl3d( Ctl3d )
      -> (  wdict( 0, Dict ),
            Dict = []
         -> wndhdl( -1, Instance ),
            winapi( (ctl3d32,'Ctl3dUnregister'), [Instance], 0, _ ),
            winapi( (kernel32,'FreeLibrary'), [Ctl3d], 0, _ ),
            dynamic( known_ctl3d/1 )
         ;  throw( 10, ctl3d(State) )
         )
      ;  true
      )
   ;  State = 1
   -> (  known_ctl3d( _ )
      -> true
      ;  (  wdict( 0, Dict ),
            Dict = []
         -> winapi( (kernel32,'LoadLibraryA'), [`ctl3d32.dll`], 0, Ctl3d ),
            wndhdl( -1, Instance ),
            winapi( (ctl3d32,'Ctl3dRegister'), [Instance], 0, _ ),
            winapi( (ctl3d32,'Ctl3dAutoSubclass'), [Instance], 0, _ ),
            addcls( [known_ctl3d(Ctl3d)], 0 )
         ;  throw( 10, ctl3d(State) )
         )
      )
   ;  throw( 24, ctl3d(State) )
   ).

% set ctl3d mode for all controls in the given dialog window

ctl3d( Window ) :-
   type( Window, 3 ),
   !,
   (  catch( 0, wndhdl(Window,Handle) )
   -> (  known_ctl3d( _ )
      -> winapi( (ctl3d32,'Ctl3dSubclassDlgEx'), [Handle,16'0000ffff], 0, _ )
      ;  true
      )
   ;  throw( 10, ctl3d(Window) )
   ).

% generate an error for any other types

ctl3d( Stupid ) :-
   throw( 23, ctl3d(Stupid) ).
