/* ProWeb Hits File Example - Written by Rebecca Shalfield
   -------------------------------------------------------

   This example reads the first 65535 bytes of ProWeb's hits file,
   HITS.LOG, and places them into the LPA string, HitDetails. This
   partial log is then 'posted' to Prolog's internal database and
   picked-up for inclusion in the form, hits_form.

   You need to have the /Y1 switch set on the Win-Prolog command line
   in the PROWEB.INI file:

   [PRO386W]
   COMMAND=/Y1
*/

:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).
:-      multifile( proweb_question     / 2 ).

main_goal :-
   absolute_file_name( prolog(''), ExecRoot ),
   cat( [ExecRoot,'temp\hits.log'], HitsLogPath, _ ),
   open( HitsLogPath, read, automatic ),
   see( HitsLogPath ),
   copy(65535,_) ~> HitDetails,
   seen,   
   proweb_post_reply( hit_details, HitDetails ),
   proweb_send_form( hits_form ).

proweb_page( _,
             []
           ).

proweb_form( hits_form,
             [ h2,
               `ProWeb Hits File`,
               /h2,
               pre,
               b @ `UCO                      Page     Date           Time                 I.P. Addr~M~J`,
               ??hit_details,
               /pre
             ]
           ).
