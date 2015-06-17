reduce(Expr, Reduced) :-
	toList(Expr, List),

	% Get product of numbers
	findall(X, (member(X, List), integer(X)), Nums),
	product(Nums, Prod),
	NumProduct is Prod,

	% Get variables 
	(setof(Var1, member(Var1 ^ _, List), VarList1),!
		;
	 VarList1 = []),
	(setof(Var2, (member(Var2, List), atom(Var2)), VarList2),!
		;
	 VarList2 = []),
	append(VarList1, VarList2, VarList),
	
	% Get each variable's total power
	varProduct(VarList, VarProduct, List),

	Reduced = NumProduct * VarProduct.

	


varProduct([], 1, _).
varProduct([Var|Vars], Result * Rest, ExprList) :-	
	findall(Var, member(Var, ExprList), SingleList),
	findall(Power, member(Var ^ Power, ExprList), PowerList),
	length(SingleList, Len),
	mysum(PowerList, Sum1),
	TotalPower is Len + Sum1,
	Result = Var ^ TotalPower,
	varProduct(Vars, Rest, ExprList).

mysum(List, Sum) :-
	sum1(List, Sum1),
	Sum is Sum1.
sum1([], 0).
sum1([H|T], H + Rest) :-
	sum1(T, Rest).
product([], 1).
product([H|T], H * Rest) :-
	product(T, Rest).
toList(Op1 * Op2, [Op2|Rest]) :-
	!, toList(Op1, Rest).
toList(Op, [Op]).
