//Euklidovska vzdalenost
//get_distance(loc(FromX, FromY), loc(ToX, ToY), Dist) :- Dist = math.sqrt((FromX-ToX)*(FromX-ToX)+(FromY-ToY)*(FromY-ToY)).
//Manhattan vzdalenost
get_distance(loc(FromX, FromY), loc(ToX, ToY), Dist) :- Dist = math.abs(FromX-ToX) + math.abs(FromY-ToY).


//ocekava dvojici From - loc(X, Y) a To - loc(X,Y)
get_instructions(X, X, _, [skip]).
get_instructions(_, Y, _, [skip]) :- not possible(Y).
get_instructions(From, To, N, Instructions) :-
	.println("Path from",From)&
	.println("Path to",To)&
	get_path(From, To, Path)&
	.println("Found path",Path)&
	to_instr(Path, InstrPad) &
	right_pad(InstrPad, N, InstrTrunc) &
	truncate(InstrTrunc, N, Instructions) &
	.println("Sending path").

//zkrati na L
truncate(_, 0, []).
truncate([H|I], L, [H|O]) :-
	truncate(I,L-1,O).
	
	
//pads instruction list with pass to length 3
right_pad(I, N, P) :- 
	.reverse(I,R) &
	left_pad(R, N, L) &
	.reverse(L, P).
left_pad(_, 0, []).
left_pad(L, N, FL) :-
        .length(L) < N &
        lphelper(L, N- .length(L), FL).
left_pad(L, _, L).
lphelper(I, 0, I).
lphelper(I, N, [skip|P]) :-
	lphelper(I, N-1, P).
	
	
//prvede seznam souradnic na seznam instrukci
to_instr([loc(X1,Y1), loc(X2,Y2)|T], [right|Instr]) :-
	X2=X1+1 & Y2=Y1 &
	to_instr([loc(X2,Y2)|T], Instr).
to_instr([loc(X1,Y1), loc(X2,Y2)|T], [left|Instr]) :-
	X2=X1-1 & Y2=Y1 &
	to_instr([loc(X2,Y2)|T], Instr).
to_instr([loc(X1,Y1), loc(X2,Y2)|T], [down|Instr]) :-
	X2=X1 & Y2=Y1+1 &
	to_instr([loc(X2,Y2)|T], Instr).
to_instr([loc(X1,Y1), loc(X2,Y2)|T], [up|Instr]) :-
	X2=X1 & Y2=Y1-1 &
	to_instr([loc(X2,Y2)|T], Instr).
to_instr([loc(X1,Y1), loc(X2,Y2)|T], [skip|Instr]) :-
	to_instr([loc(X2,Y2)|T], Instr).
to_instr(X, []) :- .length(X) = 1.
to_instr([], []).

//najde cestu s A*	
get_path(From, To, Path) :- 
	get_distance(From, To, Dist)&
	astar([node(From, 0, Dist)], [], From, To, Path).

//A*	
astar(Open, Closed, Start, Goal, Solution) :- astar(Open, Closed, Start, Goal, [], Solution).
astar(_, _, Start, Goal, [Goal|Path], Solution) :-
	.reverse([Goal|Path], Solution).
astar(_, Closed, Start, Goal, Path, Solution) :-
	.length(Closed) > 20 &
	.reverse(Path, Solution).
astar(Open, Closed, Start, Goal, Path, Solution) :-
	get_min(Open, node(Best, Gscore, BestVal))&
	.delete(node(Best, Gscore, BestVal), Open, TmpOpen)&
	expand(node(Best, Gscore, BestVal), Open, [Best|Closed], Start, Goal, Expanded) &
	.concat(Expanded, TmpOpen, NewOpen)&
	astar(NewOpen, [Best|Closed], Start, Goal, [Best|Path], Solution).

//Expanze uzlu
expand(node(loc(X, Y), Gscore, StartVal), Open, Closed, Start, Goal, Expanded) :-
	get_distance(loc(X, Y-1), Goal, DistUp) &
	get_distance(loc(X, Y+1), Goal, DistDown) &
	get_distance(loc(X+1, Y), Goal, DistRight) &
	get_distance(loc(X-1, Y), Goal, DistLeft) &
	filter_impossible([node(loc(X, Y-1), Gscore+1, Gscore+DistUp),
					   node(loc(X, Y+1), Gscore+1, Gscore+DistDown),
					   node(loc(X+1, Y), Gscore+1, Gscore+DistRight),
					   node(loc(X-1, Y), Gscore+1, Gscore+DistLeft)], OnlyCorrect)&
	.println("Open", Open)&
	.println("Closed", Closed)&
	filter_open(OnlyCorrect, Open, NotOpen)&
	filter_closed(NotOpen, Closed, Expanded).

//Filters out impossible positions
filter_impossible([],[]).
filter_impossible([node(loc(X, Y), Gs, V)|T],[node(loc(X, Y), Gs, V)|F]) :-
	X>=0 & Y>=0 &
	grid_size(A, B) & X<A & Y<B &
	not dbObstacle(X,Y) &
	filter_impossible(T, F).
filter_impossible([H|T], F) :-
	filter_impossible(T, F).

possible(loc(X,Y)):-
	grid_size(A, B) & X<A & Y<B &
	not dbObstacle(X,Y).

//Filters out nodes that are in the closed set
filter_closed([], _, []).
filter_closed([H|T], Closed, F) :-
	node_loc_member(H, Closed)&
	filter_closed(T, Closed, F).
filter_closed([H|T], Closed, [H|F]) :-
	filter_closed(T, Closed, F).

node_loc_member(node(loc(X, Y), _, _), [loc(X, Y)|_]).
node_loc_member(X, [_|Tail]) :-
  node_loc_member(X, Tail).
	
//Filters out nodes that are in the closed set
filter_open([], _, []).
filter_open([H|T], Open, F) :-
	node_member(H, Open)&
	filter_open(T, Open, F).
filter_open([H|T], Open, [H|F]) :-
	filter_open(T, Open, F).

node_member(node(loc(X, Y), _, _), [node(loc(X, Y), _, _)|_]).
node_member(X, [_|Tail]) :-
  node_member(X, Tail).
  

filter_gscore([], _, []).
filter_gscore([node(_, Gs, _)|T], Gscore, F) :-
	Gs<Gscore &
	filter_gscore(T, Gscore, F).
filter_gscore([H|T], Open, [H|F]) :-
	filter_gscore(T, Gscore, F).

//Finds the node with minimal evaluation 
get_min([H|T], O) :- get_min(T, H, O).
get_min([], H, H).
get_min([node(ACoords, AGs, AVal)|T], node(BCoords, BGs, BVal), O) :- AVal<BVal & get_min(T, node(ACoords, AGs, AVal), O).
get_min([node(ACoords, AGs, AVal)|T], node(BCoords, BGs, BVal), O) :- AVal>=BVal & get_min(T, node(BCoords, BGs, BVal), O).