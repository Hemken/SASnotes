* Add variables / concatenate / stack;

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

* Concatenate;
data concat1;
	set animals plants;

proc print; run;

* Question:  how would the result of
		"set plants animals"
	differ?  What difference arises
	in the compile phase of the DATA
	step?  What difference comes
	from the execute phase?;
data concat1;
	set plants animals;

proc print; run;

* Question: why would the results of
		"set animals"
		"set plants"
	probably NOT be what you'd want?
	For the first observation, explain
	how the program data vector (PDV)
	would be arranged, and what data
	values it would contain (1) at the
	top of the DATA step, (2) after the
	first "set" statement, and (3) after
	the second "set" statement, at the
	bottom of the DATA step.;
data concatx;
	set plants;
	set animals;
run;


* This can also be accomplished with SQL,
	but it is not as simple as you might suppose;
proc sql;
	create table concatsql as
		select * from animals
	outer union corresponding
		select * from plants;

proc print; run;
