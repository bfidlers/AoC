read_file_lines(Stream, []) :- at_end_of_stream(Stream).
read_file_lines(Stream, [X | L]) :-
  \+ at_end_of_stream(Stream),
  read_line_to_string(Stream, Y),
  number_string(X, Y),
  read_file_lines(Stream, L).

read_file(Lines) :-
  open('input.txt', read, Str),
  read_file_lines(Str, Lines),
  close(Str).

star1(L, R) :-
    member(X, L), 
    member(Y, L), 
    2020 is X + Y, 
    R is X * Y.

main :-
  read_file(L),
  star1(L, R),
  print(R), nl.
