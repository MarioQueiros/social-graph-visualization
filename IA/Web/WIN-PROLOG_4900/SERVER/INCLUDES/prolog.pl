/*
    PROLOG.PL - Alan Westwood - 7 Jul 2007

    A utility program to drive the intelligence server from prolog.

*/

% Load the intelligence server interface from the prolog directory.
% This must be called before anything else can work!

load_dll :-
   absolute_file_name( prolog( 'int386w.dll' ), Dll ),
   atom_string( Dll, Dllstr ),
   winapi((kernel32,'LoadLibraryA'),[Dllstr],0,_) .

% Load an instance of prolog with default values for the various flags
% Id will be the Id of the prolog instance or a negative number
% in which case an error has occurred.

load_prolog( Id ) :-
   load_prolog( ``, 0, 0, 0, Id ) .

% Load an instance of prolog with parameters.

load_prolog( Commandswitches, Buffersize, Encoding, Tickle, Id ) :-
   winapi( (int386w,'LoadProlog'),[Commandswitches,Buffersize, Encoding,Tickle], 0, Result ),
   Id = Result.

% Halt an instance of prolog.

halt_prolog( Id ) :-
   winapi( (int386w,'HaltProlog'), [Id], 0, _ ) .

% Initialize a goal ready for calling.

init_goal( Id, Goal, Result ) :-
   goal_string( Goal, Goalstring ),
   winapi( (int386w,'InitGoal'), [Id,Goalstring], 0, Buffer ),
   get_result( Buffer, Result ) .

% Call a goal once, repeated calls backtrack for more solutions.

call_goal( Id, Result ) :-
   winapi( (int386w,'CallGoal'), [Id], 0, Buffer ),
   get_result( Buffer, Result ).

% Tell a goal for a request for more input recieved from the server.

tell_goal( Id, Goal, Result ) :-
   goal_string( Goal, Goalstring ),
   winapi( (int386w,'TellGoal'), [Id,Goalstring], 0, Buffer ),
   get_result( Buffer, Result ).
 
% Exit an pending goal.

exit_goal( Id, Result  ) :-
   winapi( (int386w,'ExitGoal'), [Id], 0, Result ) .

% Get a string from a buffer address, if the buffer address is negative then an error
% has occured so just return that.

get_result( Buffer, Result ) :-
   (  Buffer > 0
   -> wintxt( Buffer, 0, 0, Result )
   ;  Result = Buffer
   ).

% Convert a normal prolog goal into a string which the server can read.

goal_string( Goal, Goalstring ) :-
   ( writeq( Goal ),
     write( ' . ' )
   ) ~> Goalstring .

% Call a goal for one solution.

call_one_goal( Id, Goal, Result ) :-
   init_goal( Id, Goal, _ ),
   call_goal( Id, Result ),
   exit_goal( Id, _ ) .

