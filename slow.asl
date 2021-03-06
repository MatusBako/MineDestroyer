sight(3). // different for other agents
+fastName(teamAFast).
+medName(teamAMedium).
+slowName(teamASlow).

{ include("percepts.asl") }
{ include("common.asl") }	

// reaction to seeing removed resource on turn end after scan
-dbSpectacles(X,Y): target(X,Y) <-
	-target(X,Y);
	!nextAction.

-dbGold(X,Y): target(X,Y) <-
	-target(X,Y);
	!nextAction.

-dbWood(X,Y): target(X,Y) <-
	-target(X,Y);
	!nextAction.

// not necessary but saves steps
// choose next action immediately
// after last one got cancelled
+!nextAction: unexplored(_,_) <-
	!explore.
+!nextAction: dbSpectacles(X,Y) & not hasSpectacles <-
	!target(X,Y);
	!goto(X,Y).
+!nextAction: canCarryWood  & dbWood(_,_) <-
    !findWood.
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
	!explore.

+step(S): pos(X,Y) & spectacles(X,Y) & not hasSpectacles <-
	!pick(dbSpectacles(X,Y));
	+hasSpectacles;
	-sight(3);
	+sight(6).
	
+step(S): dbSpectacles(X,Y) & not hasSpectacles <-
	!target(X,Y);
	!goto(X,Y).

+step(S): unexplored(X,Y) <-
	!explore.

+step(S): capacityReached & pos(X,Y) & dbDepot(X,Y) <-
	do(drop);
	!nextAction.

+step(S): capacityReached <-
	?dbDepot(X,Y);
	!goto(X,Y).

+step(S): returnBase & pos(X,Y) & dbDepot(X,Y) <-
	do(drop);
	!nextAction.

+step(S): returnBase <-
	?depot(X,Y);
	!goto(X,Y).

+step(S): pos(X,Y) & wood(X,Y) & canCarryWood <-
	!pick(dbWood(X,Y)).

/*+step(S): pos(X,Y) & gold(X,Y) & canCarryGold <-
	!pick(dbGold(X,Y)).*/

/*+step(S): canCarryWood & canCarryGold & (dbWood(_,_) | dbGold(_,_)) <-
	!findRes.*/

+step(S): canCarryWood & dbWood(_,_) <- 
	!findWood.
/*
+step(S): canCarryGold & dbGold(_,_) <- 
	!findGold.*/

+step(S)<-
	?depot(X,Y);
	!goto(X,Y).
+step(S).

