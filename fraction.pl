:- lib(fd).

fraction(Sol) :-
	Sol = [A,B,C,D,E,F,G,H,I],
	Sol :: 1..9,
	alldifferent(Sol),

	A #< D, D #< G, % to cut off symmetrical solutions

	X #= C + 10*B,
	Y #= F + 10*E,
	Z #= I + 10*H,

	X1 #= A*100/X,	
	Y1 #= D*100/Y,
	Z1 #= G*100/Z,

	X1 + Y1 + Z1 #= 100,

	labeling(Sol).