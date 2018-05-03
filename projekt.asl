+sight(1). // different for other agents
+fastName(teamAFast).
+medName(teamAMedium).
+slowName(teamASlow).

//{ include("./a_star.asl")  }
{ include("percepts.asl") }

//TODO: do goto pridat preposielanie suradnic medzi MED a FAST
+!goto(X,Y) : pos(X,Y) <-
	!skipTurn.
+!goto(X,Y).

+!skipRestOfTurn <-
	.while (moves_left(Left) & Left > 0)
	{
		do(skip)	
	}.

+!unbelieve(X) <- abolish(X).

+!tellFriends(X) <-
	.for(friend(A))
	{
		.send(A,tell,X);
	}.

+!untellFriends(X) <-
	.for(friend(A))
	{
		.send(A,achieve,unbelieve(X));
	}.

+!target(X,Y) <-
	+targeted(X,Y);
	!tellFriends(targeted(X,Y)).


// agent carrieso only one of these
// but it works anyway
capacityReached :-
	carrying_gold(G) &
	carrying_wood(W) &
	carrying_capacity(MAX) &
	G + W == MAX.

onPowerUp :-
	pos(X,Y) &
	.my_name(Name) &
	.length(Name,Length) &
	.nth(Length-1, Name,Last)
	(
		(gloves(GX,GY) & Last == "t" & HX == X & HY == Y) |		//fast
		(spectacles(SX,SY) & Last == "e" & GX == X & GY == Y) |	//middle
		(shoes(HX,HY) & Last == "w" & SX == X & SY == Y)		//slow
	).

// becuse agent carries one type of resource at a time
canCarryWood :- carrying_gold(G) & G == 0 & ~capacityReached.
canCarryGold :- carrying_wood(W) & W == 0 & ~capacityReached.

+!scanArea <-
	?pos(X,Y);
	?sight(S)
	.findall(unexplored(UX,UY),math.abs(X-UX) <= S & math.abs(Y-UY) <= S, L);
	.for (.member(M,L))
	{
		-unexplored(X,Y);
		!untellFriends(unexplored(X,Y))
	}.

		
+!step(0) <-
	for ( .range(X,0,39))
	{
		for ( .range(Y,0,39))
		{
			+unexplored(X,Y)
		}
	};
	+state(explore).

+!step(S): state(locatePow)

+!step(S): state(return) & depot(X,Y) & pos(X,Y) <-
	do(drop);
	-state().

+!step(S): state(return) <-
	?depot(X,Y);
	goto(X,Y).

+!step(S): onPowerUp <-
	do(pick).
	

+!step(S): dbWood(X,Y) & pos(X, Y) & canCarryWood<-
	do(pick);
	-dbWood(X,Y);
	!untellFriends(dbWood(X,Y)).

+!step(S): dbGold(X,Y) & pos(X, Y) & canCarryGold<-
	do(pick);
	-dbGold(X,Y);
	!untellFriends(dbGold(X,Y)).

+!step(S): carrying_wood(W) & W > 0 dbWood(X,Y) <-
	!goto(X,Y).

+!step(S): state(explore) & unexplored(X,Y) <-
	?unexploredPos(X,Y); //get from A*
	goto(X,Y).
+!step(S).