/*
   Convert Windows Metafile to Enhanced Metafile - Alan Westwood - 25 Sep 02
   =========================================================================

   Windows metafiles are special resource files containing a sequence of
   graphics output commands, and can be used to port vector-based images
   between different applications. Later versions of Windows replaced the
   original type of metafile with a newer, "Enhanced" metafile format.

   Up to version 4.200, WIN-PROLOG used the original, Windows Metafile format
   in its GraFiX commands, but WIN-PROLOG 4.300 introduces the native use
   of the newer, Enhanced Metafile format. Because existing applications
   might include a number of predefined images as metafiles, this program
   has been provided to facilitate the conversion of such images.

   The following program reads an existing windows metafile, "Windows", and
   converts it into an enhanced metafile, "Enhanced", using an automatically
   computed bounding box. Using this program, you will be able to convert and
   import Windows Metafiles into WIN-PROLOG programs.

   Example: to convert the Windows metafile, "foo.wmf", into an enhanced
   metafile, "bar.wmf", make the call:

      ?- windows_enhanced( 'foo.wmf', 'bar.wmf' ).
*/

windows_enhanced( Windows, Enhance ) :-
   atom_string( Windows, Source ),
   atom_string( Enhance, Target ),
   winapi( (gdi32,'GetMetaFileA'), [Source], 0, WinHandle ),
   (  WinHandle \= 0
   -> winapi( (gdi32,'GetMetaFileBitsEx'), [WinHandle,0,0], 0, Size ),
      (  Size \= 0
      -> fcreate( metafile, [], -2, Size, 0 ),
         winapi( (gdi32,'GetMetaFileBitsEx'),
                 [WinHandle,Size,metafile],
                 0,
                 Bytes
               ),
         (  Bytes=Size
         -> winapi( (gdi32,'SetWinMetaFileBits'),
                    [Size,metafile,0,0],
                    0,
                    EnhHandle
                  ),
            (  EnhHandle \= 0
            -> winapi( (gdi32,'CopyEnhMetaFileA'), [EnhHandle,Target], 0, _ ),
               winapi( (gdi32,'DeleteEnhMetaFile'), [EnhHandle], 0, _ ),
               winapi( (gdi32,'DeleteMetaFile'), [WinHandle], 0, _ ),
               fclose( metafile )
            ;  winapi( (gdi32,'DeleteMetaFile'), [WinHandle], 0, _ ),
               fclose( metafile )
            )
         ;  winapi( (gdi32,'DeleteMetaFile'), [WinHandle], 0, _ ),
            fclose( metafile )
         )
      ;  winapi( (gdi32,'DeleteMetaFile'), [WinHandle], 0, _ )
      )
   ).
