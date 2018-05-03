
// map between BB info and percepts
map(dbShoes,shoes).
map(dbGloves,gloves).
map(dbSpectacles,spectacles).
map(dbGold,gold).
map(dbWood,wood).
map(dbObstacle,obstacle).

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

onPowerUp(dbShoes) :-		//fast
	pos(X,Y) &
	.my_name(Name) &
	.length(Name,Length) &
	.nth(Length-1, Name,Last) & 
	shoes(X,Y) & Last == "t" &.

onPowerUp(dbGloves) :-	//middle
	pos(X,Y) &
	.my_name(Name) &
	.length(Name,Length) &
	.nth(Length-1, Name,Last) &
	gloves(X,Y) & Last == "e".

onPowerUp(dbSpectacles) :-		//slow
	pos(X,Y) &
	.my_name(Name) &
	.length(Name,Length) &
	.nth(Length-1, Name,Last)
	spectacles(X,Y) & Last == "w".

canCarryWood :- carrying_gold(G) & G == 0 & ~capacityReached.
canCarryGold :- carrying_wood(W) & W == 0 & ~capacityReached.

+!pick(Item(X,Y)) <-
	do(pick).
	-target(X,Y);
	-Item;
	!untellFriends(Item(X,Y));
	!untellFriends(targeted(X,Y)).

+!goto(X,Y) : pos(X,Y) <-
	!skipTurn.
+!goto(X,Y) <-
	!move; //TODO: w8ing 4 A*
	!scanArea.

+!target(X,Y) <-
	+targeted(X,Y);
	!tellFriends(targeted(X,Y)).

+!scanArea <-
	?pos(X,Y);
	?sight(S)
	.findall(unexplored(UX,UY),math.abs(X-UX) <= S & math.abs(Y-UY) <= S, L);

	// remove unexplored tiles
	for (.member(M,L))
	{
		-unexplored(X,Y);
		!untellFriends(unexplored(X,Y))
	};

	// remove vanished resources
	for (.member([dbShoes,dbGloves,dbSpectacles,dbGold,dbWood],Item))
	{
		// for all items from memory (from DB)
		.findall(Item(UX,UY),math.abs(X-UX) <= S & math.abs(Y-UY) <= S, L);
		for (.member(M,L))
		{
			// if percept not doesn't agree
			if (map(Item,Percept) not Percept(X,Y))
			{
				-Item(X,Y);

				// TODO: every agent reacts differently to this
				!untellFriends(Item(X,Y))
			}
		}
	}.

