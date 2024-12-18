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
yesnoquestion --> [is,it,true,that], multiple_sentences(Q), {evaluate_predicates(Q)}.

whoisquestion(Answer) --> [who, is, the], relation(X, num=sing), [of], person(Y), {=..(Q, [X,Answer,Y]), Q}.

% A single person
people([P], num=sing) --> person(P).  
% Will match a list of people, if it needs to be multiple it will only be plural
people([P | PS], num=plur) --> person(P), [and], people(PS, num=_).

% A multiple sentence can be a single sentence
multiple_sentences(Q) --> sentence(Q), {evaluate_predicates(Q)}.

% Multiple sentences are a sentence seperated by "and", both of them have to be true
multiple_sentences(Q) --> sentence(Q),[and],multiple_sentences(Qs),{evaluate_predicates(Q),evaluate_predicates(Qs)}.

% Given, X matches with person, we find the relation and then find Y
sentence(Q) --> 
    people(X, num=sing), 
    [is, the], 
    relation(Rel, num=sing), 
    [of], 
    people(Y, num=sing), 
    {is_the(Rel,X,Y,Q), evaluate_predicates(Q)}.

sentence(Q) --> 
    people(X, num=sing), 
    [is, a], 
    relation(Rel, num=sing), 
    {is_a(Rel,X,Q), evaluate_predicates(Q)}.

% same as above but with is a instead
sentence(Q) --> 
    people(X, num=sing),
    [has, a],
    relation(Rel, num=sing), 
    {has_a(Rel,X,Q), evaluate_predicates(Q)}.

% edge case, like bart has parents -> true
% i think has is special cus it can be single has plural "you have computers"
sentence(Q) --> 
    people(X, num=sing), 
    [has], 
    relation(Rel, num=plur), 
    {has_a(Rel,X,Q), evaluate_predicates(Q)}.

% gets multiple people, then since are, we call the is_a function to get a list of all the predicats, 
% then evaluate them to make sure they are all true
sentence(Q) --> 
    people(XS, num=plur), 
    [are], 
    relation(Rel, num=plur),
    {is_a(Rel,XS,Q), evaluate_predicates(Q)}.

% gets multiple people, then since have, we call the has_a function to get a list of all the predicats, 
% then evaluate them to make sure they are all true
sentence(Q) -->
    people(XS, num=plur),
    [have],
    relation(Rel, num=plur),
    {has_a(Rel,XS,Q), evaluate_predicates(Q)}.

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
relation(husband, num=sing) --> [husband].
relation(husbands, num=plur) --> [husbands].
relation(wife, num=sing) --> [wife].
relation(wife, num=plur) --> [wifes].
relation(child, num=sing) --> [child].
relation(child, num=plur) --> [children].
relation(daughter, num=sing) --> [daughter].
relation(daughter, num=plur) --> [daughters].
relation(son, num=sing) --> [son].
relation(son, num=plur) --> [sons].
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
relation(grandchild, num=sing) --> [grandchild].
relation(grandchild, num=plur) --> [grandchildren].
relation(grandson, num=sing) --> [grandson].
relation(grandson, num=plur) --> [grandsons].
relation(granddaughter, num=sing) --> [granddaughter].
relation(granddaughter, num=plur) --> [granddaughters].
relation(uncle, num=sing) --> [uncle].
relation(uncle, num=plur) --> [uncles].
relation(aunt, num=sing) --> [aunt].
relation(aunt, num=plur) --> [aunts].
relation(nibling, num=sing) --> [nibling].
relation(nibling, num=plur) --> [niblings].
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
is_a(_,[],[]).

is_a(Rel, [HP | RP], [HQ | RQ]) :-
    HQ =.. [Rel, HP, _],
    is_a(Rel,RP,RQ).

has_a(_, [], []).
% Rel, PersonList, QueryList
% Interpretation: HeadP has a Rel.
has_a(Rel, [HeadP|RestP], [HeadQ|RestQ]) :-
  HeadQ =.. [Rel, _, HeadP],
  has_a(Rel, RestP, RestQ).

is_the(_, [], [], []).
% Rel, PersonList1, PersonList2, QueryList
% Interpretation: HeadP1 has a Rel to HeadP2.
is_the(Rel, [HeadP1|RestP1], [HeadP2|RestP2], [HeadQ|RestQ]) :-
  HeadQ =.. [Rel, HeadP1, HeadP2],
  is_the(Rel, RestP1, RestP2, RestQ).

% Used to evaluate the predicate list from is_a/3, has_a/3.
evaluate_predicates([]).
evaluate_predicates([H|Rest]) :-
  H, evaluate_predicates(Rest).

% father(X, Y) checks if X is the father of Y. X must be a parent of Y and male.
father(X,Y) :-
  parent(X,Y),
  gender(X, male).

% mother(X, Y) checks if X is the mother of Y. X must be a parent of Y and female.
mother(X,Y) :-
    parent(X,Y),
    gender(X, female).

% sibling(X, Y) checks if X and Y share the same parent (i.e., they have the same mother or father).
sibling(X,Y) :-
    parent(Z,X),
    parent(Z,Y),
    \+ (X = Y).

% brother(X, Y) checks if X and Y are siblings, and X must be male.
brother(X,Y) :-
    sibling(X,Y),
    gender(X, male).

% sister(X, Y) checks if X and Y are siblings, and X must be female.
sister(X,Y) :-
    sibling(X,Y),
    gender(X, female).

% son(X, Y) checks if X is the son of Y. X must be male and Y must be the parent.
son(X,Y) :-
    parent(Y,X),
    gender(X, male).

% daughter(X, Y) checks if X is the daughter of Y. X must be female and Y must be the parent.
daughter(X,Y) :-
    parent(Y,X),
    gender(X, female).

% child(X, Y) checks if X is a child of Y.
child(X,Y) :-
    parent(Y,X).

% aunt(X, Y) checks if X is the aunt of Y. X is the sibling of Y's parent and is female.
aunt(X,Y) :-
    parent(Parent, Y),
    sibling(Z, Parent),
    spouse(X,Z),
    gender(X, female).

% aunt(X, Y) (alternative definition) checks if X is the sister of Y's parent.
aunt(X,Y) :-
    parent(Parent, Y),
    sister(X, Parent).

% uncle(X, Y) checks if X is the uncle of Y. X is the sibling of Y's parent and is male.
uncle(X,Y) :-
    parent(Parent, Y),
    sibling(Z, Parent),
    spouse(X,Z),
    gender(X, male).

% uncle(X, Y) (alternative definition) checks if X is the brother of Y's parent.
uncle(X,Y) :-
    parent(Parent, Y),
    brother(X, Parent).

% nibling(X, Y) checks if X is a nibling (nephew or niece) of Y. X is the child of Y's sibling.
nibling(X,Y) :-
    parent(Parent, X),
    sibling(Z,Parent),
    spouse(Z,Y).

% nibling(X, Y) (alternative definition) checks if X is a sibling of Y's parent.
nibling(X,Y) :-
    parent(Parent, X),
    sibling(Parent, Y).

% niece(X, Y) checks if X is a female nibling of Y.
niece(X,Y) :-
    nibling(X,Y),
    gender(X, female).

% nephew(X, Y) checks if X is a male nibling of Y.
nephew(X,Y) :-
    nibling(X,Y),
    gender(X, male).

% cousin(X, Y) checks if X and Y are cousins. Their parents must be siblings.
cousin(X,Y) :-
    parent(Parent1, X),
    parent(Parent2, Y),
    sibling(Parent1, Parent2).

% grandparent(X, Y) checks if X is a grandparent of Y. X is the parent of Y's parent.
grandparent(X,Y) :-
    parent(X, Parent),
    child(Y, Parent).

% grandmother(X, Y) checks if X is the grandmother of Y. X must be a female grandparent.
grandmother(X,Y) :-
    grandparent(X,Y),
    gender(X, female).

% grandfather(X, Y) checks if X is the grandfather of Y. X must be a male grandparent.
grandfather(X,Y) :-
    grandparent(X,Y),
    gender(X, male).

% grandchild(X, Y) checks if X is a grandchild of Y. X is the child of Y's child.
grandchild(X,Y) :-
    grandparent(Y,X).

% grandson(X, Y) checks if X is a male grandchild of Y.
grandson(X,Y) :-
    grandchild(X,Y),
    gender(X, male).

% granddaughter(X, Y) checks if X is a female grandchild of Y.
granddaughter(X,Y) :-
    grandchild(X,Y),
    gender(X, female).

% husband(X, Y) checks if X is the husband of Y. X is male and a spouse of Y.
husband(X,Y) :-
    spouse(X,Y),
    gender(X, male).

% wife(X, Y) checks if X is the wife of Y. X is female and a spouse of Y.
wife(X,Y) :-
    spouse(X,Y),
    gender(X, female).

% ancestor(X, Y) checks if X is an ancestor of Y. Base case: X is Y's parent.
ancestor(X, Y) :-
    parent(X, Y).

% ancestor(X, Y) (recursive case) checks if X is the ancestor of Y by checking if X is an ancestor of Y's parent.
ancestor(X,Y) :-
    parent(Parent, Y),
    ancestor(X, Parent).

% descendant(Descendant, X) checks if Descendant is a descendant of X. Base case: Descendant is X's child.
descendant(Descendant, X) :-
  child(Descendant, X).

% descendant(Descendant, X) (recursive case) checks if Descendant is a descendant of X's child.
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

spouse(abe,mona).
spouse(mona,abe).
spouse(clancy, jacqueline).
spouse(homer, marge).
spouse(jacqueline, clancy).
spouse(marge, homer).
