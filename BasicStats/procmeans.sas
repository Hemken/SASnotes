/* 02b - VARIABLE LISTS */
libname y "y:\sas\data";

data cake; /* from SAS Procedures, Means Procedure, Example 1 */
   input LastName $ 1-12 Age 13-14 PresentScore 16-17 
         TasteScore 19-20 Flavor $ 23-32 Layers 34 ;
   datalines;
Orlando     27 93 80  Vanilla    1
Ramey       32 84 72  Rum        2
Goldston    46 68 75  Vanilla    1
Roe         38 79 73  Vanilla    2
Larsen      23 77 84  Chocolate  .
Davis       51 86 91  Spice      3
Strickland  19 82 79  Chocolate  1
Nguyen      57 77 84  Vanilla    .
Hildenbrand 33 81 83  Chocolate  1
Byron       62 72 87  Vanilla    2
Sanders     26 56 79  Chocolate  1
Jaeger      43 66 74             1
Davis       28 69 75  Chocolate  2
Conrad      69 85 94  Vanilla    1
Walters     55 67 72  Chocolate  2
Rossburger  28 78 81  Spice      2
Matthew     42 81 92  Chocolate  2
Becker      36 62 83  Spice      2
Anderson    27 87 85  Chocolate  1
Merritt     62 73 84  Chocolate  1
;


* The default is to use all appropriate variables;
proc means data=cake;
run;

* Specified variables;
proc means data=cake;
	var age presentscore tastescore;
run;

proc means data=cake n mean std stderr fw=8;   
	var PresentScore TasteScore;
run;

* Means by group;
proc means data=cake;
	var age presentscore tastescore;
	class layers;
run;


* Use '_numeric_' to specify all numeric variables;
proc freq data=cake;
   tables _numeric_ /nocum;
run;

* Use '_character_' or '_char_' to specify all character variables;
proc freq data=workshop.cake;
   tables _character_ /nocum;
run;

* And use _all_ likewise.  This is especially useful where you
	are specifying some modification to the standard output, or
	in crosstabs;
proc freq data=workshop.cake;
   tables _all_ /nocum nopercent;
   tables _all_*layers;
run;

* Variables may be specified as a list in the order in which
	they appear in the data set with a double-dash, '--';
proc freq data=workshop.cake;
   tables age--tastescore /nocum;
run;

* Variables with a common root name and numeric suffix may be
	specified in a list with a single dash, '-';
data new;
	set workshop.cake(rename=(presentscore=score1 tastescore=score2));
	label score1="Presentation"
		score2="Taste";
	run;

proc means data=new;
   var score1-score2;
run;
