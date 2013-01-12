/*
   Proweb Input/Output Example - Written by Rebecca Shalfield
   ----------------------------------------------------------

   This example shows how ProWeb handles the input and output of the
   Prolog data types: atoms, LPA strings, integers, floats and lists.

   It is documented in chapter 11 of the ProWeb Server User Guide.
*/

:- multifile( proweb_page     / 2 ).
:- multifile( proweb_form     / 2 ).
:- multifile( proweb_question / 2 ).

main_goal :-
   proweb_send_form( input_form ),
   proweb_returned_answer( atom_input, AtomInput ),
   type( AtomInput, 3 ),
   proweb_returned_answer( string_input, StringInput ),
   type( StringInput, 4 ),
   proweb_returned_answer( integer_input, IntegerInput ),
   type( IntegerInput, 1 ),
   proweb_returned_answer( float_input, FloatInput ),
   type( FloatInput, 2 ),
   proweb_returned_answer( atom_list_input, AtomListInput ),
   ( type(AtomListInput,5); type(AtomListInput,6) ),
   proweb_send_form( output_form ).

proweb_page( _, [] ).

proweb_form( input_form,
             [ `Please enter an atom: `,
               ?atom_input,
               p,
               `Please enter a string: `,
               ?string_input,
               p,
               `Please enter an integer: `,
               ?integer_input,
               p,
               `Please enter a float: `,
               ?float_input,
               p,
               `Please select an atom list: `,
               ?atom_list_input,
               p,
               input(type=submit)
             ]
           ).

proweb_form( output_form,
             [ `Atom: `,
               AtomOutput,
               p,
               `String: `,
               StringOutput,
               p,
               `Integer: `,
               IntegerOutput,
               p,
               `Float: `,
               FloatOutput,
               p,
               `Atom List: `,
               verbatim @ AtomListOutput
             ]
           ) :-
  proweb_returned_answer( atom_input,       AtomOutput      ),
  proweb_returned_answer( string_input,     StringOutput    ),
  proweb_returned_answer( integer_input,    IntegerOutput   ),
  proweb_returned_answer( float_input,      FloatOutput     ),
  proweb_returned_answer( atom_list_input,  AtomListOutput  ).

proweb_question( atom_input,
                 [ method  = input,
                   type    = atom,
                   prefill = MyAtom
                 ]
               ) :-
  MyAtom = foo,
  atom( MyAtom ).

proweb_question( string_input,
                 [ method  = input,
                   type    = string,
                   prefill = MyString,
                   cols    = 30
                 ]
               ) :-
  MyString = `Logic Programming Associates`,
  string( MyString).

proweb_question( integer_input,
                 [ method  = input,
                   type    = integer,
                   prefill = MyInteger
                 ]
               ) :-
  MyInteger = 123,
  integer( MyInteger ).

proweb_question( float_input,
                 [ method  = input,
                   type    = number,
                   prefill = MyFloat
                 ]
               ) :-
  MyFloat = 3.6,
  float( MyFloat ).

proweb_question( atom_list_input,
                 [ method  = multibox,
                   type    = atom,
                   select  = MyAtomList,
                   rows    = 5
                 ]
               ) :-
  MyAtomList = [a,b,c,d,e],
  list( MyAtomList ).
