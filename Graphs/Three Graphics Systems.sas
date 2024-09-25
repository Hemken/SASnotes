/* Three graphics systems */

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

/* Titles affect all forms of output */
title "Boiling Point and Altitude";
title2 "James D. Forbes, 1857";

ods listing; /* Show graphics in their
	intended output destination */

/* Character graphics */
proc plot data=forbes;
	plot boil*pressure;
	run;

/* "Device" graphics */
proc gplot data=forbes;
	plot boil*pressure;
	run;

/* "Template" graphics 
	aka "ODS graphics" */

proc sgplot data=forbes;
	scatter y=boil x=pressure;
	run;

/* Note that ALL THREE can be sent to a variety of
	ODS destinations, like rtf and pdf files. */
