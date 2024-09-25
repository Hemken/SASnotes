proc freq data=employees;
	tables educ*gender;
	run;

proc freq data=employees;
	tables educ*gender / out=eductable;
	run;

proc freq data=eductable;
	tables educ*gender / chisq;
	weight count;
	run;

ods trace on;
proc freq data=employees;
	tables educ*gender;
	run;
ods trace off;

ods trace on / listing;
proc freq data=employees;
	tables educ*gender / chisq;
	run;
ods trace off;

ods output CrossTabFreqs=xtab;
proc freq data=employees;
	tables (educ jobcat minority)*gender / nopercent norow;
	run;
*ods output close;

ods trace on / listing;
proc freq data=employees;
	tables minority*gender /chisq;
	run;
ods trace off;

ods output crosstabfreqs=xtab2 chisq=chi fishersexact=exact;
proc freq data=employees;
	tables minority*gender /chisq;
	run;

proc freq data=employees;  /*contrast the two forms of the CHISQ table*/
	tables minority*gender /chisq;
	output out=chi2 chisq;
	run;

ods trace on /listing;
proc means data=employees;
	var salary salbegin;
	output out=salmeans mean=;
	run;
ods trace off;

ods output summary=salmeans2;
proc means data=employees;
	var salary salbegin;
	output out=salmeans mean=;
	run;

ods output summary=salmeans2;
proc means data=employees mean;
	var salary salbegin;
	output out=salmeans mean=;
	run;

proc contents data=salmeans2; run;

