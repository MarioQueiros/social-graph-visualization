/* ProWeb Cookie Example
   Written by Rebecca Shalfield  2nd May 2003
   ------------------------------------------

   This example creates a page from which a cookie, containing
   the user's name, can be saved on to the client machine.

   This same page, when refreshed, will then retrieve the
   user's name from the cookie and display it within the page.
*/

main_goal :-
  proweb_send_form( cookie_form ).

proweb_page( cookie_form,
             [ head,
               unencoded @ `<SCRIPT LANGUAGE=JAVASCRIPT TYPE="TEXT/JAVASCRIPT">~M~J`,
               unencoded @ `expireDate = new Date~M~J`,
               unencoded @ `expireDate.setMonth(expireDate.getMonth()+6)~M~J`,
               unencoded @ `userName = ""~M~J`,
               unencoded @ `if(document.cookie != "") { userName = document.cookie.split("=")[1] }~M~J`,
               unencoded @ `function setCookie() { userName = document.forms[0].nameField.value~M~J`,
               unencoded @ `document.cookie = "userName="+userName+";expires=" + expireDate.toGMTString() }~M~J`,
               /script,
               /head
             ]
           ).

proweb_form( cookie_form,
             [ h1 @ `Setting Your Cookie`,
               p,
               `Enter your name: `,
               input(type=text,name='nameField',onfocus='document.forms[0].nameField.value = userName'),
               /p,
               p @ input(type='button',value='Set',onclick='setCookie()'),
               hr,
               h1 @ `Reading Your Cookie`,
               p,
               unencoded @ `<SCRIPT LANGUAGE=JAVASCRIPT TYPE="TEXT/JAVASCRIPT">~M~J`,
               unencoded @ `if(document.cookie != "") { document.write("Hello, "+document.cookie.split("=")[1]) }~M~J`,
               /script,
               /p,
               p @ `Note: Refresh the browser window to re-read your cookie`
             ]
           ). 
