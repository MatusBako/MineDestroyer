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

capacityReached :-
	carrying_gold(G) & G>0 &
	not dbGold(_,_) &
	not unexplored(_,_).

capacityReached :-
	carrying_wood(W) & W>0 &
	not dbWood(_,_) &
	not unexplored(_,_).
	
inSight(X,Y,TX,TY) :- 
	sight(Sight) & 
	math.abs(X-TX) <= Sight &
	math.abs(Y-TY) <= Sight.

canCarryWood :- carrying_gold(G) & G == 0 & not capacityReached.
canCarryGold :- carrying_wood(W) & W == 0 & not capacityReached.

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
+!goto(X,Y) <- ?moves_left(N);
	for (.range(_,1,N))
	{	
		?pos(A,B);
		//.println("From: ",loc(A,B));
		//.println("To: ",loc(X,Y));
		astar.astar(A, B, X, Y, Move);
		//.println("Going  ",Move);
		if (Move == fail)
		{
			.abolish(unexplored(X,Y));
			!untellFriends(unexplored(X,Y));
			do(skip);
		}
		else
		{
			do(Move);
		}
		!scanArea;
	};
	//.println("** finished moving to ", X, Y)
	.
+!goto(X,Y) <- 
	.abolish(unexplored(X,Y));
	!untellFriends(unexplored(X,Y));
	?moves_left(N);
	for (.range(_,1,N))
	{	
		do(skip);
	}.
+!goto(X,Y).
	
	
+!explore : pos(A,B)<-
	.findall(dst(Dist,X,Y),unexplored(X,Y) & 
		get_distance(loc(A,B), loc(X,Y), Dist) & not targeted(X,Y) , Unx);
	.min(Unx, Dst);
	Dst = dst(_, X, Y);
	!goto(X,Y).


	
+!findRes : pos(A,B)<-
	.findall(dst(Dist,X,Y),(dbWood(X,Y) | dbGold(X,Y)) & 
		get_distance(loc(A,B), loc(X,Y), Dist) & not targeted(X,Y) , Unx);
	.min(Unx, Dst);
	Dst = dst(_, X, Y);
	!goto(X,Y).
	
	
+!findWood : pos(A,B)<-
	.findall(dst(Dist,X,Y),dbWood(X,Y) & 
		get_distance(loc(A,B), loc(X,Y), Dist) & not targeted(X,Y) , Unx);
	.min(Unx, Dst);
	Dst = dst(_, X, Y);
	!goto(X,Y).
	
		
+!findGold : pos(A,B)<-
	.findall(dst(Dist,X,Y),dbGold(X,Y) & 
		get_distance(loc(A,B), loc(X,Y), Dist) & not targeted(X,Y) , Unx);
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

	//.println("Position: ",X, ", ", Y);
	//.println("Sight: ",Sight);
	//.println("Removing: ",U);

	// remove unexplored tiles
	for (.member(M,U))
	{
		.abolish(M);
		!untellFriends(M);
	};
	//.println("** Passed remove of unexplored");
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
	//.println("** Passed remove vanished resources");

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
	//.println("** Passed finding gloves");

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

	//.println("** Passed finding spectacles");
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
	
	//.println("** Passed finding wood");

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

