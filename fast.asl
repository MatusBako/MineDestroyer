sight(1). // different for other agents


{ include("common.asl") }	
{ include("percepts.asl") }

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
+!nextAction: canCarryWood & dbWood(X,Y) <-
	!findWood.
/*+!nextAction: canCarryGold & dbGold(X,Y)  <-
	!findGold.
+!nextAction: canCarryWood & canCarryGold & (dbWood(X,Y) | dbGold(X,Y)) <-
    !findRes.*/
+!nextAction: unexplored(X,Y) <-
	!explore.
+!nextAction.


+step(0) <-
	?grid_size(XS,YS);
	for (.range(X,0,XS-1))
	{
		for (.range(Y,0,YS-1))
		{
			+unexplored(X,Y)
		}
	};
	!scanArea;
	!nextAction.


// check powerup
+step(S): pos(X,Y) & shoes(X,Y) & not hasShoes <-
	!pick(dbShoes(X,Y));
	+hasShoes.
	

+step(S): dbShoes(X,Y) & not hasShoes <-
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
	!pick(dbWood(X,Y)).

+step(S): pos(X,Y) & gold(X,Y) & canCarryGold & ally(X,Y) <-
	!pick(dbGold(X,Y)).
	
+step(S): come(X,Y) & canCarryGold<-
	!goto(X,Y).
+step(S): come(X,Y) &  pos(X,Y)<-
	.abolish(come(X,Y)).
/*+step(S): canCarryWood & canCarryGold & (dbWood(_,_) | dbGold(_,_)) <-
	!findRes.
*/
+step(S): canCarryWood & dbWood(X,Y) <- 
	!findWood.
/*
+step(S): canCarryGold & dbGold(_,_) <- 
	!findGold.
*/

// exploration
+step(S): unexplored(X,Y) <-
	!explore.

// terminal rule
+step(S) <-
	?depot(X,Y);
	!goto(X,Y).
	
+step(S).

