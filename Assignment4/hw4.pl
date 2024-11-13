% len(List, Length) - Computes the length of a list.
len([], 0).                             % Base case: empty list has length 0.
len([_ | R], L) :-                      % Recursive case: head is ignored, count tail length.
    len(R, L1),
    L is L1 + 1.

% listlength(X, Y) - Returns the length of list X as Y.
listlength(X,Y) :- len(X,Y), !.         % Use the len predicate to compute the length.

% count(Element, List, N) - Counts occurrences of Element in List.
count(_, [], 0).                        % Base case: empty list has 0 occurrences.
count(Element, [Element|Tail], N) :-    % If Element is the head, increment count.
    count(Element, Tail, N1),
    N is N1 + 1.
count(Element, [_|Tail], N) :-          % If Element is not the head, continue searching.
    count(Element, Tail, N).

% sit1(X) - Checks if list X has 20 elements, 19 white balls, and 1 red ball.
sit1(X) :-
    length(X, 20),                     % Ensure the list has 20 elements.
    count(white, X, 19),               % Ensure there are 19 white balls.
    count(red, X, 1).                  % Ensure there is exactly 1 red ball.

% sit2(X) - Ensures X has 6 elements with 2 orange, 2 white, and 2 black balls, and no adjacent same color balls.
sit2(X) :-
    listlength(X, 6),
    count(orange, X, 2),
    count(white, X, 2),
    count(black, X, 2),
    not_adjacent(X).                   % Ensure no adjacent elements are the same.

% not_adjacent(List) - Ensures no two adjacent elements are the same in List.
not_adjacent([]).                       % Empty list trivially satisfies the condition.
not_adjacent([_]).                      % Single element trivially satisfies the condition.
not_adjacent([Element, E2 | Rest]) :-   % Check if Element is different from E2.
    Element \= E2,
    not_adjacent([E2 | Rest]).          % Recursively check the rest.

% sit3(X) - Ensures X has 6 elements with 4 green balls, 1 pink ball, 1 red ball, and no three consecutive green balls.
sit3(X) :-
    listlength(X, 6),
    count(green, X, 4),                 % Ensure there are 4 green balls.
    count(pink, X, 1),                  % Ensure there is 1 pink ball.
    count(red, X, 1),                   % Ensure there is 1 red ball.
    no_more_green(X).                   % Ensure no three consecutive green balls.

% no_more_green(List) - Ensures there are no three consecutive green balls in List.
no_more_green([]).                      % Base case: empty list has no consecutive greens.
no_more_green([_]).                     % Single element trivially satisfies the condition.
no_more_green([_,_]).                   % Two elements trivially satisfy the condition.
no_more_green([X1, X2, X3 | Rest]) :-   % Check for three consecutive green balls.
    \+ (X1 = green, X2 = green, X3 = green),  % Ensure no three consecutive greens.
    no_more_green([X2, X3 | Rest]).    % Recursively check the rest.

% sit4(X) - Ensures X has 8 elements with certain color constraints, no adjacent silver and white balls, and specific positions for colors.
sit4(X) :-
    listlength(X, 8),
    count(purple, X, 1),                % Ensure there is exactly 1 purple ball.
    count(red, X, 2),                   % Ensure there are exactly 2 red balls.
    count(white, X, 2),                 % Ensure there are exactly 2 white balls.
    count(silver, X, 3),                % Ensure there are exactly 3 silver balls.
    not_color(X, silver, 2, 3),         % Ensure silver balls are not at positions 2 and 3.
    not_color(X, white, 6, 7),          % Ensure white balls are not at positions 6 and 7.
    same_color48(X),                    % Ensure the balls at positions 4 and 8 are of the same color.
    diff_color17(X),                    % Ensure the balls at positions 1 and 7 are of different colors.
    red_bruh(X),                        % Ensure there is no red ball at position 1 or 7.
    silver_left(X).                     % Ensure the first silver ball is to the left of white.

% kth(X, List, K) - Finds the K-th element in the list List (1-indexed).
kth(X, [X | _], 1).                    % Base case: the first element is the K-th.
kth(X, [_ | L], K) :-                  % Recursive case: decrease K by 1 and search in the tail.
    K > 1,
    K1 is K - 1,
    kth(X, L, K1).

% not_color(List, Color, Pos1, Pos2) - Ensures Color is not at positions Pos1 and Pos2 in List.
not_color(List, Color, Pos1, Pos2) :-
    kth(Ball1, List, Pos1),            % Get the Ball at position Pos1.
    kth(Ball2, List, Pos2),            % Get the Ball at position Pos2.
    Ball1 \= Color,                    % Ensure Ball1 is not the Color.
    Ball2 \= Color.                    % Ensure Ball2 is not the Color.

% same_color48(List) - Ensures the balls at positions 4 and 8 are the same color.
same_color48(List) :-
    kth(Ball1, List, 4),               % Get the ball at position 4.
    kth(Ball2, List, 8),               % Get the ball at position 8.
    Ball1 = Ball2.                     % Ensure the two balls are the same.

% diff_color17(List) - Ensures the balls at positions 1 and 7 are of different colors.
diff_color17(List) :-
    kth(Ball1, List, 1),               % Get the ball at position 1.
    kth(Ball2, List, 7),               % Get the ball at position 7.
    Ball1 \= Ball2.                    % Ensure the two balls are different.

% red_bruh(List) - Ensures there is no red ball at position 1 or 7.
red_bruh([Ball1 | List]) :-
    Ball1 \= red,                      % Ensure Ball1 is not red.
    kth(Ball2, List, 7),               % Get the ball at position 7.
    Ball2 \= red.                      % Ensure Ball2 is not red.

% silver_left(List) - Ensures the first silver ball is to the left of the first white ball.
silver_left([silver, white | Rest]) :-
    silver_left(Rest).                 % If silver and white are in order, continue checking.
silver_left([Ball | Rest]) :-
    Ball \= white,                     % Ensure Ball is not white.
    silver_left(Rest).                 % Continue checking the rest.
silver_left([]).                       % Base case: an empty list satisfies the condition.

% split3(N, L) - Checks if L can be split into 3 sublists where each sum is <= N
split3(N, L) :-
    split2(L, L1, L2),                % Split the list into two parts L1 and L2.
    split2(L2, L2a, L2b),             % Further split L2 into L2a and L2b.
    sum_the_list(L1, Sum1),           % Sum the elements of L1.
    sum_the_list(L2a, Sum2),          % Sum the elements of L2a.
    sum_the_list(L2b, Sum3),          % Sum the elements of L2b.
    Sum1 =< N,                        % Ensure the sum of L1 is <= N.
    Sum2 =< N,                        % Ensure the sum of L2a is <= N.
    Sum3 =< N,                        % Ensure the sum of L2b is <= N.
    L1 \= [],                         % Ensure L1 is non-empty.
    L2a \= [],                        % Ensure L2a is non-empty.
    L2b \= [].                         % Ensure L2b is non-empty.

% split2(List, Left, Right) - Splits the list into two non-empty parts Left and Right.
split2([Head | Tail], [Head | Left], Right) :-
    split2(Tail, Left, Right).        % Recursively split the tail.
split2(Tail, [], Tail) :- Tail \= []. % Ensure that the list is not empty for the right part.

% sum_the_list(List, Sum) - Calculates the sum of elements in the list List.
sum_the_list([], 0).                   % Base case: empty list has sum 0.
sum_the_list([Head | Tail], Sum) :-    % Recursive case: sum of list is Head + sum of Tail.
    sum_the_list(Tail, TailSum),
    Sum is Head + TailSum.
