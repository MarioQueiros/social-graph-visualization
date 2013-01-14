

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLASS  : buffer
% COMMENT: The generic class for all types of buffers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


class buffer .


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    DECLARATIONS                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


categories
  library ,
  buffer  .

public attribute
  size     = 0 .               % Initial buffer size is always 0

private attribute
  contents = @nil .            % Initial contents is determined by type of buffer

public methods
  push         /  1 ,          % Push something into the buffer
  pop          /  1 ,          % Pop the top of the buffer
  empty        /  0 ,          % Test if the buffer is empty
  non_empty    /  0 ,          % Test if the buffer is non-empty
  top          // 0 ,          % Return the top of the buffer
  list         // 0 .          % Return contents as a proper list


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    DEFINITIONS                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : push/1
% COMMENT: Push an item into the buffer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

push( Item ) :-
  contents := push( Item, contents ),
  size     += 1.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : pop/1
% COMMENT: Pop an item from the top of the buffer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


pop( Item ) :-
  non_empty,
  contents := pop( Item, contents ),
  size     -= 1.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : empty/0
% COMMENT: Test whether a buffer is empty ?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

empty :-
  @size = 0.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : non_empty/0
% COMMENT: Test whether a buffer is non-empty ?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

non_empty :-
  @size > 0.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : top//0
% COMMENT: Return the top item in the buffer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

top = @top( @contents ) :-
  non_empty.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : list//0
% COMMENT: Access function to return the buffer's
%          contents as a list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

list = @list( @contents ).


end buffer.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLASS  : queue
% COMMENT: The generic queue class
%          (first-in-first-out OR last-in-last-out)
%          Queues are best represented by the
%          difference between two Prolog lists,
%          since access is required to both the
%          front (pop) and back (push).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


class queue .


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    DECLARATIONS                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


categories
  library ,
  buffer  .

inherit
  buffer .                   % A queue is a kind of buffer.

public methods
  nil      // 0 ,            % A nil queue
  push     // 2 ,            % Push something onto the end of the queue
  pop      // 2 ,            % Pop something from the beginning of the queue
  top      // 1 ,            % Return the beginning of the queue
  list     // 1 .            % Return the contents of the queue as a list


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    DEFINITIONS                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : nil//0
% COMMENT: The default value for a nil queue is the
%          difference between two identical lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nil = ( List - List ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : push//2
% COMMENT: Items are pushed onto the back of the
%          queue
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

push( Item, ( Front - [Item|Back] ) ) = ( Front - Back ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : pop//2
% COMMENT: Items are popped from the front of the
%          queue
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pop( Item, ( [Item|Front] - Back ) ) = ( Front - Back ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : top//1
% COMMENT: The top of the queue is the 1st item in
%          the front list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

top( ( [Item|_] - _ ) ) = Item.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : list//1
% COMMENT: Return the complete queue as a list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

list( ( Queue - [] ) ) = Queue.


end queue.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLASS  : stack
% COMMENT: The generic stack class (last-in-first-out
%          OR first-in-last-out)
%          Stacks can be represented by Prolog lists,
%          since access is only required at the top
%          of the stack (1st item in the list)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


class stack .


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    DECLARATIONS                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


categories
  library ,
  buffer  .

inherit
  buffer .                   % A stack is a kind of buffer.

public methods
  nil      // 0 ,            % A nil stack
  push     // 2 ,            % Push something onto the top of the stack
  pop      // 2 ,            % Pop something from the top of the stack
  top      // 1 ,            % Return the top of the stack
  list     // 1 .            % Return the contents of the stack as a list


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    DEFINITIONS                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : nil//0
% COMMENT: The default value for a nil stack is a
%          nil list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nil = [].


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : push//2
% COMMENT: Items are pushed onto the front of the
%          stack
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

push( Item, Stack ) = [Item|Stack].


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : pop//2
% COMMENT: Items are popped from the front of the
%          stack
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pop( Item, [Item|Stack] ) = Stack.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : top//1
% COMMENT: The top of the stack is the 1st item in
%          the list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

top( [Item|_] ) = Item.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : list//1
% COMMENT: Return the complete stack as a list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

list( Stack ) = Stack.


end stack.
