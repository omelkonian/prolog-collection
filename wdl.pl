:- lib(fd).

wdl(P, M, WDL) :-
	WDL = W/D/L,
	[W,D,L] :: 0..P,
	
	getSum([W,D,L], Sum),	
	constrainWins(W, P, WP),
	constrainDraws(D, P, DP),

	Sum #= M,
	WP + DP #= P,

	labeling([W,D,L]).

constrainWins(W, 0, WP) :- !,
	W #= 0 #=> WP #= 0.
constrainWins(W, Cur, WP) :-
	W #= Cur #=> WP #= Cur*3,
	NewCur is Cur - 1,
	constrainWins(W, NewCur, WP).
constrainDraws(D, 0, DP) :- !,
	D #= 0 #=> DP #= 0.
constrainDraws(D, Cur, DP) :-
	D #= Cur #=> DP #= Cur,
	NewCur is Cur - 1,
	constrainDraws(D, NewCur, DP).
getSum([], 0).
getSum([H|T], H + X) :-
	getSum(T, X).