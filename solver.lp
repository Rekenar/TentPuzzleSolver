row(1..row).
column(1..column).

{tent(X,Y) : row(X), column(Y), not tree(X,Y)}.


adjacentTree(X, Y, X1, Y) :- tent(X1, Y), row(X1), column(Y), X = X1+1.
adjacentTree(X, Y, X1, Y) :- tent(X1, Y), row(X1), column(Y), X = X1-1.
adjacentTree(X, Y, X, Y1) :- tent(X, Y1), row(X), column(Y1), Y = Y1+1.
adjacentTree(X, Y, X, Y1) :- tent(X, Y1), row(X), column(Y1), Y = Y1-1.

adjacentTent(X, Y, X1, Y) :- tent(X1, Y), row(X1), column(Y), X = X1+1.
adjacentTent(X, Y, X1, Y) :- tent(X1, Y), row(X1), column(Y), X = X1-1.
adjacentTent(X, Y, X, Y1) :- tent(X, Y1), row(X), column(Y1), Y = Y1+1.
adjacentTent(X, Y, X, Y1) :- tent(X, Y1), row(X), column(Y1), Y = Y1-1.

adjacentTent(X, Y, X1, Y1) :- tent(X1, Y1), row(X1), column(Y1), Y = Y1+1, X = X1+1.
adjacentTent(X, Y, X1, Y1) :- tent(X1, Y1), row(X1), column(Y1), Y = Y1-1, X = X1+1.
adjacentTent(X, Y, X1, Y1) :- tent(X1, Y1), row(X1), column(Y1), Y = Y1+1, X = X1-1.
adjacentTent(X, Y, X1, Y1) :- tent(X1, Y1), row(X1), column(Y1), Y = Y1-1, X = X1-1.


:- tree(X, Y), not adjacentTree(X, Y, _, _).

:- tent(X,Y), adjacentTent(X,Y,_,_).

:- columnCount(C, N), N != #count{X: tent(X,C)}.
:- rowCount(R, N), N != #count{Y: tent(R,Y)}.

#show tent/2.