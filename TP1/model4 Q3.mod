/*********************************************
 * OPL 20.1.0.0 Model
 * Author: tvaucour
 * Creation Date: 3 mars 2023 at 08:16:22
 *********************************************/
 
int nbEng = ...;
int nbW = ...;
int nbMinDem = ...;
int nbEmp = ...;


range Eng=1..nbEng;
range W=1..nbW;
range MinD = 1..nbMinDem;

int times[W][Eng] = ...;
int AvTimes[W] = ...;
int profit[Eng]=...;
int demand[MinD]=...;
//int overtime[W]=...;

// Decision variables
//dvar float+ x[Eng];
dvar int+ x[Eng];
dvar int+ overtime[W];

//model
maximize sum (i in Eng) profit[i]*x[i] - (sum (j in W) overtime[j]*10/60);
subject to {
	forall(i in W)
		sum(j in Eng) times[i,j]*x[j] <= AvTimes[i]+overtime[i];
	x[1]+x[2] >= demand[1];
	x[3]+x[4] >= demand[2];
	x[1]+x[2] >= x[3]+x[4];
	forall (i in W)
	  overtime[i]<=4*60*nbEmp;
}


//executing c++ code with conditions 
execute {
	for(var i in Eng)
	if (x[i]>0) writeln("Engine ",i,": ", x[i], " units to produce");
	writeln("");
	for(var i in W)
	writeln("Workshop ",i,": ", overtime[i]/60, " total overtime man hours ");
}
