/*/* A single PROC can often give you an output 
	data set in several different forms.
	As an example, consider PROC MEANS.
	There are two basic mechanisms for
	getting an output data set from
	PROC MEANS - either an OUTPUT
	statement, or through an ODS
	(Output Delivery System) statement.
*/

/*/* The simplest to specify is a plain
	OUTPUT statement.
*/
proc means data=sashelp.class mean std;
	output out=basic;
	run;

proc print; run;

/*/* Notice that regardless of what statistics
	we request on the PROC statement, the
	data set has the default five number summary.

	This form of output data set has been
	part of SAS for many decades, so there is
	a lot of code that depends upon it.
*/

* Exercise - explore the difference between 
	OUTPUT and ODS when you specify
	PROC MEANS NOPRINT.  PROC SUMMARY
	is essentially PROC MEANS NOPRINT.;

/*/* To have less (or more) statistics
	in your output data, you can specify the
	statistics of interest (anything that
	PROC MEANS calculates) on the OUTPUT
	statement.  A simple, common example is
	to request just the means.
*/
proc means data=sashelp.class;
	output out=meansonly mean=;
	run;

proc print; run;
/*/* Notice that, as in the previous example,
	the new statistics retain the old variable
	names by default.
*/

* Exercise - explore specifying output variable names;
* Exercise - explore specifying only one variable for
	output.  There are two ways to do this.;
* Exercise - explore what happens with data formats;

proc means data=sashelp.class;
	output out=meanstd mean= std=; *Creates an error;
	run;
* See the log;

proc means data=sashelp.class;
	output out=meandata mean=;
	output out=stddata std=;
	run;

proc print; run;

proc means data=sashelp.class;
	output out=meanstd mean= std= /autoname;
*	output out=meanstd mean=age height weight 
		std=agesd heightsd weightsd;
	* You can always be explicit;
	run;

proc print; run;

ods output summary=basicods;
proc means data=sashelp.class;
	run;

proc print; run;

ods output summary=meansonlyods;
proc means data=sashelp.class mean;
	run;

proc print; run;

ods output summary=stackedods;
proc means data=sashelp.class stackodsoutput;
	run;

proc print; run;
