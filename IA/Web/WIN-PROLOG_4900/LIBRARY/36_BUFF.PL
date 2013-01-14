/*
   Old Buffer Predicates - Brian D Steel - 20 Aug 98 / 21 Jun 02
   =============================================================

   Version 3.800 of 386-PROLOG introduced a more flexible method for reading
   and writing memory, by adding additional features to the file handling
   predicates (see fcreate/5). This rendered the old buffer predicates
   (bcreate/2, bclose/1, bdata/3 and bdict/1) obsolete, and so they have
   been removed. A final buffer predicate, btext/3, was retained, but renamed
   wintxt/4 to align it more closely with the Win32 API (winapi/4) predicate.

   The only restriction of using these emulations is that it is no longer
   possible to simultaneously open a disk file and memory buffer using the
   same name; apart from this, all features are still supported, with the
   added benefit that file input/output is possible directly from buffers.
*/

% create a memory buffer

bcreate( Name, Size ) :-
   fcreate( Name, [], -2, Size, 0 ).

% close a memory buffer

bclose( Name ) :-
   fclose( Name ).

% return the address and size of a memory buffer

bdata( Buffer, Address, Size ) :-
   (  Buffer = (Buf,Fer)
   -> true
   ;  Buf = Buffer,
      Fer = 0
   ),
   (  type( Buf, 3 )
   -> fdata( Buf, Adr, _, Sze, _ ),
      Adr = (Off,_),
      (  Sze - Fer > 0
      -> Address is Off + Fer,
         Size is Sze - Fer
      ;  throw( 24, bdata(Buffer,Address,Size) )
      )
   ;  type( Buf, 1 )
   -> fdata( Buf, Adr, _, Sze, _ ),
      Address is Buffer + Fer,
      Size is -1
   ;  type( Buf, 0 )
   -> throw( 22, bdata(Buffer,Address,Size) )
   ;  throw( 23, bdata(Buffer,Address,Size) )
   ).

% return a dictionary of memory buffers

bdict( Buffers ) :-
   fdict( 0, Files ),
   findall( Buffer,
            (  member( Buffer, Files ),
               fdata( Buffer, Address, _, _, _ ),
               Address = (_,_)
            ),
            Buffers
          ).

% get or set text in a buffer

btext( Buffer, Size, Text ) :-
   wintxt( Buffer, Size, 0, Text ).
