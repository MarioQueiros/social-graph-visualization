WIN-PROLOG 4.900 Release - Logic Programming Associates - 01 Jun 10
===================================================================

Welcome to the WIN-PROLOG 4.900 Release, the new version of LPA's
leading Prolog compiler and tool suite for Windows. This README.TXT file
tells you a little about your software: full documentation is provided
in the form of ".PDF" files, which can be read using Adobe Acrobat
Reader 4.0 or later (included on the CD).

New Features in WIN-PROLOG 4.900
================================

Relaxed Numeric and Formatted Syntax
------------------------------------
Partly in support for JSON (see below), but also for increased
compatibility with most other computer languages, some optional
relaxations have been made to the number syntax used by the term read
predicates. Firstly, it is no long necessary to have an explicit decimal
portion in exponential formats:

        ?- X = 123e-4 .
        X = 0.0123

is now identical in meaning to:

        ?- X = 123.0e-4 .
        X = 0.0123

Previously, the first example would have resulted in a syntax error.
This change is sensitive to the Edinburgh Language Extensions flag, as
set or tested by elex/1, and so can be reversed temporarily or
permanently if required.

A related change was made to the formatted input predicate, fread/4:
previously, its Radix input format ("r") required alphabetic digits in
the range A..Z to be in upper case; now, either case can be used
interchangeably, again for greater compatibility with JSON and other
computer languages:

        ?- fread( r, 4, 16, Hex ). abcd
        Hex = 43981

is now identical in meaning to:

        ?- fread( r, 4, 16, Hex ). ABCD
        Hex = 43981

Previously, the first case would have resulted in failure of the call to
fread/4.

Unicode Conversion Predicate
----------------------------
While WIN-PROLOG has included comprehensive, automatic and transparent
Unicode support for many years, making most Prolog programs entirely
unaware of the dozen or so character encodings commonly in use today,
there nonetheless remains the occasional application where it is
necessary to perform explicit conversions of strings, especially where
those applications are web or network based.

Rather than force users to read and write from disk or memory files in
order to perform Unicode conversions, 4.900 includes a direct string-to-
string converter call strutf/3. It takes as its first two arguments
respectively, a binary, WIN-PROLOG format string and a variable, or a
variable and an 8-bit Unicode UTF-encoded string. The third argument
specifies the enconding to use, offering all the same options as
fcreate/5, as shown in this example, which converts a binary string into
UTF-8:

        ?- strutf( `This is a TM: ™`, UTF8, 1 ).
        UTF8 = `This is a TM: -?¢`

Here is a similar call, which this time retuns the UTF-16LE enconding
for the same string:

        ?- strutf( `This is a TM: ™`, UTF16LE, -2 ).
        UTF16LE = `T~@h~@i~@s~@ ~@i~@s~@ ~@a~@ ~@T~@M~@:~@ ~@”!`

Sublist and Toteall Predicates
------------------------------
A new predicate, sublist/2, has been introduced to help list processing
programs that need to work with ordered sublists, of known or unknown
length, of a parent list. Similar in use to member/2, extends the
funcionality to return 1, 2 or more elements at a time:

        ?- sublist( [One,Two], [cat,and,dog] ).
        One = cat ,
        Two = and ;

        One = cat ,
        Two = dog ;

        One = and ,
        Two = dog ;

A second new predicate, toteall/3, provides a powerful way to count
and/or tote up numerical solutions, using arbitrary Prolog logic to
compute the components. This predicate can be very useful in the
preparation of certain types of statistics, such as the mean and
standard deviation, which require the counting of solutions, as well as
the toting up of their values and the squares of values. Consider the
following database relation:

        foo( 9 ).
        foo( 2 ).
        foo( 27 ).
        foo( 81 ).

The following call counts up the total number of solutions and the total
of those solutions in order to calculate the arithmetic mean:

        ?- toteall( (One,Val), (One=1,foo(Val)), (Count,Total) ),
           Mean is Total/Count.
        One = _ ,
        Val = _ ,
        Count = 4 ,
        Total = 119 ,
        Mean = 29.75

Enhanced Help Subsystem
-----------------------
The help files in WIN-PROLOG 4.900 have been considerably extended
compared to previous releases, and in addition to the original
commentary, now include example calls and application notes, along with
increased cross-referencing between topics.

Word Wrap to Window
-------------------
Until now, the WIN-PROLOG console window, as well as all and any program
windows, have used a virtual line width equivalent to around 4,192
standard Courier 12 characters, meaning that long lines of output (or
program data) have required horizontal scrolling of the window in order
to be viewed. New in version 4.900 is the ability to wrap text to the
window, much as is done in word processing programs. This can be
achieved either through a new "Word Wrap ..." item in the "Options"
menu, or through a simple predicate, word_wrap/1, which can pick up or
set the "Word Wrap to Windows" mode:

        ?- word_wrap( Wrap ).
        Wrap = 0

The above call confirms that word wrap is currently off ("0", zero); the
following call sets it to on ("1", one):

        ?- word_wrap( 1 ).
        yes

Optimising Compiler Support for Meta-Arguments
----------------------------------------------
One of the unique features of the 386-PROLOG engine, is its support for
meta-arguments: predicate calls whose number of arguments are not known
until runtime. More than just a notational convenience, meta-arguments
allow for some very efficient and sophisticated systems code. For
example, consider this example:

        apply( Pred, Args ) :-
           Pred(|Args).

With "Pred" bound to an atom, for example "sort", and "Args" bound to a
list of arguments, the predicate can be applied directly to the
arguments without the added step of converting all the data into a call
using (=..)/2 (univ):

        ?- apply( sort, [[q,w,e,r,t,y],Sort] ).
        Sort = [e,q,r,t,w,y]

Unfortuntely, the above program used not to work when optimised, owing
to a historical shortcoming of the optimising compiler. In version
4.900, the optimising compiler has been modified to provide full support
for this useful and efficient feature.

Redefinition of Mod Operator
----------------------------
A small change, but one which may affect some programs: the "mod"
operator, used to compute modulo arithmetic in the is/2 predicate and
its family, has been redefined from "300 xfx" to "400 yfx", for
consistency with the other multiplication and division operators;
meanwhile, a new binary operator, "\", was added to the table with the
same priority, as this is an alternative notation for modulus in WIN-
PROLOG.

Soft Meta-Predicate Declarations
--------------------------------
There was a fixed data relation in WIN-PROLOG, called meta_system/2,
which told various system predicates and environment functions, such as
listing/0, listing/1 and the debuggers, how to recurse into the meta-
call arguments of predicates like findall/3, setof/3 and so on. It has
long beed wished to make this definition "soft", or user-redefinable,
and 4.900, meta_system/2 is present as a dynanic, multifile user
predicate, enabling any predicate with arguments which are metacalls, to
be listed with the same full indentation or debugged with the same
detail as the original "meta system" predicates, simply by asserting new
cases to meta_system/2. Similarly, it is now possible to prevent the
indentation of listings or nesting of the debugger selectively by
retracting one or more of the pre-defined cases.

JSON Features
-------------
Support for JSON as been added to WIN-PROLOG 4.900; this data exchange
language is used in many applications on the Internet, where the
formality and verbosity of XML is considered overkill. Provided as a
source code file in the EXAMPLES folder, JSON.PL defines to main
predicates, jread/1 and jwrite/1, which let you read and write JSON
terms respectively. A third predicate, jprint/1, displays the Prolog
equivalent of any depth of nested JSON structure, in a clear indented
format.

RGB, HSL and HSV Colours
------------------------
A new set of example/utility files, to be found in the EXAMPLES folder,
provide support for manipulating RGB colours, converting between them
and their HSL and HSV equivalents, as well as displaying them in the
console and matching for similarity.

Technical Support
-----------------
Please check the Support section of the LPA website for latest updates
and reports on bug fixes, and direct all email correspondence to the
appropriate address as shown in table below, making sure you include the
following details:

        1) A cut-and-pasted copy of your WIN-PROLOG "welcome banner",
           for example:

                ---------------------------------------------------
                LPA DOS-PROLOG 4.900 - S/N 0015996960 - 01 Jun 2010
                Copyright (c) 2010 Logic Programming Associates Ltd
                Licensed To: LPA Development and Documentation Team
                B=64 L=64 R=64 H=256 T=2048 P=8192 S=64 I=256 O=256
                ---------------------------------------------------

           You can create this banner at any time during a Prolog
           session simply by typing the command:

                ?- ver(1).

        2) Brief details about your:

                System (Windows 98, ME, 2000, XP, Vista, 7, (32/64 bit))
                Service Pack (None, SP1, SP2)
                Processor (486, Pentium, Core Solo/Duo, Xeon, Athlon)
                Memory/Disk Size (RAM, Cache, Hard Disk)
                Browser (NetScape 7, Internet Explorer 6, Opera 9)
                Computer Make (Compaq, HP, Lenovo)

        3) Description of the problem, including the exact text of any
           error message or error code that is displayed

           Please DON'T send email attachments (.ZIP, .EXE, .DOC, .BMP,
           etc) unless we have specifically asked for them: we simply
           delete unsolicited files without opening them.

Contact Details
---------------

        Info:           info_team@lpa.co.uk
        Sales:          sale_team@lpa.co.uk
        Support:        tech_team@lpa.co.uk

        Phone:          +44 (0) 20 8871 2016
        Fax:            +44 (0) 20 8874 0449
        Web:            http://www.lpa.co.uk

        Logic Programming Associates Ltd
        Studio 30, Royal Victoria Patriotic Building
        Trinity Road, London, SW18 3SX, England

Thank you for purchasing WIN-PROLOG 4.900 - please enjoy your software!
