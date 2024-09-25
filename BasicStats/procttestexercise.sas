* Are the boys heavier than the girls?;
proc ttest data=sashelp.class;
	var weight;
	class sex;
	run;
* Make it a one-sided test?
* Plot confidence intervals (hint, this is an option)?;

proc ttest data=sashelp.class sides=l plots=interval;
	var weight;
	class sex;
	run;

* Are heights, weights, and age distributions the same
	for girls and boys?;
proc ttest data=sashelp.class plots=interval;
	var height weight age;
	class sex;
	run;

* BMI?;
data class;
	set sashelp.class;
	bmi=weight*703/(height**2);
	run;

proc ttest data=class;
	class sex;
	var bmi;
	run;

proc reg data=class;
	model weight = height age;
	run; quit;

