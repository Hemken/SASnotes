* https://www.ssc.wisc.edu/~hemken/SASworkshops/BasicStats/Energy%20Use%20project.sas;

libname z "Z:\PUBLIC_web\SASworkshops\BasicStats";

* Data:  home energy use, one observation per billing period;

* Outcome of interest:  therms;
* Possible predictors:  days, degr_day, location, renovate;

* Some data preparation;
proc format;
	value loc 0 = "Few St" 1 = "Ohio Ave";
	value ren 0 = "Before" 1 = "After";
	value locren 0 = "Few St" 1 = "Ohio Ave, before" 2 = "Ohio Ave, after";
	run;

data energy;
	set z.energy1992_2018;
	label date = "Billing period"
	      days = "Days billed"
		  degr_day = "Heating degree days"
		  therms = "Gas (therms)";
	format loc loc. renovate ren.;

	locren = loc + renovate; * this becomes clear, below;
	format locren locren.;
	run;

proc corr data=energy plots=matrix;
	var date therms degr_day days;
	run;
/*
* already given by proc corr;
proc means data=energy;
run;
*/
proc freq data=energy;
	tables location*renovate / nopercent norow nocol;
	run;

proc ttest data=energy;
	class location;
	var therms;
	run;

proc ttest data=energy;
	where location eq "Ohio Ave";
	class renovate;
	var therms;
	run;
/*
proc reg data=energy;  * "type" error ;
	model therms = location;
	run;

proc reg data=energy;
	model therms = loc;
	run;
*/
proc glm data=energy;
	class location;
	model therms = location;
	run;

proc glm data=energy;
	class location;
	model therms = location / solution ss3;
	run;

proc glm data=energy;
	class location(ref="Few St");
	model therms = location / solution ss3;
	run;

proc glm data=energy plots=diagnostics;
	class location(ref="Few St");
	model therms = location / solution ss3;
	run;

proc sgplot data=energy;
	scatter y=therms x=date / group=location;
	run;

proc sgplot data=energy;
	series y=therms x=date / group=locren;
	run;

proc sgplot data=energy;
	series y=degr_day x=date / group=locren;
	run;

proc glm data=energy plots=diagnostics;
	model therms = degr_day / solution ss3;
	run;

* Polynomial model;
proc glm data=energy plots=diagnostics;
	model therms = degr_day|degr_day          / solution ss3;
*	model therms = degr_day degr_day*degr_day / solution ss3;
	run;

proc glm data=energy plots=diagnostics;
	class location(ref="Few St");
	model therms = degr_day location / solution ss3;
	run;

proc glm data=energy plots=diagnostics;
	class location(ref="Few St");
	model therms = degr_day|location / solution ss3;
	run;

proc glm data=energy plots=diagnostics;
	class location(ref="Few St");
	model therms = degr_day|location|renovate / solution ss3;
	run;

proc glm data=energy plots=diagnostics;
	class location(ref="Few St");
	model therms = degr_day|location degr_day|renovate / solution ss3;
	run;

proc glm data=energy plots=diagnostics;
	class locren(ref="Few St");
	model therms = degr_day|locren / solution ss3;
	run;

proc glm data=energy plots=diagnostics;
	class locren(ref="Ohio Ave, before");
	model therms = degr_day|locren / solution ss3;
	run;


* Go on to calculate saved therms;
data energy2;
	set energy;

	if locren eq 0 then f_therms = therms;
	if locren eq 1 then ob_therms = therms;
	if locren eq 2 then oa_therms = therms;
	run;

proc glm data=energy2;
	model f_therms = degr_day / solution ss3;
	output out=fewst predicted=fewst_therms;
	run; quit;
