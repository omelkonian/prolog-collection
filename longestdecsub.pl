longestdecsub(List, Sub) :-
	sub1(List, Sub), length(Sub, L),
	not (sub1(List, Sub2), length(Sub2, L2), L2 > L).

sub1(List, Sub) :-
	inorder(List, Sub), descending(Sub).

inorder(_, []).
inorder(List, [H|T]) :-
	take(H, List, Rest),
	inorder(Rest, T).

descending([]).
descending([_]).
descending([X,Y|T]) :-
	X > Y, descending([Y|T]).

take(X, List, Rest) :-
	append(_, [X|Rest], List). 