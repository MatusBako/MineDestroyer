
//Euklidovska vzdalenost
get_distance(pos(FromX, FromY), pos(ToX, ToY), Dist) :- Dist = math.sqrt((FromX-ToX)*(FromX-ToX)+(FromY-ToY)*(FromY-ToY)).


//ocekava dvojici From - pos(X, Y) a To - pos(X,Y)
get_instructions(X, X, Instructions).
get_instructions(From, To, Instructions) :-
	get_path(From, To, Path)&
	to_instr(Path, InstrDirty)&
	right_pad(InstrDirty, InstrToTrunc)&
	truncate(InstrToTrunc, 3, Instructions).

//zkrati na L
truncate(_, 0, []).
truncate([H|I], L, [H|O]) :-
	truncate(I,L-1,O).
	
	
//pads instruction list with pass to length 3
right_pad(I, P) :- 
	.reverse(I,R) &
	left_pad(R, 3, L) &
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
to_instr([pos(X1,Y1), pos(X2,Y2)|T], [right|Instr]) :-
	X2=X1+1 & Y2=Y1 &
	to_instr([pos(X2,Y2)|T], Instr).
to_instr([pos(X1,Y1), pos(X2,Y2)|T], [left|Instr]) :-
	X2=X1-1 & Y2=Y1 &
	to_instr([pos(X2,Y2)|T], Instr).
to_instr([pos(X1,Y1), pos(X2,Y2)|T], [down|Instr]) :-
	X2=X1 & Y2=Y1+1 &
	to_instr([pos(X2,Y2)|T], Instr).
to_instr([pos(X1,Y1), pos(X2,Y2)|T], [up|Instr]) :-
	X2=X1 & Y2=Y1-1 &
	to_instr([pos(X2,Y2)|T], Instr).
to_instr(X, []) :- .length(X) = 1.
to_instr([], []).

//najde cestu s A*	
get_path(From, To, Path) :- 
	get_distance(From, To, Dist) &
	astar([node(From, Dist)], [], To, Path).

//A*
astar(Open, Closed, Goal, Solution) :- astar(Open, Closed, 0, Goal, [], Solution).
astar([], Closed, _, Goal, _, []).
astar(_, _, Depth, Goal, [H|Path], Solution) :-
	Goal==H &
	.reverse([Goal|Path], Solution).
astar(Open, Closed, Depth, Goal, Path, Solution) :-
	get_min(Open, node(Best, BestVal))&
	.delete(node(Best, BestVal), Open, TmpOpen)&
	expand(Best, Closed, Depth, Goal, Expanded) &
	.concat(Expanded, TmpOpen, NewOpen)&
	astar(NewOpen, [Best|Closed], Depth+1, Goal, [Best|Path], Solution).

//Expanze uzlu
expand(pos(X, Y), Closed, Depth, Goal, Expanded) :-
	get_distance(pos(X, Y-1), Goal, DistUp) &
	get_distance(pos(X, Y+1), Goal, DistDown) &
	get_distance(pos(X+1, Y), Goal, DistRight) &
	get_distance(pos(X-1, Y), Goal, DistLeft) &
	filter_impossible([node(pos(X, Y-1), DistUp),
					   node(pos(X, Y+1), DistDown),
					   node(pos(X+1, Y), DistRight),
					   node(pos(X-1, Y), DistLeft)], OnlyCorrect)&
	filter_closed(OnlyCorrect, Closed, Expanded).

//Filters out impossible positions
filter_impossible([],[]).
filter_impossible([node(pos(X, Y), V)|T],[node(pos(X, Y), V)|F]) :-
	X>=0 & Y>=0 &
	grid_size(A, B) & X<A & Y<B &
	not dbObstacle(X,Y) &
	filter_impossible(T, F).
filter_impossible([H|T], F) :-
	filter_impossible(T, F).

//Filters out nodes that are in the closed set
filter_closed([], _, []).
filter_closed([H|T], Closed, F) :-
	.member(H, Closed)&
	filter_closed(T, Closed, F).
filter_closed([H|T], Closed, [H|F]) :-
	filter_closed(T, Closed, F).

	
//Finds the node with minimal evaluation 
get_min([H|T], O) :- get_min(T, H, O).
get_min([], H, H).
get_min([node(ACoords, AVal)|T], node(BCoords, BVal), O) :- AVal<BVal & get_min(T, node(ACoords, AVal), O).
get_min([node(ACoords, AVal)|T], node(BCoords, BVal), O) :- AVal>=BVal & get_min(T, node(BCoords, BVal), O).
 