last([X], X).
last([_|L], Y) :-
	last(L, Y).

% Gets item of the list at given index(starting from 1).
getByIndex([X|_], 1, X).
getByIndex([_|L], Index, Ret) :-
	Index =< length(L) + 1,
	Index > 1,
	NewIndex is Index - 1,
	getByIndex(L, NewIndex, Ret).

% Accumulates elements starting from <ListIndex, ItemIndex> and traversing the matrix diagonically downwards.
accumulateFrom(Matrix, ListIndex, ItemIndex, Ret) :-
	ListIndex =< length(Matrix),
	getByIndex(Matrix, ListIndex, List),
	ItemIndex =< length(List),
	getByIndex(List, ItemIndex, Item),
	NewListIndex is ListIndex + 1,
	NewItemIndex is ItemIndex + 1,
	accumulateFrom(Matrix, NewListIndex, NewItemIndex, NewRet),
	append([Item], NewRet, Ret).
accumulateFrom(Matrix, ListIndex, ItemIndex, []) :-
	ListIndex =< length(Matrix),
	getByIndex(Matrix, ListIndex, List),
	ItemIndex > length(List).
accumulateFrom(Matrix, ListIndex, _, []) :-
	ListIndex > length(Matrix).

% Check if input is valid.
check([Row|Rows]) :- 
	length(Row, L),
	check1(Rows, L).

check1([], _).
check1([Row|Rows], L) :-		
	length(Row, L),
	check1(Rows, L).

diags(Matrix, DiagsDown, DiagsUp) :-
	check(Matrix), !,
	diagsDown(Matrix, DiagsDown),
	diagsUp(Matrix, DiagsUp).

diags(_, _, _) :-
	write("Rows are not even-lengthed!"), nl, fail.

% Performs two passes, the first one with elements starting in left side of the matrix
% and the second one with elements starting in top side of the matrix.
diagsDown(Matrix, DiagsDown) :-
	diagsDown1(Matrix, FirstPass),
	diagsDown2(Matrix, SecondPass),
	append(FirstPass, SecondPass, DiagsDown).

% First pass
diagsDown1(Matrix, Ret) :-
	L is length(Matrix),
	diagsDown1Rec(Matrix, [], L, Ret).
diagsDown1Rec(_, Acc, 1, Acc).
diagsDown1Rec(Matrix, Acc, ListIndex, Ret) :-
	ListIndex > 1,
	accumulateFrom(Matrix, ListIndex, 1, Res),
	NewListIndex is ListIndex - 1,
	append(Acc, [Res], NewAcc),	
	diagsDown1Rec(Matrix, NewAcc, NewListIndex, Ret).

% Second pass
diagsDown2(Matrix, Ret) :-
	diagsDown2Rec(Matrix, [], 1, Ret).
diagsDown2Rec(Matrix, Acc, ItemIndex, Acc) :-
	getByIndex(Matrix, 1, List),
	L is length(List) + 1,
	ItemIndex == L.
diagsDown2Rec(Matrix, Acc, ItemIndex, Ret) :-
	getByIndex(Matrix, 1, List),
	L is length(List) + 1,
	ItemIndex < L,
	accumulateFrom(Matrix, 1, ItemIndex, Res),
	NewItemIndex is ItemIndex + 1,
	append(Acc, [Res], NewAcc),	
	diagsDown2Rec(Matrix, NewAcc, NewItemIndex, Ret).

% Reverses all inner lists.
reverseInner(Matrix, Ret) :-
	reverseInner1(Matrix, [], Ret).
reverseInner1([], Acc, Acc).
reverseInner1([H|T], Acc, Ret) :-
	reverse(H, RevH),
	append(Acc, [RevH], NewAcc),
	reverseInner1(T, NewAcc, Ret).

% Utilizes diagsDown predicate to avoid rewriting many similar predicates.
diagsUp(Matrix, DiagsUp) :-
	reverse(Matrix, RevMatrix),
	diagsDown(RevMatrix, Result),
	reverseInner(Result, DiagsUp).