Data Neuralgia;
      input Treatment $ Sex $ Age Duration Pain $ @@;
	  agec = age - 70.05;
	  durc = duration - 16.733333333;
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

proc means data=Neuralgia;
	var age duration;
	output out=means mean=agem durm;
	run;

proc logistic data=Neuralgia;
	class treatment sex;
	model pain = treatment sex agec|durc;
	contrast 'age' agec 1;
	contrast 'lrt' agec 1, durc 1 , agec*durc 1/ e;
	run;

proc logistic data=Neuralgia;
	class treatment sex;
	model pain = treatment sex durc;
	run;

proc logistic data=Neuralgia;
	class treatment sex;
	model pain = treatment sex;
	run;

data detergent;
   input Softness $ Brand $ Previous $ Temperature $ Count @@;
   datalines;
soft X yes high 19   soft X yes low 57
soft X no  high 29   soft X no  low 63
soft M yes high 29   soft M yes low 49
soft M no  high 27   soft M no  low 53
med  X yes high 23   med  X yes low 47
med  X no  high 33   med  X no  low 66
med  M yes high 47   med  M yes low 55
med  M no  high 23   med  M no  low 50
hard X yes high 24   hard X yes low 37
hard X no  high 42   hard X no  low 68
hard M yes high 43   hard M yes low 52
hard M no  high 30   hard M no  low 42
;

proc logistic data=detergent;
   class Softness Previous Temperature / param=effect;
   freq Count;
   model Brand = Softness|Previous|Temperature;
   contrast 'lrt'
   softness*previous 1 0,
   softness*previous 0 1,
   softness*temperature 1 0,
   softness*temperature 0 1,
   previous*temperature 1,
   softness*previous*temperature 1 0,
   softness*previous*temperature 0 1;
run;

proc logistic data=detergent;
   class Softness Previous Temperature / param=effect;
   freq Count;
   model Brand = Softness Previous Temperature;
run;
