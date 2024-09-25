* Keeping track of which data sets contribute;
* Many- to-one;
* Many-to-many;
* Merging three data sets;
* PROC SQL;

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
