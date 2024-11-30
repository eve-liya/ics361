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

% A yes no question can be made out of multiple sentences
yesnoquestion --> [is,it,true,that], multiple_sentences(Q), {Q}.

% yesnoquestion can also be 
yesnoquestion --> [is,it,true,that], sentence(Q), {Q}.

% Multiple sentences are a sentence seperated by "and", both of them have to be true
multiple_sentences(Q) --> sentence(Q),[and],multiple_sentences(Qs),{Q,Qs}.

% A multiple sentence can be a single sentence
multiple_sentences(Q) --> sentence(Q).

% base case of sentence

sentence(Q) --> 
    person(X), 
    [is, the], 
    relation(Rel, num=sing), 
    [of], 
    person(Y), 
    {=..(Q, [Rel, X, Y])}.

sentence(Q) --> 
    person(X), 
    [is, a], 
    relation(Rel, num=sing), 
    {=..(Q, [role,Rel, X, _])}.

sentence(Q) --> 
    person(X),
    [has, a],
    relation(Rel, num=sing), 
    {=..(Q, [Rel, _, X])}.

sentence(Q) --> 
    person(X), 
    [has], 
    relation(Rel, num=plur), 
    {=..(Q, [Rel, _, X])}.

sentence(Q) --> 
    people(XS, num=plur), 
    [are], 
    relation(Rel, num=plur),
    {=..(Q, [role,Rel,XS,_])}.

sentence(Q) -->
    people(XS, num=plur),
    [have],
    relation(Rel, num=plur),
    {=..(Q, [has_a,Rel,XS,_])}.

whoisquestion(Answer) --> [who, is, the], relation(X, num=sing), [of], person(Y), {=..(Q, [X,Answer,Y]), Q}.

people([P | PS], num=plur) --> person(P), [and], people(PS, num=_).
people([P], num=sing) --> person(P).  

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

relation(parent, num=sing) --> [parent].
relation(parent, num=plur) --> [parents].
relation(father, num=sing) --> [father].
relation(father, num=plur) --> [fathers].
relation(mother, num=sing) --> [mother].
relation(mother, num=plur) --> [mothers].
relation(child, num=sing) --> [child].
relation(child, num=plur) --> [children].
relation(sibling, num=sing) --> [sibling].
relation(sibling, num=plur) --> [siblings].
relation(ancestor, num=sing) --> [ancestor].
relation(ancestor, num=plur) --> [ancestors].
relation(descendant, num=sing) --> [descendant].
relation(descendant, num=plur) --> [descendants].
relation(grandparent, num=sing) --> [grandparent].
relation(grandparent, num=plur) --> [grandparents].
relation(grandfather, num=sing) --> [grandfather].
relation(grandfather, num=plur) --> [grandfathers].
relation(grandmother, num=sing) --> [grandmother].
relation(grandmother, num=plur) --> [grandmothers].
relation(uncle, num=sing) --> [uncle].
relation(uncle, num=plur) --> [uncles].
relation(aunt, num=sing) --> [aunt].
relation(aunt, num=plur) --> [aunts].
relation(nephew, num=sing) --> [nephew].
relation(nephew, num=plur) --> [nephews].
relation(niece, num=sing) --> [niece].
relation(niece, num=plur) --> [nieces].
relation(cousin, num=sing) --> [cousin].
relation(cousin, num=plur) --> [cousins].
relation(spouse, num=sing) --> [spouse].
relation(spouse, num=plur) --> [spouses].
relation(brother, num=sing) --> [brother].
relation(brother, num=plur) --> [brothers].
relation(sister, num=sing) --> [sister].
relation(sister, num=plur) --> [sisters].

% alternative terms
relation(father, num=sing) --> [papa].
relation(father, num=plur) --> [papas].
relation(mother, num=sing) --> [mama].
relation(mother, num=plur) --> [mamas].
relation(cousin, num=sing) --> [cuz].
relation(cousin, num=plur) --> [cuzs].
relation(uncle, num=sing) --> [unc].
relation(uncle, num=plur) --> [uncs].
relation(aunt, num=sing) --> [aunty].
relation(aunt, num=plur) --> [aunties].
relation(brother, num=sing) --> [bro].
relation(brother, num=plur) --> [bros].
relation(brother, num=sing) --> [bruddah].
relation(brother, num=plur) --> [bruddahs].
relation(sister, num=sing) --> [sis].
relation(sister, num=sing) --> [sistah].
relation(sister, num=plur) --> [sistahs].
relation(sister, num=plur) --> [sissies].
relation(grandfather, num=sing) --> [grandpa].
relation(grandfather, num=plur) --> [grandpas].
relation(grandmother, num=sing) --> [grandma].
relation(grandmother, num=plur) --> [grandmas].


/* THE DEFINITIONS

For example: X is Y's father if X is the parent of Y and X is male.

*/
role(_,[],[]).

role(Rel, [HP | RP], [HQ | RQ]) :-
    HQ =.. [Rel, HP, _],
    role(Rel,RP,RQ).

has_a(_,[],[]).

has_a(Rel, [HP | RP], [HQ | RQ]) :-
    HQ =.. [Rel, _, HP],
    role(Rel,RP,RQ).

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

% A descendent is a child or a descendant of a child.
descendant(Descendant, X) :-
  child(Descendant, X).

descendant(Descendant, X) :-
  child(Child, X),
  descendant(Descendant, Child).

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
