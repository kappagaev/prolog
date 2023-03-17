:- use_module(library(dcg/basics)).
main :- write('Hello World!'), nl.
loves(romeo, juliet).
loves(juliet, romeo) :- loves(romeo, juliet).
male(albert).
male(bob).
male(bill).
male(carl).
male(vlad).
female(alice).
female(julia).
female(kate).
happy(albert) :-
  male(albert).
parent(albert, bob).
parent(bob, carl).
parent(bob, bill).
% parent(albert, X), parent(X, Y). - grandchildren of bob
get_grandchild :-
  parent(albert, X),
  parent(X, Y),
  format('Albert grandchild is ~w~n', [Y]),
  nl.

grandparent(X, Y) :-
  parent(X, Z),
  parent(Z, Y).
what_grade(Other) :-
  Grade is Other - 5,
  format('Go to grade ~w~n', [Grade]).

owns(vlad, fruit(apple)).
owns(vlad, car(bmw)).
owns(vlad, car(mercedes)).
customer(tom, smith, 20.55).
customer(sally, smith, 120.55).
customer(sally, doe, 50.55).
vertical(line(point(X, Y), point(X, Y2))).

as --> "a",{write("hello")}.
bs --> [foo],{write("hello")}.
