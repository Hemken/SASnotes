proc freq data=sashelp.cars;
	table type;
	run;

/* WHERE reads in 10 observations,
	and outputs 10 observations */
data cars;
	set sashelp.cars(obs=10);
	put _n_ type origin;
	where origin  eq 'Asia';
	run;

/* IF reads in 10 observations,
	and outputs only 7 observations */
data cars;
	set sashelp.cars(obs=10);
	put _n_ type origin;
	if origin  eq 'Asia';
	run;

data cars;
	set sashelp.cars;
	discount = msrp - invoice;
	run;

proc means data=cars n mean stddev;
	class origin type;
	var discount;
	run;

proc sgplot data=sashelp.cars;
	scatter y=mpg_highway x=weight;
	run;

proc glm data=sashelp.cars;
	where type not in('Hybrid', 'SUV');
	*class type(ref='Sedan');
	model mpg_highway = weight|weight/*|type*/ / ss3 solution;
	run;

data cars;
	set sashelp.cars;
	where type not in('Hybrid', 'SUV');
	if weight lt 3000 then wgt = 2;
		else if weight lt 4000 then wgt = 3;
		else if weight lt 5000 then wgt = 4;
		else if weight lt 6000 then wgt = 5;
		else if weight ge 6000 then wgt = 6;
	run;

data cars;
	set sashelp.cars;
	where type not in('Hybrid', 'SUV');
	select weight lt 3000 then wgt = 2;
		else if weight lt 4000 then wgt = 3;
		else if weight lt 5000 then wgt = 4;
		else if weight lt 6000 then wgt = 5;
		else if weight ge 6000 then wgt = 6;
	run;


proc glm data=cars;
	class wgt;
	model mpg_highway = weight | wgt /ss2;
	run;

/* IF (condition) THEN statement(s);
	 ELSE statement(s);
*/

proc freq data=sashelp.cars;
	tables cylinders;
	tables type*cylinders;
	run;

proc means data=sashelp.cars;
	class cylinders;
	var mpg_city;
	run;
data cars;
	set sashelp.cars;
	if weight lt 3000 then wgt = 2;
		else if weight lt 4000 then wgt = 3;
		else if weight lt 5000 then wgt = 4;
		else if weight lt 6000 then wgt = 5;
		else if weight ge 6000 then wgt = 6;
	run;

* Comparisons;
* Evaluate to 0 or 1;
data _null_;
	cond = 1 > 2;
	put '1 > 2 evalutes to: ' cond;
	cond = 1 < 2;
	put '1 < 2 evalutes to: ' cond;
	run;

* Missing Value Comparisons;
* These also evaluate to 0 or 1 (never to missing);
* As a value, missing the the smallest possible number.  .a is
	the next smallest number. (This effects SORTs as well.);
data _null_;
	cond = 1 ge .;
	put '1 ge . evalutes to: ' cond;
	cond = 1 le .;
	put '1 le . evalutes to: ' cond;
	cond = . eq .;
	put '. eq . evalutes to: ' cond;
	put;
	cond = 1 ge .a;
	put '1 ge .a evalutes to: ' cond;
	cond = . eq .a;
	put '. eq .a evalutes to: ' cond;
	cond = . lt .a;
	put '. lt .a evalutes to: ' cond;
	run;

* Note that you may compare character values;
data _null_;
	cond = 'A' le 'B';
	put "'A' le 'B' evalutes to: " cond;
	run;

* Comparing character values and numeric values;
* Character values are coerced to numeric (first NOTE), and therefore
	are missing.  So the comparison is indeed evaluated.

	The log shows that an ERROR occured while
	constructing the PDV for the second assignment statement,
	and printed the whole PDV in the log.
	However, the PUT statement tht followed was still executed (the DATA
	step did not stop).;
data _null_;
	cond = 1 le 'B';
	put "1 le 'B' evalutes to: " cond;
	cond = 'A' le 1;
	put "'A' le 1 evalutes to: " cond;
	run;

* Compound Conditions;
* Conditional operators also always evaluate to 0 or 1.
	In this use, a missing value is "false" or the
	same a 0.;
data _null_;
	cond = 1 and 0;
	put '1 and 0 evalutes to: ' cond;
	cond = 1 or 0;
	put '1 or  0 evalutes to: ' cond;
	cond = 1 and .;
	put '1 and . evalutes to: ' cond;
	cond = 1 or .;
	put '1 or  . evalutes to: ' cond;
	put;
	cond = . and .;
	put '. and  . evalutes to: ' cond;
	cond = . or .;
	put '. or  . evalutes to: ' cond;
	cond = not .;
	put 'not . evalutes to: ' cond;
	run;

proc format;
	value tf 0 = 'FALSE' 1 = 'TRUE';
	run;

* Use in IF/THEN/ELSE statements;
* An expression used as a condition might evaluate
	to any arbitrary number (including missing).  In
	SAS logic, the condition is "true" if it evaluates
	as anything other than 0 or missing;

data _null_;
	cond = 1;
	if (cond) then put 'Condition was "true" at ' cond;
		else put 'Condition was "false" at ' cond;
	cond = 0;
	if (cond) then put 'Condition was "true" at ' cond;
		else put 'Condition was "false" at ' cond;
	cond = .a;
	if (cond) then put 'Condition was "true" at ' cond;
		else put 'Condition was "false" at ' cond;
	put;
	cond = 1.5;
	if (cond) then put 'Condition was "true" at ' cond;
		else put 'Condition was "false" at ' cond;
	cond = 0.5;
	if (cond) then put 'Condition was "true" at ' cond;
		else put 'Condition was "false" at ' cond;
	cond = -0.5;
	if (cond) then put 'Condition was "true" at ' cond;
		else put 'Condition was "false" at ' cond;
	run;

data _null_;
	cond = 0.2 = 0.3 - 0.1;
	put cond;
	run;
