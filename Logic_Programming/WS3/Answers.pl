% exercise 2 - Recursion over Lists
% a)
list_size(L, S):-
    list_size_tail(L, 0, S).

list_size_tail([], Acc, Acc).
list_size_tail([H|T], Acc, S):-
    Acc1 is Acc + 1,
    list_size_tail(T, Acc1, S).

% b)
list_sum(L, S):-
    list_sum_tail(L, 0, S).

list_sum_tail([], Acc, Acc).
list_sum_tail([H|T], Acc, S):-
    Acc1 is Acc + H,
    list_sum_tail(T, Acc1, S).

% e) count(E, L, N)
count(_, [], 0).
count(E, [L|Ls], N):-
    (E =:= L ->
        count(E, Ls, N1),
        N is N1 + 1
    ;
        count(E, Ls, N1),
        N is N1
    ).

% exercise 3 - List Manipulation
% a)
invert(L, LR):- invert(L, [], LR).

invert([], LR, LR).
invert([L|Ls], Acc, LR):-
    invert(Ls, [L|Acc], LR).

% b)
del_one(_, [], []).
del_one(E, [H|T], R):- 
    (E =:= H ->
        R = T                   
    ;
        del_one(E, T, R1),       
        R = [H|R1]               
    ).

% c)
del_all(_, [], []).
del_all(E, [H|T], R):-
    (E =:= H ->
        del_all(E, T, R1),
        R = R1
    ;
        del_all(E, T, R1),
        R = [H|R1]
    ).

% d)
del_all_list([], L, L).
del_all_list([E|El], L, R):-
    del_all(E, L, R1),        
    del_all_list(El, R1, R).  

% e)
del_dups([], []).
del_dups([L|Ls], [L|R]):-
    del_all(L, Ls, R1),      
    del_dups(R1, R).     

% i) insert_elem(I, L, E, R)  
insert_elem(0, L, E, [E|L]).         
insert_elem(I, [H|T], E, [H|R]):-    
    I > 0,
    I1 is I - 1,
    insert_elem(I1, T, E, R).        

% exercise 4 - Append, The Powerful
% a) list_append(L1, L2, L3)
list_append([], Y, Y).
list_append([X|Xs], Y, [X|L3]):-
    list_append(Xs, Y, L3).

% b) list_member(E, L)
list_member(E, L):-
    list_append(_, [E|_], L).

% c) list_last(List, Last)
list_last(Li, La):-
    list_append(_, [La], Li).

% h) list_replace_one(X, Y, L1, L2)
list_replace_one(X, Y, L1, L2):-
    list_append(Prefix, [X|Xs], L1),
    list_append(Prefix, [Y|Xs], L2).

% exercise 7 - List Sorting
% b) insert_ordered(Value, List1, List2)
insert_ordered(V, [], [V]).
insert_ordered(V, [H|T], L):-
    (V < H ->
        L = [V, H | T]
    ;
        L = [H | R],
        insert_ordered(V, T, R)
    ).

% c) insert_sort(List, OrderedList)
insert_sort([], []).
insert_sort([H|T], OL):-
    insert_sort(T, SortedTail),     
    insert_ordered(H, SortedTail, OL).  