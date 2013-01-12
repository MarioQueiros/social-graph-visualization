/*
   Support for 4.200 "etoks/n" Predicates - Brian D Steel - 09 May 03
   ==================================================================

   With the introduction of Rich Syntax Colouring in WIN-PROLOG 4.300,
   it was necessary to modify the etoks/n predicates to support, among
   other things, the handling and returning of:

      1) The length (in characters) of each token
      2) Incomplete tokens and/or terms without giving errors
      3) Comment and white space tokens as distinct cases
      4) End-of-Term token, if present

   In the process of modifying the low-level Edinburgth tokeniser to
   provide the necessary support for the above, the distinction between
   quoted and unquoted atoms was lost. In Prolog, such quotes are not
   significant; furthermore, there were two other quoted/unquoted term
   types (variables and numbers) which were not distinguished in the old
   etoks/n predicate.

   In short, it was felt simplest to drop the returning of quoted atoms
   as a special case, rather than add two further cases for quoted
   variables and integers, all of which would have served simply to slow
   down the Rich Syntax Colouring which was the focus of the work.

   The present file emulates the behaviour of the old etoks/n predicates
   for those applications that require the distinction between quoted
   and unquoted atoms to be maintained, by the simple process of
   comparing the token's length to the atom's length: if they are not
   identical, then the atom must have been quoted!

   The main etoks_convert/2 predicate converts the new-style token list
   into the old-style one by handling the following cases:

      1) An empty list or incomplete token means end of file has occurred

      2) A correct end of term sequence terminates finishes the token list

      3) An atom which is shorter than its token length is assumed quoted

      4) A sequence of space/comment tokens is replaced by one space token

      5) Any other punctuation character is copied with the old token type

      6) All remaining tokens are returned directly, without their lengths
*/

% read an old-style token edinburgh token list from current input

old_etoks( Tokens ) :-
   old_etoks( Tokens, _ ).

old_etoks( OldTokens, Vars ) :-
   etoks( NewTokens, Vars ),
   etoks_convert( NewTokens, OldTokens ).

% convert new-style tokens into old-style ones

etoks_convert( NewTokens, OldTokens ) :-
   (  (  NewTokens = []
      ;  NewTokens = [(8,_,_)]
      )
   -> throw( 43, etoks_convert(NewTokens,OldTokens) )
   ;  NewTokens = [(7,_,'.')]
   -> OldTokens = []
   ;  NewTokens = [(3,Size,Atom)|More],
      len( Atom, Length ),
      Length < Size
   -> OldTokens = [(7,Atom)|Tail],
      etoks_convert( More, Tail )
   ;  NewTokens = [(7,_,Char)|More],
      member( Char, [' ','%'] )
   -> OldTokens = [(8,' ')|Tail],
      etoks_trim( More, Trim ),
      etoks_convert( Trim, Tail )
   ;  NewTokens = [(7,_,Char)|More]
   -> OldTokens = [(8,Char)|Tail],
      etoks_convert( More, Tail )
   ;  NewTokens = [(Type,_,Term)|More]
   -> OldTokens = [(Type,Term)|Tail],
      etoks_convert( More, Tail )
   ).

% trim successive comment and white space tokens

etoks_trim( Lint, Trim ) :-
   (  Lint = []
   -> throw( 43, etoks_trim(Lint,Trim) )
   ;  Lint = [(7,_,Char)|More],
      member( Char, [' ','%'] )
   -> etoks_trim( More, Trim )
   ;  Trim = Lint
   ).
