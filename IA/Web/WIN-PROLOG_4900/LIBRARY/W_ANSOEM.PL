/*
   The ansoem/4 Predicate - Brian D Steel - 19 Sep 96 / 27 Feb 02
   --------------------------------------------------------------

   The ansoem/4 predicate was used extensively in versions of WIN-PROLOG up
   to and including 4.040, the final non-Unicode release, and was necessary
   because the character set used in the "console" and "text" windows was
   that of the IBM PC ROM BIOS, and not the Windows "ANSI" character set.

   Since version 4.100 of WIN-PROLOG was introduced in April 2001, the
   concept of "OEM" and "ANSI" character sets has become obsolete, as all
   Prolog text objects are now assumed to be a subset, superset, or exact
   set of Unicode characters, and this predicate has been removed from the
   system. However, for reasons of backwards compatibility of existing code,
   the 1996 implemention is presented here. New applications should avoid 
   use of ANSI/OEM conversions.
*/

% convert between ansi and oem strings or atoms - bds 19 sep 96

ansoem( Ans, Oem ) :-
   (  type( Ans, 0 )
   -> (  type( Oem, 3 )
      -> stratm( String, Oem )
      ;  type( Oem, 4 )
      -> String = Oem
      ;  type( Oem, 0 )
      -> throw( 22, ansoem(Ans,Oem) )
      ;  throw( 23, ansoem(Ans,Oem) )
      ),
      wintxt( [], -1, -1, Text ),
      wintxt( [], 0, 0, String ),
      winapi( (user32,'OemToCharA'), [[],[]], 0, _ ),
      wintxt( [], 0, 0, Result ),
      wintxt( [], -1, -1, Text ),
      (  type( Oem, 3 )
      -> stratm( Result, Ans )
      ;  Ans = Result
      )
   ;  (  type( Ans, 3 )
      -> stratm( String, Ans )
      ;  type( Ans, 4 )
      -> String = Ans
      ;  throw( 23, ansoem(Ans,Oem) )
      ),
      wintxt( [], -1, -1, Text ),
      wintxt( [], 0, 0, String ),
      winapi( (user32,'CharToOemA'), [[],[]], 0, _ ),
      wintxt( [], 0, 0, Result ),
      wintxt( [], -1, -1, Text ),
      (  type( Ans, 3 )
      -> stratm( Result, Oem )
      ;  Oem = Result
      )
   ).
