#const row=8.
#const column=8.

tree(1, 3).
tree(2, 5).

tree(2, 7).

tree(3, 1).

tree(4, 4).

tree(4, 6).
tree(4, 7).

tree(5, 2).
tree(5, 7).

tree(8, 3).
tree(8, 6).

tree(8, 7).


columnCount(1, 1).
columnCount(2, 2).
columnCount(3, 1).
columnCount(4, 1).
columnCount(5, 1).
columnCount(6, 3).
columnCount(7, 1).
columnCount(8, 2).


rowCount(1, 2).
rowCount(2, 1).
rowCount(3, 1).
rowCount(4, 2).
rowCount(5, 2).
rowCount(6, 1).
rowCount(7, 1).
rowCount(8, 2).


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