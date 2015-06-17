:- lib(fd).
:- [stable_data].

/* ------------------------ TIME MEASUREMENTS -----------------------

	                ______		 _______________
					|SIZE| 		 |RUN_TIME(sec)|
					------ 		 ---------------
					  10           	0.00
					  20			0.05					 
					  30			0.19					 
					  40			0.47
					  50			1.19	
					  60           	2.44
					  80			8.88
					  100			24.53
					  120			53.33
					  140			110.3
					  160			198.9
					  180			358.5
					  200			...
					  250			...					  
*/

% -------------------------- UTILITIES ----------------------------

% Convert solution to required output format.
constructSolution([], [], []).
constructSolution([Man|Men], [Woman|Women], [Man-Woman|Marriages]) :-
	constructSolution(Men, Women, Marriages).

% For each husband-solution tuple, check all possible wife-solution tuples.
iterateHusbands([], [], _, _).
iterateHusbands([Man|Men], [ManSol|MenSol], Women, WomenSol) :-
	% Iterate wives with fixed man-solution tuple.
	iterateWives(Women, WomenSol, Man, ManSol),
	% Continue with others.
	iterateHusbands(Men, MenSol, Women, WomenSol).

% For each wife-solution tuple, express constraints based on given husband-solution tuple.
iterateWives([], [], _, _).
iterateWives([Woman|Women], [WomanSol|WomenSol], Man, ManSol) :-
	% Stabilize.
	stabilize(Man, Woman, WomanSol, ManSol),
	% Continue with others.
	iterateWives(Women, WomenSol, Man, ManSol).

% -------------------------- CONSTRAINTS ----------------------------

% Creates constraints for two domain variables, based on given instantiated man and woman.
stabilize(Man, Woman, WomanSol, ManSol) :-
	% Get prefer lists.
	prefers(Man, ManPreferList),
	prefers(Woman, WomanPreferList),

	% Get indices of Woman and current solution in Man's prefer list.
	element(WomanIndex,ManPreferList,Woman),
	element(ManSolIndex,ManPreferList,ManSol),	
	% Get indices of Man and current solution in Woman's prefer list.
	element(ManIndex,WomanPreferList,Man),
	element(WomanSolIndex,WomanPreferList,WomanSol),	

	% If Man prefers Woman more than current solution, contrain 
	% Woman to prefer her current solution more than Man.
	WomanIndex #< ManSolIndex #=> WomanSolIndex #< ManIndex,
	% If Woman prefers Man more than current solution, constrain 
	% Man to prefer his current solution more than Woman.
	ManIndex #< WomanSolIndex #=> ManSolIndex #< WomanIndex,

	% Marry the two solutions.
	WomanSol #= Man #<=> ManSol #= Woman.

% ----------------------------- CSP --------------------------------------

stable(Couples) :-		
	men(Men), 
	women(Women),		
	length(Men, N), 

	length(MenSol, N),
	MenSol :: Women,	
	alldifferent(MenSol),

	length(WomenSol, N),
	WomenSol :: Men,	
	alldifferent(WomenSol),

	iterateHusbands(Men, MenSol, Women, WomenSol),

	append(MenSol, WomenSol, AllSol),
	labeling(AllSol),

	length(Couples, N),
	constructSolution(Men, MenSol, Couples).





