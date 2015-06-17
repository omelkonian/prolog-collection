:- lib(ic).
:- [diags].

% ARROW
% decode([1,1,10,11,10,1,1],[3,3,3,3,3,3,3,5,5,3,1],[0,0,1,2,3,3,3,4,3,4,3,3,2,4,0,0,0],[0,0,1,2,3,3,3,4,3,4,3,3,2,4,0,0,0]).

% INFINITY
% decode([4,4,3,3,4,4],[2,2,2,4,2,4,2,2,2],[0,2,1,0,2,1,5,5,1,2,0,1,2,0],[0,2,1,0,2,1,5,5,1,2,0,1,2,0]).

% PROLOG
% decode([13,10,14,10,13],[5,2,2,1,0,5,2,3,2,0,3,2,2,3,0,5,1,1,1,0,3,2,2,3,0,3,2,3,2],[1,1,1,2,2,2,3,1,4,2,1,4,2,1,1,3,4,2,2,1,0,2,2,1,1,2,4,2,1,2,2,1,0],[1,2,2,2,3,1,2,2,2,3,1,2,3,1,1,3,3,1,1,1,1,3,3,1,1,2,4,2,1,1,2,2,0]).


%--------------- UTILITIES ---------------
% Access array at given index.
accessAt(0, [H|_], H) :- !. 
accessAt(Index, [_|T], Ret) :-
	NewIndex is Index-1,
	accessAt(NewIndex, T, Ret).


% Converts the image from a list of rows to a list of columns
getColumns([Row|Rows], Columns) :-
	length(Row, X),
	length(Columns, X),
	length(Rows, RowLength),
	ColumnLength is RowLength + 1,
	getColumns1([Row|Rows], Columns, 0, ColumnLength).
getColumns1([], _, _, _).
getColumns1([Row|Rows], Columns, GlobalIndex, ColumnLength) :-
	mapRowToColumns(Row, Columns, 0, GlobalIndex, ColumnLength),
	NewGlobalIndex is GlobalIndex + 1,
	getColumns1(Rows, Columns, NewGlobalIndex, ColumnLength).		
mapRowToColumns([], _, _, _, _).
mapRowToColumns([H|T], Columns, Index, GlobalIndex, ColumnLength) :-
	accessAt(Index, Columns, Column),
	length(Column, ColumnLength),
	accessAt(GlobalIndex, Column, Elem),
	Elem = H,
	NewIndex is Index + 1,
	mapRowToColumns(T, Columns, NewIndex, GlobalIndex, ColumnLength).


% Create pattern for Y x X array.  
createImage(X, Y, Image) :-
	length(Image, Y),
	createImage1(X, Image).
createImage1(_, []).
createImage1(X, [Row|Rows]) :-
	length(Row, X),
	createImage1(X, Rows).


% Prints image on the console.
printImage([]).
printImage([Row|Rows]) :-
	printRow(Row),
	printImage(Rows).
printRow([]) :- writeln("").
printRow([H|T]):-
	printElem(H),
	printRow(T).
printElem(0) :- write('. ').
printElem(1) :- write('* ').
%-----------------------------------------

decode(RowSums, ColumnSums, DiagsDownSums, DiagsUpSums) :-
	% Get dimentions
	length(RowSums, Y),
	length(ColumnSums, X),
	% Initialize image
	createImage(X, Y, Image),

	% Row constraints
	constrain(Image, RowSums), 
	getColumns(Image, Columns),
	% Column constraints
	constrain(Columns, ColumnSums), 
	diags(Image, DiagsDown, DiagsUp),
	% Up diagonals constraints
	constrain(DiagsUp, DiagsUpSums), 
	% Down diagonals constraints
	constrain(DiagsDown, DiagsDownSums),  

	flatten(Image, FlatImage),
	FlatImage #:: [0,1],
	search(FlatImage, 0, input_order, indomain, complete, []),
	printImage(Image).

constrain([], []).
constrain([Head|Tail], [HeadSum|TailSums]) :-
	sum(Head) #= HeadSum,
	constrain(Tail, TailSums).
