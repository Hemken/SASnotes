* Concatenations can be accomplished with PROC APPEND or PROC DATASETS;

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

* The end result is to have the new observations
	added to the first/base/master data set;
* This only works if all the variables are common to both
	data sets.  You cannot rename variables in the first data set;
proc append base=animals data=plants(rename=(plant=animal));
run;
proc print; run;

* The syntax of PROC DATASETS is similar;
proc datasets;
	append base=animals data=plants(rename=(plant=animal));
proc print; run;
