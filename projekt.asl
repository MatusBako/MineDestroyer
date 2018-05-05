+sight(1). // different for other agents
+fastName(teamAFast).
+medName(teamAMedium).
+slowName(teamASlow).

{ include("percepts.asl") }
{ include("common.asl") }


// reaction to seeing removed resource on turn end after scan
-dbShoes(X,Y): target(X,Y) <-
	-target(X,Y);
	!nextAction.

-dbGold(X,Y): target(X,Y) <-
	-target(X,Y);
	!nextAction.

-dbWood(X,Y): target(X,Y) <-
	-target(X,Y);
	!nextAction.


+!nextAction: dbShoes(X,Y) & not hasShoes <-
	!target(X,Y);
	!goto(X,Y).
+!nextAction: canCarryWood & canCarryGold <-
	//TODO: - get closest of all untargeted Wood and Gold
	!target(X,Y);
	!goto(X,Y).
+!nextAction: canCarryWood & dbGold(_,_) <-
	//TODO: - get closest of all untargeted Wood
	!target(X,Y);
	!goto(X,Y).
+!nextAction: canCarryGold & dbGold(_,_)  <-
	//TODO: - get closest of all untargeted Gold
	!target(X,Y);
	!goto(X,Y).
+!nextAction: unexplored(X,Y) <-
	!explore.
+!nextAction.


+!step(0) <-
	?grid_size(XS,YS);_
	for ( .range(X,0,XS-1))
	{
		for ( .range(Y,0,YS-1))
		{
			+unexplored(X,Y)
		}
	};
	!nextAction.


// check powerup
+!step(S): pos(X,Y) & shoes(X,Y) & not hasShoes <-
	!pick(dbShoes(X,Y));
	+hasShoes.
	

+!step(S): dbShoes(X,Y) & not hasShoes <-
	!target(X,Y);
	!goto(X,Y).


// full capacity
+!step(S): capacityReached & pos(X,Y) & dbDepot(X,Y) <-
	do(drop);
	!nextAction.

+!step(S): capacityReached <-
	?dbDepot(X,Y);
	!goto(X,Y).


// pickup Resources
+!step(S): pos(X,Y) & wood(X,Y) & canCarryWood <-
	!pick(dbWood(X,Y)).

+!step(S): pos(X,Y) & gold(X,Y) & canCarryGold <-
	!pick(dbGold(X,Y)).

+!step(S): canCarryWood & canCarryGold & (dbWood(_,_) | dbGold(_,_)) <-
	//TODO: - get closest of all untargeted Wood and Gold
	!target(X,Y);
	!goto(X,Y).

+!step(S): canCarryWood & dbWood(_,_) <- 
	//TODO: - get closest of all untargeted Wood
	!target(X,Y);
	!goto(X,Y).

+!step(S): canCarryGold & dbGold(_,_) <- 
	//TODO: - get closest of all untargeted Gold
	!target(X,Y);
	!goto(X,Y).

// exploration
+!step(S): unexplored(X,Y) <-
	!explore.

// terminal rule
+!step(S).
