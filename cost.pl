:- lib(fd).

cost(X1, X2, X3, X4) :-
	[X1,X2,X3,X4] :: 1..711,
	X1+X2+X3+X4 #= 711,
	X1*X2*X3*X4 #= 711000000,
	labeling([X1,X2,X3,X4]).