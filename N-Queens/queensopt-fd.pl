:- set_flag(print_depth, 1000).

:- lib(fd).

queensopt(N, Solution, Cost) :-
   length(Solution, N),
   Solution :: 1..N,
   constrain(Solution, CostList, 1),
   min_max(generate(Solution), CostList),
   max(CostList, Cost).

constrain([], [], _).
constrain([X|Xs], [2*K-X, X-2*K|CostList], K) :-
   noattack(X, Xs, 1),
   K1 is K + 1,
   constrain(Xs, CostList, K1).

noattack(_, [], _).
noattack(X, [Y|Ys], M) :-
   X ## Y,
   X ## Y-M,
   X ## Y+M,
   M1 is M+1,
   noattack(X, Ys, M1).

generate([]).
generate(L) :-
   deleteff(X, L, R),
   indomain(X),
   generate(R).
