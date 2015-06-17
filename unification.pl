unify(T1, T2) :-
	T1 = T2.

unifiable(T1, T2) :-
	not not T1 = T2.