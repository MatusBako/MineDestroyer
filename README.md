# MineDestroyer

Traja agenti (slow, med, fast) na gride 40x40.

#### Klúčové informácie
- rozhľad sa berie štvorcový (rozhlad 1 znamená že vidím štvorec 3x3)

- súradnice agenta sa počítajú od 0

- na začiatku sa vytvorí v belief(?) base (ďalej BB) informácia o všetkých nepreskúmaných políčkach a postupne sa odoberajú

- udržujú sa informácie o prekážkach, vylepšeniach a zdrojoch

Agent má **3 stavy** činnosti: 

- state(explore) : agent nemá informáciu o existujúcich surovinách a je na ceste na nepreskúmané súradnice

-  state(pickup) : agent je na ceste ku surovine, agenti samostatne rozhodnú podľa ich pozícii ktorý to pôjde zobrať, ostatným sa to vyhodí z BB

- state(return) - agent má plnú kapacitu (alebo došli suroviny) a 


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
Rozhodovanie - komu dat ulohu brat suroviny

Slow- ak je blizsie ako fast objavovanie
Fast - ak vie o surovinach - zober, inak objavuj
Middle- ak je blizsie ako fast, ber, inak fast, inak explore
