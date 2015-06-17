:-lib(fd).

guessscores(M, P, FG-AG, Sol) :-
	length(Sol, M),
	create(Sol, FG, AG),	
	consAG(Sol, AG2, 0), AG2 #= AG,
	consFG(Sol, FG2, 0), FG2 #= FG,
	getPoints(Sol, Points, 0), Points #= P,
	generate(Sol).


getPoints([], P, P).
getPoints([X-Y|T], P, Acc) :-
	X #= Y #=> NewAcc #= Acc + 1,
	X #> Y #=> NewAcc #= Acc + 3,
	X #< Y #=> NewAcc #= Acc,
	getPoints(T, P, NewAcc).

consFG([], FG, FG).
consFG([X-_|T], FG, Acc) :-
	NewAcc #= Acc + X,
	consFG(T, FG, NewAcc).
consAG([], AG, AG).
consAG([_-X|T], AG, Acc) :-
	NewAcc #= Acc + X,
	consAG(T, AG, NewAcc).

create([], _, _).
create([X-Y|T], FG, AG) :-
	X :: 0..FG,
	Y :: 0..AG,
	create(T, FG, AG).

generate([]).
generate([X-Y|T]) :-
	indomain(X),
	indomain(Y),	
	generate(T).