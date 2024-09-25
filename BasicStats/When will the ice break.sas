* When will the ice break?;
libname y "y:\sas\data";

proc sgplot data=y.mendotaice;
	series y=iceout x = year;
	reg y=iceout x = year;
	where days ne .;
	run;

proc reg data=y.mendotaice;
	where days ne .;
	model iceout = year;
	run;

data mendotaice;
	set y.mendotaice;
	year = year - 2015;
	run;

proc reg;
	where days ne .;
	model iceout = year;
	run;

data _null_;
	a = 85.87493;
	put a date5.;
	run;

