p(a,c).
p(b,c).
p(X,X).
p(X,Y):-p(Y,X).
p(X,Z):-p(X,Y),p(Y,Z).