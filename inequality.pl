:- lib(fd).

constrain(X, Y, Z) :-
	[X, Y, Z] :: 0..9,
	X #> Y,
	Y #> Z,
	Z #> X,
	labeling([X, Y, Z]).