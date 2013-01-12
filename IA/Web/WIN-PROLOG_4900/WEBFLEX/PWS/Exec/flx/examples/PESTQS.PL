:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).
:-      multifile( proweb_question     / 2 ).

graphic_root( '/pws_data/flx/images/' ).
   
% :- ensure_loaded( library(tcptrace) ).

pws_question_pest( Pests, Data, Choice ) :-
   proweb_send_form( (pest_form,Pests,Data) ),
   proweb_returned_form( (pest_form,Pests,Data) ),
   proweb_returned_answers( Pests, Choice ).


pws_question_crop( Crops, Data, Choice ) :-
   proweb_send_form( (crop_form,Crops,Data) ),
   proweb_returned_form( (crop_form,Crops,Data) ),
   proweb_returned_answer( radio_button(Crops), Choice ).


pws_question_harvest( Text, Explanation, Result ) :-
   proweb_send_form( (harvest_form,Text,Explanation) ),
   proweb_returned_form( (harvest_form,Text,Explanation) ),
   proweb_returned_answer( days, Result ).


pws_solution( no_solution ) :-
   !,
   proweb_send_form( no_solution ).
pws_solution( Solution ) :-
   proweb_send_form( (solution_form,Solution) ) .

proweb_returned_answers( [], [] ).
proweb_returned_answers( [Pest|Pests], Choices ) :-
   proweb_returned_answer( checkbox(Pest), V ),
   (  V = on
   -> Choices = [Pest|Rest]
   ;  Choices = Rest
   ),
   proweb_returned_answers( Pests, Rest ) .


proweb_page( [(pest_form,Pests,Data)],
             [ include( 'pestcide.htm' )
             ]
           ).

proweb_form( (pest_form,Pests,Data), Form ) :-
    javascript( JavaScript ),
    graphic_root( Root ),
    cat( [Root,'bgchalk.gif'], Graphic, _ ),
    Form = [
              unencoded @ JavaScript, 
              table(border=1,cellpadding=2,cellspacing=0
              )
              |Rest
           ],
    make_pest_form( Pests, Data, 3, Rest,  
                   [
                     /table,
                     br,
                     input(type=submit,value='Submit Pests')
                   ] ).


proweb_question( checkbox(Pest),
                 [ method = checkbox,
                   prefill = off
                 ] ).

                 
make_pest_form( [], [], _, V, V ) :-
    !.
make_pest_form( [Pest|Pests], [Datum|Data], N, [tr|List], R ) :-
    make_item( Pest, Datum, N, List, [/tr|Rest] ),
    N1 is N + 1,
    make_pest_form( Pests, Data, N1, Rest, R ).
    

make_item( Pest, [Picture,Description], N, List, Var ) :-
    graphic_root( Root ),
    cat( [Root,Picture], Graphic, _ ),
    ( write( '<A href="javascript:void(0);" onClick="' ),
      write( select_check(N) ),
      write( '">' ),
      write( '<IMG src="' ),
      write( Graphic ),
      write( '" border="0" alt="Click here to select ' ),
      write( Pest ),
      write( '" width="96" height="72"></A>' )
    ) ~> Method,
    List = [ td( align=`MIDDLE`, valign=`CENTER`),
             unencoded @ Method,
             /td,
             td(width='30%', valign=top, nowrap ),
             ?checkbox(Pest),
             Pest,
             /td,
             td(width='60%', valign=top, nowrap),
             Description,
             /td
             |Var].


proweb_page( [ (crop_form,Crops,Data)],
             [ 
               include( 'crop.htm' )
             ]
           ).

proweb_form( (crop_form,Crops,Data), Form ) :- 
    javascript( JavaScript ),
    graphic_root( Root ),
    cat( [Root,'bgchalk.gif'], Graphic, _ ),
    Form = [  unencoded @ JavaScript,
              table(border=1,cellpadding=0,cellspacing=0
              ),
              tr
              |Row
           ],
    length( Crops, RowSpan ),
    Crops = [Crop|CropRest],
    Data  = [Datum|DataRest],
    make_crop_item( Crop, Datum, 0, Row, 
           [ 
             td(rowspan=RowSpan,width='60%',nowrap),
             ?radio_button(Crops),
             /td,
             /tr
             |Tail
           ] ),
    make_crop_form( CropRest, DataRest, 1, Tail, 
           [ 
              /table,
              br,
              input(type=submit,value='Submit Crop')
           ] ).
    

proweb_question( radio_button(Crops),
                 [ method = radio,
                   select=Crops,
                   infix=br,
                   prefill = Crop
                 ] ) :-
     Crops = [Crop|_].


make_crop_form( [], [], _, V, V ) :-
    !.
make_crop_form( [Crop|Crops], [Datum|Data], N, [tr|List], R ) :-
    make_crop_item( Crop, Datum, N, List, [/tr|Rest] ),
    N1 is N + 1,
    make_crop_form( Crops, Data, N1, Rest, R ).
    

make_crop_item( Crop, Picture, N, List, Var ) :-
    graphic_root( Root ),
    cat( [Root,Picture], Graphic, _ ),
    (
       write( '<A href="javascript:document.forms[0].submit();" onclick="' ),
       write( select_radio(N) ),
       write( '">' ),
       write( '<IMG src="' ),
       write( Graphic ),
       write( '" alt="Click here to select ' ),
       write( Crop ),
       write( '" border="0"></A>' )
    ) ~> Anchor,
    List = [ td,
             unencoded @ Anchor,
             /td
             |Var].
    

proweb_page( [ (harvest_form,Text,Explanation)],
             [ 
               include( 'harvest.htm' )
             ]
           ).
           

proweb_form( (harvest_form,Text,Explanation), Form ) :- 
    Form = [  
              table(border=1,cellpadding=4,cellspacing=0),
              tr, 
                 td( width='20%' ), 
                    Text,           
                 /td, 
                 td, 
                    ?days,
                 /td,
              /tr,
              tr, 
                 td(valign=top), 
                    'Because:', 
                 /td,
                 td, 
                    Explanation, 
                 /td, 
              /tr,
              /table,
              br,
              input(type=submit,value='Submit Days')
           ].


proweb_question( days,
                 [ method=input,
                   type=integer,
                   prefill=0,
                   lwb=0
                 ]
               ).

proweb_page( [ (solution_form,Text)],
             [ 
               include( 'solution.htm' )
             ]
           ).
           

proweb_form( (solution_form,Text),  Form ) :- 
   Form = [ include('solform.htm')
          ],
   member( crop(Crop), Text ),
   member( pests(Pests), Text),
   member( pesticide(Pesticide), Text ),
   proweb_post_reply( crop, Crop ),
   proweb_post_reply( pests, dl @ Pests ),
   proweb_post_reply( pesticide, Pesticide ).


proweb_page( [ no_solution ],
             [ 
               include( 'nosol.htm' )
             ]
           ).
           

proweb_form( no_solution,  [] ). 



javascript( JScript ) :-
   JScript = 
`<SCRIPT language=JAVASCRIPT type="TEXT/JAVASCRIPT">
<!--
function select_check(thing) {

   document.forms[0].elements[thing].checked
      = document.forms[0].elements[thing].checked ? false : true 
}

function select_radio(thing){

   document.forms[0].q0001[thing].checked = true 
}

// -->

</SCRIPT>
` .
   
