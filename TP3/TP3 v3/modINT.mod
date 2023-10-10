/*********************************************
 * OPL 20.1.0.0 Model
 * Author: tvaucour
 * Creation Date: 31 mars 2023 at 08:16:13
 *********************************************/

int nbPatterns = ...;
int nbPatGen = ...;
int nbPatAct = ...;

range patt = 1..nbPatterns;
range pattGen = 1..nbPatGen;
//range patAct = 1..nbPatAct;

int SizeRoll[patt] = ...;
int PatternReq[patt] = ...;
int PatternGen[pattGen][patt];
int PatternAct[pattGen];
float ReducedCost[pattGen];

execute //generation of a certain number activated patterns
{
  for (var i = 1; i <= nbPatAct; i++) {
    PatternAct[i] = 1
  }
  //writeln(PatternAct)
}

//generation of patterns : Pattern
execute {
  //writeln(Pattern)
  var width; // one of the 21 widths
  var CurrentWidth = 0; // Total width used
  var nbRoll = 0;
  for (var i = 1; i <= nbPatGen; i++) {
    CurrentWidth = 0;
    for (var j = 1; j <= 21; j++) {
      width = Opl.rand(21) + 1; // select one width
      if (PatternGen[i][width] == 0) { // check if this width has no yet been selected
        nbRoll = 1 + Opl.rand(9); //number of rolls of this width
        //the max. number of rolls is 9
        if ((CurrentWidth + nbRoll * SizeRoll[width]) <= 100) {
          //the current pattern is feasible
          PatternGen[i][width] = nbRoll;
          CurrentWidth = CurrentWidth + nbRoll * SizeRoll[width];
        }
      }

      /* writeln("j: ", j)
       writeln("width: ", width)
       writeln("current width: ", CurrentWidth)
       writeln(PatternGen[i])*/

    }
    //writeln(Pattern)
  }
}

//Decision variables
dvar int+ patternUse[pattGen];



//Model 
minimize sum(i in pattGen) patternUse[i] + sum(i in pattGen) patternUse[i]*100 - sum(i in pattGen) sum(j in patt) PatternGen[i][j]*SizeRoll[j]*patternUse[i]/1;
  


subject to {
  forall(j in patt)
  prodDem: sum(i in pattGen) PatternGen[i][j] * patternUse[i] * PatternAct[i] >= PatternReq[j];

}

//computing the number of rolls used
execute {
	var rollsUsed = 0;
  for (var i in pattGen) {
    rollsUsed += patternUse[i];
  }
  writeln("Rolls used: ",rollsUsed)
}  


//computing the number of rolls wasted in cm (of width)
float CM[pattGen];
execute{
  var total = 0;
  for (var i in pattGen) {
    //ReducedCost[i] = 1
    CM[i] = 100*patternUse[i];
    for (var j in patt) {
      
      CM[i] -= PatternGen[i][j]*SizeRoll[j]*patternUse[i];
      
    } 
    total += CM[i]     
  }
  writeln("total: ",total)
}

