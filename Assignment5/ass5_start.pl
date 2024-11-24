/* TOP LEVEL: QUERY/2

1st argument: a list of words that should make up a question
2nd argument: the answer to that question

Should fail if the question is ungrammatical or outside the range of the assignment (e.g. grammatical English, but not about families). For yes/no questions, it should succeed if the answer is "yes", fail if "no". 

Examples:

?- query([is,it,true,that,homer,is,the,father,of,lisa],_).
true .

?- query([who,is,the,father,of,lisa],Ans).
Ans = homer.

*/

query(Question, _) :-
  yesnoquestion(Question, []).

query(Question, Answer) :-
  whoisquestion(Answer, Question, []).

/* THE GRAMMAR

This is a DCG (Definite Clause Grammar). 

*/

yesnoquestion --> [is,it,true,that], sentence(Q), {Q}.

sentence(Q) --> person(X), [is,the], relation(Y), [of], person(Z), {=..(Q, [Y,X,Z])}.

whoisquestion(Answer) --> [who, is, the], relation(X), [of], person(Y), {=..(Q, [X,Answer,Y]), Q}.

person(homer) --> [homer].
person(lisa) --> [lisa].
person(bart) --> [bart].

relation(father) --> [father].
relation(mother) --> [mother].

/* THE DEFINITIONS

For example: X is Y's father if X is the parent of Y and X is male.

*/

father(X,Y) :-
  parent(X,Y),
  gender(X, male).

mother(X,Y) :-
    parent(X,Y),
    gender(X, female).

sibling(X,Y) :-
    parent(Z,X),
    parent(Z,Y).

brother(X,Y) :-
    sibling(X,Y),
    gender(X, male).

sister(X,Y) :-
    sibling(X,Y),
    gender(X, female).

son(X,Y) :-
    parent(Y,X),
    gender(X, male).

daughter(X,Y) :-
    parent(Y,X),
    gender(X, female).

child(X,Y) :-
    parent(Y,X).

aunt(X,Y) :-
    parent(Parent, Y),
    sister(X, Parent).

uncle(X,Y) :-
    parent(Parent, Y),
    brother(X, Parent).

nibling(X,Y) :-
    parent(Parent, X),
    sibling(Parent, Y).

niece(X,Y) :-
    nibling(X,Y),
    gender(X, female).

nephew(X,Y) :-
    nibling(X,Y),
    gender(X, male).

grandparent(X,Y) :-
    parent(Parent, Y),
    parent(X, Parent).

grandmother(X,Y) :-
    grandparent(X,Y),
    gender(X, female).

grandfather(X,Y) :-
    grandparent(X,Y),
    gender(X, male).

grandchild(X,Y) :-
    grandparent(Y,X).

grandson(X,Y) :-
    granchild(X,Y),
    gender(X, male).

granddaughter(X,Y) :-
    grandchild(X,Y),
    gender(X, female).

husband(X,Y) :-
    spouse(X,Y),
    gender(X, male).

wife(X,Y) :-
    spouse(X,Y),
    gender(X, female).

/* THE FACTS

These are all the true statements about basic relationships.

*/

gender(abe, male).
gender(bart, male).
gender(clancy, male).
gender(herb, male).
gender(homer, male).
gender(jacqueline, female).
gender(lisa, female).
gender(maggie, female).
gender(marge, female).
gender(mona, female).
gender(patty, female).
gender(selma, female).
parent(abe, herb).
parent(abe, homer).
parent(clancy, marge).
parent(clancy, patty).
parent(clancy, selma).
parent(homer, bart).
parent(homer, lisa).
parent(homer, maggie).
parent(jacqueline, marge).
parent(jacqueline, patty).
parent(jacqueline, selma).
parent(marge, bart).
parent(marge, lisa).
parent(marge, maggie).
parent(mona, herb).
parent(mona, homer).
parent(selma, ling).
spouse(clancy, jacqueline).
spouse(homer, marge).
spouse(jacqueline, clancy).
spouse(marge, homer).
