libname y "y:\sas\data";

proc format;
	value foreign 0 = "Domestic" 1 = "Foreign";
	run;

data auto;
	set y.auto;
	format foreign foreign.;
	run;

proc sgpanel data=auto;
	panelby foreign;
	vbar rep78;
	run;

proc sgpanel data=auto;
	panelby foreign;
	dot rep78;
	run;

proc sgpanel data=auto;
	panelby foreign;
	vbox mpg / category=rep78;
	run;

proc sgpanel data=auto;
	panelby foreign;
	vline rep78 / response=mpg stat=mean;
	run;

