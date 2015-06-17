:- lib(fd).

sendmory1([S, E, N, D, M, O, R, Y]) :-
   [C1, C2, C3, C4] :: 0..1,
   [S, E, N, D, M, O, R, Y] :: 0..9,
   alldifferent([S, E, N, D, M, O, R, Y]),
   S ## 0,
   M ## 0,
   D + E #= Y + 10 * C1,
   C1 + N + R #= E + 10 * C2,
   C2 + E + O #= N + 10 * C3,
   C3 + S + M #= O + 10 * C4,
   C4 #= M,
   labeling([S, E, N, D, M, O, R, Y]).

sendmory2([S, E, N, D, M, O, R, Y]) :-
   [S, E, N, D, M, O, R, Y] :: 0..9,
   alldifferent([S, E, N, D, M, O, R, Y]),
   S ## 0,
   M ## 0,
   1000 * S + 100 * E + 10 * N + D + 1000 * M + 100 * O + 10 * R + E #=
      10000 * M + 1000 * O + 100 * N + 10 * E + Y,
   labeling([S, E, N, D, M, O, R, Y]).
