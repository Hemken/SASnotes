* Match merge nuances;

* Key variable types and lengths.
	As with "set", common variable must be of the
	same type, and OUGHT to be of the same length;

* Here we have two sets of ids that should match, but are read
	with different lengths;
* Question:  what happens to the id data values in animal4? in plant4? ;

data animal4;
	input id : $1. initial $ animal $ count;
datalines;
10      a       Ant          5
20      b       Bird         .
30      c       Cat         17
40      d       Dog          9
50      e       Eagle        .
60      f       Frog        76
;

data plant4;
	input id : $2. initial $ plant $ count;
datalines;
10      g       Grape         69
20      h       Hazelnut      55
30      i       Indigo         .
40      j       Jicama        14
50      k       Kale           5
60      l       Lentil        77
;

data mergetrunc1;  /* This works!  but only by sheer luck!*/
	merge animal4 plant4;
	by id;

proc print label; run;

data mergetrunc2;  /* This fails spectacularly!*/
	merge plant4 animal4;
	by id;

proc print label; run;
* The only good way to fix this is to re-read the data;

* Question:  explain the difference between these two
	data steps - how is the PDV defined in each case
	and how is the first observation built in each case?
	(If you don't know where to start, work through the
	next example and come back to this question.);


* Variables in common other than the key(s);
*   Notice that the data values of common variables
	come from the LAST data set named, while
	variable attributes (length, format, label)
	come from the FIRST data set named.;

data animal5;
	input id : $1. initial $ animal $ count;
	label initial = "Animal initial";
	format count f5.2;
datalines;
1      a       Ant          5
2      b       Bird         .
3      c       Cat         17
4      d       Dog          9
5      e       Eagle        .
6      f       Frog        76
;

data plant5;
	input id : $2. initial $ plant $ count;
	label initial = "Plant initial";
	format count f6.3;
datalines;
1      g       Grape         69
2      h       Hazelnut      55
3      i       Indigo         .
4      j       Jicama        14
5      k       Kale           5
6      l       Lentil        77
;

data mergeover;
	merge animal5 plant5;
	by id;

proc print label; run;

* Question:  suppose we want to keep both counts
	and are happy to throw away initials.  Without
	re-inputting the data, fix the data so it
	merges as specified, and without the warning
	message. ;

* Updates ;
* Sometimes we want to overwrite data with new
	values, but retain the original value if there
	is no new value.  This is sometimes called an
	"update." ;
* You could accomplish this with a "merge" and some
	conditional processing in the DATA step, but
	there is an "update" statement that accomplishes
	this more directly;
data animal6;
	input id initial $ animal $ count;
datalines;
1      a       Ant          5
2      b       Bird         .
3      c       Cat         17
4      d       Dog          9
5      e       Eagle        .
6      f       Frog        76
;

data newcounts;
	input id animal $ 8-13 count;
datalines;
1                  69
2                  55
3      Feline       .
4      Canine      14
5                   5
6                  77
7                  22
;

* The problem with "merge" here is we overwrite ALL
	the original data in two variables;
data mergeupdate1; /* NOT what we want */
	merge animal6 newcounts;
	by id;

proc print label; run;

* We could write a data step that renames two
	variables and uses IF-THEN to pick the
	right data values.  But more direct is
	the "update" statement. ;

data mergeupdate2;
	update animal6 newcounts;
	by id;

proc print label; run;

* Question - do this the hard way, with "merge"
	instead of "update", and IF-THEN.  You may 
	re-input the data, if that makes it easier.;

* As with "set" and "merge", "update" has the usual
	issues with inconsistent variable attributes:
	type, length, label, format. ;
