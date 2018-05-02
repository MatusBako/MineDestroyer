# MineDestroyer

Traja agenti (slow, med, fast) na gride 40x40.

#### Klúčové informácie
- rozhľad sa berie štvorcový (rozhlad 1 je štvorec 3x3)

- na začiatku sa vytvorí v belief(?) base (ďalej BB) informácia o všetkých nepreskúmaných políčkach a postupne sa odoberajú

- udržujú sa informácie o prekážkach, vylepšeniach a zdrojoch


- agent má **3 stavy** činnosti: state(explore), state(pickup), state(return)

## Metódy na naimplementovanie

###Scan

Pre každú súradnicu v rozhľade odstrániš unexplored(X,Y) z BB a zapíšeš do BB (a prepošleš ostatným) ak to bolo neprázdne políčko:

- obstacle(X,Y)
- wood(X,Y), gold(X,Y)
- gloves(X,Y), spectacles(X,Y), shoes(X,Y) - prepošleš iba príslušnému agentovi


- metóda scan odoberá nepreskúmané políčka, pridáva a zdiela info o vylepšeniach a zdrojoch 

### A*
Rieši získavanie vzdialenosti a nasledujúcich ťahov. Metóda by mala vracať _n_ nasledujúcich ťahov podľa parametru. Keď neexistuje cesta k cieľu, vráti prázdny zoznam (a vyhodí miesto z BB). 

/*
- rozhlad a power-upy napevno z belief base (getRange)
*/

/*
MAP EXCHANGE:
na zaciatku (raz) a po kazdom pohybe poslat suradnice mapy inym agentom
s cislom kola (step), pockat si na flag, ze si dostal vsetky suradnice
*/



##Stratégie
Rozhodovanie - komu dat ulohu brat suroviny

Slow- ak je blizsie ako fast objavovanie
Fast - ak vie o surovinach - zober, inak objavuj
Middle- ak je blizsie ako fast, ber, inak fast, inak explore
