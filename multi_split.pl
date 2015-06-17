multi_split(L, N, SL) :-
	length(SL, N),
	split(L, SL).

split([], []).
split(L, [H|T]) :-
	append(H, Rest, L),
	H \= [],
	split(Rest, T).
	
	