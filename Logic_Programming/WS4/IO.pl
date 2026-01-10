% exercicio 5 - Data Input and Output
% a) print_n(N, S) - prints symbol S, N times
print_n(0, _):- !.
print_n(N, S):-
    write(S),
    N1 is N - 1,
    print_n(N1, S).

% d) read_number(X) - reads a number from input
read_number(X):-
    read_number(0, X).  

read_number(Acc, Acc):-         % read_number(Acc, Result)
    peek_code(10), !,           % Check if next is Line Feed (10)
    get_code(_).                % Consume the Line Feed

read_number(Acc, X):-
    get_code(Code),             % Read one character
    Digit is Code - 48,         % Convert ASCII to digit (ASCII '0' = 48)
    Acc1 is Acc * 10 + Digit,   % Build number: 12 + 3 = 123
    read_number(Acc1, X).

% e) read_until_between(Min, Max, Value) - succeeds if input is between Min & Max
read_until_between(Min, Max, V):-
    read_number(X),
    (X >= Min, X =< Max ->
        V = X
    ;
        read_until_between(Min, Max, V)
    ).