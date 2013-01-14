/**************************************************
 *   Public Domain Library for LPA-PROLOG 4.000   *
 **************************************************/

% Load LPA Compatibility File
:- ensure_loaded( prolog('\public\lpa') ).


%*% exercise the BAGUTL package

:- initialization ensure_loaded(public(bagutl)).

bag_test :-
	bag_test([1,3,4,5,6,1,6,4,3,4,5,6,19]).

bag_test(L) :-
	write('Input list: '), write(L), nl,

	list_to_bag(L, Bag), 

	write('Resulting bag: '), write(Bag), nl,

	write('The same bag with portray: '),
	portray_bag(Bag), nl,

	bagmax(Bag, BagMax),

	write('Maximum of bag: '), write(BagMax), nl, 

	bagmin(Bag, BagMin),

	write('Minimum of bag: '), write(BagMin), nl,

	bag_to_set(Bag, BagSet),

	write('The corresponding set: '), write(BagSet), nl,

	write('Result of a checkbag'), nl,

	checkbag(print_one_elem, Bag),

	is_bag(Bag),

	write(is_bag(Bag)), write(' succeeds'), nl,

	length(Bag, Total, Distinct), 

	write('Length: total: '), write(Total), write(' , distinct: '),
	write(Distinct), nl,

	bag_union(Bag, Bag, NewBag),

	write('Bag union Bag: '), portray_bag(NewBag), nl,

	write('make_sub_bag: '), nl,

	( make_sub_bag(Bag, SubBag),
	  length(SubBag, 10, _),
	  write('  '), portray_bag(SubBag), nl,
	  fail
	| true 
        ),

	write('member: '), nl,

	( bag_member(MElem, MCount, Bag),
	  write('   '), write(MElem), write(':'), write(MCount), nl,
	  fail
        | true
        ),

	write('Test sub bag '),

	test_sub_bag(Bag, NewBag),

	write('succeeds'), nl,

	bag_to_list(Bag, ListBag),

	write('result of bag_to_list: '), write(ListBag), nl,

	bag_inter(Bag, Bag, TheSameBag),

	write('Bag inter Bag: '), portray_bag(TheSameBag), nl,

	mapbag(inc_one_elem, Bag, BagPlus1),

	write('result of mapbag + 1: '), portray_bag(BagPlus1), nl.

inc_one_elem(Elem, NewElem) :- NewElem is Elem + 1.


print_one_elem(Elem, Count) :-
	write('*** '), write(Elem), write(':'), write(Count), nl.
