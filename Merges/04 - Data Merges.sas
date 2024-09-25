* 04 - Data Merges.sas;

data animal;
	input id initial $ animal $ count;
datalines;
1      a       Ant          5
2      b       Bird         .
3      c       Cat         17
4      d       Dog          9
5      e       Eagle        .
6      f       Frog        76
;

data plant;
	input id initial $ plant $ count;
datalines;
1      g       Grape         69
2      h       Hazelnut      55
3      i       Indigo         .
4      j       Jicama        14
5      k       Kale           5
6      l       Lentil        77
;

* Concatenate;
data concat1;
	set animal plant;

proc print; run;

*renaming variables;
data  concat2;
	set animal(rename=(animal=being))
	    plant(rename=(plant=being));

proc print; run;

*Interleave by count;
proc sort data=animal; by count;
proc sort data=plant; by count;

data interleave;
	set animal plant;
	by count;
	rare = count lt 10;  /* Note missing values are the smallest possible number*/

proc print; run;

*Match merge;
proc sort data=animal; by id;
proc sort data=plant; by id;

data merged;
	merge animal
		  plant
			(rename=(initial=plantinitial count=plantcount));
	by id;  /* again, the data were pre-sorted */

proc print; run;

* Using the in= option;
* from "Combining and Modifying SAS Data Sets: Examples";
data people;
   input id $ name $  dept $ project $;
   datalines;
000 Miguel A12 Document
111 Fred B45 Survey
222 Diana B45 Document
888 Monique A12 Document
999 Vien D03 Survey
;

data projects;
   input id $ name $ projhrs;
   datalines;
111 Fred 35
222 Diana 40
777 Steve 0
888 Monique 37
999 Vien 42
;

data combined;
   merge people(in=in1) projects(in=in2);
   by id;
   if not in2 then projhrs=0;
run;

proc print data=combined; run;

* Many-to-one, or table-lookup;
filename file1 url "http://www.ssc.wisc.edu/~hemken/SASworkshops/data/student.csv";
data student;
	infile file1 dsd firstobs=2;
	input childid classid schoolid sex $ minority $ mathkind mathgain ses;
	run;

filename file2 url "http://www.ssc.wisc.edu/~hemken/SASworkshops/data/school.csv";
data school;
	infile file2 dsd firstobs=2;
	input schoolid housepov;
	run;

proc sort data=student; by schoolid;
proc sort data=school; by schoolid;

data studentpov;
	merge student school;
	by schoolid;
	run;

proc means; var housepov; run;
