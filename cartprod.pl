cartprod(Set1, Set2, Set3, CP) :-
	findall([X,Y,Z], take(Set1, Set2, Set3, [X,Y,Z]), CP).

take(S1, S2, S3, [X,Y,Z]) :-
	member(X, S1),
	member(Y, S2),
	member(Z, S3).