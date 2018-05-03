# MineDestroyer

Traja agenti (slow, med, fast) na gride 40x40.

#### Klúčové informácie
- rozhľad sa berie štvorcový (rozhlad 1 znamená že vidím štvorec 3x3)

- súradnice agenta sa počítajú od 0

- na začiatku sa vytvorí v belief(?) base (ďalej BB) informácia o všetkých nepreskúmaných políčkach a postupne sa odoberajú

- udržujú sa informácie o prekážkach, vylepšeniach a zdrojoch

#### Výmena informácii o mape

Na začiatku hry a po každom pohybe sa pošlú súradnice mapy iným agentom. 
s cislom kola (step), pockat si na flag, ze si dostal vsetky suradnice


## Metódy na naimplementovanie

### Scan

Pre každú súradnicu v rozhľade odstrániš unexplored(X,Y) z BB a zapíšeš do BB (a prepošleš ostatným) ak to bolo neprázdne políčko (**predpona je nutná** aby sa názvy nekryli s perceptami, lebo percepty sú aktualizované):

- dbObstacle(X,Y)
- dbWood(X,Y), dbGold(X,Y)
- dbGloves(X,Y), dbSpectacles(X,Y), dbShoes(X,Y) - prepošleš iba príslušnému agentovi



- metóda scan odoberá nepreskúmané políčka, pridáva a zdiela info o vylepšeniach a zdrojoch 

### A*
Rieši získavanie vzdialenosti a nasledujúcich ťahov. Metóda by mala vracať _n_ nasledujúcich ťahov podľa parametru. Keď neexistuje cesta k cieľu, vráti prázdny zoznam (a vyhodí miesto z BB). 



## Stratégie
Slow- ak je blizsie ako ostatni, inak objavovanie

Fast - ak vie o nejakych surovinach - zober, inak objavuj

Middle- ak je blizsie ako fast a moze, bere, inak bere fast a M objavuje

**TODO:** pridať výmenu súradníc medzi FAST a MED a podla toho zisťovať, kto je bližšie a pôjde pre surovinu

#### FAST

Agent má **4 stavy** činnosti: 

- state(explore) : agent nemá informáciu o existujúcich surovinách a je na ceste na nepreskúmané súradnice

-  state(locateRes) : agent je na ceste ku surovine, agenti samostatne rozhodnú podľa ich pozícii ktorý to pôjde zobrať, ostatným sa to vyhodí z BB

- state(locatePow) : agent je na ceste k vylepšeniu (pre seba)

- state(return) - agent má plnú kapacitu (alebo došli suroviny) a 



- state(return) & pos(depo)		-> explore
- state(return)				-> goto(dep)
- state(locatePow) & pos(pow)	-> explore
- state(locatePow)
- state(locateRes) & pos(res)		-> pick(Res), state(explore|return)
- state(locateRes)			-> goto(Res)

- state(explore) & dbWood(X,Y) & not targeted(X,Y)	
	& canCarryWood -> state(locateRes), targeted(X, Y)
		
- state(explore) & dbGold(X,Y) & not targeted(X,Y)	
	& canCarryGold -> state(locateRes), targeted(X, Y)

- state(explore) & mapUnexplored() -> explore
.


MED
//TODO: asi to isté ako fast, bude to genericky nakódené

SLOW
- not hasSpectacles & dbSpectacles(X,Y)	-> goto(spectacles)
- mapUnexplored					-> explore
- capacityReached 				-> goto(dep)
- pos(res)						-> goto(Res)
- pickResources					-> goto(Res)
.
