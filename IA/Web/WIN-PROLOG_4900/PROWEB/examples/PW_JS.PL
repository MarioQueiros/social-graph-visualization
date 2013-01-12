/* ProWeb JavaScript Example - Written by Phil Vasey, Alan Westwood and Rebecca Shalfield
   --------------------------------------------------------------------------------------

   This example shows how and where a JavaScript program should be placed
   in your Prolog/ProWeb source code so as to be embedded correctly
   in an HTML page. The JavaScript program here echos what you type into
   the edit field via an alert dialog.
*/

:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).

main_goal :-
   proweb_send_form( script_form ).

proweb_page( script_form,
             [ head,
               unencoded @ `<SCRIPT TYPE="TEXT/JAVASCRIPT" LANGUAGE=JAVASCRIPT>~M~J`,
               unencoded @ '<!-- ~M~J',
                           `function showField(myText) {~M~J`,
               unencoded @ `    alert("Text:"+myText);~M~J`,
                           `}~M~J`,
               unencoded @ '// -->',
               /script,
               /head
             ] ).

proweb_form( script_form,
             [ unencoded @ `<INPUT TYPE="text" NAME="myeditfield">`,
               unencoded @ `<INPUT TYPE=BUTTON VALUE="Click Me!" onClick="showField(document.forms[0].myeditfield.value)">`
             ]
           ).
