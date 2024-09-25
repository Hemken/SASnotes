* Three different places to find output commands
    within a PROC;
libname y "y:\sas\data";

* OUTPUT statement;
proc freq data=y.employees;
	tables jobcat*gender / chisq;
	output out=stat chisq;
	run;

* OUTPUT option, generally on a MODEL or similar statement;
proc freq data=y.employees;
	tables jobcat*gender / chisq out=freqs;
	output out=stat chisq;
	run;

* OUTPUT option on the PROC statement, usually for alternative
	forms of input data, or to collect parameters;
proc corr data=y.employees noprint outp=cor;
run;

proc reg data=cor(type=corr);
	model salary = salbegin educ;
	run;
