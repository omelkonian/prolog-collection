prefix(List, Prefix) :-
	append(Prefix, _, List),
	Prefix \= [].

binrep(N, List, RetList) :-
	nonvar(N), !,
	binrep1(N, List, RetList).
binrep(N, List, RetList) :-
	prefix(RetList, List),	
	bin1(N, List, RetList, 0).

bin1(0, List, List, 0).
bin1(N, List, RetList, Acc) :-
	append(List, List, RetList),
	N is Acc + 1.
bin1(N, List, RetList, Acc) :-
	append(List, List, List1),	
	prefix(RetList, List1),
	NewAcc is Acc + 1,
	bin1(N, List1, RetList, NewAcc).




	