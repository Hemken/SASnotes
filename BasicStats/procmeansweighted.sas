data size;
   input Distance ObjectSize @@;
   Precision=1/distance;
* from "SAS Procedures, Statements with the
   same function in multiple procedures, Weight";
   datalines;
1.5 30 1.5 20 1.5 30 1.5 25
3   43 3   33 3   25 3   30
4.5 25 4.5 36 4.5 48 4.5 33
6   43 6   36 6   23 6   48
7.5 30 7.5 25 7.5 50 7.5 38
;

proc means;
	var objectsize;
	run;

proc means mean var std;
	class distance;
	var objectsize;
	run;

goptions hsize=6 vsize=8;

proc boxplot;
	plot objectsize*distance;
	run; quit;

proc means mean var std;
	var objectsize;
	weight precision;
	run;

