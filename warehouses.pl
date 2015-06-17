:- set_flag(print_depth, 1000).
:- lib(fd).
:- [warehouses_data].

% ------------------ UTILITIES -----------------
% Returns trimmed matrix, according to given size N
submatrix(Initial, Trimmed, N) :-
	length(Trimmed, N),
	submatrix1(Initial, Trimmed).		
submatrix1(_, []) :- !.
submatrix1([H|T], [H2|T2]) :-
	H = H2,
	submatrix1(T, T2).
% Get sub-matrix of building costs.
buildCosts(N1, BuildCosts) :-
	fixedcosts(FixedCosts),
	submatrix(FixedCosts, BuildCosts, N1).
% Get sub-matrix of service costs.
serviceCosts(N1, M1, ServiceCosts) :-
	varcosts(VarCosts),
	submatrix(VarCosts, AllServiceCosts, M1),
	length(ServiceCosts, M1),
	serviceCosts1(N1, AllServiceCosts, ServiceCosts).
serviceCosts1(_, [], []) :- !.
serviceCosts1(N1, [H|T], [H2|T2]) :-
	submatrix(H, H2, N1),
	serviceCosts1(N1, T, T2).

% ------------------ COST -----------------
% Calculates cost of building the warehouse.
calculateBuildCost(YesNoLocs, Cost) :-
	length(YesNoLocs, N),
	buildCosts(N, BuildCosts),
	calculateBuildCost1(YesNoLocs, BuildCosts, 0, Cost).
calculateBuildCost1([], _, Cost, Cost).
calculateBuildCost1([H|T], [B|T2], CurrentCost, Cost) :-
	Temp #= B * H,
	NewCost #= CurrentCost + Temp,	
	calculateBuildCost1(T, T2, NewCost, Cost). 
% Calculates cost of servicing the customers.
calculateServiceCost(N, CustServs, Cost, YesNoLocs) :-
	length(CustServs, M),
	serviceCosts(N, M, ServiceCosts),
	calculateServiceCost1(CustServs, ServiceCosts, 0, Cost, YesNoLocs).
calculateServiceCost1([], _, Cost, Cost, _).
calculateServiceCost1([N|T], [SerCost|T2], CurrentCost, Cost, YesNoLocs) :-
	element(N, SerCost, AddCost),
	NewCost #= CurrentCost + AddCost,	
	calculateServiceCost1(T, T2, NewCost, Cost, YesNoLocs). 
% Calculates total cost.
calculateCost(N, YesNoLocs, CustServs, Cost) :-
	calculateBuildCost(YesNoLocs, Cost1),		
	calculateServiceCost(N, CustServs, Cost2, YesNoLocs),
	Cost #= Cost1 + Cost2.


% ------------------ CONSTRAINTS -----------------
% Cross-constrains
crossconstrains(_, [], _) :- !.
crossconstrains(WarehouseIndex, [H1|YesNoLocs], CustServs) :-
	produceConstrains(H1, CustServs, WarehouseIndex),
	NewWarehouseIndex is WarehouseIndex + 1,
	crossconstrains(NewWarehouseIndex, YesNoLocs, CustServs).
produceConstrains(H1, [], _) :- !.
produceConstrains(H1, [H2|CustServs], Index) :-
	H1 #= 0 #=> H2 ## Index,
	%% H2 #= Index #=> H1 #= 1,
	produceConstrains(H1, CustServs, Index).

% ------------------ CSP -----------------
warehouses(0, 0, YesNoLocs, CustServs, Cost) :-
	!, warehouses(20, 40, YesNoLocs, CustServs, Cost). 
warehouses(0, M1, YesNoLocs, CustServs, Cost) :-
	!, warehouses(20, M1, YesNoLocs, CustServs, Cost).
warehouses(N1, 0, YesNoLocs, CustServs, Cost) :-
	!, warehouses(N1, 0, YesNoLocs, CustServs, Cost).
warehouses(N1, M1, YesNoLocs, CustServs, Cost) :-
	length(YesNoLocs, N1),
	length(CustServs, M1),
	YesNoLocs :: [0, 1],
	CustServs :: 1..N1,
	ConstrainZeros is N1 - 1,
	atmost(ConstrainZeros, YesNoLocs, 0),	
	crossconstrains(1, YesNoLocs, CustServs),
	calculateCost(N1, YesNoLocs, CustServs, Cost),
	minimize(generateAll(YesNoLocs, CustServs), Cost).

generateAll(YesNoLocs, CustServs) :-
	generate(YesNoLocs),
	generate(CustServs).
generate([]).
generate(L) :-
   deleteff(X, L, R),
   indomain(X),
   generate(R).

