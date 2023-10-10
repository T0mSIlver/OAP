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
dvar float+ patternUse[pattGen];

//MANUAL CONDITIONS : allowing the solver to use certain models we found to be the most promising
execute{
  
  PatternAct[334] = 1;
  PatternAct[200] = 1;
  PatternAct[244] = 1;
  PatternAct[260] = 1;
  PatternAct[237] = 1;
  PatternAct[274] = 1;
  PatternAct[311] = 1;
  PatternAct[289] = 1;
  PatternAct[360] = 1;
  PatternAct[221] = 1;
  PatternAct[406] = 1;
  PatternAct[256] = 1;
  
}


//Model 
minimize sum(i in pattGen) patternUse[i];
subject to {
  forall(j in patt)
  prodDem: sum(i in pattGen) PatternGen[i][j] * patternUse[i] * PatternAct[i] >= PatternReq[j];

}

//finding the best pattern to add to the model
execute {

  //compute reduced costs for actiavted pattern and 1 for deactivated ones
  for (var i in pattGen) {
    //writeln("a",patternUse[i])
    //writeln(i, ": ", patternUse[i].reducedCost);
    ReducedCost[i] = patternUse[i].reducedCost;
    //writeln("pattern ",i,": ",PatternGen[i])

  }

  var min = 0;
  var min_i = 0;

  for (var i = nbPatAct; i <= nbPatGen; i++) {
    //ReducedCost[i] = 1
    for (var j in patt) {
      ReducedCost[i] -= PatternGen[i][j] * prodDem[j].dual; //we don't need to add 1 since ReducedCost[i] was already equal to one bc of the previous generation
    }

    //MANUAL CALCULATION BECAUSE OF THE MANUALLY ADDED PATTERN 
    ReducedCost[334] = patternUse[334].reducedCost
    ReducedCost[200] = patternUse[200].reducedCost
    ReducedCost[244] = patternUse[244].reducedCost
    ReducedCost[260] = patternUse[260].reducedCost
    ReducedCost[237] = patternUse[237].reducedCost
    ReducedCost[274] = patternUse[274].reducedCost
    ReducedCost[311] = patternUse[311].reducedCost
    ReducedCost[289] = patternUse[289].reducedCost
    ReducedCost[360] = patternUse[360].reducedCost
    ReducedCost[221] = patternUse[221].reducedCost
    ReducedCost[406] = patternUse[406].reducedCost
    ReducedCost[256] = patternUse[256].reducedCost

    //Finding the minimum reduced cost (minimization problem)
    if (ReducedCost[i] < min) {
      min = ReducedCost[i];
      min_i = i;
    }
  }
  writeln("min: ", min, " ----", min_i)

  /* very useful reduced cost calculation troubleshooting
	for (var j in patt) 
		writeln(prodDem[j].dual, " --")
    for (var i in PatternGen) 
		writeln(PatternGen[i], " ++")
	for (var i in PatternGen) 
    	writeln(ReducedCost[i], " red")   	
    */

  for (var i in pattGen)
    writeln(PatternGen[i], "  ", ReducedCost[i], "  ", patternUse[i], " pattern ", i)

  //We'll now add the most itneresting pattern to the model MANUALLY and the pattern generation will be identical bc of the random seed we used
}

//computing the number of rolls wasted in cm
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