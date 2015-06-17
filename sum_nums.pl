sum_nums(L1, L2, L3) :-
	getNum(L1, N1),
	getNum(L2, N2),
	N3 is N1 + N2,
	getList(N3, L3).

getNum(L, N) :-
	reverse(L, R),
	get1(R, 0, N, 1).
get1([], N, N, _).
get1([H|T], Acc, N, Factor) :-
	NewAcc is Acc + H*Factor,
	NewFactor is Factor*10,
	get1(T, NewAcc, N, NewFactor).

getList(N, L) :-
	get2(N, 10, L1),
	write(L1),nl,
	reverse(L1, L).
get2(N, Factor, []) :-
	Factor > N*10,
	!.
get2(N, Factor, [H|T]) :-
	H1 is N mod Factor,
	F1 is Factor div 10,
	H is H1 div F1,
	NewFactor is Factor*10,
	get2(N, NewFactor, T).
/*
reverse([],[]).
reverse([H|T], Rev) :-
	reverse(T, R),
	append(R, [H], Rev).
*/