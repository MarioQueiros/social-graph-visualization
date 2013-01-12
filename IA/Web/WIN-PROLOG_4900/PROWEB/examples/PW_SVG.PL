/* ProWeb Scalable Vector Graphics Example - Written by Rebecca Shalfield - 8th July 2002
   -------------------------------------------------------------------------------------- */

/* Scalable Vector Graphics (SVG) is a vector graphics format for the Web.
   
   SVG is based on XML.

   Adobe have produced a SVG plug-in for web browsers; this is available from:

     http://www.adobe.com/svg/
*/

main_goal :-
  proweb_send_form( my_svg_example_form ).

proweb_page( my_svg_example_form, [] ).

proweb_form( my_svg_example_form,
             [ embed( src=RelativeSVGFileName,
                      width='100',
                      height='100',
                      type='image/svg+xml'
                    ),
               p,
               `Note: This page requires Scalable Vector Graphics (SVG) support - `,
               a(href='http://www.adobe.com/svg/',target='new'),
               `Download Adobe SVG Viewer`,
               /a,
               /p
             ]
           ) :-
   RelativeSVGFileName = 'examples\example.svg',
   absolute_file_name( prolog(''), ExecRoot ),
   cat( [ExecRoot,'examples\example.svg'], AbsoluteSVGFileName,   _ ),
   generate_svg_file( AbsoluteSVGFileName ).

generate_svg_file( AbsoluteSVGFileName ) :-
  fcreate( svg_file, AbsoluteSVGFileName, -2, 0, 1 ),
  output( Old ),
  output( svg_file ),
  write( `<?xml version="1.0" encoding="UTF-8"?>` ),
  nl,
  write( `<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20001102//EN" "http://www.w3.org/TR/2000/CR-SVG-20001102/DTD/svg-20001102.dtd">` ),
  nl,
  write( `<svg width="100" height="100">` ),
  nl,
  write( `<!-- Constructed by ProWeb -->` ),
  nl,
  write( `<desc>Example</desc>` ),
  write_svg_rect( 10, 10, 80, 80, red ),
  write_svg_rect( 20, 20, 75, 75, green ),
  write_svg_rect( 30, 30, 70, 70, blue ),
  write_svg_text( 35, 40, arial, fantasy, 12, bold, normal, white, 'Powered by...' ),
  write_svg_text( 35, 60, arial, fantasy, 18, bold, normal, yellow, 'ProWeb' ),
  write( `</svg>` ),
  nl,
  output( Old ),
  fclose( svg_file ).

write_svg_rect( X, Y, Width, Height, Colour ) :-
  write(`<rect x="`),
  write(X),
  write(`" y="`),
  write(Y),
  write(`" width="`),
  write(Width),
  write(`" height="`),
  write(Height),
  write(`" rx="4" ry="4" style="fill:`),
  write(Colour),
  write(`;"/>`),
  nl.

write_svg_text( X, Y, Specific, Generic, Size, Style, Weight, FillColour, Text ) :-
  write( `<text x="` ),
  X2 is X + 3,
  write( X2 ),
  write( `" y="` ),
  Y2 is Y + 3,
  write( Y2 ),
  write( `" style="font-family:` ),
  write(Specific),
  write(`,`),
  write(Generic),
  write(`; font-stretch:condensed; font-style:` ),
  write(Style),
  write( `; font-weight:` ),
  write( Weight ),
  write( `; font-size:` ),
  write( Size ),
  write( `; fill:` ),
  write( FillColour ),
  write( `; stroke:none">` ),
  write( Text ),
  write( `</text>` ),
  nl. 
