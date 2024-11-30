/* TOP LEVEL: QUERY/4

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

yesnoquestion --> [is,it,true,that], multiple_sentences(Q), {Q}.
yesnoquestion --> [is,it,true,that], sentence(Q), {Q}.

% Multiple sentences are a sentence seperated by "and", both of them have to be true
multiple_sentences(Q) --> sentence(Q),[and],multiple_sentences(Qs),{Q,Qs}.

% A multiple sentence can be a single sentence
multiple_sentences(Q) --> sentence(Q).

% base case of sentence
sentence(Q) --> person(X), [is,the], relation(Y), [of], person(Z), {=..(Q, [Y,X,Z])}.
sentence(Q) --> person(X), [is,a], relation(Y), {=..(Q, [Y,X,_])}.

sentence(Q) --> person(X), [has,a], relation(Y), {=..(Q, [Y,X,_])}.

sentence(Q) --> persons(PS), [are], relation(Y), {handle_plural(PS,Y,Q)}.

whoisquestion(Answer) --> [who, is, the], relation(X), [of], person(Y), {=..(Q, [X,Answer,Y]), Q}.

persons([P | PS]) --> person(P), persons(PS).
persons([P]) --> person(P).

person(homer) --> [homer].
person(lisa) --> [lisa].
person(bart) --> [bart].
person(maggie) --> [maggie].
person(marge) --> [marge].
person(patty) --> [patty].
person(selma) --> [selma].
person(ling) --> [ling].
person(clancy) --> [clancy].
person(jacqueline) --> [jacqueline].
person(herb) --> [herb].
person(abe) --> [abe].
person(mona) --> [mona].

relation(parent) --> [parent]. 
relation(parent) --> [creator].
relation(father) --> [father].
relation(father) --> [papa].
relation(mother) --> [mother].
relation(mother) --> [mama].
relation(sibling) --> [sibling].
relation(brother) --> [brother].
relation(brother) --> [bro].
relation(brother) --> [bruddah].
relation(sister) --> [sister].
relation(sister) --> [sis].
relation(son) --> [son].
relation(daughter) --> [daughter].

relation(child) --> [child].
relation(aunt) --> [aunt].
relation(aunt) --> [aunty].
relation(uncle) --> [uncle].
relation(uncle) --> [unc].
relation(niece) --> [niece].
relation(nephew) --> [nephew].
relation(nibling) --> [nibling].
relation(grandparent) --> [grandparent].
relation(grandmother) --> [grandmother].
relation(grandmother) --> [meemaw].
relation(grandmother) --> [grandma].
relation(grandmother) --> [granny].
relation(grandfather) --> [grandfather].
relation(grandchild) --> [grandchild].
relation(granddaughter) --> [granddaughter].
relation(grandson) --> [grandson].
relation(husband) --> [husband].
relation(husband) --> [hubby].
relation(wife) --> [wife].
relation(wife) --> [wifey].
relation(cousin) --> [cousin].
relation(spouse) --> [spouse].
relation(ancestor) --> [ancestor].
relation(descendant) --> [descendant].

/* THE DEFINITIONS

For example: X is Y's father if X is the parent of Y and X is male.

*/

handle_plural([P1, P2 | PS], Relation, Q) :-
    roles(Relation, [P1, P2 | PS], Q).

roles(_,[],[]).

roles(Rel, [HP | RP], [HQ | RQ]) :-
    HQ =.. [Rel, HP, _],
    roles(Rel,RP,RQ).

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
    sibling(Z, Parent),
    spouse(X,Z),
    gender(X, female).

aunt(X,Y) :-
    parent(Parent, Y),
    sister(X, Parent).

uncle(X,Y) :-
    parent(Parent, Y),
    sibling(Z, Parent),
    spouse(X,Z),
    gender(X, male).

uncle(X,Y) :-
    parent(Parent, Y),
    brother(X, Parent).

nibling(X,Y) :-
    parent(Parent, X),
    sibling(Z,Parent),
    spouse(Z,Y).

nibling(X,Y) :-
    parent(Parent, X),
    sibling(Parent, Y).

niece(X,Y) :-
    nibling(X,Y),
    gender(X, female).

nephew(X,Y) :-
    nibling(X,Y),
    gender(X, male).

cousin(X,Y) :-
    parent(Parent1, X),
    parent(Parent2, Y),
    sibling(Parent1, Parent2).

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

% Base case
% Your parent is your ancestor
ancestor(X, Y) :-
    parent(X, Y).

% If X is the ancestor of your parent, they are your ancestor
ancestor(X,Y) :-
    parent(Parent, Y),
    ancestor(X, Parent).

descendant(X,Y) :-
    parent(Y,X).

descendant(X,Y) :-
    parent(Y, Child),
    descendant(Child, Y).

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
gender(ling, female).

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


% tester
?- query([is,it,true,that,lisa,is,the,sibling,of,bart], _).
?- query([is,it,true,that,bart,is,the,brother,of,lisa], _).
?- query([is,it,true,that,lisa,is,the,sister,of,bart], _).
?- query([is,it,true,that,bart,is,the,son,of,homer], _).
?- query([is,it,true,that,lisa,is,the,daughter,of,marge], _).
?- query([is,it,true,that,maggie,is,the,child,of,homer], _).
?- query([is,it,true,that,marge,is,the,mother,of,bart], _).
?- query([is,it,true,that,patty,is,the,aunt,of,lisa], _).
?- query([is,it,true,that,herb,is,the,uncle,of,bart], _).
?- query([is,it,true,that,ling,is,the,niece,of,selma], _).
?- query([is,it,true,that,bart,is,the,nephew,of,patty], _).
?- query([is,it,true,that,bart,is,the,nibling,of,patty], _).
?- query([is,it,true,that,abe,is,the,grandparent,of,lisa], _).
?- query([is,it,true,that,jacqueline,is,the,grandmother,of,bart], _).
?- query([is,it,true,that,abe,is,the,grandfather,of,maggie], _).
?- query([is,it,true,that,bart,is,the,grandchild,of,jacqueline], _).
?- query([is,it,true,that,lisa,is,the,granddaughter,of,abe], _).
?- query([is,it,true,that,bart,is,the,grandson,of,abe], _).
?- query([is,it,true,that,homer,is,the,husband,of,marge], _).
?- query([is,it,true,that,marge,is,the,wife,of,homer], _).
?- query([is,it,true,that,ling,is,the,cousin,of,bart], _).


?- fail.
