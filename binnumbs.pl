binnumbs(N, L) :-
	length(L, N),
	populate(L).
populate([]).
populate([H|T]) :-
	(H=0; H=1),
	populate(T).