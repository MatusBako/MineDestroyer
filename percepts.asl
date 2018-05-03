+obstacle(X,Y) <-
	+dbObstacle(X,Y);
	.for(friend(A))
	{
		.send(A,tell,dbObstacle(X,Y));
	}.

+wood(X,Y) <-
	+dbWood(X,Y);
	.for(friend(A))
	{
		.send(A,tell,dbWood(X,Y));
	}.

+gold(X,Y) <-
	+dbGold(X,Y);
	.for(friend(A))
	{
		.send(A,tell,dbGold(X,Y));
	}.

+shoes(X,Y) <-
	+dbShoes(X,Y);
	.for(friend(A))
	{
		.send(A,tell,dbShoes(X,Y));
	}.

+spectacles(X,Y) <-
	+dbSpectacles(X,Y);
	.for(friend(A))
	{
		.send(A,tell,dbSpectacles(X,Y));
	}.

+gloves(X,Y) <-
	+dbGloves(X,Y);
	.for(friend(A))
	{
		.send(A,tell,dbGloves(X,Y));
	}.


