data logs;
	do x = 1 to 50;
		y = log(x);
		output;
		end;
	run;

title "Untransformed";
proc sgplot;
	scatter y=x x=x;
	run;

title "Transformed Data";
proc sgplot;
	scatter y=y x=x;
	run;

title "Transformed Scale";
proc sgplot;
	scatter y=x x=x;
	xaxis type=log /*logstyle=linear*/;
	run;

title "Transformed Scale";
proc sgplot;
	scatter y=x x=x;
	xaxis type=log logstyle=logexpand;
	run;

title "Transformed Coordinate";
proc sgplot;
	scatter y=x x=x;
	xaxis type=log logstyle=logexponent;
	run;

title "Transformed Data with a Transformed Coordinate";
proc sgplot;
	where y ne 0;
	scatter y=y x=x;
	xaxis type=log logstyle=logexponent;
	run;
