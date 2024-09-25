proc reg data=sashelp.class;
	model weight = height age / spec acov;
	output out=resid r=wresid;
	run;

data resid;
	set resid;
	r = abs(wresid);
	r2 = wresid**2;
	run;

proc reg data=resid;
	model r2 = height age;
	output out=resid2 p=presid;
	run; quit;

data resid2;
	set resid2;
	w = 1/presid;
	run;

proc reg data=resid2;
	model weight = height age;
	weight w;
	run;

proc reg data=resid;
	model r = height age;
	output out=resid2 p=presid;
	run; quit;

data resid2;
	set resid2;
	w = 1/(presid**2);
	run;

proc reg data=resid2;
	model weight = height age;
	weight w;
	run;
