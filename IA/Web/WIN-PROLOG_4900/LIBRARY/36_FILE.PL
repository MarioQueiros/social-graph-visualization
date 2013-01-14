/*
   Old File Handling Predicates - Brian D Steel - 08 Jul 98 / 10 Jun 00
   ====================================================================

   Version 4.100 of 386-PROLOG introduced support for Unicode, ISO/IEC 8859-1,
   ASCII and 24-bit character sets, which necessitated the replacement of the
   3.800 predicates, fcreate/4 and fdata/4 with fcreate/5 and fdata/5
   respectively. The additional, final parameter is a flag indicating the
   character set to use, with 0 meaning ISO/IEC 8859-1 (8-bit "Latin-1").

   Version 3.800 of 386-PROLOG introduced a more flexible and efficient
   predicate for opening and creating files for subsequent input and output.
   Key features of the new system is support for opening up to 64 files
   simultaneously (the previous limit was 8), and the inclusion of user-
   defined input/output buffer sizes (the previous fixed size of 1024 bytes
   made file input and output inefficient).

   The new fcreate/4 predicate subsumes the old fcreate/3 and fopen/3
   predicates, but with some subtle differences in functionality, as described
   below.

   Firstly, the old fcreate/3 predicate included a parameter which specified
   not the read/write access mode, but the attributes that would be applied to
   the file after it was closed: it always opened the file in read/write mode.
   This feature is no longer supported, and attributes should be managed with
   the attrib/2 predicate instead.

   Secondly, when fopen/3 was used to open a file, the file pointer was always
   set to 0 (top of file), even for write-only access. This would cause the
   overwriting of existing data, and most programs included calls to move the
   pointer to the end of the file in this case. This is handled automatically
   in the new fcreate/4 predicate.

   Finally, the old fcreate/3 and fopen/3 predicates used a fixed size (1024-
   byte) buffer for input and output. This was inefficient for serial access
   file input and output (the most common type), but good for random access.
   The new default buffer size is 65536 bytes, which is excellent for serial
   access for but poor for random access where the file size being processed
   exceeds this size. In the present emulations, the default size is chosen,
   specified by "0" as a final parameter to fcreate/4. If it is found that
   some applications using random access input and output have become slower,
   set this parameter either to 1024 (for direct compatibility with the old
   system), or if there is sufficient RAM available, to a size greater than
   that of the file being processed.
*/

% 3.600 version of fcreate/3

fcreate( Name, File, Atts ) :-
   (  type( Atts, 1 ),
      member( Atts, [0,1,2,3] )
   -> fcreate( Name, File, -2, 0, 0 ),
      (  Atts = 0
      -> true
      ;  message_box( ok,
                      `Warning: fcreate/3 tried to~M~Jset file attributes!`,
                      _
                    )
      )
   ;  type( Atts, 0 )
   -> throw( 22, fcreate(Name,File,Atts) )
   ;  type( Atts, 1 )
   -> throw( 24, fcreate(Name,File,Atts) )
   ;  throw( 23, fcreate(Name,File,Atts) )
   ).

% 3.800 version of fcreate/4

fcreate( Name, File, Atts, Size ) :-
   (  catch( Error, fcreate( Name, File, Atts, Size, 0 ) )
   -> throw( Error, fcreate( Name, File, Atts, Size ) )
   ).

% 3.600 version of fopen/3

fopen( Name, File, Mode ) :-
   (  type( Mode, 1 ),
      member( Mode, [0,1,2] )
   -> fcreate( Name, File, Mode, 0, 0 ),
      (  Mode = 1
      -> output( Current ),
         output( Name ),
         outpos( 0 ),
         output( Current )
      ;  true
      )
   ;  type( Mode, 0 )
   -> throw( 22, fopen(Name,File,Mode) )
   ;  type( Mode, 1 )
   -> throw( 24, fopen(Name,File,Mode) )
   ;  throw( 23, fopen(Name,File,Mode) )
   ).

% 3.600 version of fdata/3

fdata( Name, File, Mode ) :-
   fdata( Name, File, Mode, _, _ ).

% 3.800 version of fdata/4

fdata( Name, File, Mode, Size ) :-
   fdata( Name, File, Mode, Size, _ ).
