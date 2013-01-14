/*
   Load WIN-PROLOG 4.700 Old-Style Icons - Brian D Steel - 08 Dec 09
   =================================================================

   In version 4.800 of WIN-PROLOG, the handling of icons was updated to
   support the multi-size, full-colour icons that are a feature of
   Windows Vista and later.

   However, some older applications still need access to the previous
   method of loading icons, such as by importing them from executable
   files an DLLs, and this file provides a way to do just that.

   The predicate, gfx_icon_load_old/3, works in the same way as the old,
   WIN-PROLOG 4.700 and earlier version of gfx_icon_load/3. To load
   icons the old-fashioned way, simply edit your code to replace all
   instances of:

      gfx_icon_load( ...

   with:

      gfx_icon_load_old( ...
*/

% load an old-style icon

gfx_icon_load_old( Icon, File, Index ) :-
   (  type( Icon, 3 ),
      type( File, 3 ),
      type( Index, 1 ),
      dict( 1, Dict ),
      member( Pred, Dict ),
      cmp( 0, Pred, known_icon ),
      member( Vers, Dict ),
      cmp( 0, Vers, rgl_windows_nt )
   -> (  Pred( Icon, _, _ )
      -> gfx_icon_close( Icon )
      ;  true
      ),
      wndhdl( -1, Instance ),
      stratm( String, File ),
      (  Vers
      -> winapi( (shell32,'ExtractIconW'), [Instance,String,Index], 2, Data )
      ;  winapi( (shell32,'ExtractIconA'), [Instance,String,Index], 1, Data )
      ),
      (  (  cmp( 0, Data, 0 )
         ;  cmp( 0, Data, 1 )
         )
      -> throw( 10, gfx_icon_load_old(Icon,File,Index) )
      ;  addcls( [Pred(Icon,Data,32)], 0 )
      )
   ;  (  type( Icon, 0 )
      ;  type( File, 0 )
      ;  type( Index, 0 )
      )
   -> throw( 22, gfx_icon_load_old(Icon,File,Index) )
   ;  throw( 23, gfx_icon_load_old(Icon,File,Index) )
   ).
