read_input(File, Q, Intervs) :-
    open(File, read, Stream),
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atom_number(Atom, Q),
    read_lines(Stream, Q, Intervs).

read_lines(Stream, N, Intervs) :-
    ( N == 0 -> Intervs = []
    ; N > 0  -> read_line(Stream, Interv),
                Nm1 is N-1,
                read_lines(Stream, Nm1, RestIntervs),
                Intervs = [Interv | RestIntervs]).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).


%returns a list of strings with the paths
solve([[Lin, Rin, Lout, Rout]], Lista_Answers, Sol):-
    %print("In solve 1 "),
    empty_assoc(Assoc),
    put_assoc([Lin,Rin], Assoc, [Lout,Rout], TheAssoc), 
    bfs([Lout,Rout], [[Lin,Rin,'']], TheAssoc, Answer),
    (Answer = '' -> Answer2 = 'EMPTY' ; Answer2 = Answer),
    append(Lista_Answers,[Answer2],Sol).

solve([[Lin, Rin, Lout, Rout]|RestIntervs], Lista_Answers, Sol):-
    %print("In solve 2 "),
    empty_assoc(Assoc),
    put_assoc([Lin,Rin], Assoc, [Lout,Rout], TheAssoc), 
    bfs([Lout,Rout], [[Lin,Rin,'']], TheAssoc, Answer),
    %print("After bfs"),
    (Answer = '' -> Answer2 = 'EMPTY' ; Answer2 = Answer),
    append(Lista_Answers, [Answer2], NewL),
    solve(RestIntervs, NewL, Sol).

% comparators

isLessOrEqual(X,Y) :-
    (  X @=< Y
       -> true
       ;  false
    ).

isBiggerOrEqual(X,Y) :-
    (  X @>= Y
       -> true
       ;  false
    ).


%BFS returns a list with a string
bfs(_, [], _, Path) :-
    %print("in bfs 1 "),
    Path = 'IMPOSSIBLE'.

bfs([Lout,Rout], [[Lin,Rin,PathSoFar]|_], _, Path) :-
    %print("in bfs 2 "),
    isBiggerOrEqual(Lin,Lout),
    isLessOrEqual(Rin,Rout),
    %print("AMAMAMAMA  "),
    Path = PathSoFar.


bfs([Lout,Rout], [[Lin,Rin,PathSoFar]|Rest], Visited, Path) :-
    
    %print("In bfs 3 "),

    HLin is div(Lin,2),
    HRin is div(Rin,2),


    (get_assoc([HLin,HRin],Visited,[Lout,Rout]) -> (NewVisited = Visited, 
                                                    append([],Rest, NewRest))
    
    ; (atom_concat(PathSoFar,h,HPath),
        append(Rest,[[HLin,HRin,HPath]],NewRest),
        put_assoc([HLin,HRin], Visited, [Lout,Rout], NewVisited))
        ),



    TLin is 3*Lin+1,
    TRin is 3*Rin+1,

    ( (not(get_assoc([TLin,TRin],NewVisited,[Lout,Rout])), TLin @< 1000000, TRin @< 1000000) -> (atom_concat(PathSoFar,t,TPath),
                                                                                                append(NewRest,[[TLin,TRin,TPath]],FinalRest),
                                                                                                put_assoc([TLin,TRin], NewVisited, [Lout,Rout], FinalVisited))
    ; (FinalVisited = NewVisited, 
       append([],NewRest, FinalRest))
    ),
    
    bfs([Lout,Rout], FinalRest, FinalVisited, Path).

    

ztalloc(File,Answer):-
      read_input(File, _, Intervs),
      once(solve(Intervs,[], Answer)).