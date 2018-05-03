+sight(1). // different for other agents
+fastName(teamAFast).
+medName(teamAMedium).
+slowName(teamASlow).

//{ include("./a_star.asl")  }
{ include("percepts.asl") }
{ include("common.asl") }

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

//TODO: rework imminent!

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