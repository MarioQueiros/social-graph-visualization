/* ProWeb Environment Strings Example
   ----------------------------------

   This example generates a page which displays environment strings, ProWeb version information,
   proweb settings and source files loaded.
*/

:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).

main_goal :-
        env( EnvironmentStrings ),
        findall( (verbatim @ Env = unencoded@Value),
                    member( (Env,Value), EnvironmentStrings ),
                    Envs
                  ),
        findall(
                 (verbatim @ String = verbatim@Value),
                 proweb_string( String, Value ),
                 Strings
               ),
        findall(
                 (verbatim @ Setting = verbatim@Value),
                 proweb_setting( Setting, Value ),
                 Settings
               ),
        findall(
                 verbatim @ File,
                 source_file( File ),
                 Files
               ),
        proweb_send_form( environment(Envs,Strings,Settings,Files) ).


proweb_page(
             [environment(_,_,_,_)],
             [
               html,
               head @ title @ verbatim @ `Environment`,
               body @ form(target='pws_demo_frame') @ proweb(form),
               /html
             ]
           ).

proweb_form(
             environment(Envs,Strings,Settings,Files),
             [
               h2 @ `ProWeb Strings`,
               p @ ol @ Strings,
               h2 @ `ProWeb Settings`,
               p @ ol @ Settings,
               h2 @ `Environment Variables`,
               p @ ol @ Envs,
               h2 @ `Source Files`,
               p @ ol @ Files
             ]
           ). 
