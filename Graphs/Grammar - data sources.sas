* Graph data sources;

* Empirical, i.e. given in a data set;

data class;
	set sashelp.class;
	bmi = (weight/height**2)*703;

proc sgplot data=class;
	scatter y=bmi x=age;
	run;

* Derived ;
proc ttest data=class;
	class sex;
	var bmi;
	run;

proc sgplot data=class;
	density bmi / type=normal(mu=17.0510 sigma=1.9933);
	density bmi / type=normal(mu=18.5942 sigma=1.9933);
	run;

* Theoretical;

proc sgplot data=class;
	density bmi / type=normal (mu=18 sigma=2);
	density bmi / type = normal(mu=0 sigma = 2);
	run;
