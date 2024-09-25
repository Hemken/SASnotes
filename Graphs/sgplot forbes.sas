/* James Forbes' Altimeter (1857)
	Bringing water to a boil throughout the Alps */

data forbes;
	input id boil pressure;
	label boil = "Boiling Point (degrees F)"
		pressure = "Air Pressure (inches Hg)";
	datalines;
	1   194.5   20.79
    2   194.3   20.79
    3   197.9   22.40
    4   198.4   22.67
    5   199.4   23.15
    6   199.9   23.35
    7   200.9   23.89
    8   201.1   23.99
    9   201.4   24.02
   10   201.3   24.01
   11   203.6   25.14
   12   204.6   26.57
   13   209.5   28.49
   14   208.6   27.76
   15   210.7   29.04
   16   211.9   29.88
   17   212.2   30.06
;


title "Boiling Point and Altitude";
title2 "James D. Forbes, 1857";

proc sgplot data=forbes;
	scatter y=boil x=pressure;
	run;

proc sgplot data=forbes;
	title2;
	scatter y=boil x=pressure;
	yaxis values=(0 to 250 by 50);
	run;

proc sgplot data=forbes;
	scatter y=boil x=pressure;
	yaxis values=(190 to 215 by 5); 
	refline 212 /axis=y;
	run;

proc sgplot data=forbes;
	scatter y=boil x=pressure / markerattrs=(symbol=circlefilled size=4px);
	yaxis values=(190 to 215 by 5); 
	run;

proc sgplot data=forbes;
	reg y=boil x=pressure;
	yaxis values=(190 to 215 by 5); 
	run;

ods html style=journal;
proc sgplot data=forbes;
	reg y=boil x=pressure / clm cli;
	yaxis values=(190 to 215 by 5); 
	run;

title;

proc sgplot data=sashelp.class;
	scatter y=weight x=height / group=sex;
	run;

* Essentially height(sex), i.e. with an interaction;
proc sgplot data=sashelp.class;
	reg y=weight x=height / group=sex;
	run;

proc glm data=sashelp.class;
	class sex;
	model weight = height sex /ss3 solution;
	output out=class p=predweight;            /* for series, later   */
	estimate 'F intercept' intercept 1 sex 1; /* for lineparm, later */
	run;

proc sgplot data=class;
	scatter y=weight x=height / group=sex;
	series y=predweight x=height /group=sex;
	run;

proc sgplot data=class;
	scatter y=weight x=height / group=sex;
	lineparm y=-126.1686948 x=0 slope=3.6789031 / curvelabel="M";
	lineparm y=-132.789538 x=0 slope=3.6789031 / curvelabel="F";
	run;

proc glm data=sashelp.class;
	class sex;
	model weight = height age sex /ss3 solution;
	output out=class p=predweight;            /* for series, later   */
	estimate 'F intercept' intercept 1 sex 1; /* for lineparm, later */
	run;

proc sort data=class;
	by height;
	run;

proc sgplot data=class;
	reg y=weight x=height / group=sex;
	scatter y=weight x=height / group=sex;
	scatter y=predweight x=height /group=sex markerattrs=(symbol=circlefilled);
	run;
