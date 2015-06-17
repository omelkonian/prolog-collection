:- lib(fd).

numpart(N, A, B) :-
	length(Sol, N), Sol :: 1..N,	
	append(A, B, Sol),
	A = [First|_], First #= 1,
	ordered(A), ordered(B),	
	length(A, L), length(B, L),
	alldifferent(Sol),
	getSum(A, SA), getSum(B, SB), SA #= SB,
	getSum2(A, SA2), getSum2(B, SB2), SA2 #= SB2,
	labeling(Sol).

getSum([], 0).
getSum([H|T], H + X) :-
	getSum(T, X).

getSum2([], 0).
getSum2([H|T], H*H + X) :-
	getSum2(T, X).

ordered([]).
ordered([_]).
ordered([X,Y|T]) :-
	X #< Y,
	ordered([Y|T]).