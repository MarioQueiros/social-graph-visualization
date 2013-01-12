/*
   Old Date and Time Predicates - Brian D Steel - 25 Mar 98 / 24 Jun 02
   ====================================================================

   Version 3.710 of 386-PROLOG introduced a new set of time/n predicates to
   provide more security during date/time processing (especially with respect
   to midnight rollover, easier comparisons and arithmetic between dates/times,
   increased precision and to avoid 32-bit elapsed time rollover.

   In providing these features, the previous date/3, date/4, ticks/1 and
   time/4 predicates were replaced by a new family of time/n predicates.

   The present library uses a special predicate, hide/2, to mask the new
   definitions so that the previous ones can be restored. In order for this
   trick to work, this library should be loaded at run-time, BEFORE loading
   any applications which use the previous set of predicates.

   The patching technique used in this library will not work in stand-alone
   applications, so it is strongly recommended that applications be modified
   to use the new time/n predicates as soon as possible.
*/

% hide the atom "time", and then make new definitions

:- hide( time, 1 ), stratm( `time`, TIME ),

% define the old time/4 predicate

   assert( (  TIME( Hour, Minute, Second, Hundreth ) :-
                 time( _, _, _, Hour, Minute, Second, Millisecond ),
                 Hundreth is Millisecond // 10
           )
         ),

% define the old date/3 predicate

   assert( (  date( Day, Month, Year ) :-
                 time( Year, Month, Day, _, _, _, _ )
           )
         ),

% define the old date/4 predicate

   assert( (  date( Day, Month, Year, Date ) :-
                 (  type( Date, 0 )
                 -> time( Zero, Year, Month, Day ),
                    Date is Zero + 1
                 ;  Zero is Date - 1,
                    time( Zero, Year, Month, Day )
                 )
           )
         ),

% define the old ticks/1 predicate

   assert( (  ticks( Ticks ) :-
                 time( 0, Elapsed ),
                 Elapsed = (Days,Time),
                 Ticks is Days * 86400000 + Time
           )
         ),

% re-define the new time/2 predicate

   assert( (  TIME( Flag, Time ) :-
                 time( Flag, Time )
           )
         ),

% re-define the new time/4 predicate

   assert( (  TIME( Date, Year, Month, Day ) :-
                 time( Date, Year, Month, Day )
           )
         ),

% re-define the new time/5 predicate

   assert( (  TIME( Time, Hour, Minute, Second, Millisecond ) :-
                 time( Time, Hour, Minute, Second, Millisecond )
           )
         ),

% re-define the new time/7 predicate

   assert( (  TIME( Year, Month, Day, Hour, Minute, Second, Millisecond ) :-
                 time( Year, Month, Day, Hour, Minute, Second, Millisecond )
           )
         ).
