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

/* Titles (and footnotes) apply to all output
	including plots, until turned off */
title "Boiling Point and Altitude";
title2 "James D. Forbes, 1857";

/* Basic scatter plot */
proc plot data=forbes;
	plot boil*pressure;
	run;

/* Vertical axis required to start at zero */
proc plot data=forbes;
	plot boil*pressure/vzero;
	run;

/* Reference lines added.  Note the
	vref refers to the vertical axis by
	drawing a horizontal line. */
proc plot data=forbes;
	title3 "212 degrees at sea level";
	plot boil*pressure/vref=212 href=29.921;
	run;

title3;

/* Specify a custom marker/symbol, and add
	a label for each point */
proc plot data=forbes;
	plot boil*pressure='.' $ id;
	run;

/* To plot a regression "line" you first
	have to generate the data for the
	predicted points on the line. */
proc reg data=forbes;
	model boil = pressure;
	output out=forbes2 pred=yhat;
	run; quit;
/* Then overlay the data and the predicted points. 
	The resulting plot does not convey much, because
	characters graphics have such low resolution. */
proc plot data=forbes2;
	plot boil*pressure yhat*pressure='+' / overlay;
	run;

proc gplot data=forbes2;
	plot boil*pressure yhat*pressure / overlay;
	run;

title;
