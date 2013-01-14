/* ProWeb Hyperlink Example - Written by Rebeca Shalfield
   Note: As written, this example is intended for use in ProWeb's test mode
   ------------------------------------------------------------------------

   This program outputs a page containing three lists, each list
   containing three hyperlinks. The text of the three hyperlinks is
   'Letter A', 'Letter B' and 'Letter C' in each case. The actual URLs
   to which these hyperlinks point to are the same (i.e. correct) in the
   first and the third lists, although assembled differently, but totally
   different (i.e. incorrect) in the second list.
*/
:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).
:-      multifile( proweb_question     / 2 ).

main_goal :-
  %Method 1
  get_list_of_hyperlinks1( ListOfHyperlinks1 ),
  proweb_post_reply( list_of_hyperlinks1, ul @ ListOfHyperlinks1 ),
  %Method 2
  get_list_of_hyperlinks2( ListOfHyperlinks2 ),
  proweb_post_reply( list_of_hyperlinks2, ul @ ListOfHyperlinks2 ),
  %Method 3
  get_list_of_hyperlinks3( ListOfHyperlinks3 ),
  proweb_post_reply( list_of_hyperlinks3, ul @ ListOfHyperlinks3 ),
  proweb_send_form( my_form ).

proweb_page( my_form, [] ).

proweb_form( my_form,
             [ ??list_of_hyperlinks1,
               ??list_of_hyperlinks2,
               ??list_of_hyperlinks3
             ]
           ).

/******************************************************
 * Method 1                                           *
 * This version stops the value of ProWeb's temporary *
 * directory from being prefixed to WebSite           *
 ******************************************************/

get_list_of_hyperlinks1( ListOfHyperlinks1 ) :-
  findall( unencoded @ Hyperlink,
           ( part_hyperlink( Text, WebSite ),
             ( write(`<A HREF="` ),
               write( `http://` ),
               write( WebSite ),
               write( `">` ),
               write( Text ),
               write( `</A>` )
             ) ~> Hyperlink
           ),
           ListOfHyperlinks1
         ).

/*******************************************
 * Method 2                                *
 * This version has the value of ProWeb's  *
 * temporary directory prefixed to WebSite *
 * This is probably not what you want, but *
 * is mentioned here as an example of what *
 * not to do                               *
 *******************************************/

get_list_of_hyperlinks2( ListOfHyperlinks2 ) :-
  findall( unencoded @ Hyperlink,
           ( part_hyperlink( Text, WebSite ),
             ( html_print( a(href=WebSite) ),
               write( Text ),
               html_print( /a )
             ) ~> Hyperlink
           ),
           ListOfHyperlinks2
         ).

/**********************************************************
 * Method 3                                               *
 * This version stops the value of ProWeb's temporary     *
 * directory from being prefixed to WebSite by picking    *
 * up values for WebSite already beginning with 'http://' *
 **********************************************************/

get_list_of_hyperlinks3( ListOfHyperlinks3 ) :-
  findall( unencoded @ Hyperlink,
           ( full_hyperlink( Text, WebSite ),
             ( html_print( a(href=WebSite) ),
               write( Text ),
               html_print( /a )
             ) ~> Hyperlink
           ),
           ListOfHyperlinks3
         ).

/****************************************************
 * Used by Methods 1 and 2                          *
 * Saves memory as none are prefixed with 'http://' *
 ****************************************************/

part_hyperlink( `Letter A`, `www.a.co.uk` ).
part_hyperlink( `Letter B`, `www.b.co.uk` ).
part_hyperlink( `Letter C`, `www.c.co.uk` ).

/****************************************************
 * Used by Method 3                                 *
 * Wastes memory as each is prefixed with 'http://' *
 ****************************************************/

full_hyperlink( `Letter A`, `http://www.a.co.uk` ).
full_hyperlink( `Letter B`, `http://www.b.co.uk` ).
full_hyperlink( `Letter C`, `http://www.c.co.uk` ).
