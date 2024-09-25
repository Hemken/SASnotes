* Using TEST with proc reg;

proc reg data=employees;
	model raisepct = bdate;
	run;

proc glm data=employees plots=diagnostics;
	model raisepct = bdate|bdate;
	run;

data employees;
	set employees;
	female = gender = "f";
	clerk = jobcat = 1;
	custodian = jobcat = 2;
	minfem = female * minority;
	run;

proc reg data=employees;
	model raisepct = bdate female minority minfem;
	run;
	test female, minfem;
	run;

proc reg data=employees;
	model raisepct = bdate female minority minfem clerk custodian;
	run;
	test clerk, custodian;
	run;

proc glm;
	class gender jobcat minority;
	model raisepct = bdate gender|minority jobcat;
	run;
