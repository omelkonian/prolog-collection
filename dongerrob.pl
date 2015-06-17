:- lib(ic).
:- lib(ic_global).

dongerrob(Solution) :-
   Solution = [D, O, N, A, L, G, E, R, B, T],
   Solution #:: 0..9,
   D #\= 0,
   G #\= 0,
   R #\= 0,
   ic_global:alldifferent(Solution),
   100000 * D + 10000 * O + 1000 * N + 100 * A + 10 * L + D +
      100000 * G + 10000 * E + 1000 * R + 100 * A + 10 * L + D #=
      100000 * R + 10000 * O + 1000 * B + 100 * E + 10 * R + T,
   search(Solution, 0, first_fail, indomain_middle, complete, []),
   write(D), write(O), write(N), write(A), write(L), write(D),
   write(' + '),
   write(G), write(E), write(R), write(A), write(L), write(D),
   write(' = '),
   write(R), write(O), write(B), write(E), write(R), write(T).

