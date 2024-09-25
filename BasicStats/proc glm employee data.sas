libname y "y:\sas\data";

proc format;
	value minfmt 0 = "Not a minority" 1 = "Minority";
	value jobs 1 = "Clerk" 2 = "Custodian" 3="Manager";
	run;

data employees;
	set y.employees;
	raisepct = (salary/salbegin)**(1/int(jobtime/12)) - 1;
	format minority minfmt. jobcat jobs.;
	run;

proc means;
	class jobcat minority gender;
	*types jobcat minority gender;
	var raisepct;
	run;

proc ttest;
	class minority;
	var raisepct;
	run;
proc ttest;
	class gender;
	var raisepct;
	run;

proc glm;
	class jobcat;
	model raisepct = jobcat;
	run;
	lsmeans jobcat / adjust=scheffe;
	run;

proc glm plots=diagnostics;
	class gender minority jobcat;
	model raisepct = /*educ*/ prevexp bdate 
		gender minority jobcat 
		/*gender*minority*/ jobcat*minority gender*jobcat
		/*gender*minority*jobcat*/ / /*ss1*/ ss2 /*ss3*/ ss4 solution;
	run;

ods output DesignPoints = emp2;
proc glmmod data=employees outdesign=emp1;
	class gender minority jobcat;
    model raisepct = educ prevexp bdate gender|minority|jobcat@2;
run;

proc reg data=emp1;
	model raisepct = col2 col3 col4 col5 col7 col9 
		col13 col14 col16 col21 col22;
	run;
	test col7, col9, col21, col22;
	run;

proc glm;
	class gender minority jobcat;
	model raisepct = educ prevexp bdate gender|jobcat / ss2;
	run;

proc glm;
	class gender minority jobcat;
	model raisepct = prevexp bdate gender|jobcat / ss2;
	run;
