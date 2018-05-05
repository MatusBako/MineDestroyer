
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
+!goto(X,Y): moves_left(X) & X == 0.
+!goto(X,Y) <-
	!move; //TODO: w8ing 4 A*
	!scanArea.

+!target(X,Y) <-
	+target(X,Y);
	+targeted(X,Y);
	!tellFriends(targeted(X,Y)).

+!scanArea <-
	?pos(X,Y);
	?sight(S);
	.findall(unexplored(UX,UY),math.abs(X-UX) <= S & math.abs(Y-UY) <= S, L);

	// remove unexplored tiles
	for (.member(M,L))
	{
		-unexplored(X,Y);
		!untellFriends(unexplored(X,Y))
	};

	// remove vanished resources
	for (.member([dbShoes(_,_),dbGloves(_,_),dbSpectacles(_,_),dbGold(_,_),dbWood(_,_)],Item))
	{
		// for all items from memory (from DB)
		.findall(Item,getPos(Item,IX,IY) & math.abs(X-IX) <= S & math.abs(Y-IY) <= S, L);
		for (.member(M,L))
		{
			// if percept not doesn't agree
			if (map(Item,Percept) & not Percept)
			{
				.abolish(Item);

				!untellFriends(Item);
				!untellFriends(targeted(IX,IY))
			}
		}
	}.
