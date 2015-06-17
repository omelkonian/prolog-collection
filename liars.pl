:- lib(fd).


liars(Statements, Liars) :-
	length(Statements, Len),
	length(Liars, Len),
	Liars :: 0..1,
	getSum(Liars, LiarSum),	
	constrain(Liars, Statements, LiarSum),
	labeling(Liars).

constrain([], [], _).
constrain([L|Liars], [St|Statements], Sum) :-
	L #= 0 #=> Sum #>= St,
	L #= 1 #=> Sum #< St,
	constrain(Liars, Statements, Sum).

getSum([], 0).
getSum([H|T], H + X):-
	getSum(T, X).