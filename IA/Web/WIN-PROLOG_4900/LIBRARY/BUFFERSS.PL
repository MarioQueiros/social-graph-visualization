:- ensure_loaded( library( buffers ) ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLASS  : buffer_with_statistics
% COMMENT: A specialisation of the class buffer
%          with additional statistics
%          about their changes in size over time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


class buffer_with_statistics .


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    DECLARATIONS                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


categories
  library ,
  buffer  .

inherits
  buffer.                      % A buffer with statistics is still a buffer

public attributes
  size inherited      ,        % Default size is inherited from buffer
  aggregate_size is 0 ,        % The aggregate number of items pushed into buffer
  peak_size      is 0 .        % The peak size ever reached

public methods
  reset                 /  0 , % Reset buffer to its initial state
  push                  /  1 . % Override definition of push/1 in class buffer
                               % so that the statistics can be updated


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    DEFINITIONS                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : reset/0
% COMMENT: Reset buffer to its initial state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

reset :-
  aggregate_size := 0,
  peak_size      := 0,
  super <- reset.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METHOD : push/1
% COMMENT: Push an item and then update the
%          statistics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

push( Item ) :-
  super <- push( Item ),            % Pass upwards a regular push
  aggregate_size += 1,              % Increment by 1 the aggregate size
  (  size > peak_size               % IF   current size > previous peak size
  -> peak_size := size              % THEN update the peak size
  ;  true ).                        % ELSE don't


end buffer_with_statistics.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLASS  : queue_with_statistics
% COMMENT: A specialisation of queues with
%          additional statistics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


class queue_with_statistics .


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    DECLARATIONS                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


categories
  library ,
  buffer  .

% The ordering of super-classes is very important,
% because both make public the procedural method push/1.
% In the case of "buffer_with_statistics" this is explicitly defined,
% whereas with "queue" it is implicitly inherited from its super-class "buffer".
% We want to inherit push/1 from "buffer_with_statistics" rather than "buffer"
% so that the statistics are continually re-calculated when an item is pushed.

inherits
  buffer_with_statistics,      % 1st super class
  queue.                       % 2nd super class


end queue_with_statistics.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLASS  : stack_with_statistics
% COMMENT: A specialisation of stacks with
%          additional statistics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class stack_with_statistics .


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    DECLARATIONS                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


categories
  library ,
  buffer  .

% The ordering of super-classes is very important,
% because both make public the procedural method push/1.
% In the case of "buffer_with_statistics" this is explicitly defined,
% whereas with "stack" it is implicitly inherited from its super-class "buffer".
% We want to inherit push/1 from "buffer_with_statistics" rather than "buffer"
% so that the statistics are continually re-calculated when an item is pushed.

inherits
  buffer_with_statistics,      % 1st super class
  stack.                       % 2nd super class


end stack_with_statistics.
