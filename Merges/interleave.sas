* Set, merge, interleave;

* Note in the following examples we use "initial"
	as the "by" variable, and that we have changed
	which observations are in which data set. ;

data orgs1;
	input id initial $ organism $ count;
datalines;
10      a       Ant          5
20      b       Bird         .
30      c       Cat         17
10      g       Grape         69
20      h       Hazelnut      55
30      i       Indigo         .
;

data orgs2;
	input id initial $ organism $ count;
datalines;
40      d       Dog          9
50      e       Eagle        .
60      f       Frog        76
40      j       Jicama        14
50      k       Kale           5
60      l       Lentil        77
;

data interleave1;
	set orgs1 orgs2;
	run;

proc print; run;

data interleave2;
	set orgs1 orgs2;
	by initial;
	run;

proc print; run;

data interleave3;
	merge orgs1 orgs2;
	by initial;
	run;

proc print; run;

* If we add a SORT after the first DATA step
	all three produce the same thing.

* Conceptually, this is a "set" problem, not
	a "merge" problem, because we are not adding
	new data values (new variables) to any existing 
	observation.  To use "merge" here is bad style,
	and possibly inefficient.

* Sorting two smaller data sets and then interleaving
	with "set"-"by" is more efficient than doing a
	"set"-"SORT".

* Question - what feature of the data allows the "merge"
	to even work?

