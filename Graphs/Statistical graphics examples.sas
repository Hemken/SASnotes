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
run;

/* Graphics PROC */
proc sgplot data=forbes;
	scatter y=boil x=pressure;
	run;

proc sgplot data=forbes;
	series y=boil x=pressure;
	run;

proc sgplot data=forbes;
	histogram boil / scale=count;
	run;

proc sgplot data=forbes;
	histogram pressure / scale=percent;
	run;

/* graphics/plot statement within a stat proc */
proc univariate data=forbes;
	var boil pressure;
	histogram pressure / exp;
*	probplot pressure / exp;
*	histogram boil / normal;
	run;

data forbes2;
	set forbes;
	highalt=(pressure<25);
	run;

/* Automatically produced by a stats proc */
proc glm data=forbes2;
	class highalt;
	model boil = highalt;
	run;

proc reg data=forbes;
	model boil = pressure;
	run; quit;

/* Option ODS graphics
	The request may be on the PROC statement,
	on the model request, or as a separate
	PLOT statement. */
proc freq data=forbes2;
	tables highalt /plots=freqplot(orient=horizontal scale=percent);
	run;
