/*
   Text Size in Device Context - Brian D Steel - 31 Mar 00 / 24 Jun 02
   ===================================================================

   The gfx_text/4 predicate returns the X and Y extents, in logical
   coordinates, for a given text string rendered in the given font
   in the currently active "gfx" device context. As such, it can only
   be called somewhere between gfx_begin/1 or gfx_paint/1 and the
   corresponding gfx_end/1, and to give meaningful results, it should
   be called after any mapping (gfx_mapping/4) has been performed,
   for example, first compile the program:

      foo( Xscale, Yscale, Text ) :-
         gfx_begin( foo ),
         gfx_mapping( 1, 1, Xscale, Yscale ),
         gfx_text( bar, Text, X, Y ),
         X10 is X + 10,
         Y10 is Y + 10,
         gfx( (  font = bar
              -> rectangle(10,10,X10,Y10),
                 text(10,10,Text)
              )
            ),
         gfx_end( foo ).

   Next, type the commands:

      ?- wcreate( foo, grafix, `foo`, 100, 100, 500, 300, 16'90800000 ).

      ?- gfx_font_create( bar, 'Times New Roman', 32, normal ).

      ?- wfocus( foo ), foo( 3, 2, `Hello World` ).

   The latter command will show the words "Hello World" neatly boxed in
   a light grey rectangle, using a 1:1=3:2 mapping. Try other mappings:
   the rectangle should always be a perfect fit.
*/

% return size information about a font and text - bds 31 mar 00

gfx_text( Font, String, X, Y ) :-
   (  gfx_device( Device )
   -> (  type( String, 4 ),
         type( X, 0 ),
         type( Y, 0 )
      -> gfx_font_handle( Font, Handle ),
         len( String, Length ),
         wintxt( [], -1, -1, Text ),
         wintxt( [], 8, 0, `` ),
         gfxdev( [Device], 0, Shell, Index ),
         winapi( (gdi32,'SelectObject'), [Device,Handle], 0, _ ),
         winapi( (gdi32,'GetTextExtentPointA'), [Device,String,Length,[]], 0, _ ),
         gfxdev( [Device], 0, Shell, Index ),
         wintxt( [], 8, 0, Data ),
         wintxt( [], -1, -1, Text ),
         (  getx( 4, X ),
            getx( 4, Y )
         ) <~ Data
      ;  type( String, 0 )
      -> throw( 22, gfx_text(Font,String,X,Y) )
      ;  throw( 23, gfx_text(Font,String,X,Y) )
      )
   ;  throw( 11, gfx_text(Font,String,X,Y) )
   ).

% back door to find the device context - please don't worry how it works!

:- abolish( gfx_device/1 ),
   dict( 1, Dictionary ),
   member( Predicate, Dictionary ),
   cmp( 0, Predicate, known_device ),
   !,
   assert( (gfx_device(Device):-Predicate(_,_,Device,_)) ).
