/* ProWeb-Based Calendar Example
   Written by Rebecca Shalfield  2nd May 2003
   ------------------------------------------

   It utilises the CALENDAR.PL file supplied with Win-Prolog.
*/

:- ensure_loaded( examples('calendar.pl') ).

main_goal :-
  proweb_resend_form( calendar_form ).

proweb_page( _, [] ).

proweb_form( calendar_form,
             [ div(align='center'),
               h1 @ `ProWeb-Based Calendar Example`,
               table,
               tr,td(align='center'),`Start Date: `,?start_date,/td,
                  td(align='center'),`End Date:`,   ?end_date,  /td,
               /tr,
               tr,td(align='left'),pre,StartCalendar,/pre,/td,
                  td(align='left'),pre,EndCalendar,  /pre,/td,
               /tr,
               /table,
               p,
               `Number of intervening days: `,
               NumberOfInterveningDays,
               /p,
               p,
               `Number of intervening weeks: `,
               NumberOfInterveningWeeks,
               /p,
               p @ input(type=submit,value='Refresh'),
               /div
             ]
           ) :-
  time( 1, TodaysDateTime ),
  TodaysDateTime = (DayNumber,_),
  time( DayNumber, Year, Month, _ ),
  (  proweb_returned_answer( start_date, date(SYear,SMonth,SDay) )
  -> calendar( SYear, SMonth ) ~> StartCalendar,
     time( StartDayNumber, SYear, SMonth, SDay )
  ;  calendar(  Year,  Month ) ~> StartCalendar,
     StartDayNumber = DayNumber
  ),
  (  proweb_returned_answer( end_date, date(EYear,EMonth,EDay) )
  -> calendar( EYear, EMonth ) ~> EndCalendar,
     time( EndDayNumber, EYear, EMonth, EDay )
  ;  calendar(  Year,  Month ) ~> EndCalendar,
     EndDayNumber = DayNumber
  ),
  NumberOfInterveningDays  is   EndDayNumber - StartDayNumber,
  NumberOfInterveningWeeks is ( EndDayNumber - StartDayNumber ) / 7.

proweb_question( start_date,
                 [ method  = date,
                   format  = '[D][MM][yyyy]',
                   prefill = Prefill
                 ]
               ) :-
  (  proweb_returned_answer(start_date,Prefill)
  -> true
  ;  time( 1, TodaysDateTime ),
     TodaysDateTime = (DayNumber,_),
     time( DayNumber, Year, Month, Day ),
     Prefill = date(Year,Month,Day)
  ).

proweb_question( end_date,
                 [ method  = date,
                   format  = '[D][MM][yyyy]',
                   prefill = Prefill
                 ]
               ) :-
  (  proweb_returned_answer(end_date,Prefill)
  -> true
  ;  time( 1, TodaysDateTime ),
     TodaysDateTime = (DayNumber,_),
     time( DayNumber, Year, Month, Day ),
     Prefill = date(Year,Month,Day)
  ). 
