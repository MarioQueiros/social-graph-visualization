/*
   Convert True Metafile to Placeable Metafile - Brian D Steel - 23 Nov 00
   =======================================================================

   Windows metafiles are special resource files containing a sequence of
   graphics output commands, and can be used to port vector-based images
   between different applications. Unfortunately, some applications
   (such as Microsoft Word for Windows) are unable to process these files
   unless the include an additional header which specifies the size and
   scaling factor of the metafile. Equally unfortunate is that such metafiles
   cannot be loaded using standard Windows API calls without first discarding
   this header!

   The following program reads an existing true metafile, "True", and
   converts it into a placeable metafile, "Meta", using the user-specified
   bounding box (X0,Y0), (X1,Y1) to define the "placeable" header. Using this
   program, you will be able to export Prolog graphics to Word and other
   Microsoft applications.

   Example: to convert the true metafile, "foo.wmf", into a placeable
   metafile, "bar.wmf", with a declared bounding box of (0,0,400,400),
   make the call:

      ?- convert_metafile( 'foo.wmf', 'bar.wmf', 0, 0, 400, 400 ).
*/

convert_metafile( True, Meta, X0, Y0, X1, Y1 ) :-
   H0 = 16'cdd7,			% magic number - key sig part 1
   H1 = 16'9ac6,			% magic number - key sig part 2
   H2 = 0,				% magic number - reserved (must be 0)
   H3 = X0,				% left logical bounding coordinate
   H4 = Y0,				% top logical bounding coordinate
   H5 = X1,				% right logical bounding coordinate
   H6 = Y1,				% bottom logical bounding coordinate
   H7 = 1000,				% number of logical units per inch
   H8 = 0,				% magic number - reserved (must be 0)
   H9 = 0,				% magic number - reserved (must be 0)
   rpn( [H0,H1,x,H2,x,H3,x,H4,x,H5,x,H6,x,H7,x,H8,x,H9,x], Check ), % checksum
   fcreate( True, True, 0, 0, 0 ),	% open original true metafile
   fcreate( Meta, Meta, -1, 0, 0 ),	% create new placeable metafile
   input( Input ),			% save current input stream
   output( Output ),			% save current output stream
   input( True ),			% set original file for input
   output( Meta ),			% set named file for output
   putx( 2, H0 ),			% output header word 0
   putx( 2, H1 ),			% output header word 1
   putx( 2, H2 ),			% output header word 2
   putx( 2, H3 ),			% output header word 3
   putx( 2, H4 ),			% output header word 4
   putx( 2, H5 ),			% output header word 5
   putx( 2, H6 ),			% output header word 6
   putx( 2, H7 ),			% output header word 7
   putx( 2, H8 ),			% output header word 8
   putx( 2, H9 ),			% output header word 9
   putx( 2, Check ),			% output header checksum
   copy( -1, Bytes ),			% copy true metafile to output
   input( Input ),			% restore current input stream
   output( Output ),			% restore current output stream
   fclose( True ),			% close original temp metafile
   fclose( Meta ),			% close placeable metafile
   write( 'True Metafile "' ),		% output assorted details...
   write( True ),
   write( '" converted to Placeable Metafile ' ),
   write( Meta ),
   write( '" containing ' ),
   write( Bytes ),
   write( ' graphics bytes' ),
   nl.					% and that's it!
