* Additional problems concatenating / stacking data;

* example from SAS documentation;
data animals;
	input id initial $ animal $ count;
datalines;
1      a       Ant          5
2      b       Bird         .
3      c       Cat         17
4      d       Dog          9
5      e       Eagle        .
6      f       Frog        76
;

data plants;
	input id initial $ plant $ count;
datalines;
1      g       Grape         69
2      h       Hazelnut      55
3      i       Indigo         .
4      j       Jicama        14
5      k       Kale           5
6      l       Lentil        77
;

* Getting variables with different names into the same column;
* renaming variables: note you really only need to rename
	one of the variables, but here it makes sense to rename
	both;
data  concat2;
	set animals(rename=(animal=organism))
	    plants(rename=(plant=organism));

proc print; run;

* Keeping track of where data comes from;
* Note the "in=" variable is temporary;
data  concat3;
	set animals(in=xx) plants;
	if xx then source="animals data";
		else source="plants data";

proc print; run;


* Mismatched variable types;
* (Question:  compile phase or execute phase error?);
data animals;
	input id $ initial $ animal $ count;
datalines;
1      a       Ant          5
2      b       Bird         .
3      c       Cat         17
4      d       Dog          9
5      e       Eagle        .
6      f       Frog        76
;

data trouble;
	set animals plants;
	run;

* I see three solutions here:
	(1) re-read the original data,
	(2) drop or rename one of the "id" variables
		(if we won't be using it, eliminate it!)
	(3) re-type the variable in a DATA step.;
* solution (3):;
* note the change in variable order in our final data set - why?;
data animals;
	set animals(rename=(id=ids));
	id = input(ids, f1.0);
	drop ids;
	run;
data fixed; 
	set animals plants;
	run;
proc print; run;

* A more subtle problem is character variables
	of differing lengths;
data animals;
	input id initial $ animal : $5. count;
datalines;
1      a       Ant          5
2      b       Bird         .
3      c       Cat         17
4      d       Dog          9
5      e       Eagle        .
6      f       Frog        76
;

data trouble;
	set animals(rename=(animal=organism))
	    plants(rename=(plant=organism));
	run;
proc print; run;

* Again I see three solutions:
	(1) reread the original data, using better lengths/informats
	(2) "set" the data sets so that the longest variable
		is found first
	(3) re-specify the length of the variable in the
		data set where it is too short;
* solution (3);
* again note the change in variable order in our final data set - why?;
data animals;
	length animal $8;
	set animals;
	run;
data fixed; 
	set animals(rename=(animal=organism))
	    plants(rename=(plant=organism));
	run;
proc print; run;
