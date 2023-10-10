/*********************************************
 * OPL 20.1.0.0 Model
 * Author: tvaucour
 * Creation Date: 14 avr. 2023 at 08:09:39
 *********************************************/

int nbDoc = ...;
int nbShifts = ...;
int nbSemaines = ...;

range Doc = 1..nbDoc;
range Shifts = 1..nbShifts;
range Semaines = 1..nbSemaines;

int ShiftsReq[Doc] = ...;
int DayOff[Shifts][Doc] = ...;
int POWReq[Doc] = ...;

//------------DATA IS OK-------------- 
/* input data checker
 execute{
   for (var i in Shifts){
     for (var j in Doc){
       writeln(DayOff[i][j])
     }
   }
   for (var j in Doc){
       writeln(ShiftsReq[j])
 }
 for (var j in Doc){
   writeln(POWReq[j])
 }
} 
*/
//------------DATA IS OK-------------- 

//PRIMARY Decision variables
dvar int+ x[Shifts][Doc];
dvar int+ y[Semaines][Doc];

//SECONDARY Decision variables used for soft constraints
dvar int+ nightS2A[1..26][Doc]; //for each doc, 26 pairs of 2 nights apart night shifts
dvar int+ consWE[1..3][Doc]; //for each doc, 3 pairs of weekends 
dvar int+ nightS3W[1..4][Doc]; //for each doc, 4 weeks 
dvar int+ equityPOS[Doc]; //equityPOS > 0 means more day shifts than night shifts worked (and it is equal to to the supplementary number of day shifts)
dvar int+ equityNEG[Doc]; //equityNEG > 0 means more night shifts than day shifts worked (and it is equal to to the supplementary number of night shifts)

//-------------------MODEL--------------------------
minimize (sum(u in 1..26) sum(j in Doc) nightS2A[u][j]) +
  sum(u in 1..3) sum(j in Doc) consWE[u][j] + sum(u in 1..4) sum(j in Doc) nightS3W[u][j] +
  sum(j in Doc) equityPOS[j] + sum(j in Doc) equityNEG[j];

subject to {

  //--------HARD CONSTRAINTS----------- 

  forall(i in Shifts, j in Doc)
  x[i][j] <= 1; //x is binary 
  forall(j in Doc, k in Semaines)
  y[k][j] <= 1; //y is binary

  forall(i in Shifts)
  Ha: sum(j in Doc) x[i][j] == 1; //every shift is covered by exactly one doctor

  forall(j in Doc)
  Hb: sum(i in Shifts) x[i][j] == ShiftsReq[j]; //every doc covers exactly the number of shifts required

  forall(i in 1..nbShifts - 1, j in Doc)
  Hc: x[i][j] + x[i + 1][j] <= 1; //no back2back shifts for any doctor

  forall(j in Doc, k in 1..27)
  Hd: x[2 * k][j] + x[2 * k + 2][j] <= 1; //no back2back nights for any doctor

  forall(j in Doc, u in 0..3)
  He: sum(i in 10 + 14 * u..14 + 14 * u) x[i][j] <= 2; //no more than 2 shifts per doc per weekend

  forall(i in Shifts, j in Doc)
  Hf: x[i][j] <= DayOff[i][j]; //no working on shifts requested off

  forall(k in Semaines)
  Hg: sum(j in Doc) y[k][j] == 1; //exactly one POW per week

  forall(j in Doc, k in Semaines)
  Hh: y[k][j] <= (x[3 + 14 * (k - 1)][j] + x[7 + 14 * (k - 1)][j] + x[12 + 14 * (k - 1)][j]) / 3; //POW works 3 specific shifts, if y = 1, then all 3 shifts = 1

  forall(j in Doc)
  Hi: sum(k in Semaines) y[k][j] <= 1; //a doc is POW no more than once per cycle 
  
  forall(j in Doc)
  Hj: sum(k in Semaines) y[k][j] <= POWReq[j]; //no doc can be POW if no requirement left


  //--------SOFT CONSTRAINTS----------- 

  //avoid consecutive weekends 
  forall(j in Doc, u in 0..2)
  Sa: sum(i in 10 + 14 * u..14 + 14 * u) x[i][j] + sum(i in 10 + 14 * (u + 1)..14 + 14 * (u + 1)) x[i][j] - 1 - consWE[u + 1][j] <= 0;
    
  //avoid night shifts two nights apart, the decision var = 0 if 0 or 1 shift worked in a pair, 1 if 2 shifts worked
  forall(j in Doc, u in 0..25)
  Sb: x[2 + u*2][j] + x[4 + (u+1)* 2][j] - nightS2A[u + 1][j] - 1 <= 0;
  
  //avoid working more than 2 night shifts in a week
  forall(j in Doc, u in 0..3)
  Sc: x[14 * u + 2][j] + x[14 * u + 4][j] + x[14 * u + 6][j] + x[14 * u + 8][j] + x[14 * u + 10][j] + x[14 * u + 12][j] + x[14 * u + 14][j] - nightS3W[u + 1][j] <= 2;

  //equity in day/night shifts for each doc
  forall(j in Doc)
  Sd: sum(u in 1..28)(x[u * 2][j] - x[(u - 1) * 2 + 1][j]) - equityPOS[j] + equityNEG[j] == 0;
  //equityNEG > 0 means more night shifts than day shifts 
  //equityPOS > 0 means more day shifts than night shifts
}


