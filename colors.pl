read_input(File, N, K, C) :-
    open(File, read, Stream),
    read_line(Stream, [N, K]),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).


do_list(N, New):- 
  findall(Num, between(1, N, Num), New).

removefirstelement([_|Tail], Tail).

addtolist(LC, C, ColorsToAdd, C2, Min, Answer2) :-
    NewLC is LC - 1,
    (LC = 0 -> Answer2 is Min
        ;	(nth1(1, C, Elem),
            removefirstelement(C, NewC),
            append(C2,[Elem],NewC2),
            checkifallcolors(NewLC, NewC, ColorsToAdd, NewC2, Elem, Min, Answer2)
        )).

checkifallcolors(LC, C, ColorsToAdd, C2, Elem, Min, Answer2) :-
    (member(Elem, ColorsToAdd) -> delete(ColorsToAdd, Elem, NewColorsToAdd) 
        ;	append(ColorsToAdd,[],NewColorsToAdd)),
    length(NewColorsToAdd, L),
    (L = 0 -> removefromlist(LC, C, NewColorsToAdd, C2, Min, Answer2)
    ;	addtolist(LC, C, NewColorsToAdd, C2, Min, Answer2)).


removefromlist(LC, C, ColorsToAdd, C2, Min, Answer2) :-
    length(C2, L),
    (L < Min -> NewMin is L ; NewMin is Min),
    removefirstelement(C2, NewC2),
    nth1(1, C2, Elem),
    (member(Elem, NewC2) -> removefromlist(LC, C, ColorsToAdd, NewC2, NewMin, Answer2)
        ;	(append(ColorsToAdd,[Elem],NewColorsToAdd),
            addtolist(LC, C, NewColorsToAdd, NewC2, NewMin, Answer2))).


colors(File, Answer) :- 
    read_input(File,N,K,C),
    do_list(K,ColorsToAdd),
    addtolist(N, C, ColorsToAdd, [], 1000001, Answer2),
    (Answer2 = 1000001 -> Answer is 0 ; Answer is Answer2).        
