/*
   Lunar Phases - Copyright (c) Brian D Steel - 25 Apr 94 / 10 Feb 99
   ==================================================================

   This program computes the next quarter phase of the moon occurring on
   or after the given date, based on two assumptions: (i) a new moon
   occurred on 01 Jan 1900, and (ii) the lunar month is 29.53059 days.

   The program uses the time/2 predicate to obtain a starting day number, and
   the time/4 predicate to compute year/month/day dates from these numbers.

   For example, to see the phase and date of the next lunar quarter, type:

      ?- lunar(P,Y,M,D).
      P = 'New Moon'
      Y = 1999
      M = 2
      D = 15

   These results assume the program was run on 10-FEB-99. If you press the
   <space> bar to backtrack, the next phase will be shown:

      P = 'First Quarter'
      Y = 1999
      M = 2
      D = 22

   You can find any number of successive phases, or simply press <return>
   to finish running the program.
*/

% compute the quarter phase of the moon on or after the current date

lunar( Phase, Year, Month, Day ) :-
   time( 1, Time ),
   Time = (Date,_),
   time( From, 1900, 1, 1 ),
   lunar( From, Date, Phase, Year, Month, Day ).

% compute the quarter phase of the moon on or after the given date

lunar( From, Date, Phase, Year, Month, Day ) :-
   Lunar is 29.53059,
   Quart is Lunar / 4,
   Days is Date - From,
   Stage is Days mod Lunar,
   Moon is ip(Date + Quart - Stage mod Quart),
   Entry is ip(Stage * 4 / Lunar) + 1,
   (  time( Moon, Year, Month, Day ),
      mem( [  'First Quarter',
              'Full Moon',
              'Third Quarter',
              'New Moon'
           ], [Entry], Phase )
   ;  Next is Moon + 1,
      lunar( From, Next, Phase, Year, Month, Day )
   ).
