data MendotaIce;
	infile "y:\sas\data\mendota2015.txt" firstobs=2;
	input Winter $ Closed $ Opened $ Days;
	year = substr(winter, 1, 4 ) + 1;
	open = input(opened||"-"||put(year, 4.), anydtdte13.);
	iceoff = input(opened||"-1960", anydtdte13.);
	format open date9. iceoff date5.;
	run;

proc sort data=mendotaice;
	by year days;
	run;

data mendotaice;
	set mendotaice;
	by year;
	if last.year;
	run;

proc glm data=mendotaice;
	model iceoff = year;
	output out=preds p=doy lcl=early r=resid1;
	run; quit;

proc glm data=preds;
	model open = year;
	output out=preds p=doc lcl=early2 r=resid2;
	run; quit;

data preds;
	set preds;
	format doy doc early early2 date11.;
	run;

proc sgplot data=preds;
	scatter y=resid2 x=resid1;
	run;
/*
proc glm data=mendotaice;
	where mod(year,4) eq 1;
	model iceoff = year;
	output out=preds2 p=doy lcl=early r=resid1;
	run; quit;

proc glm data=preds2;
	where mod(year,4) eq 1;
	model open = year;
	output out=preds2 p=doc lcl=early2 r=resid2;
	run; quit;

data preds2;
	set preds2;
	format doy doc early early2 date11.;
	run;

proc sgplot data=preds2;
	scatter y=resid2 x=resid1;
	run;
*/

data example;
	do x = -10 to 10;
		y = 0 + 1*x + rand('normal');
		output;
		end;
	run;

proc glm data=example;
	model y = x /solution;
	output out=preds2 p=pred1 r=resid1;
	run; quit;

data preds2;
	set preds2;
	if x ge 5 then x=x+1;
	run;

proc glm data=preds2;
	model y = x /solution;
	output out=preds2 p=pred1 r=resid1;
	run; quit;
