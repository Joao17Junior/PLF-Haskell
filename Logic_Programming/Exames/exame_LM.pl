% director(DirectorID, Name, Country).
director(1, 'Christopher Nolan', 'UK').
director(2, 'Steven Spielberg', 'USA').
director(3, 'Greta Gerwig', 'USA').
director(4, 'Hayao Miyazaki', 'Japan').

% movie(Title, DirectorID, Year, Duration, Genres).
movie('Inception', 1, 2010, 148, ['Sci-Fi', 'Action']).
movie('Interstellar', 1, 2014, 169, ['Sci-Fi', 'Drama']).
movie('Jaws', 2, 1975, 124, ['Adventure', 'Thriller']).
movie('Barbie', 3, 2023, 114, ['Comedy', 'Fantasy']).
movie('Spirited Away', 4, 2001, 125, ['Animation', 'Fantasy', 'Adventure']).

% TODO: Pergunta 1 (1,5 val): Implemente o predicado movie_from_country(?Title, ?Country), que associa o título de um filme ao país de origem do seu realizador.
movie_from_country(Title, Country):-
    movie(Title, Id, _, _, _),
    director(Id, _, Country).

% TODO: Pergunta 2 (1,5 val): Implemente long_movie(?Title), que unifica Title com filmes que tenham uma duração superior a 150 minutos.
long_movie(Title):-
    movie(Title, _, _, Duration, _),
    Duration > 150.

% TODO: Pergunta 3 (1,5 val): Implemente shared_genre(+Title1, +Title2, -Genre), que identifica um género que seja comum a dois filmes diferentes através de backtracking.
shared_genre(Title1, Title2, Genre):-
    movie(Title1, _, _, _, Gen1),
    movie(Title2, _, _, _, Gen2),
    member(Genre, Gen1),
    member(Genre, Gen2).

% TODO: Pergunta 4 (0,5 val): Queremos permitir a sintaxe: Movie was_released_in Year. Exemplo: 'Inception' was_released_in 2010. Qual a definição de operador correta? a) :-op(700, xfy, was_released_in). b) :-op(700, xfx, was_released_in). c) :-op(200, fy, was_released_in). d) :-op(700, fx, was_released_in).
% Answer - b

% TODO: Pergunta 5 (0,5 val): Qual o resultado da unificação f(X, [a|T]) = f(b, [Y, c]). ? a) X = b, Y = a, T = c. b) X = b, Y = a, T = [c]. c) Falha (no). d) X = b, Y = [a], T = c.
% Answer - b -> apesar de T ser uma cauda com um so item, ainda tem de ser representado como uma lista.

% TODO: Pergunta 6 (1,5 val): Implemente print_movies_by(+DirectorName), que utiliza um failure-driven loop para imprimir todos os títulos de filmes de um determinado realizador (um por linha). O predicado deve sempre ter sucesso.
print_movies_by(DirectorName):-
    movie(Title, Id, _, _, _),
    director(Id, DirectorName, _),
    write(Title), nl, fail.

print_movies_by(_).

% TODO: Pergunta 7 (2,0 val): Implemente count_genres(+Title, -Count), que calcula o número de géneros de um filme sem usar o predicado length/2.
count_genres(Title, Count):-
    movie(Title, _, _, _, Genres),
    rec_count(Genres, 0, Count).

rec_count([], Count, Count).
rec_count([H|T], Acc, Count):-
    Acc1 is Acc + 1,
    rec_count(T, Acc1, Count).

% TODO: Pergunta 8 (0,5 val): Considerando o modelo de execução do Prolog, o que acontece se colocarmos uma regra recursiva à esquerda (ex: p(X) :- p(X), q(X).)? a) O Prolog encontra a solução mais rapidamente. b) O Prolog entra em recursão infinita (estoiro de stack). c) O Prolog ignora a regra recursiva. d) O predicado funciona normalmente se q(X) for verdadeiro.
% Answer - b

% TODO: Pergunta 9 (0,5 val): Qual a diferença principal entre findall/3 e setof/3? a) findall falha se não houver soluções, setof devolve lista vazia. b) setof ordena os resultados e remove duplicados; findall mantém a ordem de procura e duplicados. c) Não há diferença; são sinónimos. d) findall permite usar o quantificador existencial ^, setof não.
% Answer - b

% TODO: Pergunta 10 (0,5 val): O predicado nonvar(X) tem sucesso se: a) X for uma variável não instanciada. b) X for um átomo, número ou termo composto. c) X for apenas um número. d) X for o átomo nil.
% Answer - b

% TODO: Pergunta 11 (1,5 val): Implemente director_filmography(+DirectorName, -Titles), que devolve uma lista com todos os títulos de filmes realizados por essa pessoa, utilizando findall/3.
director_filmography(DirectorName, Titles):-
    findall(Title, (
        movie(Title, Id, _, _, _),
        director(Id, DirectorName, _)
    ), RevTitles),
    sort(RevTitles, Titles).

% TODO: Pergunta 12 (1,5 val): Implemente movies_after(+Year, -List), que devolve uma lista de termos Title-DirectorID para todos os filmes lançados após o ano fornecido, ordenados por título e sem duplicados, usando setof/3.
movies_after(Year, List):-
    setof(Title-DirectorID, RY^_D^_Genre^(
        movie(Title, DirectorID, RY, _D, _Genre), RY > Year
    ), List).

% TODO: Pergunta 13 (2,0 val): Implemente o predicado filter_movie_data(+Title, +Indexes, -NewTerm), que recebe o título de um filme e uma lista de índices (1 a 5) e constrói um novo termo composto com o nome data contendo apenas os argumentos do facto movie/5 correspondentes a esses índices. Use =.. (univ) ou arg/3.
:-use_module(library(lists)).

filter_movie_data(Title, Indexes, NewTerm):-
    movie(Title, I, Y, D, G),
    Term =.. [movie, Title, I, Y, D, G],
    Term =.. [_H|List],
    filter_data(List, Indexes, NewData),
    NewTerm =.. [data | NewData].
filter_data(_, [], []).
filter_data(L, [I|Indexes], [H|T]):-
    nth1(I, L, H),
    filter_data(L, Indexes, T).

% TODO: Pergunta 14 (1,5 val): Implemente update_duration(+Title, +NewDuration), que atualiza a duração de um filme na base de conhecimento utilizando retract e assert.
:- dynamic movie/5.

update_duration(Title, NewDuration):-
    retract( movie(Title, DirectorID, Year, _OldDuration, Genres) ),
    assert( movie(Title, DirectorID, Year, NewDuration, Genres) ).

% TODO: Pergunta 15 (2,0 val): Imagine um grafo onde dois realizadores estão "conectados" se partilharem um género de filme comum nas suas filmografias. Implemente connected_directors(+Dir1, +Dir2), que determina se existe um caminho entre dois realizadores (evitando ciclos).
connected_directors(Dir1, Dir2):-
    bfs([Dir1], Dir2, []).
bfs([F|_], F, _V).
bfs([S|R], F, V):-
    findall(N, (
        movie(Title1, S, _, _, _),
        movie(Title2, N, _, _, _),
        shared_genre(Title1, Title2),
        \+ member(N, V),
        \+ member(N, [S|R])
    ), L),
    append(R, L, NR),
    bfs(NR, F, [S|V]).

% TODO: Exercício: Implementa o predicado flatten_genres_dl(+ListofLists, -DL) que recebe uma lista de listas de géneros (ex: [['Sci-Fi', 'Action'], ['Drama']]) e devolve uma Difference List no formato Result-Tail.
% Caso Base: Uma lista vazia resulta numa lista de diferença vazia
flatten_genres_dl([], T-T).

% Caso Recursivo:
flatten_genres_dl([H|T], Total-Resto) :-
    append(H, TailH, Total),
    flatten_genres_dl(T, TailH-Resto).