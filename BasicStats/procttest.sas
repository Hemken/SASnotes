* The minimal PROC TTEST, with all defaults in play;
proc ttest data=sashelp.class;
run;
* One sample t-tests for all numeric variables in
the data set;

* A one-sample t-test, more explicitly;
proc ttest data=sashelp.class h0=12;
	var age;
run;
* a two-sided test;

* A one-sided test;
proc ttest data=sashelp.class h0=12 sides=l;
	var age;
run;
* Here the alternative is that the mean is
<= 12, not very likely, eh?;

* A two-sample test;
proc ttest data=sashelp.class;
	class sex;
	var height;
	run;
	
* grouped;
data scores;
   input Gender $ Score @@;
   datalines;
f 75  f 76  f 80  f 77  f 80  f 77  f 73
m 82  m 80  m 85  m 85  m 78  m 87  m 82
;
run;

proc ttest data=scores;
	class gender;
	var score;
	run;


*paired;
data pressure;
      input SBPbefore SBPafter @@;
      datalines;
120 128   124 131   130 131   118 127
140 132   128 125   140 141   135 137
126 118   130 132   126 129   127 135
;
run;

proc means data=pressure;
	var sbpbefore sbpafter;
	run;

proc ttest data=pressure;
	paired SBPbefore*SBPafter;
	run;

