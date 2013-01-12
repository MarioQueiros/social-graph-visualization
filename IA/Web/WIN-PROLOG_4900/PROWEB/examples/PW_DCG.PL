/* ProWeb Definite Clause Grammar Example
   Written by Rebecca Shalfield
   --------------------------------------
*/

:-      multifile( proweb_page         / 2 ).
:-      multifile( proweb_form         / 2 ).
:-      multifile( proweb_question     / 2 ).

main_goal :-
  proweb_send_form( sentence_input_form ),
  proweb_returned_answer( sentence, Sentence ),
  proweb_post_reply( sentence, Sentence ),
  string_list( Sentence, ByteList ),
  bytelist_atomlist( ByteList, AtomList ),
  proweb_post_reply( atomlist, AtomList ),
  relationship( AtomList ),
  proweb_send_form( sentence_analyse_form ).

/*********************************
 * Definite-Clause Grammar Rules *
 *********************************/

s(   R, s(N,V)       ) --> np(R,N),    vp(R,V).
s(   R, s(N,V,P)     ) --> np(R,N),    vp(R,V), pp(R,P).
np(  R, np(D,N)      ) --> d(R,D),     n(R,N).
vp(  R, vp(V,N)      ) --> v(R,V),     np(R,N).
vp(  R, vp(V,S)      ) --> v(R,V),     s(R,S).
pp(  R, pp(P,N)      ) --> p(R,P),     np(R,N).
np(  R, np(NP)       ) --> npx(R,NPX).
npx( R, np(D,N)      ) --> d(R,D),     n(R,N).
np(  R, np(NPX,C,NP) ) --> npx(R,NPX), c(R,C), np(R,NP).

/**************
 * Vocabulary *
 **************/

c(  _, c(and)     ) --> [and].
d(  s, d(a)       ) --> [a].
d(  _, d(the)     ) --> [the].
n(  s, n(boy)     ) --> [boy].
n(  p, n(boys)    ) --> [boys].
n(  s, n(girl)    ) --> [girl].
n(  p, n(girls)   ) --> [girls].
n(  s, n(dog)     ) --> [dog].
n(  s, n(cat)     ) --> [cat].
n(  p, n(cats)    ) --> [cats].
n(  s, n(house)   ) --> [house].
n(  p, n(houses)  ) --> [houses].
n(  s, n(horse)   ) --> [horse].
n(  p, n(horses)  ) --> [horses].
n(  s, n(garden)  ) --> [garden].
v(  s, v(likes)   ) --> [likes].
v(  p, v(like)    ) --> [like].
v(  _, v(chased)  ) --> [chased].
v(  _, v(said)    ) --> [said].
v(  _, v(thought) ) --> [thought].
p(  _, p(in)      ) --> [in].
p(  _, p(into)    ) --> [into].
p(  _, p(on)      ) --> [on].
p(  _, p(to)      ) --> [to].
p(  _, p(with)    ) --> [with].

/******************
 * ProWeb Clauses *
 ******************/

proweb_page( _,
             [ h3,
               `Natural Language Processing - Definite-Clause Grammar`,
               /h3
             ]
           ).

proweb_form( sentence_input_form,
             [ table('WIDTH=100%','BORDER=1'),
               tr,
               td,
               b,
               `Grammar Rules:`,
               /b,
               p,
               `A `,
               b,
               `sentence (s)`,
               /b,
               ` can be a `,
               b,
               `noun phrase (np)`,
               /b,
               ` followed by a `,
               b,
               `verb phrase (vp)`,
               /b,
               `. A `,
               b,
               `noun phrase`,
               /b,
               ` can be a `,
               b,
               `determiner (d)`,
               /b,
               ` followed by a `,
               b,
               `noun (n)`,
               /b,
               `. A `,
               b,
               `verb phrase`,
               /b,
               ` can be just a `,
               b,
               `verb (v)`,
               /b,
               `, a `,
               b,
               `verb`,
               /b,
               ` followed by a `,
               b,
               `noun phrase`,
               /b,
               `, or a `,
               b,
               `verb`,
               /b,
               ` followed by a `,
               b,
               `noun phrase`,
               /b,
               /b,
               ` followed by a `,
               b,
               `prepositional phrase (pp)`,
               /b,
               `.`,
               /td,
               /tr,
               tr,
               td,
               b,
               `Vocabulary: `,
               /b,
               p,
               ul,
               li,
               `Determiners: `,
               b,
               verbatim @ Determiners,
               /b,
               li,
               `Nouns (Singular): `,
               b,
               verbatim @ SingularNouns,
               /b,
               li,
               `Nouns (Plural): `,
               b,
               verbatim @ PluralNouns,
               /b,
               li,
               `Conjunctions: `,
               b,
               verbatim @ Conjunctions,
               /b,
               li,
               `Verbs (Singular): `,
               b,
               verbatim @ SingularVerbs,
               /b,
               li,
               `Verbs (Plural): `,
               b,
               verbatim @ PluralVerbs,
               /b,
               li,
               `Prepositions: `,
               b,
               verbatim @ Prepositions,
               /b,
               /ul,
               /td,
               /tr,
               tr,
               td,
               `Please input a sentence: `,
               ?sentence,
               input(type=submit,value='Submit Sentence'),
               /td,
               /tr,
               /table
             ]
           ) :-
  setof( Determiner,  X^Y^d(X,Y,[Determiner|_],_),  Determiners   ),
  setof( Noun,        X^n(s,X,[Noun|_],_),        SingularNouns ),
  setof( Noun,        X^n(p,X,[Noun|_],_),        PluralNouns   ),
  setof( Conjunction, X^c(p,X,[Conjunction|_],_), Conjunctions  ),
  setof( Verb,        X^v(s,X,[Verb|_],_),        SingularVerbs ),
  setof( Verb,        X^v(p,X,[Verb|_],_),        PluralVerbs   ),
  setof( Preposition, X^p(_,X,[Preposition|_],_), Prepositions  ).

proweb_form( sentence_analyse_form,
             [ table('WIDTH=100%','BORDER=1'),
               tr,
               td('WIDTH=20%'),
               `Sentence:`,
               /td,
               td,
               b,
               ??sentence,
               /b,
               /td,
               /tr,
               tr,
               td,
               `List of Atoms:`,
               /td,
               td,
               b,
               verbatim @ ??atomlist,
               /b,
               /td,
               /tr,
               tr,
               td,
               `Comment:`,
               /td,
               td,
               b,
               ??relationship,
               /b,
               /td,
               /tr,
               tr,
               td,
               `Parse Tree:`,
               /td,
               td,
               b,
               verbatim @ ??parse_tree,
               /b,
               /td,
               /tr,
               /table
             ]
           ).

proweb_question( sentence,
                 [ method  = input,
                   type    = string,
                   cols    = 80,
                   prefill = Sentence
                 ]
               ) :-
  X is int(rand(100)),
  solution( phrase(s(_,_), AtomList), X),
  list_string( AtomList, Sentence ).

/***************************************************************
 * string_list/2                                               *
 * Convert a string into a list of bytelists                   *
 * ?- string_list( `this is a test`, List ). <enter>           *
 * List = [[116,104,105,115],[105,115],[97],[116,101,115,116]] *                                           *
 ***************************************************************/

string_list( Str, List2 ) :-
  string_chars( Str, List1 ),
  one( string_list2( List1, List2 ) ).

string_list2( [], [] ).

string_list2( [First|Rest], Result ) :-
  string_list2( Rest, Rest1 ),
  (  First = 32
  -> start_new_word( Rest1, Result )
  ;  append_char_to_word( First, Rest1, Result )
  ).

start_new_word( [[]|Rest1], Result ) :-
  append( [], [[]|Rest1], Result ).

start_new_word( Rest1, Result ) :-
  append( [[]], Rest1, Result ).

append_char_to_word( First, [], Result ) :-
  Result = [[First]].

append_char_to_word( First, [Rest], Result ) :-
  append( First, [Rest], Result ).

append_char_to_word( First, [Word|Rest], Result ) :-
  append( [First], Word, NewWord ),
  append( [NewWord], Rest, Result ).

/*******************************************************************************************
 * bytelist_atomlist/2                                                                     *
 * Convert a list of bytelists into a list of atoms                                        *
 * ?- bytelist_atomlist( [[116,104,105,115],[105,115],[97],[116,101,115,116]], R ).<enter> *
 * R = [this,is,a,test]                                                                    *
 *******************************************************************************************/

bytelist_atomlist( List1, List2 ) :-
  bytelist_atomlist2( List1, List2 ).

bytelist_atomlist2( [], [] ).

bytelist_atomlist2( [X|W], [Y|Z] ) :-
  bytelist_atomlist2( W, Z ),
  atom_chars( Y, X ).

/*************************************************
 * list_string/2                                 *
 * Convert a list of atoms into a string         *
 * ?- list_string( [this,is,a,test], S ).<enter> *
 * R = `this is a test`                          *
 *************************************************/

list_string( List, String ) :-
  length(List,Length),
  ( forall( member(ListMember,List,Position),
            ( write(ListMember),
              (  Length \= Position
              -> write(` `)
              ;  true
              )
            )
          )
  ) ~> String.

parse_tree( AtomList ) :-
  phrase( s(R,ParseTree), AtomList ),
  proweb_post_reply( parse_tree, ParseTree ).

relationship( AtomList ) :-
  phrase( s(s,_), AtomList ),
  proweb_post_reply( relationship,
                     `This sentence is in the singular`
                   ),
  parse_tree( AtomList ).

relationship( AtomList ) :-
  phrase( s(p,_), AtomList ),
  proweb_post_reply( relationship,
                     `This sentence is in the plural`
                   ),
  parse_tree( AtomList ).

relationship( AtomList ) :-
  phrase( s(_,_), AtomList ),
  proweb_post_reply( relationship,
                     `This sentence is correct, but neither singular or plural`
                   ),
  parse_tree( AtomList ).

relationship( AtomList ) :-
  proweb_post_reply( relationship,
                     `This sentence is NOT correct!`
                   ),
  proweb_post_reply( parse_tree, `Not available`).

understand(WordList,Reply) :-
  get_noun_phrase(WordList,Rest1),
  get_verb_phrase(Rest1,Reply).

get_noun_phrase([the,cat|Rest],Rest1) :-
  phrase(np(_,_),[the,cat|Rest],Rest1).

get_verb_phrase([chased|Rest],Rest1) :-
  phrase(v(_,_),[chased|Rest],Rest1).

