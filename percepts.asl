+obstacle(X,Y): not dbObstacle(X,Y) <-
	+dbObstacle(X,Y);
	for(friend(A))
	{
		.send(A,tell,dbObstacle(X,Y));
	}.

+depot(X,Y) <- +dbDepot(X,Y).
	
+wood(X,Y): not dbWood(X,Y) <-
	+dbWood(X,Y);
	for(friend(A))
	{
		.send(A,tell,dbWood(X,Y));
	}.

+gold(X,Y) : not dbGold(X,Y) <-
	+dbGold(X,Y);
	for(friend(A))
	{
		.send(A,tell,dbGold(X,Y));
	}.

+shoes(X,Y): not dbShoes(X,Y) <-
	+dbShoes(X,Y);
	for(friend(A))
	{
		.send(A,tell,dbShoes(X,Y));
	}.

+spectacles(X,Y): not dbSpectacles(X,Y) <-
	+dbSpectacles(X,Y);
	for(friend(A))
	{
		.send(A,tell,dbSpectacles(X,Y));
	}.

+gloves(X,Y): not dbGloves(X,Y) <-
	+dbGloves(X,Y);
	for(friend(A))
	{
		.send(A,tell,dbGloves(X,Y));
	}.


