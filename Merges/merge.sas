* Match Merges;

* A "merge" in SAS jargon is fundamentally the idea
	of adding the variables from one data set to the
	variables from another, typically adding new
	variables to existing observations.

* This is best done by explicitly matching the observations
	in one data set with the observations in a second data
	set through a key, an identifier variable or variables.

* Most often at least one of the tables will have only one observation
	per key value (a unique identifier).  Fairly often, 
	both tables will have unique values for the key.

* example data from SAS documentation;
data animal1;
	input id initiala $ animal $ counta;
datalines;
1      a       Ant          5
2      b       Bird         .
3      c       Cat         17
4      d       Dog          9
5      e       Eagle        .
6      f       Frog        76
;

data plant1;
	input id initialb $ plant $ countb;
datalines;
1      g       Grape         69
2      h       Hazelnut      55
3      i       Indigo         .
4      j       Jicama        14
5      k       Kale           5
6      l       Lentil        77
;

* Match merge - simple example;
* We typically need two statements in our DATA step:
	a "merge" statement, and a "by" statement;

data merge1;
	merge animal1 plant1;
	by id;

proc print; run;

* Question:  what happens if you reverse the order of the
	data sets, i.e. "merge plant1 animal1" ??

* It is important that the "by" variable(s) is present
	in both data sets, and that it is of the same
	type in both data sets (see "set nuances").;

* Sort, then match merge
* In order to use a "by" statement, our source/merging
	data sets need to already be sorted.  In the previous example they
	happened to be, but often you will need to sort one or
	both of the data sets first.;

data animal2;
	input id initiala $ animal $ counta;
datalines;
1      a       Ant          5
4      d       Dog          9
3      c       Cat         17
6      f       Frog        76
2      b       Bird         .
5      e       Eagle        .
;

data plant2;
	input id initialb $ plant $ countb;
datalines;
5      k       Kale           5
4      j       Jicama        14
2      h       Hazelnut      55
1      g       Grape         69
6      l       Lentil        77
;

data mergebyerror; * This has an ERROR;
	merge animal2 plant2;
	by id;
	run;

* Question:  what kind of error - compile or execute - is this?;

proc sort data=animal2; by id;
proc sort data=plant2;  by id;

data mergebysort;
	merge animal2 plant2;
	by id;
	run;

proc print; run;

* Notice that there is no observation with id=3
	in the plant2 data set.  In the merged data set
	the values for the plant2 variables are missing.;

* Question:  fix this;

data animal3;
	input id initial $ animal $ counta;
datalines;
5      e       Eagle        .
6      f       Frog        76
3      c       Cat         17
4      d       Dog          9
1      a       Ant          5
;

data plant3;
	input id $ initial $ plant $ countb;
datalines;
5      k       Kale           5
4      j       Jicama        14
2      h       Hazelnut      55
1      g       Grape         69
6      l       Lentil        77
;

* Fix the data so that this runs - use anything
	you know except rearranging the data rows by
	hand! ;
data mergeproblem; 
	merge animal3 plant3;
	by descending id;
	run;
