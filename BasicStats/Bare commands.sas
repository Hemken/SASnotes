data cars;
	set sashelp.cars;
	run;

proc means;
run;

proc freq; * lots of output!  A "codebook" of sorts?;
run;

proc corr;
run;

proc ttest; * there IS a default t-test!;
run;

proc reg; * no default here, just a WARNING;
run;

* Selected variables;
* Often you can specify lists of variables;
proc means; * most stats procs have a "var" statement;
	var enginesize mpg_city mpg_highway; * list by variable name;
run;

proc freq;
	tables make -- drivetrain; * list by position in data set;
	*  SAS calls this a "named range list";
run;

* regularly named variables in a list:
	v5 - v10
(order in data set does not matter)
SAS calls this a "numbered range list";

proc corr;
	var mpg: ; * A "prefix" list;
run;

proc ttest; * there IS a default t-test!;
	var _numeric_; * A "special" list, also have _character_ and _all_;
run;
