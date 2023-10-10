# OAP
Labs for the "Optimization and Prescriptive analysis" elective I was enrolled in in Ecole Centrale de Lille in 2022-2023.

## TPs (labs)
The labs were conceived by the elective's teacher : Frédéric Semet.
The notebooks in each folder are my personal work. Sometimes, hints were given.  
The solutions to the labs were implemented using IBM ILOG CPLEX Optimization Studio.

### TP1 - Introduction
- Linear modeling
- Mixed integer programming

### TP2 - Beer in the Classroom: A Case Study of Location and Distribution Decisions [^1]
*please see pdf report*
- Linear modeling
- Mixed integer programming
- Sensitivity analysis
- What-if analysis

### TP3 - Column generation algorithm
*please see pdf report*
- Some linear programs are too large to consider all the variables explicitly
- Start by solving the considered program with only a subset of its variables
- Iteratively, variables that have the potential to improve the objective function are added to the program
- The potential is calculated as the marginal cost of relevant products 
- Once it is possible to demonstrate that adding new variables would no longer improve the value of the objective function, the procedure stops.

### TP4 - Pediatrician Scheduling at British Columbia Women’s Hospital [^2]
*please see pdf report*
- Large and real-world problem modeling
- Scheduling, mixed/binary integer programming, big-M method, soft/hard constraints, multiobjective optimization
- CPLEX to excel data pipeline construction

  
[^1]: Murat Köksalan, F. Sibel Salman, (2003) Beer in the Classroom: A Case Study of Location and Distribution Decisions. INFORMS
Transactions on Education 4(1):65-77. https://doi.org/10.1287/ited.4.1.65
[^2]: Steven Shechter (2022) Case—Pediatrician Scheduling at British Columbia Women’s Hospital. INFORMS Transactions on Education 24(1):40-42.
https://doi.org/10.1287/ited.2021.0266cs
