/* ProWeb Form Input Sample Example - Written by Rebecca Shalfield
   ---------------------------------------------------------------

   This example creates a page showing all the HTML Forms form input
   fields possible with ProWeb. It is provided for reference only,
   not as a working example.
*/

:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).
:-      multifile( proweb_question     / 2 ).

main_goal :-
  proweb_send_form( proweb_home_form ).

proweb_page( [proweb_home_form], [] ).

proweb_form( proweb_home_form,
             [ `Atom: `,
               ?atom_input,
               ` String: `,
               ?unlimited_string_input,
               ` String: `,
               ?limited_string_input,
               br,
               `Number: `,
               ?number_input,
               ` Integer: `,
               ?integer_input,
               ` Password: `,
               ?password_input,
               ` On: `,
               ?checkbox_input1,
               ` Off: `,
               ?checkbox_input2,
               br,
               `Choice: `,
               ?radio_input,
               br,
               `Formatted Choice: `,
               br,
               ?formatted_radio_input,
               br,
               `Simple Menubox: `,
               ?oneline_menubox_input,
               ` Advanced Menubox: `,
               ?threeline_menubox_input,
               ` Multibox: `,
               ?multibox_input,
               br,
               ` Checkboxes: `,
               ?checkboxes_input,
               br,
               `Simple Date: `,
               ?date_input1,
               br,
               `Advanced Date1: `,
               ?date_input2,
               br,
               ` Advanced Date2: `,
               ?date_input3,
               br,
               `Time 1: `,
               ?time_input1,
               br,
               `Time 2: `,
               ?time_input2,
               br,
               `Time 3: `,
               ?time_input3,
               br,
               `Keycode: `,
               ?keycode_input,
               br,
               input(type=submit)
             ]
           ).

proweb_question( atom_input,
                 [ method = input,
                   type = atom,
                   prefill = 'Enter an atom',
                   rows = 1,
                   cols = 15,
                   help = `Please tick all those applicable`
                 ]
               ).

proweb_question( unlimited_string_input,
                 [ method = input,
                   type = string,
                   prefill = `Enter an unlimited string`,
                   rows = 3,
                   cols = 28
                 ]
               ).

proweb_question( limited_string_input,
                 [ method = input,
                   type = string,
                   prefill = `Enter a limited string`,
                   cols = 28,
                   maxlength = 28
                 ]
               ).

proweb_question( number_input,
                 [ method = input,
                   type = number,
                   prefill = 0.333,
                   lwb = 0,
                   upb = 1
                 ]
               ).

proweb_question( integer_input,
                 [ method = input,
                   type = integer,
                   prefill = 12345
                 ]
               ).

proweb_question( password_input,
                 [ method = password,
                   prefill = 'password'
                 ]
               ).

proweb_question( checkbox_input1,
                 [ method = checkbox,
                   prefill = on
                 ]
               ).

proweb_question( checkbox_input2,
                 [ method = checkbox,
                   prefill = off
                 ]
               ).

proweb_question( radio_input,
                 [ method = radio,
                   select = ['Win-Prolog','DOS-Prolog','Mac-Prolog'],
                   prefill = 'Win-Prolog'
                 ]
               ).

proweb_question( formatted_radio_input,
                 [ method = radio,
                   select = [a,b,c],
                   prefill = b,
                   infix = br
                 ]
               ).

proweb_question( oneline_menubox_input,
                 [ method = menubox,
                   select = ['Win-Prolog','DOS-Prolog','Mac-Prolog'],
                   prefill = 'Win-Prolog'
                 ]
               ).

proweb_question( threeline_menubox_input,
                 [ method = menubox,
                   select = ['Win-Prolog','DOS-Prolog','Mac-Prolog'],
                   prefill = 'Win-Prolog',
                   rows = 3
                 ]
               ).

proweb_question( multibox_input,
                 [ method = multibox,
                   select = ['Win-Prolog','DOS-Prolog','Mac-Prolog'],
                   prefill = ['Win-Prolog','DOS-Prolog'],
                   rows = 3
                 ]
               ).

proweb_question( checkboxes_input,
                 [ method = checkboxes,
                   select = ['Win-Prolog','DOS-Prolog','Mac-Prolog'],
                   prefill = ['Win-Prolog','DOS-Prolog']
                 ]
               ).

proweb_question( date_input1,
                 [method=date,
                  format='[d][m][yy]',
                  prefill=date(1998,5,15)
                 ]
               ).

proweb_question( date_input2,
                 [ method = date,
                   format = '[D][M][yyyy]',
                   prefill = date(2000,5,15)
                 ]
               ).

proweb_question( date_input3,
                 [ method = date,
                   format = 'Day: [WW] Date: [DD] Month: [MM] Year: [yyyy]',
                   prefill = date(2000,5,15)
                 ]
               ).

proweb_question( time_input1,
                 [ method = time,
                   format = '[h12][mm]',
                   prefill = time(23,59,0,0)
                 ]
               ).

proweb_question( time_input2,
                 [ method = time,
                   format = 'Hours: [hh12] Minutes: [mm] Seconds: [ss] AM/PM: [ampm]',
                   prefill = time(23,59,59,0)
                 ]
               ).

proweb_question( time_input3,
                 [ method = time,
                   format = `Hours: [hh24] Minutes: [mm] Seconds: [ss]`,
                   prefill = time(23,59,59,0)
                 ]
               ).

proweb_question( keycode_input,
                 [ method = keycode
                 ]
               ).
