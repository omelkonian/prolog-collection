
subst_one(X, List, X2, NewList) :-
	index(Index, List, X),
	replace(Index, List, X2, NewList)
	;
	NewList = List.

subst_all(X, List, X2, NewList) :-
	findall(Index, index(Index, List, X), IndexList),
	(IndexList \= [], !,
	replaceAll(IndexList, List, X2, NewList)
	;
	NewList = List).


index(N, List, X) :-
	index1(1, N, List, X).
index1(N, N, [X|_], X).
index1(Cur, N, [_|T], X) :-
	NewCur is Cur + 1,
	index1(NewCur, N, T, X).

replace(N, List, X, NewList) :-
	rep1(1, N, List, X, NewList).
rep1(N, N, [_|T], X, [X|T]) :- !.
rep1(Cur, N, [Y|T], X, [Y|T2]) :-
	NewCur is Cur + 1,
	rep1(NewCur, N, T, X, T2).

replaceAll([], L, _, L).
replaceAll([Index|TIn], L, X, NewL) :-
	replace(Index, L, X, L2),
	replaceAll(TIn, L2, X, NewL).