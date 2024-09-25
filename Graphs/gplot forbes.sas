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

proc gplot data=forbes;
	title "Boiling Point and Altitude";
	title2 "James D. Forbes, 1857";
	plot boil*pressure;
	run;

/* Vertical axis required to start at zero */
proc gplot data=forbes;
	plot boil*pressure/vzero;
	run;

/* Two methods for specifying axis ticks,
	and a reference line drawn to the
	vertical axis */
proc gplot data=forbes;
	plot boil*pressure/vaxis=(190 to 215 by 5) vref=212;
	run;

axis1 order=(190 195 200 205 210 215);
proc gplot data=forbes;
	plot boil*pressure/vaxis=axis1;
	run;

/* Changing the marker */
symbol1 value='A';
proc gplot data=forbes;
	plot boil*pressure;
	run;

symbol1 value=dot;
proc gplot data=forbes;
	plot boil*pressure;
	run;

/* Drawing a regression line */
symbol1 value=dot interpol=rl;
proc gplot data=forbes;
	plot boil*pressure;
	run;

symbol1 value=dot interpol=rlcli;
proc gplot data=forbes;
	plot boil*pressure;
	run;

title;

/* Drawing two regression lines */
ods rtf file="reg example graphics.rtf";
ods graphics on;
symbol1 value=dot interpol=none color=black;
symbol2 value=square interpol=line;
proc reg data=y.energy;
	model therms = dgrd loc;
	output out=energy2 predicted=that;
	plot (therms p.)*dgrd / overlay;
	run; quit;
ods graphics off;
ods rtf close;

data energy2;
	set energy2;
	if loc = 0 then that0=that;
	if loc = 1 then that1=that;
	run;

symbol1 value=dot interpol=none color=black;
symbol2 value=point interpol=line;
proc gplot data=energy2;
	title "Home Gas Use";
	title2 "Few St versus Ohio Ave";
	plot (therms that0 that1)*dgrd / overlay;
	run;

proc sgplot data=y.energy;
	reg y=therms x=dgrd / group=loc;
	run;

title;
