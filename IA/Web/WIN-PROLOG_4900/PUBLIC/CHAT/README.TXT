_____________________________

CHAT.TXT

Logic Programming Associates
21/12/93
Adapted by Mark Vulclair 
	&  B.W.Robinson.
_____________________________

As a public domain program, this port of the chat 80 system is offered as 
is. No claims or warranties are made as to the validity, usefulness or 
otherwise, of the system, or any of it's components.

The chat 80 system is a non trivial prolog application originally developed
at the University of Edinburgh as part of a research project by Fernando 
C.N Pereira and David H.D. Warren between 1978 and 1981.

The system consists of a natural language processing front end to a database 
system containing facts about the world as it was then. It takes in simple 
questions as input, and maps them into queries which the database can 
handle directly.

It should be noted here that the database, which is in parts out of date and 
incompleate, should be regarded as test data. The main area of interest 
being the natuarl language processing system.
 
This should be of interest to anyone looking into natural language 
processing at a pragmatic level.

Also, being a reasonably complex system chat is widely used as a bench 
mark and test for prolog implimentations.

If you would like to find out more about the chat system, the following 
papers are recommended;

____________________________________________

Logic for Natural Language Analysis
Fernando Pereira, January 1983
SRI Technical Note 275 
Technical Notes (Dori Arceo, mail stop EJ257)
Artificial Intelligence Centre
SRI International
333 Ravenswood Avenue
Menlo Park, California 94025, USA

An Efficient Easily Adaptable System
for Interpreting Natural Language Queries
David H.D. Warren & Fernando C.N. Pereira,
American Journal of Computational Linguistics
Vol. 8, No. 3-4, July 1982

Efficient Processing of Interactive Relational Database Queries
Expressed in Logic
David H.D. Warren
Seventh International Conference on Very Large Data Bases
Cannes, France, September 1981

For a more recent text on the topic of using Prolog for Natural Language 
processing try:

Prolog and Natural-Language Analysis
Fernando C.N. Pereira & Stuart M. Shieber
CLSI Lecture Notes No. 10, Stanford 1987
distributed by: University of Chicago Press
 
____________________________________________

----------------------------------------------------------------------------


____________

Using chat.
____________

In order to run chat you need to compile the system by issuing the prolog 
comand [examples(chat)] at the prolog "?-" prompt. This command compiles the 
chatinit.pl file in the chat subdirectory of the examples dirctory, which 
contains all the embedded ensure_loaded statements neaded to compile the 
system in the correct order.
To trigger the system once it is compiled and loaded type "chat." at the 
"?-" prompt. 
The system will prompt you with "Question: ". 
A typical question which chat will parse might be "What is the largest 
country bordering the united_states."
Notice that names such as "united_kingdom" are joined by an underscore. 
The system also reduces all input to lower case before parsing the sentence 
so it makes no difference how you type it in.
Questions must also be terminated, either by a full stop, or with a question 
mark to allow the system to stop reading the sentence.
The following directives can also be issued :

	Question: bye.			(exits back to the Prolog top level)
	Question: trace.		(turns on Chat's tracing mechanism)
	Question: do not trace.		(turns off the tracing mechanism)

The tracing mechanism shows all the intermediate datastructures, which are:

	* the syntactic parse tree of the question
		(a large Prolog term which is formatted)

	* the semantic interpretation of the parse tree
		(a Prolog-like clause)

	* a query-optimised version of the semantic interpretation
		(a Prolog-like clause which is a reordering of the
		 previous one, although it can sometimes be identical)

The various statistics show the times for each stage in milliseconds. You
will see that Chat is very fast at analysing and answering questions!

The chat/1 predicate parses the input from a file and processes it in batch
mode. Any file you wish to process needs to be in the directory to which 
your system is currently loged in. Usualy this will be the your prolog 
directory.
Two sets of test questions have been supplied. To invoke them issue the 
command "demo1", or "demo2". 

Good luck and have fun.


Barry Robinson.
