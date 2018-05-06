sight(1). // different for other agents

{ include("common.asl") }	
{ include("percepts.asl") }

// reaction to seeing removed resource on turn end after scan
-dbGloves(X,Y): target(X,Y) <-
	-target(X,Y);
	!nextAction.

-dbGold(X,Y): target(X,Y) <-
	-target(X,Y);
	!nextAction.

-dbWood(X,Y): target(X,Y) <-
	-target(X,Y);
	!nextAction.


+!nextAction: dbGloves(X,Y) & not hasGloves <-
	!target(X,Y);
	!goto(X,Y).
+!nextAction: canCarryWood & dbWood(X,Y) <-
	!findWood.
+!nextAction: canCarryGold & dbGold(X,Y)  <-
	!findGold.
+!nextAction: canCarryWood & canCarryGold  & (dbWood(X,Y) | dbGold(X,Y)) <-
    !findRes.
+!nextAction: unexplored(X,Y) <-
	!explore.
+!nextAction.


+step(0) <-
	?grid_size(XS,YS);
	for ( .range(X,0,XS-1))
	{
		for ( .range(Y,0,YS-1))
		{
			+unexplored(X,Y)
		}
	};
	!scanArea;
	!nextAction.


// check powerup
+step(S): pos(X,Y) & gloves(X,Y) & not hasGloves <-
	!pick(dbGloves(X,Y));
	+hasGloves.
	

+step(S): dbGloves(X,Y) & not hasGloves <-
	!target(X,Y);
	!goto(X,Y).


// full capacity
+step(S): capacityReached & pos(X,Y) & depot(X,Y) <-
	do(drop);
	!nextAction.
+step(S): capacityReached <-
	?depot(X,Y);
	!goto(X,Y).

+step(S): returnBase & pos(X,Y) & dbDepot(X,Y) <-
	do(drop);
	!nextAction.
+step(S): returnBase <-
	?depot(X,Y);
	!goto(X,Y).

// pickup Resources
+step(S): pos(X,Y) & wood(X,Y) & canCarryWood <-
	!pick(dbWood(X,Y));
	!untellFriends(come(_,_)).

+step(S): pos(X,Y) & gold(X,Y) & canCarryGold & ally(X,Y) <-
	!pick(dbGold(X,Y));
	!nextAction.

+step(S): pos(X,Y) & gold(X,Y) <-
	!tellFriends(come(X,Y));
	!skipTurn.

+step(S): canCarryWood & dbWood(X,Y) <- 
	!findWood.
/*+step(S): canCarryWood & canCarryGold & (dbWood(_,_) | dbGold(_,_)) <-
	!findRes.*/
+step(S): canCarryGold & dbGold(X,Y) <- 
	!findGold.

// exploration
+step(S): unexplored(X,Y) <-
	!explore.
	
+step(S): pos(X,Y) & depot(X,Y) <-
	do(drop);
	!nextAction.
// terminal rule
+step(S) <-
	?depot(X,Y);
	!goto(X,Y);
	!untellFriends(come(_,_)).
+step(S).
