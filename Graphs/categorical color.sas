libname y "y:\sas\data";

proc format;
	value foreign 0 = "Domestic" 1 = "Foreign";
	run;

data auto;
	set y.auto;
	format foreign foreign.;
	run;

proc sgplot data=auto;
	vbar rep78 / group=foreign;
	run;

proc sgplot data=auto;
	dot rep78 / group=foreign;
	xaxis min=0;
	run;

proc sgplot data=auto;
	vbox mpg / category=rep78 group=foreign;
	run;

proc sgplot data=auto;
	vline rep78 / response=mpg stat=mean group=foreign;
	run;

proc sort data=sashelp.class out=class;
	by age;
	run;
proc sgplot data=class;
	block x=name block=age;
	series x=name y=weight;
	run;

