/*
MAP EXCHANGE:
na zaciatku (raz) a po kazdom pohybe poslat suradnice mapy inym agentom
s cislom kola (step), pockat si na flag, ze si dostal vsetky suradnice
*/

/*
Rozhodovanie - komu dat ulohu brat suroviny

Slow- ak je blizsie ako fast objavovanie
Fast - ak vie o surovinach - zober, inak objavuj
Middle- ak je blizsie ako fast, ber, inak fast, inak explore
*/

+distance(X1, Y1, X2, Y2, R) <-
	R = math.abs(X1 - X2) + math.abs(Y1 - Y2).

// TODO: GOTO
// ides kym mozes, ak nemozes, po pravej ruke kym nemozes spravnym smerom
// ukladas si odkial si prisiel aby si sa netocil

/*
Rozhlad je STVORCOVY

na zaciatku vygenerovat suradnice nepreskumanych policok 
	a postupne odoberat

getUnexplored - vyriesene, A* riesi cestu, pripadne vyraduje

- A* volat s parametrom kolko tahov ma vratit
- ked vrati prazdny zoznam, neexistuje cesta

3 stavy - exploring, returning, goingToResource

- rozhlad a power-upy napevno z belief base (getRange)
*/

+!goto(X,Y) <-
	pos(X,Y);
	!skipMoves().

+!goto(X,Y) <-

+!skip <-
	moves_left(Left);
	Left > 0;
	do(skip);	// skip or not??
	!goto(X,Y)
+!skip <- true.

// TODO: SCAN
// zistis co mas v okoli a preposles ostatnym

+!scanArea<-
	pos(X,Y),

// grid_size(A,B)

+!storeInv <-
	depot(X,Y);
	pos(X,Y);
	do(drop).

+!storeInv <-
	depot(X,Y);
	goto(X,Y).

capacityReached :-
	carrying_gold(G) &
	carrying_wood(W) &
	carrying_capacity(MAX) &
	G + W == MAX.

+!step(X): capacityReached <-
	!storeInv.

+!step(X): ResourcePos(X,Y) & pos(X, Y) <-
	do(pick).

// TODO: zdvihni powerup

+!step(X): ResourcePos(X,Y) <-
	!goto(X,Y).

+!step(X): mapNotExplored() <-
	getUnexploredPos(X,Y),
	goto(X,Y).
+!step(X).