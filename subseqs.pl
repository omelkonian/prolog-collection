takeFirst(1, [H|_], [H]).
takeFirst(N, [H|T], [H|Rest]) :-
	N > 1,
	NewN is N - 1,
	takeFirst(NewN, T, Rest).
subseqs(N, List, [List]) :-
	length(List, N), !.
subseqs(N, [H|T], [FirstN|Rest]) :-
	takeFirst(N, [H|T], FirstN),	
	subseqs(N, T, Rest).