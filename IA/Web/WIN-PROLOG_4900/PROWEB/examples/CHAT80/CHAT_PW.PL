top_chat :-
   ensure_loaded( examples('Chat80\chat') ),
   proweb_send_form( initial_form ),
   proweb_returned_answer( chat_query, ChatQuery ),
   % If ChatQuery with a value of `` is passed into
   % process_query/2, ChatAnswer will come back as "End Of File"
   (  ChatQuery = ``
   -> proweb_send_form( goodbye_form )
   ;  process_query( ChatQuery, ChatAnswer ),
      % If you pass in `bye` using ANY case, `bye` will be returned
      (  ChatAnswer = `bye`
      -> proweb_send_form( goodbye_form )
     ;  proweb_post_reply( chat_last_query, unencoded @ ChatQuery ),
        proweb_post_reply( chat_answer,     unencoded @ ChatAnswer ),
        proweb_resend_form( continue_form )
     )
   ).

proweb_question( chat_query, 
		[ method     = input,
		  type       = string,
		  cols       = 38,
		  prefill    = ChatLastQuery,
% Bug fix by Rebecca 4/11/97; MAXLENGTH VALUE="" appears in the HTML
% page - with the next line inserted, MAXLENGTH="255" VALUE="" appears 
                  maxlength  = 255
		]
	       ) :-
	(  proweb_returned_answer( chat_query, ChatLastQuery )
	-> true
	;  ChatLastQuery = ``
	).

% There are three proweb_page/2 clauses rather than one with an underscore to
% stop such a clause from being picked up by other ProWeb applications on LPA site.
proweb_page( initial_form, include('Chat80/page.htm') ).
proweb_page( continue_form, include('Chat80/page.htm') ).
proweb_page( goodbye_form, include('Chat80/page.htm') ).

proweb_form( initial_form,  include('Chat80/initial.htm')  ).
proweb_form( continue_form, include('Chat80/continue.htm') ).
proweb_form( goodbye_form,  include('Chat80/goodbye.htm')  ).

process_query(Query,Response) :-
   catch( ReadError, read_in( Words ) <~ Query ),
   !,
   (  ReadError = 0
   -> catch( ControlError, control( Words ) ) ~> Response
   ;  cat( [Query,`.`],DotQuery,_),
      catch( DotReadError, read_in(DotWords) <~ DotQuery ),
      !,
      (  DotReadError = 0
      -> catch( DotControlError, control( DotWords ) ) ~> Response
      ;  error_message( ReadError, Message),
         write( Message ) ~> Response
      )
   ).

proweb_nl :-
   html_print_nl( p ).

