{ include("a_star.asl") }
// map between BB info and percepts
map(dbShoes(X,Y),shoes(X,Y)).
map(dbGloves(X,Y),gloves(X,Y)).
map(dbSpectacles(X,Y),spectacles(X,Y)).
map(dbGold(X,Y),gold(X,Y)).
map(dbWood(X,Y),wood(X,Y)).
map(dbObstacle(X,Y),obstacle(X,Y)).

getPos(dbShoes(X,Y), X, Y).
getPos(dbGloves(X,Y), X, Y).
getPos(dbSpectacles(X,Y), X, Y).
getPos(dbGold(X,Y), X, Y).
getPos(dbWood(X,Y), X, Y).

+!skipRestOfTurn <-
	while (moves_left(Left) & Left > 0)
	{
		do(skip)	
	}.


+!tellFriends(X) <-
	for(friend(A))
	{
		.send(A,tell,X);
	}.

+!untellFriends(X) <-
	for(friend(A))
	{
		.send(A,achieve,unbelieve(X));
	}.

+!unbelieve(X) <- .abolish(X).
+!unbelieve(X)[_] <- .abolish(X).

capacityReached :-
	carrying_gold(G) &
	carrying_wood(W) &
	carrying_capacity(MAX) &
	G + W == MAX.

inSight(X,Y,TX,TY) :- 
	sight(Sight) & 
	math.abs(X-TX) <= Sight &
	math.abs(Y-TY) <= Sight.

canCarryWood :- carrying_gold(G) & G == 0 & ~capacityReached.
canCarryGold :- carrying_wood(W) & W == 0 & ~capacityReached.

+!pick(dbShoes(X,Y)) <-
	do(pick);
	-target(X,Y);
	.abolish(dbShoes(X,Y));
	!untellFriends(dbShoes(X,Y));
	!untellFriends(targeted(X,Y)).
+!pick(dbGloves(X,Y)) <-
	do(pick);
	-target(X,Y);
	.abolish(dbGloves(X,Y));
	!untellFriends(dbGloves(X,Y));
	!untellFriends(targeted(X,Y)).
+!pick(dbSpectacles(X,Y)) <-
	do(pick);
	-target(X,Y);
	.abolish(dbSpectacles(X,Y));
	!untellFriends(dbSpectacles(X,Y));
	!untellFriends(targeted(X,Y)).
+!pick(dbWood(X,Y)) <-
	do(pick);
	-target(X,Y);
	.abolish(dbWood(X,Y));
	!untellFriends(dbWood(X,Y));
	!untellFriends(targeted(X,Y)).
+!pick(dbGold(X,Y)) <-
	do(pick);
	-target(X,Y);
	.abolish(dbGold(X,Y));
	!untellFriends(dbGold(X,Y));
	!untellFriends(targeted(X,Y)).

+!goto(X,Y): pos(X,Y) <-
	!skipTurn.
+!goto(X,Y): moves_left(N) & N == 0.
+!goto(X,Y): moves_left(N) & pos(A,B) & get_instructions(loc(A,B), loc(X,Y), N, Moves) <-
	.println("Moves: ",Moves);	
	for ( .member(X,Moves) ) 
	{	
		.println("Moving ",X);
		do(X);    // print all members of the list
	}
	!scanArea.

	
+!explore : pos(A,B)<-
	.println("** Exploring", A,", ", B);
	.findall(dst(Dist,X,Y),unexplored(X,Y) & 
		get_distance(loc(A,B), loc(X,Y), Dist) & not targeted(X,Y), Unx);
	.min(Unx, Dst);
	Dst = dst(_, X, Y);
	!goto(X,Y).
	

	
+!target(X,Y) <-
	+target(X,Y);
	+targeted(X,Y);
	!tellFriends(targeted(X,Y)).

+!scanArea <-
	?pos(X,Y);
	?sight(Sight);
	
	.findall(unexplored(UX,UY),unexplored(UX,UY) & math.abs(X-UX) <= Sight & math.abs(Y-UY) <= Sight, U);

	.println("Position: ",X, ", ", Y);
	.println("Sight: ",Sight);
	.println("Removing: ",U);

	// remove unexplored tiles
	for (.member(M,U))
	{
		.abolish(M);
		!untellFriends(M);
	};

	// remove vanished resources
	.findall(dbShoes(IX,IY),dbShoes(IX,IY) & math.abs(X-IX) <= Sight & math.abs(Y-IY) <= Sight, H);
	for (.member(M,H))
	{
		// if percept not doesn't agree
		if (getPos(M,IX,IY) & not shoes(IX,IY))
		{
			.abolish(M);
			!untellFriends(M);
			!untellFriends(targeted(IX,IY));
		}
	};

	.findall(dbGloves(IX,IY),dbGloves(IX,IY) & math.abs(X-IX) <= Sight & math.abs(Y-IY) <= Sight, L);
	for (.member(M,L))
	{
		// if percept not doesn't agree
		if (getPos(M,IX,IY) & not gloves(IX,IY))
		{
			.abolish(M);
			!untellFriends(M);
			!untellFriends(targeted(IX,IY));
		}
	};	

	.findall(dbSpectacles(IX,IY),dbSpectacles(IX,IY) & math.abs(X-IX) <= Sight & math.abs(Y-IY) <= Sight, P);
	for (.member(M,P))
	{
		// if percept not doesn't agree
		if (getPos(M,IX,IY) & not spectacles(IX,IY))
		{
			.abolish(M);

			!untellFriends(M);
			!untellFriends(targeted(IX,IY));
		}
	};

	.findall(dbGold(IX,IY),dbGold(IX,IY) & math.abs(X-IX) <= Sight & math.abs(Y-IY) <= Sight, G);
	for (.member(M,G))
	{
		// if percept not doesn't agree
		if (getPos(M,IX,IY) & not gold(IX,IY))
		{
			.abolish(M);

			!untellFriends(M);
			!untellFriends(targeted(IX,IY));
		}
	};

	.findall(dbWood(IX,IY),dbWood(IX,IY) & math.abs(X-IX) <= Sight & math.abs(Y-IY) <= Sight, W);
	for (.member(M,W))
	{
		// if percept not doesn't agree
		if (getPos(M,IX,IY) & not wood(IX,IY))
		{
			.abolish(M);

			!untellFriends(M);
			!untellFriends(targeted(IX,IY));
		}
	}.

