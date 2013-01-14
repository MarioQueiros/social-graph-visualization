/* REVERSI II - Alan Westwood - LPA Ltd - 20 June 2001

   This version of Reversi is a command line driven program that uses a
   memory buffer rather than assertions to keep the board state.
   
   The main predicates are:
   
   new_board/1 Create and initialize a new board with the given size
   
   computer/0  Tell Prolog to move if it can.
       Outputs one of the following
           'I won by n pieces'      - Prolog has won
           'You won by n pieces!'   - Prolog has lost
           'A draw'                 - It's a draw!
           'I pass'                 - Prolog cannot move
           ok                       - Still playing.
           
   human/2     Tell Prolog human moved at X,Y.
       Outputs one of the following
           'I won by n pieces'      - Prolog has won
           'You won by n pieces!'   - Prolog has lost
           'A draw'                 - It's a draw!
           'I pass'                 - Prolog cannot move
           ok                       - Still playing.
         or the predicate fails if not a valid move
           
   
   valid/2     Is this square a valid human move? This is used for hit 
         testing.
         This will either succeed or fail, no output.
         
   Human pieces are represented by -1 in the array.
   Prolog pieces are represented by 1 in the array.
   Empty squares are zero.
   This makes it easy to check who has won.

*/

% Prolog plays a move.

computer :-
   computer_move,
   !,
   state.
computer :-
   computer_pass .

% Human plays a move at X,Y

human(X,Y) :-
   human_move( X, Y ),
   state .

% Try and play a move by generate and test

computer_move :-
   computer( Who ),
   move( X, Y ),
   valid_move( X, Y, Who ),
   make_move( X, Y, Who ).

human_move( X, Y ) :-
   human( Who ),
   valid( X, Y ) 
   -> make_move( X, Y, Who ).

% Valid human move
% It's a valid move if it is in the cache.

valid( X, Y ) :-
   cache( Valid ),
   member( (X,Y), Valid ).

% Report the state of the game.

state :-
   (  no_more_moves
   -> sumall( Result ),
      (  Result > 0
      -> computer_won( Result )
      ;  Result < 0
      -> human_won( Result )
      ;  Result = 0
      -> draw
      )
   ;  ok
   ).

% Return the result of a finished game.

computer_won( Result ) :-
   write( 'I won by ' ),
   write( Result ),
   write( ' pieces!' ).

human_won( Result ) :-
   write( 'You won by ' ),
   R is abs(Result),
   write( R ),
   write( ' pieces!' ).

draw :-
   write( 'A draw!' ).

human_pass :-
   write( 'You must pass!' ).

computer_pass :-
   write( 'I pass' ).

ok :-
   write( ok ).

% It is a valid move if the square is empty and
% squares can be flipped.
    
valid_move( X, Y, Who ) :-
   empty_square( X, Y ),
   can_flip( X, Y, Who ).

% After making a move the cache is updated.

make_move( X, Y, Who ) :-
   put_board( X, Y, Who ),
   flip( X, Y, Who ),
   update_cache.

% To update the cache find all valid human moves.
% Caching valid moves avoids having to do this test
% every time the mouse moves.

update_cache :-
   findall( (X,Y),
            ( move(X,Y),
              valid_move(X,Y,-1)
            ),
            Valid
          ),
   retractall( cache(_) ),
   assert( cache(Valid) ).
            
% An empty square contains 0

empty_square( X, Y ) :-
   get_board( X, Y, 0 ).

% Generate a move
% The order of generation is the computer's simplistic strategy

move( X, Y ) :-
   board_size( Size ),
   ( corner( X, Y, Size )
   ; edge( X, Y, Size )
   ; inner_square( X, Y, Size )
   ; outer_square( X, Y, Size )
   ; outer_corner( X, Y, Size )
   ).

corner( X, Y, S ) :-
   S1 is S - 1,
   ( X = 0,   Y = 0
   ; X = 0,   Y = S1
   ; X = S1,  Y = S1
   ; X = S1,  Y = 0
   ).

edge( X, Y, S ) :-
   ( A = X, 
     B = Y
   ; A = Y, 
     B = X
   ),
   S1 is S - 3,
   integer_bound( 2, B, S1 ),
   ( A = 0
   ; A is S-1
   ).

inner_square( X, Y, S ) :-
   S1 is S - 3,
   integer_bound( 2, X, S1 ),
   integer_bound( 2, Y, S1 ).
  
outer_square( X, Y, S ) :-
   ( A = X,
     B = Y
   ; B = X,
     A = Y
   ),
   S1 is S - 3,
   integer_bound( 2, A, S1 ),
   ( B = 1
   ; B is S - 2
   ).
   
outer_corner( X, Y, S ) :-
   S1 is S - 1,
   S2 is S - 2,
   member( X, [0,1,S1,S2] ),
   member( Y, [0,1,S1,S2] ),
   \+ corner( X, Y, S ).

% Board predicates

new_board( Size ) :-
   repeat( 10 ),
   new_name( ArrayName ),
   create_array( ArrayName, Size ),
   !,
   retractall( board_size(_) ),
   assert( board_size(Size) ),
   write( ArrayName ),
   P1 is Size//2 - 1,
   P2 is P1 + 1,
   human( Human ),
   computer( Computer ),
   put_board( P1, P1, Human ),
   put_board( P1, P2, Computer ),
   put_board( P2, P1, Computer ),
   put_board( P2, P2, Human ),
   update_cache.
 
% Create a new name composed of "reversi" plus the current
% date and time (D,T)

new_name( Name ) :-
   time( 1, T ),
   ( write( reversi ),
     write( T )
   ) ~> Name.

% Create an array given the arrayname, this is mutex protected. 
% If this fails then the main application should close.
   
create_array( ArrayName, Size ) :-
   close_array( ArrayName ),
   ArraySize is 4 * Size * Size,
   write( ArrayName ) ~> ArrayStr,
   winapi( (kernel32,'CreateMutexA'),  [0,0,`MutexToProtectFileMapping`], 0, MutexHandle ),
   MutexHandle \= 0,
   winapi( (kernel32,'WaitForSingleObject'), [MutexHandle,5000], 0, WaitResult ),
   (  WaitResult = 0
   -> true
   ;  winapi( (kernel32,'ReleaseMutex' ), [MutexHandle], 0, _ ),
      fail  
   ), 
   % Got the mutex
   winapi( (kernel32,'CreateFileMappingA'), [16'FFFFFFFF,0,4,0,ArraySize,ArrayStr], 0, Handle ),
   Handle \= 0,
   winapi( (kernel32,'GetLastError'), [], 0, Error ),
   (  Error = 0
   -> winapi( (kernel32,'MapViewOfFile'), [Handle,16'f001f,0, 0, ArraySize], 0, ArrayPtr ),
      (  ArrayPtr = 0
      -> winapi( (kernel32,'CloseHandle'), [Handle], 0, _ ),
         winapi( (kernel32,'ReleaseMutex' ), [MutexHandle], 0, _ ),
         fail
      ;  winapi( (kernel32,'ReleaseMutex' ), [MutexHandle], 0, _ )
      )
   ;  winapi( (kernel32,'CloseHandle'), [Handle], 0, _ ),
      winapi( (kernel32,'ReleaseMutex' ), [MutexHandle], 0, _ ),
      fail
   ),
   wintxt( ArrayPtr, ArraySize, 0, `` ),
   retractall( array_name(_,_,_) ),
   assert( array_name(ArrayName,ArrayPtr,Handle) ).

close_array( Name ) :-
   def( array_name, 3, _ ),
   array_name( Name, Pointer, Handle ),
   !,
   winapi( (kernel32,'UnmapViewOfFile'), [Pointer], 0, _ ),
   winapi( (kernel32,'CloseHandle' ),    [Handle], 0, _ ),
   retractall( array_name(_,_,_) ).
close_array( _ ).

% Get what's at X,Y
get_board( X, Y, What ) :-
   a_cell( X, Y, W ),
   What = W.

put_board( X, Y, What ) :- 
   type( What, 1 ),
   a_cell( X, Y, What ).

% As  we are dealing with a memory address rather than a 
% Prolog buffer, some checks are made to make sure the X,Y
% position is a valid cell. If we did not do this there would
% be a risk of a GPF from invalid addresses.

a_cell( X, Y, What ) :- 
   board_size( Size ),
   X >= 0,
   X < Size,
   Y >= 0,
   Y < Size,
   array_name( _, Array, _ ),
   Offset is 4*((Size * Y) + X),
   (  type( What, 0 )
   -> wintxt( (Array,Offset), 4, 0, String ),
      getx( 4, What ) <~ String,
      List = [What]
   ;  putx( 4, What ) ~> String,
      wintxt( (Array,Offset), 4, 0, String )
   ).   

% Flipping and testing

% Flip squares

flip( X, Y, Who ) :-
   to_flip( X, Y, Who, Flip ),
   flip_lines( Flip, Who ).
  
flip_lines( [], _ ).
flip_lines( [Line|Lines], Who ) :-
   (  Line = (X,Y)
   -> put_board( X, Y, Who )
   ;  flip_lines( Line, Who )
   ),
   flip_lines( Lines, Who ).

% Find all squares to flip

to_flip( X, Y, Who, Flip ) :-
   findall( Line,
            get_squares( X, Y, Who, Line ),
            Flip
          ).

% Test to see if placing a piece at X,Y, pieces can be flipped.

can_flip( X, Y, Who ) :-
   get_squares( X, Y, Who, Line ),
   Line \= [],
   !.

get_squares( X, Y, Who, Squares ) :-
   opponent( Who, Opponent ),
   integer_bound( -1, DX, 1 ),
   integer_bound( -1, DY, 1 ),
   get_line( X, Y, DX, DY, (Who,Opponent), [], Squares ).
   
get_line( X, Y, DX, DY, (Who,Opponent), Found, Squares ) :-
   X1 is X + DX,
   Y1 is Y + DY,
   get_board( X1, Y1, Here ),
   (  Here    = Who
   -> Squares = Found
   ;  Here    = Opponent
   -> get_line( X1, Y1, DX, DY, (Who,Opponent), [(X1,Y1)|Found], Squares)
   ).
   
opponent( -1,  1 ). 
opponent(  1, -1 ). 

human( -1 ).
computer( 1 ).
empty( 0 ).

no_more_moves :-
   \+
   (  board_size( S ),
      S1 is S - 1,
      ( human(Who)
      ; computer(Who)
      ),
      integer_bound( 0, X, S1 ),
      integer_bound( 0, Y, S1 ),
      valid_move( X, Y, Who )
   ).

% Sum the contents of the array

sumall( Sum ) :-
   board_size( S ),
   ArraySize is 4*S*S,
   array_name( _, Address, _ ),
   wintxt( Address, ArraySize, 0, Text ),
   sumall( 0, Sum ) <~ Text.

sumall( Count, Sum ) :-
   (  getx(4,X)
   -> NewCount is Count + X,
      sumall( NewCount, Sum )
   ;  Sum = Count
   ).
