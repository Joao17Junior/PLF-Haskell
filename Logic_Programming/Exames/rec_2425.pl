% author(AuthorID, Name, YearOfBirth, CountryOfBirth).
author(1, 'John Grisham', 1955, 'USA').
author(2, 'Wilbur Smith', 1933, 'Zambia').
author(3, 'Stephen King', 1947, 'USA').
author(4, 'Michael Crichton', 1942, 'USA').

% book(Title, AuthorID, YearOfRelease, Pages, Genres).
book('The Firm', 1, 1991, 432, ['Legal thriller']).
book('The Client', 1, 1993, 422, ['Legal thriller']).
book('The Runaway Jury', 1, 1996, 414, ['Legal thriller']).
book('The Exchange', 1, 2023, 338, ['Legal thriller']).

book('Carrie', 3, 1974, 199, ['Horror']).
book('The Shining', 3, 1977, 447, ['Gothic novel', 'Horror', 'Psychological horror']).
book('Under the Dome', 3, 2009, 1074, ['Science fiction', 'Political']).
book('Doctor Sleep', 3, 2013, 531, ['Horror', 'Gothic', 'Dark fantasy']).

book('Jurassic Park', 4, 1990, 399, ['Science fiction']).
book('Prey', 4, 2002, 502, ['Science fiction', 'Techno-thriller', 'Horror', 'Nanopunk']).
book('Next', 4, 2006, 528, ['Science fiction', 'Techno-thriller', 'Satire']).

% ==========
% Exercicios
% ==========
% 1) book_genre(?Title, ?Genre) - relates book title to genres 
book_genre(T, G):-
    book(T, _, _, _, Gen),
    member(G, Gen).

% 2) author_wrote_book_at_age(?Author, ?Title, ?Age) - relates all 3 arguments, the age is the age the author had when the title was released
author_wrote_book_at_age(Author, Title, Age):-
    book(Title, Id, RY, _, _),
    author(Id, Author, BY, _),
    Age is RY - BY.

% 3) youngest_author(?Author) - returns the name of the person who became author at the youngest age
youngest_author(Author):-
    author_wrote_book_at_age(Author, _Title1, _Age),
    \+ (author_wrote_book_at_age(_, _Title2, _Age2), _Age2 < _Age).

% 4) genres(+Title) - without using recursion, prints all genres of Title to terminal
genres(Title):-
    book(Title, _AuthorId, _RY, _Pages, Genres),
    member(Genre, Genres),
    write(Genres), nl, fail.
genres(_).

% 5) filterArgs(+Term, +Indexes, ?NewTerm) - creates a New Term from Term, using only the arguments of Term that are in the Indexes
:- use_module(library(lists)).

filterArgs(Term, Indexes, NewTerm):-                % This version uses libraries that are not allowed in this part of the exam
    Term =.. [Name|ListArgs],
    filterByIndex(Indexes, ListArgs, NewArgs),
    NewTerm =.. [Name|NewArgs].

filterByIndex([], _, []).
filterByIndex([Index|Indexes], ListArgs, [H|T]):-
    nth1(Index, ListArgs, H),
    filterByIndex(Indexes, ListArgs, T).
    

filterArgs(Term, Indexes, NewTerm):-                % Correct version
    Term =.. [Name|ListArgs],
    filterByIndex(Indexes, Term, NewArgs),
    NewTerm =.. [Name|NewArgs].

filterByIndex([], _, []).
filterByIndex([Index|Indexes], Term, [H|T]):-
    arg(Index, Term, H),                            % <-----
    filterByIndex(Indexes, ListArgs, T).


% 6) diverse_books(-Books) - returns a list of all book titles, w/ greates number of genres
diverse_books(Books):-
    findall( Title, ( 
        book(Title, _, _, _, Genres), 
        length(Genres, LGen1), 
        \+ (
            book(_, _, _, _, Genres2), 
            length(Genres2, LGen2), 
            LGen2>LGen1
        )), Books ).

% 7) country_authors(?Country, ?Authors) - unifies country of birth and Authors
country_authors(Country, Authors):-
    bagof(Author, Id^BY^(author(Id, Author, BY, Country)), Authors).


% read_book(Person, BookTitle)
read_book(bernardete, 'The Firm').
read_book(bernardete, 'The Client').
read_book(clarice, 'The Firm').
read_book(clarice, 'Carrie').
read_book(deirdre, 'The Firm').
read_book(deirdre, 'Next').

% 8) popular(?Title) - returns the Title of a book considered popular (75% of group has read it), using backtracking to retrieve the rest of the books
popular(Title):-
    setof(Person, _B^(read_book(Person, _B)), People),  % list with all people
    length(People, NP),
    setof(Person, read_book(Person, Title), HaveRead), 
    length(HaveRead, N),
    N/NP >= 0.75.

% 9) Answer - d

% 10) Answer - d -> the question implies that the results are unified, and, in this case without the cut, the running of the predicate would always give out 2 answers, even if they are both correct.

% 11) Answer - d -> retract, will make the first clause of any call of predY, not happen. If E calls that clause, the result will skip it to the second clause that meets the requirements. assertal() will return the first clause to its original state.

% 12) Author wrote Book at Age. - we got to declare the operators and the code to make this call happen
:- op(500, xfx, wrote).
:- op(450, xfx, at).
Author wrote Book at Age :-
    author_wrote_book_at_age(Author, Book, Age).

% 13) rotate(+List, +Position, +Rotations, ?NewList) - recieves a list w/ initial config of the codex, the position of the dial to rotate (starting at 1), and no of rotations, returning a new list
:-use_module(library(lists)).

rotate(List, Position, Rotations, NewList):-
    nth1(Position, List, ToChange, Rest),
    rotate_list(Rotations, ToChange, Rotated),
    nth1(Position, NewList, Rotated, Rest).

% 14) matches(+List, +Code) - succeeds if codex List is aligned w/ Code
matches([], []).
matches([[H|_] | L], [H | C]):-
    matches(L, C).

% 15) move(+Initial, -Final) - returns in Final, via Backtracking, all possible moves for the given Initial codex config
:-use_module(library(between)).
move(Initial, Final):-
    length(Initial, MaxIndex),
    nth1(1, Initial, L),
    length(L, DialSize),
    MaxRotation is DialSize - 1,
    between(1, MaxIndex, Index),
    between(1, MaxRotation, Rotation),
    rotate(Initial, Index, Rotation, Final).

% 16) solve(+Code, +Key, -States) - returns the set of States through which the codex passes to be solved. Key contains the code of the solution (first element of each dial). Preference for shortest path
solve_dfs(Code, Key, States):-                          % DFS nao da o shortes-path -> usar BFS vvvvvvv
    solve_dfs(Code, Key, [Code], Solution),
    reverse(Solution, States).

solve_dfs(Code, Key, Acc, Acc):-
    matches(Code, Key), ! .
solve_dfs(Code, Key, Acc, States):-
    move(Code, Next), 
    \+ member(Next, Acc),
    solve_dfs(Next, Key, [Next|Acc], States).


solve(Code, Key, States):-
    bfs_queue([[Code]], Key, RevStates),
    reverse(RevStates, States).

bfs_queue([[Current|Path] | _], Key, [Current|Path]):-
    matches(Current, Key), !.
bfs_queue([[Current|Path] | Rest], Key, FinalPath):-
    findall([Next, Current|Path],
        (move(Current, Next), \+ member(Next, [Current|Path])),
        NewPaths),
    append(Rest, NewPaths, NextQueue),
    bfs_queue(NextQueue, Key, FinalPath).