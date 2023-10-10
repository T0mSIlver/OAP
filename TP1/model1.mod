/*********************************************
 * OPL 20.1.0.0 Model
 * Author: tvaucour
 * Creation Date: 3 mars 2023 at 08:16:22
 *********************************************/
 
int nbEng = ...;
int nbW = ...;

range Eng=1..nbEng;
range W=1..nbW;

int times[W][Eng] = ...;
int AvTimes[W] = ...;
int profit[Eng]=...;

// Decision variables
//dvar float+ x[Eng];
dvar int x[Eng];


//model
maximize sum (i in Eng) profit[i]*x[i];
subject to {
	forall(i in W)
	sum(j in Eng) times[i,j]*x[j] <= AvTimes[i];
}