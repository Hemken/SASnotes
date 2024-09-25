libname y "y:\sas\data";

data class;
	set sashelp.class;
	run;

data y.boys y.girls;
	set sashelp.class;
	if sex = "M" then output y.boys;
		else output y.girls;
		run;

	data y.demog;
		set sashelp.class;
		keep name sex age;
		run;

		data y.measures;
		set sashelp.class;
		keep name height weight;
		run;
