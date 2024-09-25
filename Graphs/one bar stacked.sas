proc sgplot data=sashelp.class;
	hbar age / group=sex;
	run;

data class;
	set sashelp.class;
	all = "a";
	run;

proc sgplot;
	hbar all / group=age stat=pct;
	yaxis display=none;
	run;
