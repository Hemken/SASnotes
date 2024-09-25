libname y "y:\sas\data";

data class;
	set y.class;
	bmi = (weight/height**2)*703;
	run;

proc means;
	var age bmi;
	run;

proc ttest h0=18;
	var bmi;
	run;

proc ttest;
	class sex;
	var bmi;
	run;

proc glm;
	model bmi = ;
	run;

proc glm;
	class sex;
	model bmi = sex / solution;
	run;

proc glm;
	class sex;
	model bmi = sex age / solution;
	run;

proc glm;
	class sex;
	model bmi = sex|age / solution;
	run;
	lsmeans sex;
	lsmeans sex / at age=12;
	lsmeans sex / at age=13;
	lsmeans sex / at age=14;
	run;
