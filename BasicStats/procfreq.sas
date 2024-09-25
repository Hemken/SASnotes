proc freq data=sashelp.cars;  /* typical use */
	tables origin type;
run;

data cars;
	set sashelp.cars;
	run;

proc freq;  /* the minimum proc freq, a LOT of output */
run;

* Default data: _LAST_
   default variables:  _ALL_ ;

proc freq data=cars;    /* one-way */
	tables type;
	run;

proc freq data=cars;    /* two-way; aka crosstab */
	tables type*origin; /* row * column */
	run;

/* multiple requests */
proc freq data=cars;
	tables origin origin*type;
	run;

/* multiple table statements */
/* suppress some default output,
	and request additional statistics */
proc freq data=cars;
	tables origin / nocum;
	tables origin*type / nopercent nocol chisq;
	run;

/* the data in summary or "table" form */
* from Delwiche & Slaughter, "Little SAS Book," 3e;

data coffee2;
	input loc $ type $ count;
datalines;
drive-up cappuccino 2
window cappuccino 4
drive-up espresso 6
window espresso 2
drive-up iced 2
window iced 2
drive-up kona 2
window kona 9
;

proc print; run; /* look at data values in output */

proc freq;       /* weighted data */
	tables type*loc / nopercent norow chisq;
	weight count;  /* many procs have a "freq" statement */
	run;

proc freq;   /* save a crosstab as summary data */
	tables loc * type /	out=coffeetable;
	/* name a data set for the output*/
	weight count;
	run;

proc print; run;
