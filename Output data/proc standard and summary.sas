libname y "y:\sas\data";

* Several utility PROCs create data sets;

* PROC SORT, which we have already seen;
proc sort data=y.employees out=employees;
	by bdate;
run;

* PROC COPY allows your to move single data sets
    or large numbers at once;
proc copy in=y out=work;
run;

* PROC DATASETS is useful for copy, contents, and cleanup;
proc datasets lib=work;
	delete fingers;
	run;

* A couple of statistical procs are designed just 
	to produce data sets;
* PROC SUMMARY is today much like PROC MEANS;
proc summary data=employees; /*defaults*/
	var _numeric_;
	output;
	run;

proc datasets;  /*cleanup*/
	delete data1;
	run; quit;

proc summary data=employees; /*more fully specified*/
	var salary salbegin;
	output out=means mean=msal mbeg sum=ssal sbeg median=;
	run;

proc summary data=employees;  /* by or class */
	class gender;
	var salary salbegin;
	output out=moremeans ;
	run;


proc standard data=employees out=stdemp mean=0;
	var salary salbegin;
	run;

proc standard data=employees(keep=id salary salbegin) out=stdemp mean=0 std=1;
	var salary salbegin;
	run;

proc sort data=employees;
	by id; run;
proc sort data=stdemp(rename=(salary=stdsal salbegin=stdbeg));
    by id; run;

data new;
	merge employees stdemp;
	by id;
	run;

proc means data=new;
	var salary stdsal salbegin stdbeg;
	run;
