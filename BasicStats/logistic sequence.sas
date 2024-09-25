Data Neuralgia;
      input Treatment $ Sex $ Age Duration Pain $ @@;
      datalines;
   P  F  68   1  No   B  M  74  16  No  P  F  67  30  No
   P  M  66  26  Yes  B  F  67  28  No  B  F  77  16  No
   A  F  71  12  No   B  F  72  50  No  B  F  76   9  Yes
   A  M  71  17  Yes  A  F  63  27  No  A  F  69  18  Yes
   B  F  66  12  No   A  M  62  42  No  P  F  64   1  Yes
   A  F  64  17  No   P  M  74   4  No  A  F  72  25  No
   P  M  70   1  Yes  B  M  66  19  No  B  M  59  29  No
   A  F  64  30  No   A  M  70  28  No  A  M  69   1  No
   B  F  78   1  No   P  M  83   1  Yes B  F  69  42  No
   B  M  75  30  Yes  P  M  77  29  Yes P  F  79  20  Yes
   A  M  70  12  No   A  F  69  12  No  B  F  65  14  No
   B  M  70   1  No   B  M  67  23  No  A  M  76  25  Yes
   P  M  78  12  Yes  B  M  77   1  Yes B  F  69  24  No
   P  M  66   4  Yes  P  F  65  29  No  P  M  60  26  Yes
   A  M  78  15  Yes  B  M  75  21  Yes A  F  67  11  No
   P  F  72  27  No   P  F  70  13  Yes A  M  75   6  Yes
   B  F  65   7  No   P  F  68  27  Yes P  M  68  11  Yes
   P  M  67  17  Yes  B  M  70  22  No  A  M  65  15  No
   P  F  67   1  Yes  A  M  67  10  No  P  F  72  11  Yes
   A  F  74   1  No   B  M  80  21  Yes A  F  69   3  No
   ;

* basic;
proc logistic data=Neuralgia;
	model pain = age;
	run;

* add a plot;
proc logistic data=Neuralgia plots=effectplot;
	model pain = age ;
	run;

* add a categorical variable;
proc logistic data=Neuralgia plots=effectplot;
	class treatment;
	model pain = age treatment;
	run;

* change from effects to reference coding;
* no difference in OR, but in log-odds param;
proc logistic data=Neuralgia plots=effectplot;
	class treatment(param=reference);
	model pain = age treatment;
	run;

* now lets move the intercept;
data neuralgia;
	set neuralgia;
	age60 = age - 60;
	run;

proc logistic data=Neuralgia plots=effectplot;
	class treatment(param=reference);
	model pain = age60 treatment /expb;
	* the intercept now appears within our plot;
	run;

* change the outcome being modeled, flipping ORs;
proc logistic data=Neuralgia plots=effectplot;
	class treatment(param=reference);
	model pain(event="Yes") = age60 treatment;
	run;

* pick the reference in a categorical variables;
proc logistic data=Neuralgia plots=effectplot;
	class treatment(param=reference) sex(param=reference ref="F");
	model pain(event="Yes") = age60 treatment sex;
	run;


