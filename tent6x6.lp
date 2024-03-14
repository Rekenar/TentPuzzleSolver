#const row=6.
#const column=6.

tree(1, 3).
tree(2, 1).
tree(2, 4).
tree(3, 6).
tree(4, 5).
tree(5, 6).
tree(6, 3).

columnCount(1, 0).
columnCount(2, 1).
columnCount(3, 1).
columnCount(4, 2).
columnCount(5, 0).
columnCount(6, 3).


rowCount(1, 1).
rowCount(2, 2).
rowCount(3, 1).
rowCount(4, 1).
rowCount(5, 1).
rowCount(6, 1).

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