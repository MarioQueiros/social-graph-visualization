/* ProWeb Email Hyperlink Example
   ------------------------------

   This example generates a page containing a 'mailto' hyperlink.
*/

:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).
:-      multifile( proweb_question     / 2 ).

main_goal :-
  proweb_send_form( href_form ).

proweb_page( href_form, include('mail.htm') ).

proweb_form( href_form,
             [ a(href='mailto:support@lpa.co.uk'),
               `Click here to send mail to LPA Support`,
               /a
             ]
           ).
