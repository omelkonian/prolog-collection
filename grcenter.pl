grcenter(Graph, Center) :-
	setof(X, center(X, Graph), Center).

center(X, graph(Nodes, Edges)) :-
	member(X, Nodes),
	eccentricity(X, Ecc1, graph(Nodes,Edges)),
	not (member(Y, Nodes),
		eccentricity(Y, Ecc2, graph(Nodes, Edges)),
		Ecc2 < Ecc1).

eccentricity(X, Ecc, graph(Nodes,Edges)) :-
	member(Y1, Nodes),	
	minpath(X, Y1, Ecc, Edges),
	not (member(Y2, Nodes),
		minpath(X, Y2, Dist2, Edges),
		Dist2 > Ecc).	

path(X, Y, Dist, Edges) :-
	path1(X, Y, 1, Dist, Edges).
path1(X, Y, Acc, Acc, Edges) :-
	adjacent(X, Y, Edges), !.
path1(X, Y, Acc, Dist, Edges) :-
	adjacent(X, Z, Edges),
	NewAcc is Acc + 1,
	length(Edges, Len),
	NewAcc =< Len,
	path1(Z, Y, NewAcc, Dist, Edges).

minpath(X, Y, Dist, Edges) :-
	path(X, Y, Dist, Edges),
	not (path(X,Y,Dist2,Edges),
		Dist2 < Dist).

adjacent(X, Y, Edges) :-
	member(X-Y, Edges)
	;
	member(Y-X, Edges).