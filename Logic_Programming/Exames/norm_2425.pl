% ====
% Data
% ====
%author(AuthorID, Name, YearOfBirth, CountryOfBirth).
author(1, 'John Grisham', 1955, 'USA').
author(2, 'Wilbur Smith', 1933, 'Zambia').
author(3, 'Stephen King', 1947, 'USA').
author(4, 'Michael Crichton', 1942, 'USA').

%book(Title, AuthorID, YearOfRelease, Pages, Genres).
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


% =========
% Exercises
% =========
% 1) book_author(?Title, ?Author) - associates book title w/ name of its author
book_author(T, A):-
    author(Id, A, _, _),
    book(T, Id, _, _, _).

% 2) multi_genre_book(?Title) - title of book that has multiple genres
multi_genre_book(T):-
    book(T, _, _, _, Gen),
    length(Gen, Len),
    Len > 1.

% 3) shared_genres(?Title1, ?Title2, -CommonGenres) - returns a list containing common genres
shared_genres(T1, T2, Common):-     % My res
    setof(C, (book(T1, _, _, _, Gen1), book(T2, _, _, _, Gen2), member(C, Gen1), member(C, Gen2)), Common).



shared_genres(Title1, Title2, CommonGenres):    % Alternative res
    book(Title1, _ID1, _Year1, _Pages1, Genres1),
    book(Title2, _ID2, _Year2, _Pages2, Genres2),
    common_elements(Genres1, Genres2, CommonGenres).
    
common_elements([], _L, []).        % Determine common elements between two lists
common_elements([H|T], L, [H|R]):-
    member(H, L), !,
    common_elements(T, L, R).
common_elements([_|T], L, R):-
    common_elements(T, L, R).

% 4) similarity(?Title1, ?Title2, ?Similarity) - 
similarity(T1, T2, Sim):-
    shared_genres(T1, T2, Common),
    length(Common, Inter),
    book(T1, _, _, _, Gen1),
    book(T2, _, _, _, Gen2),
    length(Gen1, U1),
    length(Gen2, U2),
    U is U1 + U2 - Inter,
    Sim is Inter/U.

    % we could also use sort to remove dups from a list w/ all genres
    % instead of calculation all lengths :
    % append(Gen1, Gen2, AllGens), sort(AllGens, Union).

% 5) Answer - a 
%       c) could also be a possible answer but it would only be the greater option if both op's had de same level 



% ====
% Data
% ====
% gives_gift_to(Giver, Gift, Receiver)
gives_gift_to(bernardete, 'The Exchange', celestina).
gives_gift_to(celestina, 'The Brethren', eleuterio).
gives_gift_to(eleuterio, 'The Summons', felismina).
gives_gift_to(felismina, 'River God', juvenaldo).
gives_gift_to(juvenaldo, 'Seventh Scroll', leonilde).
gives_gift_to(leonilde, 'Sunbird', bernardete).
gives_gift_to(marciliano, 'Those in Peril', nivaldo).
gives_gift_to(nivaldo, 'Vicious Circle', sandrino).
gives_gift_to(sandrino, 'Predator', marciliano).

% =========
% Exercises
% =========
% 6) circle_size(+Person, ?Size) - calculates de size of the circle of presents that includes the person
circle_size(P, S):-                 % compliquei um pedaço
    circle_size(P, P, [P], En),
    length(En, S).
circle_size(S, F, T, T):-
    gives_gift_to(S, _, N),
    member(N, T), !.
circle_size(S, F, T, En):-
    gives_gift_to(S, _, N), 
    \+ member(N, T),
    circle_size(N, F, [N|T], En).

circle_size(Person, Size):-         % solução- mais sucinta
    collect([Person], People),
    length(People, Size).
collect( [H|T], People):-
    gives_gift_to(H, _, N),
    \+ member(N, [H|T]), !,
    collect( [N,H|T], People).
collect(People, People).

% 7) largest_circle(?People) - finds the largest circle of presents and returns the name of the list
:- use_module(library(lists)).

largest_circle(People):-
    findall(X, (gives_gift_to(X, _, _); gives_gift_to(_, _, X)), All),
    sort(All, AllPeople),

    setof(Size-Person-Sorted, Persons^(
        member(Person, AllPeople), 
        collect([Person], Persons),
        sort(Persons, Sorted),
        length(Sorted, Size)
    ), AllCircles),

    last(AllCircles, MaxSize-_-_),
    setof(Persons, P^member(MaxSize-P-Persons, AllCircles), LargestGroups),
    member(People, LargestGroups).
    
% 8) Answer - c

% 9) Answer - a

% 10) dec2bin(+Dec, -BinList, +N) - converts a non-negative int Dec into a list of bits representing that number, using exactly N bits
dec2bin(Dec, List, N):-
    Dec >= 0,
    dec2bin(Dec, [], List, N).

dec2bin(0, List, List, 0):- !.
dec2bin(Dec, Acc, List, N):-
    N > 0,
    Bit is Dec mod 2,
    Next is Dec div 2,
    N1 is N - 1,
    dec2bin(Next, [Bit|Acc], List, N1).

% 11) initialize(+DecNumber, +Bits, +Padding, -List) - the above but with padding
initialize(Dec, N, Padd, List):-
    dec2bin(Dec, L, N),
    dec2bin(0, Sides, Padd),
    append([Sides, L, Sides], List).

% 12) print_generation(+List) - prints to terminal a text representation of a list of bits -> 0 is '.' , 1 is 'M'; separating each byte w/ a pipe '|'
print_generation([]):- !.
print_generation(List):-
    write('|'),
    print_bits(1, List).

print_bits(_, []):- !, nl.
print_bits(N, [H|T]):-
    (H =:= 0 -> write('.') ; write('M')),

    (N mod 8 =:= 0 -> write('|') ; true),

    N1 is N + 1,
    print_bits(N1, T).

% 13 - 15 - to do