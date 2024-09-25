* Univariate and Bivariate Statistical Procs;

libname y "y:\sas\data";

* The two most basic are
	PROC FREQ and
	PROC MEANS ;

proc freq data=y.cake;
run;

proc means data=y.cake;
run;

* More typical is to specify a variable or
	a list of variables;

proc freq data=y.cake;
	tables flavor layers;
	run;

proc means data=y.cake;
	var presentscore tastescore;
	run;

* For plots, many statistical PROCs
	produce related plots;

proc freq data=y.cake;
	tables flavor / plots=freqplot;
	run;

* However, univariate PROCs are idiosyncratic
	in how they do this, so it may be
	easier to just use a graphing PROC;

proc sgplot data=y.cake;
	hbar flavor;
	run;

proc sgplot data=y.cake;
	histogram presentscore;
	run;

* Many PROCs allow you to break down the
	analysis by a categorical variable;

* Often this is done by declaring a CLASS
	variable;

proc means data=y.cake;
	class flavor;
	var presentscore tastescore;
	run;

proc ttest data=y.class;
	var weight height;
	class sex;
	run;

* However, many common PROCs like
	FREQ and CORR do not allow CLASS;

* Another common approach is to use a BY
	variable;

* Using BY variables requires the data to
	be SORTed first;

proc sort data=y.cake out=cake;
	by flavor;
	run;

proc freq data=cake;
	by flavor;
	tables layers;
	run;

proc means data=cake;
	by flavor;
	var presentscore tastescore;
	run;

proc sort data=y.class out=class;
	by sex;
	run;

proc sgplot data=class;
	by sex;
	scatter y=weight x=height;
	run;

* Another statement that works the same
	way in many PROCs is the WHERE statement;

title "Junior Cake Makers";
proc means data=y.cake;
	where age < 45;
	var presentscore tastescore;
	run;

title "Master Cake Makers";
proc means data=y.cake;
	where age >= 45;
	var presentscore tastescore;
	run;

proc sgplot data=y.cake;
	title "Junior Cake Makers";
	where age < 45;
	density tastescore / type=kernel legendlabel="Taste";
	density presentscore / type=kernel legendlabel="Presentation";
	run;
title;

* Another common PROC statement is LABEL
	to supply variable labels in output;

proc means data=y.cake;
	var presentscore tastescore;
	label presentscore = "Presentation";
	run;

* FORMATs are also useful in PROCs,
	both to label output, but also
	to recode or reclassify variables;

* User-supplied FORMATs require a
	preliminary PROC FORMAT;

proc format;
	value masters 0 - <45 = "Junior"
				  45 - high = "Master";
	run;

* Note when the format is defined we call it
	"masters", but when it is put to use we
	call it "masters." (with a period);

proc means data=y.cake;
	class age;
	var presentscore tastescore;
	label presentscore = "Presentation";
	format age masters.;
	run;

* This is useful anywhere you can use CLASS or BY;

proc ttest data=y.cake;
	class age;
	format age masters.;
	var presentscore tastescore;
	run;

* Lets look at a few more details of PROC FREQ;

* In PROC FREQ, everything is a categorical variable;
* Crosstabulations look like this;

proc freq data=y.cake;
	tables flavor*layers;
	run;

* PROC FREQ allows multiple table requests,
	and lets you ask for less or more output statistics;

proc freq data=y.cake;
	tables flavor layers / nocum;
	tables flavor*layers /nopercent norow chisq;
	run;

* Of course, you can use FORMATs here too;

proc freq data=y.cake;
	tables age / nocum;
	tables age*(flavor layers) /nopercent nocol;
	format age masters.;
	run;
/*
proc format;
	value $ choc "Chocolate" = "Chocolate"
						"Rum" = "Other"
						"Spice" = "Other"
						"Vanilla" = "Other";
	run; 

proc freq data=y.cake;
	tables age*flavor / nopercent nocol chisq exact;
	format age masters. flavor $choc.;
	run;
*/

* More details of PROC MEANS;

* Additional statistics requests;

proc means data=y.cake n nmiss mean stddev stderr uclm lclm median q1 q3;
	var presentscore;
	run;

* More details of PROC TTEST;

* Three common t-tests;

* Test against a given value;

proc ttest data=y.cake h0=75;
	var presentscore;
	run;

* Two group t-test, as above;

proc ttest data=y.cake;
	class age;
	format age masters.;
	var presentscore;
	run;

* Paired t-test;

proc ttest data=y.cake;
	paired presentscore*tastescore;
	run;

* Less common, a conditional paired t-test,
	the beginnings of a repeated measures model;

* Note that to use FORMATs with BY
	requires more work;

proc sort data=y.cake out=cake;
	by age;
	run;

proc ttest data=cake;
	by age;
	format age masters.;
	paired tastescore*presentscore;
	run;

* PROC CORR;

proc corr data=y.cake plots=matrix;
	var age presentscore tastescore;
	run;


proc corr data=cake plots=scatter;
	by age;
	format age masters.;
	var presentscore tastescore;
	run;




