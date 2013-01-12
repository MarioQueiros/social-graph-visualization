/* ProWeb Cascading Style Sheet Example
   ------------------------------------
*/

main_goal :-
  proweb_send_form( my_form ).

proweb_page( _, [ html,
             	  head,
            	  style(type='text/css'),
                  StyleSheet,
                  /style,
                  /head,
                  body(bgcolor=white),
                  form,
                  proweb(form),
                  /form,
                  /body,
                  /html
                ]
           ) :-
   ( write(`H1 {color:red}`),
     nl,
     write(`H2 {font-style:italic}`),
     nl,
     write(`H3 {font-family:serif}`),
     nl,
     write(`P {font-family:sans-serif}`)
   ) ~> StyleSheet.

proweb_form( my_form, [	h1, 'This is red text', /h1,
                     	h2, 'This is italic text', /h2,
                     	h3, 'This is serif text', /h3,
                       	p,  'This is sans-serif text', /p
                      ]
           ). 
