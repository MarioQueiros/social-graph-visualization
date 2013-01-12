/*
   WordNet Loader Generator - Brian D Steel - 13 Oct 04 / 04 Sep 07
   ================================================================

   This program performs two functions, to help with the preparation and
   loading of the WordNet files:

      Firstly, it copies the WordNet files into a "target" directory of
      your choice, and then edits the copy to ensure that the files can
      be loaded directly into 386-PROLOG without syntax errors.

      Secondly, it generates a customised loader program, WORDNET.PL,
      which is stored in 386-PROLOG's LIBRARY directory.

   To copy and edit WordNet for 386-PROLOG, use the following command:

      ?- prepare_wordnet( Source, Target ).

   where:

      Source is the folder containing the original WordNet files

      Target is the name of a nonexistent folder

   For example, if you type:

      ?- prepare_wordnet( 'd:\', prolog(wordnet) ).

   you will copy the WordNet files from "d:\", and place the edited
   versions of the files in a folder called "wordnet" within the
   386-PROLOG directory.

   Once you have done this, you can load WordNet using the command:

      ?- consult( library(wordnet) ).
*/

prepare_wordnet( Source, Target ) :-
   absolute_file_name( Source, Source2 ),
   absolute_file_name( Target, Target2 ),
   ensure_loaded( examples(change) ),
   mkdir( Target2 ),
   cat( [Source2,'\wn_*.pl'], SourceFilePattern, _ ),
   dir( SourceFilePattern, 0, SourceFiles ),
   forall( member( SourceFile, SourceFiles ),
           ( fname( SourceFile, _, SourceName, SourceExt ),
             cat( [Target2,'\',SourceName,SourceExt], TargetFile, _ ),
             copy_file( SourceFile, TargetFile )
           )
         ),
   cat( [Target2,'\wn_*.pl'], Pattern, _ ),
   change( Pattern, `~~`, `~~~~`,  0 ),
   absolute_file_name( library('wordnet.pl'), File ),
   fcreate( wordnet, File, -1, 0, 0 ),
   output( Output ),
   output( wordnet ),
   write( `/*~M~J` ),
   write( `   Wordnet Loader 1.1 - Brian D Steel - 04 Sep 07~M~J` ),
   write( `   ==============================================~M~J~M~J` ),
   write( `   This file was created automatically by PREP_WN.PL, at ` ),
   time( 1, T ),
   time( T, Date, Time ),
   write( Time ),
   write( ` on~M~J` ),
   write( `   ` ),
   write( Date ),
   write( `, and is set up to load WordNet from:~M~J~M~J` ),
   write( `      ` ),
   write( Target2 ),
   write( `~M~J~M~J` ),
   write( `   To configure 386-PROLOG and load WordNet from the above directory,~M~J` ),
   write( `   simply consult this file with the command:~M~J`),
   write( `~M~J` ),
   write( `      ?- consult( library(wordnet) ).~M~J` ),
   write( `*/~M~J~M~J` ),
   write( `% hide the built-in ms/2 predicate, replacing it with lpa_ms/2~M~J~M~J` ),
   write( `wordnet_hide_ms :-~M~J` ),
   write( `   def( ms, 2, 3 ),~M~J` ),
   write( `   getprd( ms, 2, X ),~M~J` ),
   write( `   len( X, Len ),~M~J` ),
   write( `   Len < 256,~M~J` ),
   write( `   assert( (lpa_ms(Goal,Time) :- ms(Goal,Time)) ),~M~J` ),
   write( `   hide( ms, 1 ).~M~J~M~J` ),
   write( `% set the memory areas required by WordNet~M~J~M~J` ),
   write( `wordnet_set_memory :-~M~J` ),
   write( `   total( CBb, CLb, _, CHb, CTb, CPb, _, _, _ ),~M~J` ),
   write( `   CBKb is ip(CBb / 1024),~M~J` ),
   write( `   CLKb is ip(CLb / 1024),~M~J` ),
   write( `   CHKb is ip(CHb / 1024),~M~J` ),
   write( `   CTKb is ip(CTb / 1024),~M~J` ),
   write( `   CPKb is ip(CPb / 1024),~M~J` ),
   write( `   gc( 3 ),~M~J` ),
   write( `   free(  FBb, FLb, _, FHb, FTb, FPb, _, _, _ ),~M~J` ),
   write( `   FBKb is ip(FBb / 1024),~M~J` ),
   write( `   FLKb is ip(FLb / 1024),~M~J` ),
   write( `   FHKb is ip(FHb / 1024),~M~J` ),
   write( `   FTKb is ip(FTb / 1024),~M~J` ),
   write( `   FPKb is ip(FPb / 1024),~M~J` ),
   write( `   (  FBKb < 256~M~J` ),
   write( `   -> NBKb is CBKb + (256 - FBKb)~M~J` ),
   write( `   ;  NBKb = 0~M~J` ),
   write( `   ),~M~J` ),
   write( `   (  FLKb < 256~M~J` ),
   write( `   -> NLKb is CLKb + (256 - FLKb)~M~J` ),
   write( `   ;  NLKb = 0~M~J` ),
   write( `   ),~M~J` ),
   write( `   (  FHKb < 8192~M~J` ),
   write( `   -> NHKb is CHKb + (8192 - FHKb)~M~J` ),
   write( `   ;  NHKb = 0~M~J` ),
   write( `   ),~M~J` ),
   write( `   (  FTKb < 40960~M~J` ),
   write( `   -> NTKb is CTKb + (40960 - FTKb)~M~J` ),
   write( `   ;  NTKb = 0~M~J` ),
   write( `   ),~M~J` ),
   write( `   (  FPKb < 112640~M~J` ),
   write( `   -> NPKb is CPKb + (112640 - FPKb)~M~J` ),
   write( `   ;  NPKb = 0~M~J` ),
   write( `   ),~M~J` ),
   write( `   xinit( NBKb, NLKb, 0, NHKb, NTKb, NPKb, 0, 0, 0 ).~M~J~M~J` ),
   write( `% load WordNet from ` ),
   write( Target2 ),
   write( `~M~J~M~J` ),
   write( `wordnet_load_files :-~M~J` ),
   write( `   wordnet_hide_ms,~M~J` ),
   write( `   wordnet_set_memory,~M~J` ),
   write( `   dir( '` ),
   write( Target2 ),
   write( `\wn_*.pl', 0, Files ),~M~J` ),
   write( `   forall( member( File, Files ),~M~J` ),
   write( `           ensure_loaded( File )~M~J` ),
   write( `         ).~M~J~M~J` ),
   write( `:- initialization wordnet_load_files.~M~J` ),
   output( Output ),
   fclose( wordnet ),
   write( `~M~J` ),
   write( `Your customised WordNet loader file, 'WORDNET.PL',~M~J` ),
   write( `has been saved in the 386-PROLOG "library" folder~M~J` ).

copy_file( Source, Target ) :-
   fcreate( source, Source, 0, 0, 0 ),
   fcreate( target, Target, -2, 0, 0 ),
   input( Input ),
   output( Output ),
   input( source ),
   output( target ),
   copy( -1, _ ),
   input( Input ),
   output( Output ),
   fclose( source ),
   fclose( target ).
