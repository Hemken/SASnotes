data cars;
	set sashelp.cars;
	run;

proc freq; 
	tables cylinders / plots=freqplot;
	tables cylinders*origin / plots=freqplot;
run;

* No plots with PROC MEANS;
/*proc means;
run;
*/
proc univariate;
	histogram;
run;

proc corr plots=matrix;
	var msrp mpg: ;
run;

proc ttest; * already has default graphs;
	var mpg:;
run;
