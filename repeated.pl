repeated(L1, L2, N) :-
	nonvar(N),!,
	rep1(L1, L2, N)
	;
	rep2(L1, L2, 1, N).

rep1(L, L, 1).
rep1(L1, L2, N) :-	
	append(L1, L11, L2),
	L1 \= [],
	NewN is N - 1,
	rep1(L1, L11, NewN).

rep2(L1, L2, Cur, N) :-		
	append(L1, L11, L2),
	L1 \= [], L11 \= [],
	length(L1, Len1), length(L11, Len11), Len1 =< Len11,
	NewCur is Cur + 1,
	rep2(L1, L11, NewCur, N).
rep2(L, L, N, N).