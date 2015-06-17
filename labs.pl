:- lib(fd).

% Access array at given index.
accessAt(0, [H|_], H) :- !. 
accessAt(Index, [_|T], Ret) :-
	NewIndex is Index-1,
	accessAt(NewIndex, T, Ret).

% Calculates k-order autocorrelation of given sequence 
calculateCk(Sequence, K, Result) :-
	calculateCk1(Sequence, K, 0, 0, Result).
calculateCk1(Sequence, K, Index, Result, Result) :-
	length(Sequence, N),
	Index > N - K - 1,
	!.
calculateCk1(Sequence, K, Index, Accu, Result) :-
	accessAt(Index, Sequence, Elem1),
	Index2 is Index + K,
	accessAt(Index2, Sequence, Elem2),
	NewAccu #= Accu + (Elem1 * Elem2),
	NewIndex is Index + 1,
	calculateCk1(Sequence, K, NewIndex, NewAccu, Result).

% Calculates overall autocorrelation of given sequence
calculateAC(Sequence, Result) :-
	calculateAC1(Sequence, 1, 0, Result).
calculateAC1(Sequence, Order, Result, Result) :-
	length(Sequence, N),
	Order > N - 1,
	!.
calculateAC1(Sequence, Order, Accu, Result) :-
	calculateCk(Sequence, Order, Result1),
	NewAccu #= Accu + (Result1 * Result1),
	NewOrder is Order + 1,
	calculateAC1(Sequence, NewOrder, NewAccu, Result).

% CSP
labs(N, Solution, Cost) :-
	length(Solution, N),
	Solution :: [1,-1],
	calculateAC(Solution, Cost1),
	Cost #= Cost1,
	min_max(generate(Solution), Cost).

generate([]).
generate(L) :-
   deleteff(X, L, R),
   indomain(X),
   generate(R).
