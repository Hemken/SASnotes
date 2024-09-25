*modified from http://homepages.math.uic.edu/~wangjing/stat481/Nested%20Design.sas ;

data training;
	input School $ Instructor Score;
datalines;
Atlanta	1	25
Atlanta	1	29
Atlanta	2	14
Atlanta	2	11
Chicago	1	11
Chicago	1	6
Chicago	2	22
Chicago	2	18
Modesto	1	17
Modesto	1	20
Modesto	2	5
Modesto	2	2
;

proc means;
	class school instructor;
	var score;
	run;

/* Nested design with two fixed factors*/
proc glm data = training plots=diagnostics;
     class School Instructor;
	 model Score = School Instructor(School);
	 run;
	 * note the lines in the interaction plot are not meaningful;
	 lsmeans School / adjust=scheffe cl ;
	 run;

/* Nested design -- one fixed factor and one random factor*/
* Assume instructor effects are random, perhaps we selected random instructors;
proc glm data = training;
     class School Instructor;
	 model Score = School Instructor(School);
	 random Instructor(School);
	 run;
	 lsmeans School / adjust=scheffe cl e=Instructor(School);
	 test h=School e=Instructor(School);
	 run;

/* Nested design with two random factors*/
proc glm data = training;
     class School Instructor;
	 model Score = School Instructor(School);
	 random School Instructor(School);
	 run;
	 test h=School e=Instructor(School);
	 run;


/* Use proc mixed to estimate the variance components in the mixed model*/

proc mixed data = training;
     class School Instructor;
	 model Score = School;       /* Only specify the fixed factor*/
	 random Instructor(School);
	 run;

/* Nested design - random effect model (proc mixed)*/

  proc mixed data = training;
       class School Instructor;
	   model Score =;                       /* no fixed factor*/
	   random School Instructor(School);   /* both random factors*/
  run;
