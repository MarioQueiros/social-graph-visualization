/* ProWeb View Settings Example - Written by Rebecca Shalfield
   -----------------------------------------------------------

   This example creates an HTML page containing the names of many
   of the ProWeb settings together with their values. It executes
   a proweb_setting/2 call for each ProWeb setting and places its
   value at the appropriate location in the form's definition.
*/

:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).
:-      multifile( proweb_question     / 2 ).

main_goal :-
  proweb_send_form( proweb_setting_form ).

proweb_page( [proweb_setting_form], [] ).

proweb_form( proweb_setting_form,
             [ h2 @ `ProWeb Settings`,
               p,
               `Main goal: `,
               b @ MainGoal,
               p,
               `Post goal: `,
               b @ PostGoal,
               p,
               `Max forms per page: `,
               b @ MaxFormsPerPage,
               p,
               `Help: `,
               b @ Help,
               p,
               `Cache help: `,
               b @ CacheHelp,
               p,
               `Cache html: `,
               b @ CacheHtml,
               p,
               `HTML path: `,
               b @ HtmlPath,
               p,
               `Temp path: `,
               b @ tempPath,
               p,
               `Buffer size: `,
               b @ BufferSize,
               p,
               `Buffer name: `,
               b @ BufferName,
               p,
               `Mutex timeout: `,
               b @ MutexTimeout,
               p,
               `Start timeout: `,
               b @ StartTimeout,
               p,
               `Query timeout: `,
               b @ QueryTimeout,
               p,
               `Temp timeout: `,
               b @ TempTimeout,
               p,
               `Idle timeout: `,
               b @ IdleTimeout,
               p,
               `conversation src: `,
               b @ ConversationSrc
             ]
           ) :-
  proweb_setting( main_goal, MainGoal ),
  proweb_setting( post_goal, PostGoal ),
  proweb_setting( max_forms_per_page, MaxFormsPerPage ),
  proweb_setting( help, Help ),
  proweb_setting( cache_help, CacheHelp ),
  proweb_setting( cache_html, CacheHtml ),
  proweb_setting( html_path, HtmlPath ),
  proweb_setting( temp_path, TempPath ),
  proweb_setting( buffer_size, BufferSize ),
  proweb_setting( buffer_name, BufferName ),
  proweb_setting( mutex_timeout, MutexTimeout ),
  proweb_setting( start_timeout, StartTimeout ),
  proweb_setting( query_timeout, QueryTimeout ),
  proweb_setting( temp_timeout, TempTimeout ),
  proweb_setting( idle_timeout, IdleTimeout ),
  proweb_setting( conversation_src, ConversationSrc ).
