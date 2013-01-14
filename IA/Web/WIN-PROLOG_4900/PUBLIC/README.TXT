Edinburgh Public Domain Libraries - 21 Dec 98
=============================================

Welcome to the Edinburgh public domain Prolog software library! The files
contained within this directory consist of some public domain library
routines which are installed into the WIN-PROLOG sub-directory
PUBLIC/LIBRARY, and the Chat 80 application which can be found in the
sub-directory PUBLIC/CHAT. Various other sub-directories include test
programs and documentation files in plain text format.

This directory contains a straightforward port to LPA 386-PROLOG of a
significant portion of the ALP-UK Edinburgh library.  

The port has been made without efficiency preoccupation. Neither can
we guarantee the exactness of the resulting libraries. In many places
bugs has been fixed.

The code is the original one except where indicated by comments
starting with %*%.

Any comment starting with %*% is from Marc Vauclair

To run these library files, the following two symbols are supposed to
be defined throuh the file_search_path/2 predicate:

	symbol: 'public' which refers to this directory
	symbol: 'ednbtst' which refers to the 'tests' sub-directory of
		 this directory.

A number of files had the ".hlp" suffix, but were in fact short ASCII text
files. These have been moved fo rht DOC sub-directory, and renamed from
"<file>.HLP" to "<file>_H.TXT.

The LPA.PL file is needed for Edinburgh Prolog compatibility at
several places in the libraries.

Some of the major packages are fully documented according to the Technical
Reference manual format in .txt files located in the doc directory.
All the files are comented and documented internaly.

Some tests or sample programs using these libraries are located in
tests sub-directory. To load libraries within a program you have to add a 
line like the following one for each of them:

		e.g. :- ensure_loaded(public(array)).

If a library depends from another library package, loading the
library is sufficient, the other ones are automatically loaded thanks
to embedded ensure_loaded statements.

initial files_search_path assertions are defined in a library called 
ednbinit.pl. You may want to modify these to reflect your directory 
structure in order to use the file in your programs.

initializing the search path in this maner insures that the search path
will only be asserted once. You can also copy these initializations to a 
top file which compiles the other lower level files. An example of this is
the chatinit.pl file in the chat directory which compiles the chat80 system.

Here is a short one-line description of each of file in PUBLIC\LIBRARY:

applic.pl	various function application predicates based on apply/2
arrays.pl	updatable arrays
assoc.pl	association lists
bagutl.pl	bag manipulation utilities
between.pl	number intervals generating utilities
count.pl	source code analysis tool
decons.pl	manipulate Prolog control structures as terms
flags.pl	flag and global variables handling
flat.pl		flatten binary trees to lists and vice versa
gensym.pl	generate unique symbols
graphs.pl	graphs manipulation utilities
heaps.pl	heaps manipulation utilities
lazy.pl		lazy evaluated lists utilities
listut.pl	list utilities
logarr.pl	extendable arrays with logarithmic access time
long.pl		long arithmetic package
map.pl		maps manipulation utilities
metutl.pl	meta-logical utilities
multil.pl	multi-lists manipulation utilities (lists of lists)
occur.pl	term occurence within terms and replacements of subterms
order.pl	checks for ordering of lists
ordset.pl	ordered sets manipulation utilities
projec.pl	record projection primitives
queues.pl	queues manipulation utilities
random.pl	random picking of list elements and random permutations
samsort.pl	a sorting routine
setutl.pl	set manipulation utilities
trees.pl	trees manipulation utilities

Information on the Chat 80 application can be found in the file CHAT.TXT
in the PUBLIC\CHAT directory.
