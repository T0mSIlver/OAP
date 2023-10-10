/*********************************************
 * OPL 20.1.0.0 Model
 * Author: tvaucour
 * Creation Date: 3 mars 2023 at 08:16:22
 *********************************************/
 
int nbEng = ...;
int nbW = ...;
int nbMinDem = ...;



range Eng=1..nbEng;
range W=1..nbW;
range MinD = 1..nbMinDem;

int times[W][Eng] = ...;
int AvTimes[W] = ...;
int profit[Eng]=...;
int demand[MinD]=...;

// Decision variables
//dvar float+ x[Eng];
dvar int x[Eng];


//model
maximize sum (i in Eng) profit[i]*x[i];
subject to {
	forall(i in W)
		sum(j in Eng) times[i,j]*x[j] <= AvTimes[i];
	x[1]+x[2] >= demand[1];
	x[3]+x[4] >= demand[2];
	x[1]+x[2] >= x[3]+x[4];
	
}


//executing c++ code with conditions 
execute {
	for(var i in Eng)
	if (x[i]>0) writeln("Engine ",i,": ", x[i], " units");
}
