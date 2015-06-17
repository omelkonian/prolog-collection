% --------------------- BASIC LIST PREDICATES ---------------
id(X, X).

append1([], L, L).
append1([X|L1], L2, [X|L3]) :-
	append1(L1, L2, L3).

sublist1(S, L) :-
	append1(_, L2, L),
	append1(S, _, L2).

member1(X, [X|_]).
member1(X, [_|T]) :-
	member1(X, T).

% --------------------- RULES --------------------------
rule1(L) :-
	sublist1([johan,_,_,_,_,_,_,antti], L).
rule1(L) :-
	sublist1([antti,_,_,johan], L).

rule2(L) :-
	sublist1([luis,_,_,_,_,_,_,_,_,johan], L).
rule2(L) :-
	sublist1([johan,luis], L).

rule3(L) :-
	sublist1([eric,_,_,_,_,_,_,jeroen], L).
rule3(L) :-
	sublist1([jeroen,_,_,eric], L).

rule4(L) :-
	sublist1([michel,_,_,_,_,_,jeroen], L).
rule4(L) :-
	sublist1([jeroen,_,_,_,michel], L).

rule5(L) :-
	sublist1([harris,_,_,_,_,_,_,_,eric], L).
rule5(L) :-
	sublist1([eric,_,harris], L).

rule6(L) :-
	sublist1([antti,_,_,_,_,_,_,_,wolfgang], L).
rule6(L) :-
	sublist1([wolfgang,_,antti], L).

rule7(L) :-
	sublist1([peter,_,_,_,_,_,_,wolfgang], L).
rule7(L) :-
	sublist1([wolfgang,_,_,peter], L).

% Used for filling up the table with any person that has not participated in any rules. 
allmembers(L) :-
	member1(antti, L),
	member1(eric, L),
	member1(harris, L),
	member1(jeroen, L),
	member1(johan, L),
	member1(luis, L),
	member1(michel, L),
	member1(peter, L),
	member1(wolfgang, L),
	member1(yanis, L).

% Simple main predicate. 
seats(L) :-
	id(L, [yanis,_,_,_,_,_,_,_,_,_]), % yanis as reference point(always head of the list)
	rule1(L),
	rule2(L),
	rule3(L),
	rule4(L),
	rule5(L),
	rule6(L),
	rule7(L),
	allmembers(L).

% Extended main predicate.
seats(R, L) :-
	id(L, [yanis,_,_,_,_,_,_,_,_,_]),
	seatsRec(R, L),
	allmembers(L).

seatsRec([], _).
seatsRec([1|R], L) :- 
	rule1(L),
	seatsRec(R, L).
seatsRec([2|R], L) :- 
	rule2(L), 
	seatsRec(R, L).
seatsRec([3|R], L) :- 
	rule3(L), 
	seatsRec(R, L).
seatsRec([4|R], L) :- 
	rule4(L), 
	seatsRec(R, L).
seatsRec([5|R], L) :- 
	rule5(L), 
	seatsRec(R, L).
seatsRec([6|R], L) :- 
	rule6(L), 
	seatsRec(R, L).
seatsRec([7|R], L) :- 
	rule7(L), 
	seatsRec(R, L).


%----------------------BONUS 1----------------------

ruleB1_1(L) :-
	sublist1([yanis,_,_,_,_,_,_,_,_,harris], L).
ruleB1_2(L) :-
	sublist1([antti,_,_,_,_,_,_,jeroen], L).
ruleB1_3(L) :-
	sublist1([johan,_,_,_,_,luis], L).
ruleB1_4(L) :-
	sublist1([michel,_,_,peter], L).
ruleB1_5(L) :-
	sublist1([eric,wolfgang], L).

seatsB1(L) :-
	id(L, [yanis,_,_,_,_,_,_,_,_,_]),
	ruleB1_1(L),
	ruleB1_2(L),
	ruleB1_3(L),
	ruleB1_4(L),
	ruleB1_5(L).

%----------------------BONUS 2----------------------

ruleB2_1(L) :-
	sublist1([yanis,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,jeroen], L).
ruleB2_2(L) :-
	sublist1([hans,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,johan], L). 
ruleB2_3(L) :-
	sublist1([harris,_,_,_,_,_,_,_,_,_,_,_,_,_,_,maris], L).
ruleB2_4(L) :-
	sublist1([antti,_,_,_,_,_,_,_,_,_,_,_,_,michel], L).
ruleB2_5(L) :-
	sublist1([wolfgang,_,_,_,_,_,_,_,_,_,_,michael], L).
ruleB2_6(L) :-
	sublist1([pier,_,_,_,_,_,_,_,_,janis], L).
ruleB2_7(L) :-
	sublist1([rimantas,_,_,_,_,_,_,pierre], L).
ruleB2_8(L) :-
	sublist1([edward,_,_,_,_,eric], L).
ruleB2_9(L) :-
	sublist1([maria,_,_,peter], L).
ruleB2_10(L) :-
	sublist1([dusan,luis], L).

seatsB2(L) :-
	id(L, [yanis,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]),
	ruleB2_1(L),
	ruleB2_2(L),
	ruleB2_3(L),
	ruleB2_4(L),
	ruleB2_5(L),
	ruleB2_6(L),
	ruleB2_7(L),
	ruleB2_8(L),	
	ruleB2_9(L),
	ruleB2_10(L).

% -----------MININUM RULES ALGORITHM-----------------
%
%	Given N people, where n is an even number, the minimum number of rules for having only one possible ordering
%	is N/2 and we construct them by doing the following:
%	
%	1. Pick one of them as the reference point (number 1), representing the round table as a list with him as its head.
%	2. Order all others randomly from 2 to N.
%   3. Construct N/2 rules where 
%		rule i := i sits (N - 2*i + 1) rightwards from (N - i + 1)
%   4. Now we have only one possible arrangement in the round table.
%
%	If N is an odd number, we just apply the above algorithm for N-1, and the Nth person will only have one 
%	possible position. Therefore floor(N/2) rules are sufficient.