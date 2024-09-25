libname y "y:\sas\data";

proc format;
	value foreign 0 = "Domestic" 1 = "Foreign";
	run;

data auto;
	set y.auto;
	format foreign foreign.;
	run;

proc sgplot data=auto;
	vbar rep78;
	run;

proc sgplot data=auto;
	hbar rep78;
	run;

proc sgplot data=auto;
	dot rep78;
	xaxis min=0;
	run;

proc sgplot data=auto;
	vbox mpg / category=rep78;
	run;

proc sgplot data=auto;
	vline rep78 / response=mpg stat=mean;
	run;
