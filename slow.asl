+sight(3). // different for other agents
+fastName(teamAFast).
+medName(teamAMedium).
+slowName(teamASlow).

//{ include("./a_star.asl")  }
{ include("percepts.asl") }
{ include("common.asl") }


//TODO: do goto pridat preposielanie suradnic medzi MED a FAST
		
+!step(0) <-
	?grid_size(XS,YS);_
	for ( .range(X,0,XS-1))
	{
		for ( .range(Y,0,YS-1))
		{
			+unexplored(X,Y)
		}
	};
	!scanArea;
	!explore.

+!step(S): onPowerUp(dbSpectacles) <-
	!pick(dbSpectacles(X,Y));
	+hasSpectacles;
	-sight(3);
	+sight(6).
	
+!step(S): dbSpectacles(X,Y) & not hasSpectacles <-
	!goto(X,Y).

+!step(S): unexplored(X,Y) <-
	!explore.

+!step(S): capacityReached & pos(X,Y) & depot(X,Y) <-
	do(drop).

+!step(S): capacityReached <-
	?depot(X,Y);
	!goto(X,Y).

+!step(S): pos(X,Y) & wood(X,Y) <-
	!pick(dbWood(X,Y)).

+!step(S): pos(X,Y) & gold(X,Y) <-
	!pick(dbGold(X,Y)).

+!step(S): pos(X,Y) & target(TX,TY) & math.abs(X-TX)  

+!step(S): dbGold(X,Y) & not targeted(X,Y) <- 
	!target(X,Y);
	!goto(X,Y).

+!step(S): dbWood(X,Y) & not targeted(X,Y) <- 
	!target(X,Y);
	!goto(X,Y).
