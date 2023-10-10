/*********************************************
 * OPL 20.1.0.0 Model
 * Author: tvaucour
 * Creation Date: 10 mars 2023 at 08:13:13
 *********************************************/

 int nbPlant  = ...;
 int nbBrew = ...;
 int nbDist = ...;
 
 range dist = 1..nbDist;
 range brew = 1..nbBrew;
 range plant = 1..nbPlant;
 
 float costB[brew][dist] = ...;
 float demand[dist] = ...;
 float capacityB[brew]=...;
 float capacityM[plant]=...;
 float costM[plant][brew]=...;
 
 float maltY[plant]=...;
 
 //Decision variables
 dvar float+ x[brew][dist]; //ML of beer shipped from brewery to DC
 dvar float+ y[plant][brew]; //MT of malt shipped from plant to brewery
 
 //Model 
 minimize sum (i in brew) sum (j in dist) x[i][j]*costB[i][j] + sum(p in plant) sum(i in brew) y[p][i]*costM[p][i];
 subject to {
   forall (j in dist)
     	demandDC : sum (i in brew) x[i][j] >= demand[j]; //pour chaque DC, on lui ship plus de biere que sa demande
   forall (i in brew) 
   		capacityBrew : sum (j in dist) x[i][j] <= capacityB[i]; //pour chaque brasserie, on ship moins de biere que la capacit� � produire de la biere de la brasserie
   forall (i in brew)
     	beerYield: sum (j in dist) x[i][j] <= sum (p in plant) y[p][i]* maltY[p];
   	 	//beerYield: sum (j in dist) x[i][j] <= (y[1][i]+y[2][i])*8.333 + y[3][i]*9.091;  ---old version � la main
   	    //pour chaque brasserie, on ship moins de bi�re que le malt recu (avec conversion MT malt -> ML bi�re)
   	    //remarque : on pourrait faire des boucles au lieu d'iterer a travers les plants � la main pour convertir les MT malt en ML beer --- done
   forall (p in plant)
     	capacityMalt : sum (i in brew) y[p][i] <= capacityM[p];  //pour chaque plant, on ship moins de malt que la capacit� � produire
 }
 
 //C++ code execution
 execute{
   for(var i in brew)
   	for(var j in dist)
   		writeln("Brewery ", i," to DC ", j, ": ", x[i][j]," ML of beer to ship")
   writeln("-----------------------------------------------------------------------------------")   
   for(var p in plant)
   	for(var i in brew)		
   		writeln("Plant ", p," to brewery ", i,": ", y[p][i], " MT of malt to ship")
   writeln("-----------------------------------------------------------------------------------")
   
  /* writeln("Reduced cost of shipping from Istanbul to Antalya: ", x[1][3].reducedCost)
   writeln("Reduced cost of importing malt to Istanbul: ", y[3][1].reducedCost)
   writeln("Reduced cost of importing malt to Anakara: ", y[3][2].reducedCost) */
   
    for(var i in brew)
   	for(var j in dist)
   		writeln("Reduced cost: Brewery ", i," to DC ", j, ": ", x[i][j].reducedCost," $")
   writeln("-----------------------------------------------------------------------------------")   
   for(var p in plant)
   	for(var i in brew)		
   		writeln("Reduced cost: Plant ", p," to brewery ", i,": ", y[p][i].reducedCost, " $")
   writeln("-----------------------------------------------------------------------------------")
   for(var i in brew)
   		writeln("Dual var: Brewery ", i, " capacity: ", capacityBrew[i].dual)
   writeln("-----------------------------------------------------------------------------------")
   for(var p in plant)
   		writeln("Dual var: Plant ", p," prod capacity: ", capacityMalt[p].dual)
   writeln("-----------------------------------------------------------------------------------")
   for(var j in dist)
   		writeln("Dual var: Demand at DC ",j,": ", demandDC[j].dual)
   
 }