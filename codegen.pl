%------------LIST OPERATIONS---------------
getAt(1, [H|_], H) :- !.
getAt(Index, [_|T], X) :-
	NewIndex is Index - 1,
	getAt(NewIndex, T, X).

setAt(1, NewItem, [_|T1], [NewItem|T1]) :- !.
setAt(Index, NewItem, [H|T1], [H|T2]) :-
	NewIndex is Index - 1,
	setAt(NewIndex, NewItem, T1, T2).

listsEqual([],[]).
listsEqual([_|T1],[*|T2]) :- 
	listsEqual(T1, T2).
listsEqual([H|T1],[H|T2]) :- 
	listsEqual(T1, T2).

sublist([], _).
sublist([X|Sub], List) :-
	member(X, List),
	sublist(Sub, List).

%---------------------------------------------

% Returns all registers in a list(numbered 1-N).
getRegisterList(RegisterNo, Registers) :-
	getRegisterList1(RegisterNo, Ret),
	reverse(Ret, Registers).
getRegisterList1(0, []) :- !.
getRegisterList1(RegisterNo, [H|T]) :-
	H = RegisterNo,
	NewRegisterNo is RegisterNo - 1,
	getRegisterList1(NewRegisterNo, T).

% Returns a list with all possible move operations on the given registers.
getAllPossibleMoves(RegisterNo, Moves) :-
	getRegisterList(RegisterNo, Registers),
	length(Registers, L),
	length(Moves, L),
	getAllPossibleMoves1(Registers, Moves).

getAllPossibleMoves1([], _) :- !.
getAllPossibleMoves1([Register|Registers], [move(Register)|Moves]) :-
	getAllPossibleMoves1(Registers, Moves).

% Returns a list with all possible swap operations on the given registers.
getAllPossibleSwaps(RegisterNo, Swaps) :-
	getRegisterList(RegisterNo, Registers),
	length(Registers, L),
	SwapLength is div(L*(L-1), 2),
	length(Swaps, SwapLength),
	getAllPossibleSwaps1(Registers, Swaps).

getAllPossibleSwaps1([_], []) :- !.
getAllPossibleSwaps1([Register|Registers], Swaps) :-
		length(Registers, LR),
		length(Swaps1, LR),
		addSwaps(Register, Registers, Swaps1),
		getAllPossibleSwaps1(Registers, Swaps2),
		append(Swaps1, Swaps2, Swaps).
addSwaps(_, [], _).
addSwaps(Register, [H|Registers], [swap(Register, H)|Swaps]) :- 
	addSwaps(Register, Registers, Swaps).

% Returns a list with all possible operations on the given registers (move + swap).
getAllPossibleOperations(RegisterNo, Operations) :-
	getAllPossibleMoves(RegisterNo, Moves),
	getAllPossibleSwaps(RegisterNo, Swaps),
	append(Moves, Swaps, Operations).


%----------------REGISTER OPERATIONS----------------
move(Index, Registers, NewRegisters) :-
	length(Registers, LR),
	Index == LR,
	!,
	getAt(Index, Registers, X),
	setAt(1, X, Registers, NewRegisters).
move(Index, Registers, NewRegisters) :-
	getAt(Index, Registers, X),
	NewIndex is Index + 1,
	setAt(NewIndex, X, Registers, NewRegisters).

swap(Index1, Index2, Registers, NewRegisters) :-
	getAt(Index1, Registers, X1),
	getAt(Index2, Registers, X2),
	setAt(Index1, X2, Registers, Registers1),
	setAt(Index2, X1, Registers1, NewRegisters).

applyOperations(Registers, [], Registers) :- !.
applyOperations(Registers, [move(I)|T], NewRegisters) :-
	move(I, Registers, Registers1),
	applyOperations(Registers1, T, NewRegisters).
applyOperations(Registers, [swap(I, J)|T], NewRegisters) :-
	swap(I, J, Registers, Registers1),
	applyOperations(Registers1, T, NewRegisters).

%-----------------------------------------------------

codegen(R1, R2, Operations) :-
	codegen1(R1, R2, Operations, 0).

codegen1(R1, R2, Operations, Length) :-
	length(R1, RegisterNo),
	length(Operations, Length),
	getAllPossibleOperations(RegisterNo, AllOperations),
	sublist(Operations, AllOperations),
	applyOperations(R1, Operations, NewR1),
	listsEqual(NewR1, R2),
	!.

codegen1(R1, R2, Operations, Length) :-
	NewLength is Length + 1,
	length(R1, L),
	MaxLength is div(L*(L-1), 2) + L,
	NewLength =< MaxLength,
	codegen1(R1, R2, Operations, NewLength).